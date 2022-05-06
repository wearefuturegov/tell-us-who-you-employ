require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject { described_class.new(
      surname: 'Lastname',
      forenames: 'Forenames', 
      employed_from: Date.today,
      date_of_birth: Date.today - 30.years,
      street_address: '1 The Street',
      postal_code: 'AB12CD',
      currently_employed: true
    ) }

  it 'is is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without employed_to or currently_employed' do
    subject.currently_employed = nil
    subject.employed_to = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with employed_to and currently_employed' do
    subject.employed_to = Date.today
    expect(subject).to_not be_valid
  end
end
