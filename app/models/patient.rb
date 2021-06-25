class Patient < ApplicationRecord
    attr_accessor :is_provider
    has_secure_password validations: false
    enum sex: {unknown: 0, male: 1, female: 2, not_applicable: 9}
    has_many :encounters
    has_many :providers, through: :encounters
    validates :first_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :last_name, presence: true, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}
    validates :sex, presence: true
    validates :dob, presence: true
    validates :username, presence: true, uniqueness: true, format: {with: /\A[0-9a-zA-Z]+\z/, message: "only accepts letters and numbers"}, length: {in: 6..30}, unless: :is_provider
    validates :password, presence: true, confirmation: true, unless: :is_provider
    validates :password_confirmation, presence: true, unless: :is_provider
    validate :password_requirements, unless: -> {password.blank?}

    def patient?
        self.is_a?(Patient)
    end

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
