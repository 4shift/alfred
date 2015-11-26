class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable

  has_many :tickets, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :labelings, as: :labelable, dependent: :destroy
  has_many :labels, through: :labelings
  has_many :identities
  has_many :conversations, :foreign_key => :sender_id

  # after_initialize :default_localization
  #after_create :create_default_conversation

  scope :agents, -> {
    where(agent: true)
  }

  scope :by_agent, ->(value) {
    where(agent: value)
  }

  scope :ordered, -> {
    order(:email)
  }

  scope :by_email, ->(email) {
    where('LOWER(email) LIKE ?', '%' + email.downcase + '%')
  }

  scope :search, ->(term) {
    if !term.nil?
      term.gsub!(/[\\%_]/) { |m| "!#{m}" }
      term = "%#{term.downcase}%"
      where('LOWER(email) LIKE ? ESCAPE ?', term, '!')
    end
  }

  def self.agents_to_notify
    User.agents
        .where(notify: true)
  end

  private

  def create_default_conversation
    Conversation.create(sender_id: 1, recipient_id: self.id) unless self.id == 1
  end

  class << self
    def find_by_confirmation_token(confirmation_token)
      original_token = confirmation_token
      confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)

      confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
      if !confirmable.persisted? && Devise.allow_insecure_token_lookup
        confirmable = find_or_initialize_with_error_by(:confirmation_token, original_token)
      end

      confirmable
    end

    def search(query)
      where("lower(name) LIKE :query OR lower(email) LIKE :query", query: "%#{query.downcase}%")
    end

    def sort(method)
      case method.to_s
        when 'recent_sign_in' then reorder(last_sign_in_at: :desc)
        when 'oldest_sign_in' then reorder(last_sign_in_at: :asc)
        else
          order_by(method)
      end
    end
  end
end
