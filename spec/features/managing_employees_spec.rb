require 'rails_helper'

RSpec.feature 'Managing employees' do
  let(:org_id) { 123 }
  let(:service_id) { 456 }
  let(:service_name) { FFaker::Company.name }

  scenario 'must be signed in' do
    visit employees_path
    expect(page).to have_link 'Start now'
  end

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
            organisation_id: org_id,
            organisation: {
              id: org_id,
              services: [
                {
                  id: service_id,
                  name: service_name
                }
              ]
            }
          }
        }
      })

      visit root_path
      click_link 'Start now'
      choose 'Yes'
      click_button 'Continue'
      click_button 'Sign in'
    end

    after do
      OmniAuth.config.test_mode = false
    end

    context 'creating employees' do
      let(:surname) { FFaker::Name.last_name }
      let(:forenames) { FFaker::Name.first_name }
      let(:address) { FFaker::AddressUK.street_address }
      let(:postcode) { FFaker::AddressUK.postcode }
      let(:dob) { FFaker::Time.date(year_latest: 18, year_range: 65 - 18) }
      let(:employed_from) { FFaker::Time.date(year_range: 25) }
      let(:job_title) { 'Childminder' }

      before do
        click_link 'Add your first employee'
      end

      context 'with valid employee details' do
        before do
          fill_in :employee_surname, with: surname
          fill_in :employee_forenames, with: forenames
          fill_in :employee_street_address, with: address
          fill_in :employee_postal_code, with: postcode
          fill_in :employee_date_of_birth, with: dob
          fill_in :employee_employed_from, with: employed_from
          page.select job_title, from: :employee_job_title
          check :employee_currently_employed

          click_button 'Continue'
        end

        scenario 'it creates the record' do
          expect(page).to have_content 'Your employees'
          expect(page).to have_content surname
          expect(page).to have_content forenames
          expect(page).to have_content job_title
          expect(page).to have_content service_name
        end

        scenario 'having submitted the records you are signed out' do
          check :confirm_validity
          click_button 'Finish and send'
          expect(page).to have_content 'Your records have been updated'
          visit employees_path
          expect(page).to_not have_content surname
          expect(page).to have_link 'Start now'
        end

        scenario 'you must confirm before you can finish' do
          click_button 'Finish and send'
          expect(page).to have_content 'You must confirm these records'
        end
      end

      context 'with invalid employee details' do
        before do
          fill_in :employee_surname, with: surname
          fill_in :employee_forenames, with: forenames
          fill_in :employee_street_address, with: address
          fill_in :employee_postal_code, with: postcode
          fill_in :employee_date_of_birth, with: dob
          page.select job_title, from: :employee_job_title
          check :employee_currently_employed

          click_button 'Continue'
        end

        it 'shows you the errors' do
          expect(page).to have_content "Employed from can't be blank"
        end
      end
    end

    context 'with employee records in the DB' do
      let!(:employee) { FactoryBot.create :employee, organisation_id: org_id, service_id: service_id }
      let(:employed_to) { Date.today - 5 }

      before do
        visit root_path
        click_link 'Start now'
        choose 'Yes'
        click_button 'Continue'
        click_button 'Sign in'
      end

      scenario 'you can update employee records' do
        expect(page).to have_content employee.surname
        expect(page).to have_content service_name

        click_link 'Change'

        fill_in :employee_employed_to, with: employed_to
        uncheck :employee_currently_employed

        click_button 'Continue'
        expect(page).to have_content 'If these records are accurate, carry on'
        expect(page).to have_content employee.surname
        expect(page).to have_content service_name
        expect(page).to have_content employed_to
      end

      scenario 'you cannot update records with invalid employee details' do
        click_link 'Change'

        fill_in :employee_employed_to, with: employed_to

        click_button 'Continue'
        expect(page).to have_content "Current employees can't have a finish date"
      end

      scenario 'you can delete records' do
        expect(page).to have_content employee.surname
        click_link 'Remove'
        expect(page).to_not have_content employee.surname
      end
    end
  end
end
