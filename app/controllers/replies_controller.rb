class RepliesController < ApplicationController

  load_and_authorize_resource :reply, except: [:create]

  def create
    # store attributes and reopen ticket
    @reply = current_user.replies.new({
                                        'ticket_attributes' => {
                                          'status' => 'open',
                                          'id' => reply_params[:ticket_id]
                                        }
                                      }.merge(reply_params))

    authorize! :create, @reply
    save_reply_and_redirect
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @reply.assign_attributes(reply_params)
    save_reply_and_redirect
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected

  def save_reply_and_redirect
    begin
      if @reply.draft?
        Rails.logger.debug 'save_reply_and_redirect::draft save'
        original_updated_at = @reply.ticket.updated_at

        @reply.save

        # don't screw up the ordering of inbox by resetting updated_at
        @reply.ticket.update_column :updated_at, original_updated_at
        flash[:notice] = I18n::translate(:draft_saved)

        # redirect_to @reply.ticket, notice: I18n::translate(:draft_saved)
      else
        Rails.logger.debug 'save_reply_and_redirect::transaction save'
        Reply.transaction do
          @reply.save!

          @reply.notified_users.each do |user|
            mail = NotificationMailer.new_reply(@reply, user)

            mail.deliver_now unless EmailAddress.pluck(:email).include?(user.email)
            @reply.message_id = mail.message_id
          end

          @reply.save!
        end

        flash[:notice] = I18n::translate(:reply_added)

        # redirect_to @reply.ticket, notice: I18n::translate(:reply_added)
      end
    rescue => e
      Rails.logger.error 'Exception occured on Reply transaction!'
      Rails.logger.error "Message: #{e.message}"
      Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
      @outgoing_addresses = EmailAddress.verified.ordered
      flash[:error] = "#{e.message}"
    end
  end

  def show
    respond_to do |format|
      format.eml do
        begin
          send_file @reply.raw_message.path(:original),
                    filename: "reply-#{@reply.id}.eml",
                    type: 'text/plain',
                    disposition: :attachment
        rescue
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end

  protected

  def reply_params
    attributes = params.require(:reply).permit(
      :content,
      :ticket_id,
      :message_id,
      :user_id,
      :content_type,
      :draft,
      notified_user_ids: [],
      attachments_attributes: [
        :file
      ],
      ticket_attributes: [
        :id,
        :to_email_address_id,
        :status,
      ]
    )

    unless can?(:update, Ticket.find(attributes[:ticket_id]))
      attributes.delete(:ticket_attributes)
    end

    attributes
  end
end
