require 'rails_helper'

RSpec.feature 'Adding employees' do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:outpost, {
      uid: 12345,
      info: {
        email: 'user@example.com'
      },
      extra: {
        raw_info: {
          organisation: {
            id: 1234,
            services: [
              {
                id: 12345,
                name: 'A really good service'
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
    click_link 'Add your first employee'
  end

  context 'with valid employee details' do
    let(:last_name) { FFaker::Name.last_name }
    let(:other_names) { FFaker::Name.first_name }
    let(:address) { FFaker::AddressUK.street_address }
    let(:postcode) { FFaker::AddressUK.postcode }
    let(:dob) { FFaker::Time.date(year_latest: 18, year_range: 65 - 18) }
    let(:employed_from) { FFaker::Time.date(year_range: 25) }
    let(:role) { FFaker::Job.title }

    before do
      fill_in :employee_last_name, with: last_name
      fill_in :employee_other_names, with: other_names
      fill_in :employee_street_address, with: address
      fill_in :employee_postal_code, with: postcode
      fill_in :employee_date_of_birth, with: dob
      fill_in :employee_employed_from, with: employed_from
      fill_in :employee_role, with: role
      check :employee_currently_employed

      click_button 'Continue'
    end

    scenario 'it creates the record' do
      expect(page).to have_content 'Your employees'
      expect(page).to have_content last_name
      expect(page).to have_content other_names
      expect(page).to have_content role

      check :confirm_validity
      click_button 'Finish and send'

      expect(page).to have_content 'Your records have been updated'
    end

    scenario 'you must confirm before you can finish' do
      click_button 'Finish and send'
      expect(page).to have_content 'You must confirm these records'
    end
  end
end
