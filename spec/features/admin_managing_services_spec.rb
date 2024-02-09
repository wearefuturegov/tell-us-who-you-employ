require 'rails_helper'

RSpec.feature 'Admin managing services' do
  let(:org_id_1) { 123 }
  let(:service_1) { FactoryBot.create :service, name: 'Rspec Name' }
  let(:service_2) { FactoryBot.create :service, name: 'Test Title' }


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
      click_link 'click here'
    end

    after do
      OmniAuth.config.test_mode = false
    end

    context 'with employee records in the DB' do
      let!(:employee_1) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_1.id, employed_from: Date.today - 1.year  }
      let!(:employee_2) { FactoryBot.create :employee, organisation_id: org_id_1, service_id: service_2.id, employed_from: Date.today - 1.year  }

      before do
        visit root_path
        click_link 'Start now'
        choose 'Yes'
        click_button 'Continue'
        click_button 'Sign in'
        visit admin_services_path
      end

      scenario 'you view all services' do

        expect(page).to have_content('Provider employee details')
        expect(page).to have_content(service_1.name)
        expect(page).to have_content(service_2.name)
      end

      scenario 'you search by service name' do
        fill_in 'filterrific[search]', with: service_1.name
        find('#search-button').click

        expect(page).to have_content(service_1.name)
      end

      scenario 'you search by address' do
        fill_in 'filterrific[search]', with: service_2.address_1
        find('#search-button').click

        expect(page).to have_content(service_2.name)
      end

      scenario 'you filter by service name' do
        find('details.filters').click
        select service_1.name, from: 'filterrific[service]'
        find('#search-button').click

        expect(page).to have_content(service_1.name)
      end
    end
  end
end
