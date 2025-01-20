class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # Check if we need password to update user parameters
    if account_update_params[:password].blank?
      account_update_params.delete('password')
      account_update_params.delete('password_confirmation')
      account_update_params.delete('current_password')
    end

    @user = resource

    if @user.update(account_update_params)
      # set_flash_message :notice, :updated, first_name: @user.first_name
      # Sign in the user bypassing validation in case their password changed
      redirect_to profile_path
    #   bypass_sign_in @user
    else
      @user.errors.full_messages.each do |message|
        flash[:alert] = "• #{message}\n"
      end
      redirect_to edit_user_registration_path
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :mobile_number])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :mobile_number])
  end

  def set_flash_message(key, kind, options = {})
    options[:first_name] = resource.first_name if resource&.first_name.present?
    super
  end
end 