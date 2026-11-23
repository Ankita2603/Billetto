class ImportBillettoEventsJob < ApplicationJob
  queue_as :default

  def perform
    imported_count = Billetto::EventImporter.new.call

    Rails.logger.info(
      "Billetto import completed. Processed #{imported_count} events."
    )
  rescue Billetto::Client::ApiError => e
    Rails.logger.error("Billetto import failed: #{e.message}")
    raise
  end
end
