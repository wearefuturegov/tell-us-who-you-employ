FactoryBot.define do
  factory :employee do
    surname { FFaker::Name.last_name }
    forenames { FFaker::Name.first_name }
    street_address { FFaker::AddressUK.street_address }
    postal_code { FFaker::AddressUK.postcode }
    date_of_birth { FFaker::Time.date(year_latest: 18, year_range: 65 - 18) }
    employed_from { FFaker::Time.date(year_range: 25) }
    role { FFaker::Job.title }
    currently_employed { true }
  end
end
