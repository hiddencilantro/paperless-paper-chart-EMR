module EncountersHelper
    def encounter_options
        [["SOAP", "soap"], ["Physical", "physical"], ["Well Child", "well_child"]]
    end

    def new_encounter
        if params[:encounter_type] == "soap"
            content_tag(:h2, "SOAP")
        elsif params[:encounter_type] == "physical"
            content_tag(:h2, "Physical")
        elsif params[:encounter_type] == "well_child"
            content_tag(:h2, "Well Child")
        end
    end

    def edit_encounter
        if @encounter.encounter_type == "soap"
            content_tag(:h2, "Edit SOAP")
        elsif @encounter.encounter_type == "physical"
            content_tag(:h2, "Edit Physical")
        elsif @encounter.encounter_type == "well_child"
            content_tag(:h2, "Edit Well Child")
        end
    end

    def formatted_date(datetime)
        Time.zone.at(datetime).strftime("%Y-%-m-%-d")
    end

    def formatted_time(datetime)
        Time.zone.at(datetime).strftime("%l:%M %p")
    end
end
