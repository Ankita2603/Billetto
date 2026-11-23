class VotesController < ApplicationController
  skip_before_action :require_clerk_session!

  def create
    debugger
    Rails.logger.info("VOTE CREATE EXECUTED")

    @event = Event.find(params[:event_id])

    Voting::CastVote.new(
      event: @event,
      clerk_user_id: current_clerk_user_id,
      vote_type: params[:vote_type]
    ).call

    redirect_to event_path(@event),
                notice: "Your vote has been recorded."
  end

  private

  def debug_clerk_session
    Rails.logger.info("CLERK USER? #{clerk.user?}")
    Rails.logger.info("CLERK USER ID PRESENT? #{clerk.user_id.present?}")
    Rails.logger.info("CLERK SESSION PRESENT? #{clerk.session.present?}")
  end
end