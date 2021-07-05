class Patient < ApplicationRecord
    attr_accessor :is_provider
    has_secure_password validations: false
    enum sex: {unknown: 0, male: 1, female: 2, not_applicable: 9}
    has_many :encounters, dependent: :destroy
    has_many :providers, through: :encounters, validate: false
    validates :first_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :last_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :sex, presence: true
    validates :dob, presence: true
    validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}, unless: :is_provider
    validates :password, presence: true, confirmation: true, unless: :is_provider
    validates :password_confirmation, presence: true, unless: :is_provider
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
