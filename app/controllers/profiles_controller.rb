class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    if params[:user][:signature].present?
      current_user.signature.attach(params[:user][:signature])
      current_user.signature.variant(resize_to_limit: [300, 100]).processed
    end
  
    if current_user.update(user_params)
      redirect_to profile_path, notice: 'Signature updated successfully'
    else
      redirect_to profile_path, alert: 'Failed to update signature'
    end
  end
  

  def remove_signature
    current_user.signature.purge
    redirect_to profile_path, notice: 'Signature removed successfully'
  end

  private

  def user_params
    params.require(:user).permit(:signature)
  end
end 