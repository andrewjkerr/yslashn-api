class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :username, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password

    def generate_token
        loop do
            random_token = SecureRandom.urlsafe_base64(nil, false)
            break random_token unless User.exists?(auth_token: random_token)
        end
    end

    def change_token!
        self.auth_token = generate_token
        self.save!
    end
end
