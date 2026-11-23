class Event < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true

  validates :starts_at, comparison: {
    greater_than_or_equal_to: Time.zone.parse("2000-01-01")
  }, allow_nil: true

  scope :upcoming, -> {
    where("starts_at >= ?", Time.current)
      .order(:starts_at)
  }

  scope :published, -> {
    where(status: "published")
  }
end
