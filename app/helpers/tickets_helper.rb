module TicketsHelper
  def ticket_username ticket
    ticket.username ? ticket.username : ticket.from.split('@')[0]
  end

end
