class Provider < ApplicationRecord
    has_secure_password
    has_many :encounters, dependent: :destroy
    has_many :patients, through: :encounters
end
