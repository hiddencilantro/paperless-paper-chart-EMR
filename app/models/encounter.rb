class Encounter < ApplicationRecord
  belongs_to :provider
  belongs_to :patient
  has_one :soap
  enum encounter_type: {soap: 0, physical: 1, well_child: 2}
  validates :encounter_type, presence: true
end
