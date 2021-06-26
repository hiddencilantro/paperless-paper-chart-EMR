class Provider < ApplicationRecord
    has_secure_password
    has_many :encounters
    has_many :patients, through: :encounters
end
