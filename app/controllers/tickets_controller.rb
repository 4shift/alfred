class TicketsController < ApplicationController
  include HtmlTextHelper
  include ActionView::Helpers::SanitizeHelper

  before_filter :authenticate_user!, except: [:create, :new]
  load_and_authorize_resource :ticket, except: :create
  skip_authorization_check only: :create
  skip_before_action :verify_authenticity_token, only: :create, if: 'request.format.json?'

  layout :determine_layout

  def index
    @agents = User.agents

    params[:status] ||= 'open'

    @tickets = @tickets.by_status(params[:status])
      .search(params[:q])
      .by_label_id(params[:label_id])
      .filter_by_assignee_id(params[:assignee_id])
      .ordered

    respond_to do |format|
      format.html do
        @tickets = @tickets.includes(:user).paginate(page: params[:page], per_page: current_user.per_page)
      end
      format.csv do
        @tickets = @tickets.includes(:status_changes)
      end
    end
  end

  def show
    params[:status] ||= 'open'

    @tickets = Ticket.by_status(params[:status])
      .search(params[:q])
      .by_label_id(params[:label_id])
      .filter_by_assignee_id(params[:assignee_id])
      .ordered
    @tickets = @tickets.includes(:user).paginate(page: params[:page], per_page: current_user.per_page)

    @agents = User.agents

    draft = @ticket.replies.where(user: current_user).where(draft: true).first
    if draft.present?
      @reply = draft
    else
      @reply = @ticket.replies.new(user: current_user)
      @reply.set_default_notifications!
    end

    @labeling = Labeling.new(labelable: @ticket)
    @outgoing_addresses = EmailAddress.verified.ordered

    respond_to do |format|
      format.html
      format.js
      format.eml do
        begin
          send_file @ticket.raw_message.path(:original),
                    filename: "ticket-#{@ticket.id}.eml",
                    type: 'text/plain',
                    disposition: :attachment
        rescue
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end

  def new
    unless current_user.blank?
      if current_user.prefer_plain_text?
        signature = { content: "\n#{html_to_text current_user.signature}" }
      else
        signature = { content: "<p></p>#{current_user.signature}" }
      end
    else
      signature = {}
    end

    unless params[:ticket].nil?
      @ticket = Ticket.new(signature.merge(ticket_params))
    else
      @ticket = Ticket.new(signature)
    end

    unless current_user.nil?
      @ticket.user = current_user
    end

    respond_to do |format|
      format.html { render 'new', :layout => false }
    end
  end

  def create
    if params[:format] == 'json'
      @ticket = TicketMailer.receive(params[:message])
    else
      @ticket = Ticket.new(ticket_params)
    end

    @ticket.ref_url = request.referrer
    @ticket.ipaddress = request.remote_ip
    @ticket.browser = browser.name
    @ticket.browser_version = browser.full_version

    os = 'Unknown'

    if browser.ios?
      os = 'iOS'
    elsif browser.mac?
      os = 'Mac'
    elsif browser.windows_x64?
      os = 'Windows x64'
    elsif browser.windows?
      os = 'Windows x86'
    elsif browser.linux?
      os = 'Linux'
    elsif browser.android?
      os = 'Android'
    else
      os = 'Unknown'
    end

    @ticket.os = os

    if @ticket && @ticket.save

      Rule.apply_all(@ticket) unless @ticket.is_a?(Reply)

      # where user notifications added?
      if @ticket.notified_users.count == 0
        @ticket.set_default_notifications!
      end

      # @ticket might be a Reply when via json post
      if @ticket.is_a?(Ticket)
        if @ticket.assignee.nil?
          @ticket.notified_users.each do |user|
            mail = NotificationMailer.new_ticket(@ticket, user)
            mail.deliver_now unless EmailAddress.pluck(:email).include?(user.email)
            @ticket.message_id = mail.message_id
          end

          @ticket.save
        else
          NotificationMailer.assigned(@ticket).deliver_now
        end
      end
    end

    respond_to do |format|
      format.html do

        if !@ticket.nil? && @ticket.valid?

          if current_user.nil?
            if request.xhr?
              return render I18n.translate(:ticket_added)
            else
              render 'create', layout: false
            end
          else
            redirect_to ticket_url(@ticket), notice: I18n::translate(:ticket_added)
          end

        else
          render 'new', :layout => false
        end

      end

      format.json do
        if @ticket.nil?
          render json: {}, status: :created  # bounce mail handled correctly
        elsif @ticket.valid?
          render json: @ticket, status: :created
        else
          render json: @ticket, status: :unprocessable_entity
        end
      end

      format.js { render }
    end
  end

  def update
    respond_to do |format|
      if @ticket.update_attributes(ticket_params)

        # assignee set and not same as user who modifies
        if !@ticket.assignee.nil? && @ticket.assignee.id != current_user.id

          if @ticket.previous_changes.include? :assignee_id
            NotificationMailer.assigned(@ticket).deliver_now

          elsif @ticket.previous_changes.include? :status
            NotificationMailer.status_changed(@ticket).deliver_now

          elsif @ticket.previous_changes.include? :priority
            NotificationMailer.priority_changed(@ticket).deliver_now
          end

        end

        format.html {
          redirect_to @ticket, notice: I18n::translate(:ticket_updated)
        }
        format.js {
          render notice: I18n::translate(:ticket_updated)
        }
        format.json {
          head :no_content
        }
      else
        format.html {
          render action: 'edit'
        }
        format.json {
          render json: @ticket.errors, status: :unprocessable_entity
        }
      end
    end
  end

  protected

    def ticket_params
      if !current_user.nil? && current_user.agent?
        params.require(:ticket).permit(
            :from,
            :username,
            :content,
            :subject,
            :status,
            :assignee_id,
            :priority,
            :message_id,
            :content_type,
            attachments_attributes: [
                :file
            ])
      else
        params.require(:ticket).permit(
            :from,
            :username,
            :content,
            :subject,
            :priority,
            :content_type,
            attachments_attributes: [
                :file
            ])
      end
    end

    def determine_layout
      if [:new].include?(action_name.to_sym)
        'empty'
      else
        'application'
      end
    end
end
