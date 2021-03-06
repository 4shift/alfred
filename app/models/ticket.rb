class Ticket < ActiveRecord::Base
  include CreateFromUser
  include RawMessage

  validates_presence_of :user_id

  belongs_to :user
  belongs_to :assignee, class_name: 'User'
  belongs_to :to_email_address, -> { EmailAddress.verified }, class_name: 'EmailAddress'
  belongs_to :locked_by, class_name: 'User'

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :replies, dependent: :destroy
  has_many :labelings, as: :labelable, dependent: :destroy
  has_many :labels, through: :labelings

  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :notified_users, source: :user, through: :notifications

  has_many :status_changes, dependent: :destroy

  enum status: [:open, :closed, :deleted, :waiting]
  enum priority: [:unknown, :low, :medium, :high]

  after_update :log_status_change
  after_create :create_status_change

  def self.active_labels(status)
    label_ids = where(status: Ticket.statuses[status])
        .joins(:labelings)
        .pluck(:label_id)
        .uniq

    return Label.where(id: label_ids)
  end

  scope :by_label_id, ->(label_id) {
    if label_id.to_i > 0
      joins(:labelings).where(labelings: { label_id: label_id })
    end
  }

  scope :by_status, ->(status) {
    where(status: Ticket.statuses[status.to_sym])
  }

  scope :filter_by_assignee_id, ->(assignee_id) {
    if !assignee_id.nil?
      if assignee_id.to_i == 0
        where(assignee_id: nil)
      else
        where(assignee_id: assignee_id)
      end
    else
      all
    end
  }

  scope :search, ->(term) {
    if !term.nil?
      term.gsub!(/[\\%_]/) { |m| "!#{m}" }
      term = "%#{term.downcase}%"
      where('LOWER(subject) LIKE ? ESCAPE ? OR LOWER(content) LIKE ? ESCAPE ?',
            term, '!', term, '!')
    end
  }

  scope :ordered, -> {
    order(:updated_at).reverse_order
  }

  scope :viewable_by, ->(user) {
    if !user.agent? || user.labelings.count > 0
      ticket_ids = Labeling.where(label_id: user.label_ids)
                       .where(labelable_type: 'Ticket')
                       .pluck(:labelable_id)
      where('tickets.id IN (?) OR tickets.user_id = ? OR tickets.assignee_id = ?',
            ticket_ids, user.id, user.id)
    end
  }

  scope :unlocked_for, ->(user) {
    where('locked_by_id IN (?) OR locked_at < ?', [user.id, nil], Time.zone.now - 5.minutes)
  }

  def previous_ticket
    self.class.ordered.where("updated_at > ?", updated_at).last
  end

  def next_ticket
    self.class.ordered.where("updated_at < ?", updated_at).first
  end

  def set_default_notifications!
    users = User.agents_to_notify.select do |user|
      Ability.new(user).can? :show, self
    end
    self.notified_user_ids = users.map(&:id)
  end

  def status_times
    total = {}

    Ticket.statuses.keys.each do |key|
      total[key.to_sym] = 0
    end

    status_changes.each do |status_change|
      total[status_change.status.to_sym] += status_change.updated_at - status_change.created_at
    end

    # add the current status as well
    current = status_changes.ordered.last
    unless current.nil?
      total[current.status.to_sym] += Time.now - current.created_at
    end

    Ticket.statuses.keys.each do |key|
      total[key.to_sym] /= 1.minute
    end

    total
  end

  def reply_from_address
    if to_email_address.nil?
      EmailAddress.default_email
    else
      to_email_address.formatted
    end
  end

  def locked?(for_user)
    locked_by != for_user && locked_by != nil && locked_at > Time.zone.now - 5.minutes
  end

  def to
    to_email_address.try :email
  end

  protected
  def create_status_change
    status_changes.create! status: self.status
  end

  def log_status_change

    if self.changed.include? 'status'
      previous = status_changes.ordered.last

      unless previous.nil?
        previous.updated_at = Time.now
        previous.save
      end

      status_changes.create! status: self.status
    end
  end
end
