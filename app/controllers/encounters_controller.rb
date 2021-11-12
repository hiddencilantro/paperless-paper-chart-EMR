class EncountersController < ApplicationController
    before_action :verify_if_logged_in, :set_patient_by_id
    before_action :authorize_provider, except: [:index, :show]
    before_action :set_encounter_by_id, except: [:index, :new, :create]
    # before_action :add_patient_index_bc, :add_patient_directory_bc, :add_patient_show_bc, except: [:create, :update, :destroy]
    # before_action :add_encounters_index_bc, only: [:new, :show, :edit]
    before_action :add_all_breadcrumbs, except: [:create, :update, :destroy]
    
    def index
        if not_authorized(@patient)
            redirect_to patient_encounters_path(current_user), alert: "You do not have access to another patient's records."
        elsif !@patient
            redirect_to provider_patients_path(current_user), alert: "Patient record not found"
        end
        @encounters = @patient.encounters.ordered_by_most_recent if @patient
        # add_breadcrumb("Encounters")
    end

    def new
        redirect_back fallback_location: patient_encounters_path(@patient), allow_other_host: false, alert: "Choose a type of encounter" if params[:encounter_type].blank?
        @encounter = Encounter.new
        if params[:encounter_type] == "soap"
            @encounter.build_soap
        end
        # add_breadcrumb(helpers.new_encounter_text)
    end

    def create
        @encounter = Encounter.new(encounter_params)
        @encounter.provider = current_user
        @encounter.patient = @patient
        if @encounter.save
            @patient.touch
            @encounter.patient.providers << current_user if !@encounter.patient.providers.include?(current_user)
            redirect_to patient_encounter_path(@patient, @encounter), notice: "New #{@encounter.encounter_type.titleize} record created!"
        else
            render :new
        end
    end

    def show
        if not_authorized(@patient)
            redirect_to patient_encounters_path(current_user), alert: "You do not have access to another patient's records."
        elsif !@patient
            redirect_to provider_patients_path(current_user), alert: "Patient record not found"
        elsif !@encounter && logged_in_as_provider
            redirect_to patient_encounters_path(@patient), alert: "No encounter record by that id for this patient"
        elsif !@encounter && logged_in_as_patient
            redirect_to patient_encounters_path(@patient), alert: "You do not have an encounter record by that id"
        end
        # add_breadcrumb("#{helpers.formatted_date(@encounter.created_at)} [#{@encounter.encounter_type.titleize}]") if @encounter
    end

    def edit
        if !@patient
            redirect_to provider_patients_path(current_user), alert: "Patient record not found"
        elsif !@encounter
            redirect_to patient_encounters_path(@patient), alert: "No encounter record by that id for this patient"
        elsif @encounter.provider != current_user
            redirect_back fallback_location: patient_encounter_path(@patient, @encounter), allow_other_host: false, alert: "You can't edit another provider's encounter record."
        end
        # add_breadcrumb("#{helpers.formatted_date(@encounter.created_at)} [#{@encounter.encounter_type.titleize}]", patient_encounter_path(@patient, @encounter)) if @patient && @encounter
        # add_breadcrumb(helpers.edit_encounter_text) if @encounter
    end

    def update
        @encounter.assign_attributes(encounter_params)
        if @encounter.save
            @patient.touch
            redirect_to patient_encounter_path(@patient, @encounter), notice: "Record successfully updated"
        else
            render :edit
        end
    end

    def destroy
        if @encounter.provider != current_user
            redirect_back fallback_location: patient_encounter_path(@patient, @encounter), allow_other_host: false, alert: "You can't delete another provider's encounter record."
        else
            @encounter.destroy
            @patient.touch
            redirect_to patient_encounters_path(@patient, @encounter), notice: "#{@encounter.encounter_type.titleize} successfully deleted"
        end
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

    # def add_encounters_index_bc
    #     add_breadcrumb("Encounters", patient_encounters_path(@patient)) if @patient
    # end
end
