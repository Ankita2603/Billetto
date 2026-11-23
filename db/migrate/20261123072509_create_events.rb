class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :external_id
      t.string :title
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :image_url
      t.string :billetto_url
      t.string :status

      t.timestamps
    end

    add_index :events, :external_id, unique: true
    add_index :events, :starts_at
    add_index :events, :status
  end
end
