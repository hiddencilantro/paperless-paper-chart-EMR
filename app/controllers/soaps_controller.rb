class SoapsController < ApplicationController
    before_action :verify_if_logged_in, :authorize_provider, :set_patient_by_id, :set_encounter_by_id

    def new
        @soap = SOAP.new
    end

    def create

    end

    private

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:patient_id])
    end

    def set_encounter_by_id
        @encounter = Encounter.find_by(id: params[:encounter_id])
    end
end