class Account < ActiveRecord::Base

  RESTRICTED_SUBDOMAINS = %w(www admin)
  EMPLOYEES_RANGE = ["1~9", "10~50", "50~100", "100~200", "200~"]

  before_validation :downcase_subdomain

  validates :owner, presence: true
  validates :subdomain, presence: true,
                        uniqueness: { case_sensitive: false },
                        format: {
                          with: /\A[\w\-]+\Z/i,
                          message: :invalid_characters
                        },
                        exclusion: {
                          in: RESTRICTED_SUBDOMAINS,
                          message: :restricted
                        }

  belongs_to :owner, class_name: "User"
  has_many :users, inverse_of: :organization

  private

  def downcase_subdomain
    self.subdomain = subdomain.try(:downcase)
  end
end
