class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def provider?
    self.is_a?(Provider)
  end

  def patient?
    self.is_a?(Patient)
  end

  def downcase_email
    self.email = email.downcase
  end

  def capitalize_name
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
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
