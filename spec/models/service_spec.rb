require 'rails_helper'

RSpec.describe Service, type: :model do
  subject { described_class.new(
    name: 'Service Name',
    location_name: 'Location Name',
    address_1: '1 The Street',
    city: 'City',
    postal_code: 'AB12CD'
  ) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'associations' do
    it 'has many employees' do
      association = described_class.reflect_on_association(:employees)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'scopes' do
    describe '.service' do
      it 'returns services with the given name' do
        service = Service.create(name: 'Service Name')
        expect(Service.service('Service Name')).to include(service)
      end
    end

    describe '.location' do
      it 'returns services with the given location' do
        service = Service.create(location_name: 'Location Name', address_1: '1 The Street', city: 'City', postal_code: 'AB12CD')
        expect(Service.location('Location Name, 1 The Street, City, AB12CD')).to include(service)
      end
    end
  end

  describe 'methods' do
    describe '#full_address' do
      it 'returns the full address' do
        expect(subject.full_address).to eq('Location Name, 1 The Street, City, AB12CD')
      end
    end
  end
end
