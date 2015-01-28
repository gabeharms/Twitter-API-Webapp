class User < ActiveRecord::Base
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i      # This is a regular expression which detail the format that any email must conform to
    
    before_save { self.email = email.downcase }                   # Make sure all saved email addresses are lower case to avoid saving two versions of the same email address
     
    validates :name,  presence: true, length: { maximum: 50 }     # Validates that the name field exists, and is less than 50 chars
    validates :email, presence: true, length: { maximum: 255 },   # Validates that the email field exists, and is less than 255 chars
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

    has_secure_password                                           # Adds a password digest field to our database so user passwords are secure
    validates :password, length: { minimum: 6 }
    
end

