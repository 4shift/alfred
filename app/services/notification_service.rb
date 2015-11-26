class NotificationService
  def new_ticket(ticket, user)
    raise 'Argument Exception' unless (ticket || user)
    mailer.new_ticket(ticket.id, user.id)
  end

  def assigned(ticket)
    raise 'Argument Exception' unless ticket
    mailer.assigned(ticket.id)
  end

  protected

  def mailer
    NotificationMailer.delay
  end
end
