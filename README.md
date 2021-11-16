# Paperless Paper Chart (Beta)

Paperless Paper Chart is an Electronic Medical Record (EMR) system that allows both providers and patients to easily communicate, manage appointments, keep track of health records, and upload imaging or other documents. Its primary purpose is to seamlessly connect physicians with their patients using a straightforward and clutter-free platform that's convenient for any medical setting.

## Prerequisites

Before you begin, ensure you have met the following requirements:

* You have installed `ruby 2.6.1`, `rails 6.1.3`, `PostgreSQL` and all other dependencies.

## Installing Paperless Paper Chart

To install PPC, follow these steps:

1. Fork and clone the repository
2. Run `bundle install` to require all dependencies from the Gemfile
3. Run `rake db:setup`
4. Run `rake db:migrate`
5. (Optional) Run `rake db:seed` if you'd like to seed some data. *Please create the first Provider account before you seed.

## Using Paperless Paper Chart (locally)

This project is currently still in development and will not be hosted live until production. But to try out the beta version, follow these steps:

1. Run `rails s` to start up the server on your local machine
2. Navigate to http://localhost:3000/ (default port) in your web browser

## Contact

If you want to contact me you can reach me at <thehiddencilantro@gmail.com>.

## Copyright Notice and Statement

This project is under exclusive copyright and is currently not offering any license for open-source contributions. Nobody shall copy, distribute, or modify this project unless specified otherwise.

## Links
[Beta version](https://shielded-beach-31390.herokuapp.com/)

<!-- 

///to do or fix:
* application.rb -> config.force_ssl = true
* remove GET route to /logout?
* when using omniauth, is there a downside to skipping validations instead of generating a random password every time (i.e. SecureRandom.hex())?
* pull birthday and gender from Google OAuth [prevent OAuth users from intercepting other patients' accounts]
* encounter -> accepts_nested_attributes_for -> reject_if: :all_blank -> validate to prevent persisting encounter when nested attributes are rejected
* breadcrumb w/ patient name can change if we error while editing name fields

///to implement next:
* Apppintment class
    - Patients must be permitted to make an appointment before being registered
    - choose Provider from collection
* Patient#create (as Provider)
    - pre-populate patient info from details in Appointment
* SOAP#create
    - pre-populate encounter from details in Appointment
* implement additional OAuth providers
* password entry for destroying records instead of just confirmation pop-ups
* have user select time zone or use JS to get local time on client side?
* encounters index (limit # of displayed records per page)
    - links to page numbers
    - allow user to select how many records to display
* add search/filter for encounters (by type, date, or physician)
* add physical and well child encounters

///stretch goals:
* security (https://guides.rubyonrails.org/security.html)
    - session hijacking
    - injections
    - prevent password params from being logged
* software licensing (product key)
    - allow users to select location during signup

///
<%= button_to "Delete Account", current_user, method: :delete, data: {confirm: "You are about to permanently delete a provider account. ALL of your data will be lost. Are you sure?"} %>
///

///
Confirmation pop-up: Cannot use the "confirm" data attribute for FormBuilder (must use JS instead), only available for FormTagHelper

<%= f.submit, data: {confirm: "Does everything look accurate? You cannot change your information once your account has been created."} %>
<%= f.submit, data: {confirm: "Are you sure you want to save these changes?"} %>
///

///
another potential solution to breadcrumbs:
    - include all actions in case statement & use before_action
    - handle breadcrumbs for post-error re-renders by possibly using different layouts or variants
///

 -->