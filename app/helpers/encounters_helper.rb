module EncountersHelper
    def encounter_options
        [["SOAP", "soap"], ["Physical", "physical"], ["Well Child", "well_child"]]
    end

    def new_encounter_text
        if params[:encounter_type] == "soap"
            "New SOAP"
        elsif params[:encounter_type] == "physical"
            "New Physical"
        elsif params[:encounter_type] == "well_child"
            "New Well Child"
        end
    end

    def new_encounter_header
        if params[:encounter_type] == "soap"
            content_tag(:h1, "New SOAP", id: "temp")
        elsif params[:encounter_type] == "physical"
            content_tag(:h1, "New Physical", id: "temp")
        elsif params[:encounter_type] == "well_child"
            content_tag(:h1, "New Well Child", id: "temp")
        end
    end

    def edit_encounter_text
        if @encounter.encounter_type == "soap"
            "Edit SOAP"
        elsif @encounter.encounter_type == "physical"
            "Edit Physical"
        elsif @encounter.encounter_type == "well_child"
            "Edit Well Child"
        end
    end

    def edit_encounter_header
        if @encounter.encounter_type == "soap"
            content_tag(:h1, "Edit SOAP", id: "temp")
        elsif @encounter.encounter_type == "physical"
            content_tag(:h1, "Edit Physical", id: "temp")
        elsif @encounter.encounter_type == "well_child"
            content_tag(:h1, "Edit Well Child", id: "temp")
        end
    end

    def formatted_date(datetime)
        Time.zone.at(datetime).strftime("%Y-%-m-%-d")
    end

    def formatted_time(datetime)
        Time.zone.at(datetime).strftime("%l:%M %p")
    end
end
