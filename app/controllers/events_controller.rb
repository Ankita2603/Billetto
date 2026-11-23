class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  def index
    @events = Event.order(starts_at: :asc)

    @vote_counts = @events.each_with_object({}) do |event, counts|
      counts[event.id] = Voting::VoteCounter.new(event).call
    end
  end

  def show
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
