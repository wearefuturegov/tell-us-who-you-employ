FactoryBot.define do
  factory :service do
    name { FFaker::Name.name }
    location_name { FFaker::AddressUK.building_number }
    address_1 { FFaker::AddressUK.street_address }
    city { FFaker::AddressUK.city }
    postal_code { FFaker::AddressUK.postcode }
  end
end
