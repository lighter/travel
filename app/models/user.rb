class User < ActiveRecord::Base
    # 添加密碼驗證
    has_secure_password

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    before_save { self.email = email.downcase } # email convet to downcase

    validates :name, presence: true, length: { maximum: 50 } # name 不得為空直, 最大長度 50

    # email 不得為空直, 最大長度 255, Email 格式, 忽略大小寫的唯一性
    validates :email, presence: true, length: { maximum: 255 },
                                      format: { with: VALID_EMAIL_REGEX },
                                      uniqueness: { case_sensitive: false }

    validates :password, presence: true, length: { minimum: 6 }
end
