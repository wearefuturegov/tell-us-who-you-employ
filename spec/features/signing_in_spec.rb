require 'rails_helper'

RSpec.feature 'Signing in' do
  before do
    OmniAuth.config.test_mode = true
  end

  scenario 'choosing "No" when asked about listed services takes you to a register link' do
    visit root_path
    click_link 'Start now'
    choose 'No'
    click_button 'Continue'
    expect(page).to have_content 'You need an account to continue'
    expect(page).to have_link 'Register'
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
        },
        admin: false
      }
    })

    visit root_path
    click_link 'Start now'
    choose 'Yes'
    click_button 'Continue'
    click_button 'Sign in'

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
          },
          admin: false
        }
      }
    })

    visit root_path
    click_link 'Start now'
    choose 'Yes'
    click_button 'Continue'
    click_button 'Sign in'

    expect(page).to have_content 'please list your services on our directory before you begin'
  end

  scenario 'redirects to the non-admin view' do
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
            services: [{ id: 1, name: 'Service 1' }]
          },
          admin: false,
          admin_users: false
        }
      }
    })

    visit root_path
    click_link 'Admin'
    click_button 'Sign in'

    expect(page).to have_content 'If these records are accurate, carry on.'
  end

  scenario 'grants access to the admin portal if the user is an admin' do
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
            services: [{ id: 1, name: 'Service 1' }]
          },
          admin: true,
          admin_users: true
        }
      }
    })

    visit root_path
    click_link 'Admin'
    click_button 'Sign in'

    expect(page).to have_content 'Provider employee details'
  end

end
