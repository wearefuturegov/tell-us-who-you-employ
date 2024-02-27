require 'rails_helper'

RSpec.describe Service, type: :model do
  subject { described_class.new(
    name: 'Service Name',
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
  end
end
