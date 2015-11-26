class EmailAddress < ActiveRecord::Base

  validates :email, uniqueness: true, presence: true

  before_save :ensure_one_default
  before_create :generate_verification_token

  scope :ordered, -> { order(:email) }
  scope :verified, -> { where(verification_token: nil) }

  def self.default_email
    unless EmailAddress.verified.where(default: true).first.nil?
      EmailAddress.verified.where(default: true).first.email
    else
      "#{Apartment::Tenant.current}@4shift.com"
    end
  end
 
  def self.find_first_verified_email(addresses)
    if addresses.nil?
      nil
    else
      verified.where(email: addresses.map(&:downcase)).first
    end
  end

  def formatted
    if name.blank?
      email
    else
      "#{name} <#{email}>"
    end
  end

  protected

  def ensure_one_default
    if self.default
      EmailAddress.where.not(id: self.id).update_all(default: false)
    end
  end

  def generate_verification_token
    self.verification_token = Devise.friendly_token
  end
end
