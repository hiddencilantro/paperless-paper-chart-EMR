# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

<!-- 

///to do or fix:
* pull birthday and gender from Google OAuth [prevent OAuth users from intercepting other patients' accounts]
* make dynamic breadcrumbs
* make seed file
* make sanitize and validation methods private?

///to implement next:
* Apppintment class
    - Patients must be permitted to make an appointment before being registered
    - choose Provider from collection
* Patient#create (as Provider)
    - pre-populate patient info from details in Appointment
* SOAP#create
    - pre-populate encounter from details in Appointment

///stretch goals:
* security (https://guides.rubyonrails.org/security.html)
    - session hijacking
    - injections
    - prevent password params from being logged
* password entry for destroying records instead of just confirmation pop-ups
* have user select time zone or use JS to get local time on client side?
* refactor to limit logic in controllers?

///
<%= button_to "Delete Account", current_user, method: :delete, data: {confirm: "You are about to permanently delete a provider account. ALL of your data will be lost. Are you sure?"} %>
///

///
Confirmation pop-up: Cannot use the "confirm" data attribute for FormBuilder (must use JS instead), only available for FormTagHelper

<%= f.submit, data: {confirm: "Does everything look accurate? You cannot change your information once your account has been created."} %>
<%= f.submit, data: {confirm: "Are you sure you want to save these changes?"} %>
///

 -->