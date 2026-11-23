class ApplicationController < ActionController::Base
  include Clerk::Authenticatable

  private

  def require_clerk_session!
    unless clerk.user? && clerk.user_id.present?
      redirect_to clerk.sign_in_url,
                  alert: "Please sign in to continue."
    end
  end

  def current_clerk_user_id
    clerk.user_id
  end
end