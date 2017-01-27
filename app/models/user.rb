class User < ActiveRecord::Base
    # 添加密碼驗證
    has_secure_password

    # user.remember_token
    attr_accessor :remember_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    before_save { self.email = email.downcase } # email convet to downcase

    validates :name, presence: true, length: { maximum: 50 } # name 不得為空直, 最大長度 50

    # email 不得為空直, 最大長度 255, Email 格式, 忽略大小寫的唯一性
    validates :email, presence: true, length: { maximum: 255 },
                                      format: { with: VALID_EMAIL_REGEX },
                                      uniqueness: { case_sensitive: false }

    validates :password, presence: true, length: { minimum: 6 }

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

    def authenticate?(remember_token)
        return false if remember_digest.nil?
        # check remember_digest equal to remember_token
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # forget remember
    def forget
        update_attribute(:remember_digest, nil)
    end
end
