module CreateFromUser
  extend ActiveSupport::Concern

  included do
    attr_accessor :from

    def from=(email)

      unless email.blank?
        from_user = User.find_first_by_auth_conditions(email: email)

        unless from_user
          password_length = 12
          password = Devise.friendly_token.first(password_length)
          from_user = User.create(
            email: email,
            password: password, 
            password_confirmation: password
          )

          unless from_user
            errors.add(:from, :invalid)
          end
        end

        self.user = from_user
      end

    end

    def from
      user.email unless user.nil?
    end

  end

end
