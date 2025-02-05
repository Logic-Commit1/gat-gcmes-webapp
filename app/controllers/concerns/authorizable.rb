module Authorizable
  extend ActiveSupport::Concern

  private

  def authorize_sales!
    unless current_user&.sales? || current_user&.developer?
      redirect_to root_path
    end
  end

  def authorize_purchasing!
    unless current_user&.purchasing? || current_user&.developer?
      redirect_to root_path
    end
  end

  def authorize_admin!
    unless current_user&.admin? || current_user&.developer?
      redirect_to root_path
    end
  end
end 