class SoapsController < ApplicationController
    before_action :verify_if_logged_in
    before_action :authorize_provider
    before_action :set_patient_by_id
    before_action :set_encounter_by_id

    def new
        @soap = SOAP.new
    end

    private

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:patient_id])
    end

    def set_encounter_by_id
        @encounter = Encounter.find_by(id: params[:encounter_id])
    end
end