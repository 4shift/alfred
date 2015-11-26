class UsersController < ApplicationController

  load_and_authorize_resource :user
  #before_filter :load_locales, except: :index

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password] == ''
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if current_user == @user
      params[:user].delete(:agent)    # prevent removing own agent permissions
    end

    if @user.update_attributes(user_params)
      if current_user.agent? && current_user.labelings.count == 0
        redirect_to users_url, notice: I18n::translate(:settigns_saved)
      else
        redirect_to tickets_url, notice: I18n::translate(:settings_saved)
      end
    else
      render action: 'edit'
    end
  end

  def index
    @users = User.ordered.paginate(page: params[:page])
    @users = @users.search(params[:q])
    @users = @users.by_agent(params[:agent] == '1') unless params[:agent].blank?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if @user.owner
        redirect_to root_url(subdomain: @user.subdomain), notice: I18n::translate(:user_added)
      else
        redirect_to users_url, notice: I18n::translate(:user_added)
      end
    else
      render 'new'
    end

  end

  protected

  def user_params
    attributes = params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :signature,
      :agent,
      :notify,
      :time_zone,
      :locale,
      :per_page,
      :subdomain,
      :prefer_plain_text,
      label_ids: []
    )

    # prevent normal user and limited agent from changing email and role
    if !current_user.agent? || current_user.labelings.count > 0
      attributes.delete(:email)
      attributes.delete(:agent)
      attributes.delete(:label_ids)
    end

    attributes
  end
end
