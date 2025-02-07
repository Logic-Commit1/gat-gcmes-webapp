class ProfilesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token


  def show
    @user = current_user
  end

  def update
    if params[:user][:signature].present?
      # Remove any existing signature first
      current_user.signature.purge if current_user.signature.attached?
  
      begin
        current_user.signature.attach(params[:user][:signature])
        Rails.logger.info "Signature attached successfully."
      rescue => e
        Rails.logger.error "Error attaching signature: #{e.message}"
        redirect_to profile_path, alert: 'Failed to attach signature'
        return
      end
  
      # Ensure Cloudflare R2 does not enforce checksum
      # current_user.signature.blob.update!(checksum: nil) if Rails.env.production?
  
      # Generate variant after successful attachment
      if current_user.signature.attached?
        current_user.signature.variant(resize_to_limit: [300, 100]).processed
      end
    end
  
    if current_user.save
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