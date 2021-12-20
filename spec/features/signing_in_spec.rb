require 'rails_helper'

RSpec.feature 'Signing in' do
  before do
    OmniAuth.config.test_mode = true
  end

  scenario 'shows a friendly error if the user is not associated with an org' do
    OmniAuth.config.add_mock(:outpost, {
      uid: 12345,
      info: {
        email: 'user@example.com'
      },
      extra: {
        raw_info: {
          organisation_id: nil
        }
      }
    })

    visit root_path
    click_link 'Start now'
    choose 'Yes'

    click_button 'Continue'
    expect(page).to have_content 'please list your services on our directory before you begin'
  end

  scenario 'shows a friendly error if the user has no listed services' do
    OmniAuth.config.add_mock(:outpost, {
      uid: 12345,
      info: {
        email: 'user@example.com'
      },
      extra: {
        raw_info: {
          organisation_id: 123,
          organisation: {
            id: 123,
            services: []
          }
        }
      }
    })

    visit root_path
    click_link 'Start now'
    choose 'Yes'

    click_button 'Continue'
    expect(page).to have_content 'please list your services on our directory before you begin'
  end
end
