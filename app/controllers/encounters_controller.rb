class EncountersController < ApplicationController
    before_action :verify_if_logged_in, :authorize_provider, :set_patient_by_id
    before_action :set_encounter_by_id, except: [:index, :new, :create]
    
    def index
        @encounters = @patient.encounters.order(updated_at: :desc)
    end

    def new
        redirect_back fallback_location: patient_encounters_path(@patient), allow_other_host: false, alert: "Choose a type of encounter" if params[:encounter_type].blank?
        @encounter = Encounter.new
        @encounter.build_soap
    end

    def create
        @encounter = Encounter.new(encounter_params)
        @encounter.provider = current_user
        @encounter.patient = @patient
        if @encounter.save
            redirect_to patient_encounter_path(@patient, @encounter), notice: "New record was successfully created!"
        else
            render :new
        end
    end

    def show
    end

    def edit
    end

    def update
        @encounter.assign_attributes(encounter_params)
        if @encounter.save
            redirect_to patient_encounter_path(@patient, @encounter), notice: "Record was successfully updated!"
        else
            render :edit
        end
    end

    def destroy
        @encounter.destroy
        redirect_to patient_encounters_path(@patient)
    end

    private

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:patient_id])
    end

    def encounter_params
        params.require(:encounter).permit(:encounter_type, soap_attributes: [:chief_complaint, :subjective, :objective, :assessment_and_plan])
    end

    def set_encounter_by_id
        @encounter = Encounter.find_by(id: params[:id])
    end
end
