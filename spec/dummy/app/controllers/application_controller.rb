class ApplicationController < ActionController::Base
  protect_from_forgery

  FOUR_O_FOUR_ERRORS = [
    ActiveRecord::RecordNotFound,
    ActionView::MissingTemplate,
    ActionController::RoutingError,
    ActionController::MethodNotAllowed,
    ActionController::NotImplemented,
    AbstractController::ActionNotFound,
    ActionController::UnknownController,
    ActionController::UnknownHttpMethod
  ]

  rescue_from *FOUR_O_FOUR_ERRORS, :with => :render_404

  def render_404
    render :template => 'shared/404', :formats => [:html], :status => 404
  end
end
