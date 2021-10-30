class Provider < ApplicationRecord
    has_secure_password
    has_and_belongs_to_many :patients
    has_many :encounters #edge case: how should encounters be handled if Provider is destroyed?
    has_many :soaps, through: :encounters
    validates :first_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :last_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
    validate :password_requirements, unless: -> {password.blank?}
    before_save { self.email = email.downcase }

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
21