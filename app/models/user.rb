class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :username, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password

    has_many :events
    has_many :questions
    has_many :answers

    def change_token!
        self.auth_token = generate_token
        self.save!
    end

    def add_karma!(reason)
        case reason
        when 'event'
            self.karma += 3
        when 'answer'
            self.karma += 2
        when 'question'
            self.karma += 1
        end
        self.save!
    end

    private

    def generate_token
        loop do
            random_token = SecureRandom.urlsafe_base64(nil, false)
            break random_token unless User.exists?(auth_token: random_token)
        end
    end
end
