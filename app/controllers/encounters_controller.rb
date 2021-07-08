class EncountersController < ApplicationController
    before_action :verify_if_logged_in, :authorize_provider, :set_patient_by_id, :view_all_patient_encounters
    
    def index
        @encounter = Encounter.new
    end

    def create
        @encounter = Encounter.new(encounter_params)
        @encounter.provider = current_user
        @encounter.patient = @patient
        if @encounter.save
            redirect_to new_patient_encounter_soap_path(@patient, encounter)
        else
            render :index
        end
    end

    private

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:patient_id])
    end

    def view_all_patient_encounters
        @encounters = @patient.encounters
    end

    def encounter_params
        params.require(:encounter).permit(:encounter_type)
    end
end
