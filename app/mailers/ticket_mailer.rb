class TicketMailer < ApplicationMailer
  include BounceHelper

  def encode(string)
    string.encode('UTF-8', invalid: :replace, undef: :replace)
  end

  def normalize_body(part, charset)
    encode(part.body.decoded.force_encoding(charset))
  end

  def receive(email)

    # is this an address verification mail?
    if VerificationMailer.receive(email)
      return
    end

    content = ''

    if email.multipart?
      if email.html_part
        content = normalize_body(email.html_part, email.html_part.charset)
        content_type = 'html'
      elsif email.text_part
        content = normalize_body(email.text_part, email.text_part.charset)
        content_type = 'text'
      else
        content = normalize_body(email.parts[0], email.parts[0].charset)
        content_type = 'html'
      end
    else
      if email.charset
        content = normalize_body(email, email.charset)
      else
        content = encode(email.body.decoded)
      end
      content_type = 'text'
    end

    if email.charset
      subject = encode(email.subject.to_s.force_encoding(email.charset))
    else
      subject = email.subject.to_s.encode('UTF-8')
    end


    if email.in_reply_to
      # is this a reply to a ticket or to another reply?
      response_to = Ticket.find_by_message_id(email.in_reply_to)

      if !response_to

        response_to = Reply.find_by_message_id(email.in_reply_to)

        if response_to
          ticket = response_to.ticket
        else
          # we create a new ticket further below in this case
        end
      else
        ticket = response_to
      end
    end

    from_address = email.from.first
    unless email.reply_to.blank?
      from_address = email.reply_to.first
    end

    if response_to
      # reopen ticket
      ticket.status = :open
      ticket.save

      # add reply
      incoming = Reply.create({
                                content: content,
                                ticket_id: ticket.id,
                                from: from_address,
                                message_id: email.message_id,
                                content_type: content_type,
                                raw_message: StringIO.new(email.to_s)
                              })

    else

      to_email_address = EmailAddress.find_first_verified_email(email.to)

      # add new ticket
      ticket = Ticket.create({
                               from: from_address,
                               subject: subject,
                               content: content,
                               message_id: email.message_id,
                               content_type: content_type,
                               to_email_address: to_email_address,
                               raw_message: StringIO.new(email.to_s)
                             })

      incoming = ticket

    end

    if email.has_attachments?

      email.attachments.each do |attachment|

        file = StringIO.new(attachment.decoded)

        # add needed fields for paperclip
        file.class.class_eval {
          attr_accessor :original_filename, :content_type
        }

        file.original_filename = attachment.filename
        file.content_type = attachment.mime_type

        a = incoming.attachments.create(file: file)
        a.save! # FIXME do we need this because of paperclip?
      end

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

    if bounced?(email)
      nil
    else
      incoming
    end
  end
end
