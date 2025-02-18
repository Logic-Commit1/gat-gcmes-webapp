class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_active_storage_url_options
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource
  
  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :mobile_number])
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def check_user_has_signature
    return if current_user&.signature&.attached?

    redirect_to :profile,
                alert: 'You need to upload your signature first before you can create or edit reports'
  end

  def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def authorize_moderator!
    unless current_user&.moderator? || current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def console?
    request.subdomain == 'console'
  end

  # Only allow access to moderator pages when the subdomain is 'console'
  def unless_console!
    if Rails.env.production?
      if console?
        do_not_track
      else
        flash[:danger] = 'Unauthorized Access!'
        redirect_to root_path
      end
    end
  end

  def after_sign_in_path_for(resource)    
    if resource.manager?
      projects_path
    elsif resource.purchasing?
      canvasses_path
    elsif [:operation, :sales, :accounting, :warehouse].include?(resource.department&.to_sym)
      quotations_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def download_pdf(pdf_path)
    File.delete(pdf_path) if File.exist?(pdf_path)
    generate_pdf(pdf_path)

    send_file pdf_path, type: 'application/pdf', disposition: 'attachment'   
  end

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = {
      host: request.base_url,
      protocol: Rails.env.production? ? 'https' : 'http'
    }
  end
end
