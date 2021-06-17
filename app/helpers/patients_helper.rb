module PatientsHelper
    def age(dob)
        now = Time.zone.now.to_date
        now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1 )
    end
end
