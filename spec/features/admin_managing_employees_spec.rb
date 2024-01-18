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

  end
end

