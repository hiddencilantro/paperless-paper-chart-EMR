class EncountersController < ApplicationController
    before_action :verify_if_logged_in
    before_action :authorize_provider
    before_action :set_patient_by_id
    
    def index
        @encounters = @patient.encounters
        @encounter = Encounter.new
    end

    def create
        encounter = Encounter.new(encounter_params)
        encounter.provider = current_user
        encounter.patient = @patient
        encounter.save
        redirect_to new_patient_encounter_soap_path(@patient, encounter)
    end

    private

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:patient_id])
    end

    def encounter_params
        params.require(:encounter).permit(:encounter_type)
    end
end
