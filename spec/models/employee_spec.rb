require 'rails_helper'

RSpec.describe Employee, type: :model do
  it 'is is valid with valid attributes' do
    expect(Employee.new(
      last_name: 'Lastname',
      employed_from: Date.today,
      date_of_birth: Date.today - 30.years,
      street_address: '1 The Street',
      postal_code: 'AB12CD',
      currently_employed: true
    )).to be_valid
  end
end
