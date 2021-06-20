class Patient < ApplicationRecord
    enum sex: {unknown: 0, male: 1, female: 2, not_applicable: 9}
    has_many :encounters
    has_many :providers, through: :encounters

    def patient?
        self.is_a?(Patient)
    end
end
