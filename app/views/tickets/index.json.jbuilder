json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :from, :suject, :content
  json.url ticket_url(ticket, format: :json)
end
