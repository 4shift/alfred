class Rule < ActiveRecord::Base
  validates :filter_field, presence: true

  enum filter_operation: [:contains, :equals]
  enum action_operation: [:assign_label, :notify_user, :change_status,
                          :change_priority, :assign_user]

  def filter(ticket)
    if ticket.respond_to?(filter_field)
      value = ticket.send(filter_field).to_s
    else
      value = ticket.attributes[filter_field].to_s
    end

    if filter_operation == 'contains'
      value.include?(filter_value)
    elsif filter_operation == 'equals'
      value == filter_value
    end
  end

  def execute(ticket)
    if action_operation == 'assign_label'
      label = Label.where(name: action_value).first_or_create
      ticket.labels << label

    elsif action_operation == 'notify_user'
      user = User.where(email: action_value).first

      ticket.notified_users << user unless user.nil?

    elsif action_operation == 'change_status'
      ticket.status = action_value.downcase
      ticket.save

    elsif action_operation == 'change_priority'
      ticket.priority = action_value.downcase
      ticket.save

    elsif action_operation == 'assign_user'
      user = User.where(email: action_value).first

      unless user.nil?
        ticket.assignee = user
        ticket.save
      end

    end
  end

  def self.apply_all(ticket)
    Rule.all.each do |rule|
      rule.execute(ticket) if rule.filter(ticket)
    end
  end
end
