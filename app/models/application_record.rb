class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def provider?
    self.is_a?(Provider)
  end

  def patient?
    self.is_a?(Patient)
  end
end
