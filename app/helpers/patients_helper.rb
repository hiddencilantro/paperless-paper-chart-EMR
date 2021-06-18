module PatientsHelper
    def age(dob)
        now = Time.zone.now.to_date
        if now.year == dob.year && now.month > dob.month
            "#{pluralize((now.month - dob.month), 'month')}"
        elsif now.year == dob.year && now.month == dob.month
            "#{pluralize((now.day - dob.day), 'day')}"
        else
            now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1 )
        end
    end
end
