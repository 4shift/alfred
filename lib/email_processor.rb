class EmailProcessor
  def initialize(email)
    @email = email
  end

  # incomming mail
  def process
    if @email.headers["In-Reply-To"]
      response_to = Ticket.find_by_message_id(@email.headers["In-Reply-To"])
      unless response_to
        response_to = Reply.find_by_message_id(@email.headers["In-Reply-To"])
        if response_to
          ticket = response_to.ticket
        else
          # we create a new ticket further below in this case
        end
      else
        ticket = response_to
      end
    end

    from_address = @email.from[:email]
    unless @email.headers["Reply_to"].blank?
      from_address = @email.headers["Reply_to"]
    end

    if response_to
      # reopen ticket
      ticket.status = :open
      ticket.save
      # add reply
      incoming = Reply.create({
        content: @email.body,
        ticket_id: ticket.id,
        from: from_address,
        message_id: @email.headers["Message-ID"],
        content_type: "html",
        raw_message: StringIO.new(@email.to_s)
      })
    else
      # to_email_address = EmailAddress.find_first_verified_email([@email.to[:email]])
      # add new ticket
      ticket = Ticket.create({
        from: from_address,
        subject: @email.subject,
        content: @email.body,
        message_id: @email.headers["Message-ID"],
        content_type: "html",
        # to_email_address: to_email_address,
        raw_message: StringIO.new(@email.to_s)
      })
      incoming = ticket
    end

    @email.attachments.each do |f|
      a = incoming.attachments.create(file: f)
      a.save!
    end

    if ticket != incoming
      incoming.set_default_notifications!

      incoming.notified_users.each do |user|
        mail = NotificationMailer.new_reply(incoming, user)
        mail.deliver_now
        incoming.message_id = mail.message_id
      end

      incoming.save
    end

    if !@email.headers['Return-Path'].nil? && @email.headers['Return-Path'].value == ''
      nil
    else
      incoming
    end
  end
end
