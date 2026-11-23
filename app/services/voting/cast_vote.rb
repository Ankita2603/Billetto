module Voting
  class CastVote
    def initialize(event:, clerk_user_id:, vote_type:)
      @event = event
      @clerk_user_id = clerk_user_id
      @vote_type = vote_type
    end

    def call
      validate!

      vote_event =
        if @vote_type == "upvote"
          EventUpvoted.new(data: event_data)
        else
          EventDownvoted.new(data: event_data)
        end

      event_store.publish(
        vote_event,
        stream_name: "Event$#{@event.id}"
      )

      vote_event
    end

    private

    def event_store
      Rails.configuration.event_store
    end

    def event_data
      {
        event_id: @event.id,
        clerk_user_id: @clerk_user_id,
        vote_type: @vote_type
      }
    end

    def validate!
      raise ArgumentError, "Event is required" unless @event
      raise ArgumentError, "User is required" if @clerk_user_id.blank?

      unless %w[upvote downvote].include?(@vote_type)
        raise ArgumentError, "Invalid vote type"
      end
    end
  end
end
