class User < ActiveRecord::Base
    # 添加密碼驗證
    has_secure_password

    # user.remember_token
    attr_accessor :remember_token, :activation_token, :reset_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    before_save :downcase_email # email convet to downcase
    before_create :create_activation_digest

    validates :name, presence: true, length: { maximum: 50 } # name 不得為空直, 最大長度 50

    # email 不得為空直, 最大長度 255, Email 格式, 忽略大小寫的唯一性
    validates :email, presence: true, length: { maximum: 255 },
                                      format: { with: VALID_EMAIL_REGEX },
                                      uniqueness: { case_sensitive: false }

    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    class << self
        # gen password hash
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                        : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        # random token
        def new_token
            # length 22
            SecureRandom.urlsafe_base64
        end
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticate?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?

        # check remember_digest equal to remember_token
        BCrypt::Password.new(digest).is_password?(token)
    end

    # forget remember
    def forget
        update_attribute(:remember_digest, nil)
    end

    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    private

        def downcase_email
            self.email = email.downcase
        end

        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
