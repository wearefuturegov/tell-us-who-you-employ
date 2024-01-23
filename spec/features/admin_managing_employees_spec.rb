require 'rails_helper'

RSpec.feature 'Admin managing employees' do
  let(:org_id_1) { 123 }
  let(:service_id_1) { 456 }
  let(:service_name_1) { 'Test service 1' }

  let(:org_id_2) { 789 }
  let(:service_id_2) { 910 }
  let(:service_name_2) { 'Spec service 2' }

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
                {
                  id: service_id_1,
                  name: service_name_1
                },
                {
                  id: service_id_2,
                  name: service_name_2
                }
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
      let!(:employee_1) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_id_1, employed_from: Date.today - 1.year  }
      let!(:employee_2) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_id_1, employed_from: Date.today - 1.year  }
      let!(:employee_3) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_id_2, employed_from: Date.today - 1.year }

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

      scenario 'you search by provider' do
        fill_in 'filterrific[search]', with: service_name_2
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

      scenario 'you filter by provider' do
        find('details.filters').click
        select service_name_1, from: 'filterrific[provider]'
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

