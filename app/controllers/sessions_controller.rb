class SessionsController < ApplicationController
    def login
        redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You're already logged in! If you'd like to sign in with a different account, you must first log out."} if logged_in?
    end

    def provider_auth
        user = Provider.find_by(email: params[:email].downcase)
        if user
            if user.authenticate(params[:password])
                log_in(user)
                redirect_to user
            else
                redirect_to providers_login_path, alert: "Incorrect password."
            end
        else
            redirect_to providers_login_path, alert: "Email doesn't exist."
        end
    end

    def patient_auth
        user = Patient.find_by(email: params[:email].downcase)
        if user
            if user.authenticate(params[:password])
                log_in(user)
                redirect_to user
            else
                redirect_to patients_login_path, alert: "Incorrect password."
            end
        else
            redirect_to patients_login_path, alert: "Email doesn't exist."
        end
    end

    def google_auth
        auth = request.env["omniauth.auth"]
        user = Patient.set_from_omniauth(auth)
        if user.present?
            user.is_using_oauth = true
            user.email = auth.info.email
            user.save
            log_in(user)
            redirect_to user
        else
            flash.now[:alert] = "We couldn't find you in our database. <br> If you've never visited us before, please click the link below to set up an appointment. <br> Or if you're using a third-party service, the name on your account must match the name on our patient record. <br> If you're still experiencing issues, please give us a call."
            render :'static/main'
        end
    end

    def logout
        if current_user.provider?
            session.delete(:provider_id)
        elsif current_user.patient?
            session.delete(:patient_id)
        end
        @current_user = nil
        redirect_to root_path, notice: "You have successfully logged out."
    end
end
