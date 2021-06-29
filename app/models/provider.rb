class Provider < ApplicationRecord
    has_secure_password validations: false
    has_many :encounters, dependent: :destroy
    has_many :patients, through: :encounters
    validates :first_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :last_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :username, presence: true, uniqueness: true, format: {with: /\A[0-9a-zA-Z_]+\z/, message: "only accepts letters and numbers"}, length: {in: 6..30}
    validates :password, presence: true, confirmation: true
    validates :password_confirmation, presence: true
    validate :password_requirements

    def password_requirements
        requirements = {
            " must be least 8 characters long" => /.{8,}/,
            " must contain at least one number but cannot start with a number" => /\D+\d+/,
            " must contain at least one lowercase letter" => /[a-z]+/,
            " must contain at least one uppercase letter" => /[A-Z]+/,
            " must contain at least one special character" => /[[:^alnum:]]+/
        }

        requirements.each do |message, regex|
            errors.add(:password, message) unless password.match(regex)
        end
    end
end
