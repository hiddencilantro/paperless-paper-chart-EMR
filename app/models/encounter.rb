class Encounter < ApplicationRecord
  belongs_to :provider
  belongs_to :patient
  has_one :soap, dependent: :destroy
  accepts_nested_attributes_for :soap
  enum encounter_type: {soap: 0, physical: 1, well_child: 2}
  validates :encounter_type, presence: true, inclusion: { in: ["soap", "physical", "well_child"]}
  scope :ordered_by_most_recent, -> {order(created_at: :desc)}
end
