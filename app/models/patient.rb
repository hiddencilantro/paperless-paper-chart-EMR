class Patient < ApplicationRecord
    enum sex: {Unknown: 0, Male: 1, Female: 2, not_applicable: 9}
    has_many :encounters
    has_many :providers, through: :encounters
end
