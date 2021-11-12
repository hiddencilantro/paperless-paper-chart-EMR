class Patient < ApplicationRecord
    attr_accessor :as_provider, :is_using_oauth
    has_secure_password validations: false
    enum sex: {unknown: 0, male: 1, female: 2, not_applicable: 9}
    has_and_belongs_to_many :providers, validate: false
    has_many :encounters, dependent: :destroy
    has_many :soaps, through: :encounters
    validates :first_name, presence: true
    validates :first_name, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}, unless: -> {first_name.blank?}
    validates :last_name, presence: true
    validates :last_name, format: {with: /\A[-a-z A-Z']+\z/, message: "only accepts letters, spaces, hyphens and apostrophes"}, unless: -> {last_name.blank?}
    validates :sex, presence: true
    validates :dob, presence: true
    with_options unless: [:as_provider, :is_using_oauth] do |user|
        user.validates :email, presence: true
        user.validates :email, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}, unless: -> {email.blank?}
        user.validates :password, presence: true, confirmation: { message: "doesn't match" }
    end
    validate :password_requirements, unless: -> {password.blank?}
    before_save :downcase_email, unless: -> {email.blank?}
    before_save :capitalize_name
    scope :five_most_recent, -> {order(updated_at: :desc).limit(5)}
    scope :ordered_and_grouped_by_last_name, -> {order(:last_name, :first_name).group_by{|p| p.last_name[0].capitalize}}
    scope :search_records, -> (search) {where(search.transform_values(&:capitalize))}

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

    def downcase_email
        self.email = email.downcase
    end

    def capitalize_name
        self.first_name = first_name.capitalize
        self.last_name = last_name.capitalize
    end

    def self.set_from_omniauth(auth)
        find_by(first_name: auth.info.first_name.capitalize, last_name: auth.info.last_name.capitalize) #include sex and dob in query
    end
end
