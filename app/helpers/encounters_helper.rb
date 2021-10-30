module EncountersHelper
    def encounter_options
        [["SOAP", "soap"], ["Physical", "physical"], ["Well Child", "well_child"]]
    end

    def formatted_date(datetime)
        Time.zone.at(datetime).strftime("%Y-%-m-%-d")
    end

    def formatted_time(datetime)
        Time.zone.at(datetime).strftime("%l:%M %p")
    end
end
