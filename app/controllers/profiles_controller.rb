class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    if params[:user][:signature].present?
      # Remove any existing signature first
      current_user.signature.purge if current_user.signature.attached?
      
      # Create a blob parameters hash without checksum
      blob_params = {
        io: params[:user][:signature],
        filename: params[:user][:signature].original_filename,
        content_type: params[:user][:signature].content_type,
        identify: false,
        service_name: :cloudflare  # Specify the storage service explicitly
      }
      
      # Attach new signature
      current_user.signature.attach(blob_params)
      
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