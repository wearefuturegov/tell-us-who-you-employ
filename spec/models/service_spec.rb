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
      let!(:service_1) { FactoryBot.create :service, name: 'Service 1' }
      it 'returns services with the given name' do
        expect(Service.service('Service 1')).to match_array([service_1])
      end
    end
  end

  describe '.sorted_by' do
    let!(:service_1) { FactoryBot.create :service, name: 'Service 1' }
    let!(:service_2) { FactoryBot.create :service, name: 'Service 2' }
    let!(:employee_1) { FactoryBot.create :employee, service: service_1 }
    let!(:employee_2) { FactoryBot.create :employee, service: service_2 }
    it 'returns services sorted by name in ascending order' do
      expect(Service.sorted_by('service_asc')).to eq([service_1, service_2])
    end

    it 'returns services sorted by name in descending order' do
      expect(Service.sorted_by('service_desc')).to eq([service_2, service_1])
    end
  end

  describe '.with_employee_count_range' do
    let!(:service_1) { FactoryBot.create :service, name: 'Service 1' }
    let!(:service_2) { FactoryBot.create :service, name: 'Service 2' }
    let!(:employee_1) { FactoryBot.create :employee, service: service_1 }
    let!(:employee_2) { FactoryBot.create :employee, service: service_1 }
    let!(:employee_3) { FactoryBot.create :employee, service: service_1 }
    let!(:employee_4) { FactoryBot.create :employee, service: service_1 }
    let!(:employee_5) { FactoryBot.create :employee, service: service_1 }
    let!(:employee_6) { FactoryBot.create :employee, service: service_1 }

    it 'returns services with the specified employee count range' do    
      expect(service_1.employees.count).to eq(6)
      expect(service_2.employees.count).to eq(0)
      expect(Service.with_employee_count_range('6-10')).to match_array([service_1])
    end
  end
end