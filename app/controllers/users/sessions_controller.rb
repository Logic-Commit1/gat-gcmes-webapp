class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
        Rails.logger.debug "DEBUG: resource.persisted? = #{resource.persisted?}"
      if resource.persisted?
        Rails.logger.debug "DEBUG: Redirecting after sign in"
        return redirect_to root_path
      end
    end
  end
end 