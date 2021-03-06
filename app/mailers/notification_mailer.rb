class NotificationMailer < ApplicationMailer

  add_template_helper HtmlTextHelper

  def new_ticket(ticket, user, domain)
    unless user.locale.blank?
      @locale = user.locale
    else
      @locale = Rails.configuration.i18n.default_locale
    end
    title = I18n::translate(:new_ticket, locale: @locale) + ': ' + ticket.subject.to_s

    add_attachments(ticket)

    unless ticket.message_id.blank?
      headers['Message-ID'] = "<#{ticket.message_id}>"
    end

    @ticket = ticket
    @user = user

    mail(to: user.email, subject: title, from: ticket.reply_from_address)
  end

  def activation_email(username, email)
    data = username + "|" + email
    encrypted_data = AesEncrypt.encryption(data)

    @verify_url = accounts_confirm_email_url(token: encrypted_data)
    @username = username
    @email = email

    mail(to: email, subject: t('activation_account.verified'), from: "no-reply@4shift.com")
  end

  def new_reply(reply, user)
    unless user.locale.blank?
      @locale = user.locale
    else
      @locale = Rails.configuration.i18n.default_locale
    end
    title = I18n::translate(:new_reply, locale: @locale) + ': ' + reply.ticket.subject

    add_attachments(reply)
    add_reference_message_ids(reply)
    add_in_reply_to_message_id(reply)

    unless reply.message_id.blank?
      headers['Message-ID'] = "<#{reply.message_id}>"
    end

    @reply = reply
    @user = user

    mail(to: user.email, subject: title, from: reply.ticket.reply_from_address)
  end

  def status_changed(ticket)
    @ticket = ticket

    unless ticket.message_id.blank?
      headers['Message-ID'] = "<#{ticket.message_id}>"
    end

    mail(to: ticket.assignee.email, subject:
                                    'Ticket status modified in ' + ticket.status + ' for: ' \
        + ticket.subject, from: ticket.reply_from_address)
  end

  def priority_changed(ticket)
    @ticket = ticket

    unless ticket.message_id.blank?
      headers['Message-ID'] = "<#{ticket.message_id}>"
    end

    mail(to: ticket.assignee.email, subject:
                                    'Ticket priority modified in ' + ticket.priority + ' for: ' \
        + ticket.subject, from: ticket.reply_from_address)
  end

  def assigned(ticket)
    @ticket = ticket

    unless ticket.message_id.blank?
      headers['Message-ID'] = "<#{ticket.message_id}>"
    end

    mail(to: ticket.assignee.email, subject:
                                    'Ticket assigned to you: ' + ticket.subject, from: ticket.reply_from_address)
  end

  protected

  def add_reference_message_ids(reply)
    references = reply.other_replies.with_message_id.pluck(:message_id)

    if references.count > 0
      headers['References'] = '<' + references.join('> <') + '>'
    end
  end

  def add_in_reply_to_message_id(reply)

    last_reply = reply.other_replies.order(:id).last

    if last_reply.nil?
      headers['In-Reply-To'] = '<' + reply.ticket.message_id.to_s + '>'
    else
      headers['In-Reply-To'] = '<' + last_reply.message_id.to_s + '>'
    end

  end

  def add_attachments(ticket_or_reply)
    ticket_or_reply.attachments.each do |at|
      attachments[at.file_file_name] = File.read(at.file.path)
    end
  end

end
