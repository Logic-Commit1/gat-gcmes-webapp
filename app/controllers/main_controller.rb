class MainController < ApplicationController

  def index
    if current_user.manager?
      redirect_to projects_path
    elsif current_user.purchasing?
      redirect_to canvasses_path
    else
      redirect_to quotations_path
    end
  end
end
