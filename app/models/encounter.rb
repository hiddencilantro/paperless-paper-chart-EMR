class Encounter < ApplicationRecord
  belongs_to :provider
  belongs_to :patient
  has_one :soap, dependent: :destroy
  accepts_nested_attributes_for :soap
  enum encounter_type: {soap: 0, physical: 1, well_child: 2}
  validates :encounter_type, presence: true
end
