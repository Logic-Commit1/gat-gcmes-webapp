class UsersController < ApplicationController
  before_action :set_user, only: [:promote]
  before_action :authorize_admin

  def promote
    if @user.promote!
      respond_to do |format|
        format.html { redirect_back(fallback_location: employees_path, notice: "User was successfully promoted.") }
        format.json { render json: @user, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: employees_path, alert: "Unable to promote user.") }
        format.json { render json: { error: "Unable to promote user" }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_back(fallback_location: root_path, alert: "You are not authorized to perform this action.")
    end
  end
end 