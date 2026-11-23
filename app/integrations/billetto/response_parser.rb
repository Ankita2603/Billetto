module Billetto
  class ResponseParser
    def parse(event)
      {
        external_id: event["id"],
        title: event["title"],
        description: event["description"],
        starts_at: parse_date(event["startdate"]),
        ends_at: parse_date(event["enddate"]),
        image_url: event["image_link"],
        billetto_url: event["url"],
        status: event["state"]
      }
    end

    private

    def parse_date(value)
      return nil if value.blank?

      Time.zone.parse(value.to_s)
    end
  end
end
