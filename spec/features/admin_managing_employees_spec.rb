require 'rails_helper'

RSpec.feature 'Admin managing employees' do
  let(:org_id_1) { 123 }
  let(:service_1) { FactoryBot.create :service, name: 'Service Name 1' }
  let(:service_2) { FactoryBot.create :service, name: 'Service Name 2' }


  context 'signed in' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:outpost, {
        uid: 12345,
        info: {
          email: 'user@example.com'
        },
        extra: {
          raw_info: {
            organisation_id: org_id_1,
            organisation: {
              id: org_id_1,
              services: [
                service_1, service_2
              ]
            },
            admin: true,
            admin_users: true
          }
        }
      })

      visit root_path
      click_link 'Admin'
      click_button 'Sign in'
      visit admin_employees_path
    end

    after do
      OmniAuth.config.test_mode = false
    end

    scenario 'initially viewing that no employees have been created ' do
      visit admin_employees_path

      expect(page).to have_content('No employees found')
    end

    
    context 'with employee records in the DB' do
      let!(:employee_1) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_1.id, employed_from: Date.today - 1.year,  job_title: 'Manager/Leader/Supervisor' }
      let!(:employee_2) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_1.id, employed_from: Date.today - 1.year, job_title: 'Childminder' }
      let!(:employee_3) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_2.id, employed_from: Date.today - 1.year, job_title: 'Nanny' }
      let!(:employee_4) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_2.id, employed_from: Date.today - 1.year, currently_employed: false, employed_to: Date.today, job_title: 'Treasurer', has_dbs_check: true, dbs_achieved_on: Date.today - 1.year}

      before do
        visit root_path
        click_link 'Start now'
        choose 'Yes'
        click_button 'Continue'
        click_button 'Sign in'
        visit admin_employees_path
      end


      scenario 'you view all employees' do

        expect(page).to have_content('Provider employee details')
        expect(page).to have_content(employee_1.forenames)
        expect(page).to have_content(employee_2.forenames)
        expect(page).to have_content(employee_3.forenames)
      end

      scenario 'you search by employee name' do
        fill_in 'filterrific[search]', with: employee_1.forenames
        find('#search-button').click

        expect(page).to have_content(employee_1.forenames)
        expect(page).to have_content(employee_1.surname)
        expect(page).to have_content(employee_1.job_title)
        expect(page).to have_content(employee_1.qualifications)
      end

      scenario 'you search by service' do
        fill_in 'filterrific[search]', with: service_2.name
        find('#search-button').click

        expect(page).to have_content(employee_3.forenames)
      end

      scenario 'you filter by job title' do
        find('details.filters').click
        select employee_1.job_title, from: 'filterrific[job_title]'
        find('#search-button').click

        expect(page).to have_content(employee_1.forenames)
        expect(page).to have_content(employee_1.surname)
        expect(page).to have_content(employee_1.job_title)
        expect(page).to have_content(employee_1.qualifications)
      end

      scenario 'you filter by status' do
        find('details.filters').click
        select 'Active', from: 'filterrific[status]'
        find('#search-button').click

        expect(page).to have_content(employee_1.forenames)
        expect(page).to have_content(employee_1.surname)
        expect(page).to have_content(employee_1.job_title)
        expect(page).to have_content(employee_1.qualifications)
      end

      scenario 'you filter by service' do
        find('details.filters').click
        select service_1.name, from: 'filterrific[service]'
        find('#search-button').click

        expect(page).to have_content(employee_1.forenames)
        expect(page).to have_content(employee_2.forenames)
      end

      scenario 'you view an individual employee' do
        click_link employee_1.forenames

        expect(page).to have_content(employee_1.forenames)
        expect(page).to have_content(employee_1.surname)
        expect(page).to have_content(employee_1.job_title)
        expect(page).to have_content(employee_1.qualifications)
      end

      scenario 'you can see the option to edit an individual employee' do
        click_link employee_1.forenames

        expect(page).to have_content('Edit')
      end

      scenario 'you can see the option to delete an individual employee' do
        click_link employee_1.forenames

        expect(page).to have_content('Delete record')
      end

      scenario 'you can edit an individual employees name' do
        click_link employee_1.forenames
        click_link 'Edit'
        fill_in 'employee[forenames]', with: 'Jane'
        click_button 'Save'

        expect(page).to have_content('Jane')
      end

      scenario 'you can edit an individual employees surname' do
        click_link employee_1.forenames
        click_link 'Edit'
        fill_in 'employee[surname]', with: 'Doe'
        click_button 'Save'

        expect(page).to have_content('Doe')
      end

      scenario 'you can edit an individual employees date of birth' do
        click_link employee_1.forenames
        click_link 'Edit'
        fill_in 'employee[date_of_birth]', with: '01/01/1990'
        click_button 'Save'

        expect(page).to have_content('01/01/1990')
      end

      scenario 'you can edit an individual employees service' do
        click_link employee_1.forenames
        click_link 'Edit'
        select service_2.name, from: 'employee[service_id]'
        click_button 'Save'

        expect(page).to have_content(service_2.name)
      end

      scenario 'you can edit an individual employees job title' do
        click_link employee_1.forenames
        click_link 'Edit'
        select 'Nanny', from: 'employee[job_title]'
        click_button 'Save'

        expect(page).to have_content('Nanny')
      end

      scenario 'you can edit an individual employees qualifications' do
        click_link employee_1.forenames
        click_link 'Edit'
        check 'Level 3'
        click_button 'Save'

        expect(page).to have_content('Level 3')
      end

      scenario 'you can edit an individual employees status' do
        click_link employee_1.forenames
        click_link 'Edit'
        check 'Currently employed'
        click_button 'Save'

        expect(page).to have_content('Active')
      end

      scenario 'you can edit an individual employees employment start date' do
        click_link employee_1.forenames
        click_link 'Edit'
        fill_in 'employee[employed_from]', with: (Date.today - 2.years).strftime('%d/%m/%Y')
        click_button 'Save'
        formatted_date = (Date.today - 2.years).strftime('%d/%m/%Y')

        expect(page).to have_content(formatted_date)
      end

      scenario 'you can edit an individual employees employment end date' do
        click_link employee_4.forenames
        click_link 'Edit'
        fill_in 'employee[employed_to]', with: (Date.today - 1.year).strftime('%Y-%m-%d')
        click_button 'Save'
        formatted_date = (Date.today - 1.year).strftime('%d/%m/%Y')

        expect(page).to have_content(formatted_date)
      end
      

      scenario 'you can edit an individual employees address' do
        click_link employee_1.forenames
        click_link 'Edit'
        fill_in 'employee[street_address]', with: '123 New Street'
        fill_in 'employee[postal_code]', with: 'AB1 2CD'
        click_button 'Save'

        expect(page).to have_content('123 New Street')
        expect(page).to have_content('AB1 2CD')
      end

      scenario 'you receive error messages when editing an individual employee with invalid data' do
        click_link employee_1.forenames
        click_link 'Edit'
        fill_in 'employee[forenames]', with: ''
        click_button 'Save'

        expect(page).to have_content("Forenames can't be blank")
      end

      scenario 'you delete an individual employee' do
        click_link employee_1.forenames
        click_link 'Delete'

        expect(page).to have_content('Employee was successfully deleted.')
      end
    end

  end
end

