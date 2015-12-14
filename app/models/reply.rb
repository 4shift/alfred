class Reply < ActiveRecord::Base
  include CreateFromUser
  include RawMessage

  has_many :attachments, as: :attachable, dependent: :destroy

  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :notified_users, source: :user, through: :notifications
  has_many :cc_users, source: :user, through: :notifications

  accepts_nested_attributes_for :attachments

  validates :ticket_id, :content, presence: true

  belongs_to :ticket, touch: true
  belongs_to :user

  accepts_nested_attributes_for :ticket

  scope :chronologically, -> { order(:id) }
  scope :with_message_id, lambda {
                          where.not(message_id: nil)
                        }

  scope :without_drafts, -> {
    where(draft: false)
  }

  scope :unlocked_for, ->(user) {
    joins(:ticket)
      .where('locked_by_id IN (?) OR locked_at < ?',
             [user.id, nil], Time.zone.now - 5.minutes)
  }

  default_scope { order('created_at desc') }

  def set_default_notifications!
    users = users_to_notify.select do |user|
      Ability.new(user).can? :show, self
    end
    self.notified_user_ids = users.map(&:id)
  end

  def other_replies
    ticket.replies.where.not(id: id)
  end

  def users_to_notify
    to = [ticket.user] + other_replies.map(&:user)

    if ticket.assignee.present?
      to << ticket.assignee
    else
      to += User.agents_to_notify
    end

    ticket.labels.each do |label|
      to += label.users
    end

    to.uniq - [user]
  end
end
