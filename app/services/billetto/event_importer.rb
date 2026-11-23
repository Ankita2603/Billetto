module Billetto
  class EventImporter
    def initialize(client: Client.new)
      @client = client
    end

    def call
      response = @client.fetch_events

      events = extract_events(response)

      imported_count = 0

      events.each do |event_data|
        import_event(event_data)
        imported_count += 1
      end

      imported_count
    end

    private

    def extract_events(response)
      return response if response.is_a?(Array)

      response["events"] || response["data"] || []
    end

    def import_event(event_data)
      external_id = event_data["id"]

      raise Client::InvalidResponseError, "Event ID is missing" if external_id.blank?

      event = Event.find_or_initialize_by(
        external_id: external_id.to_s
      )

      event.assign_attributes(
        title: event_data["title"],
        description: event_data["description"],
        starts_at: parse_date(event_data["startdate"]),
        ends_at: parse_date(event_data["enddate"]),
        image_url: event_data["image_link"],
        billetto_url: event_data["url"],
        status: event_data["state"]
      )

      event.save!
    end

    def parse_date(value)
      return nil if value.blank?

      Time.zone.parse(value.to_s)
    end
  end
end
