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
            }
          }
        }
      })

      visit root_path
      click_link 'click here'
    end

    after do
      OmniAuth.config.test_mode = false
    end

    scenario 'initially viewing that no employees have been created ' do
      visit admin_employees_path

      expect(page).to have_content('No employees found')
    end

    
    context 'with employee records in the DB' do
      let!(:employee_1) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_1.id, employed_from: Date.today - 1.year  }
      let!(:employee_2) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_1.id, employed_from: Date.today - 1.year  }
      let!(:employee_3) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_2.id, employed_from: Date.today - 1.year }

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
    end

  end
end

