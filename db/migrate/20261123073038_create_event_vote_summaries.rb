class CreateEventVoteSummaries < ActiveRecord::Migration[7.1]
  def change
    create_table :event_vote_summaries do |t|
      t.integer :event_id
      t.integer :upvotes_count
      t.integer :downvotes_count

      t.timestamps
    end
    
    add_index :event_vote_summaries, :event_id, unique: true
  end
end
