module Voting
  class VoteCounter
    def initialize(event)
      @event = event
    end

    def call
      votes = Rails.configuration.event_store
        .read
        .stream("Event$#{@event.id}")
        .to_a

      {
        upvotes: votes.count { |vote| vote.is_a?(EventUpvoted) },
        downvotes: votes.count { |vote| vote.is_a?(EventDownvoted) }
      }
    end
  end
end