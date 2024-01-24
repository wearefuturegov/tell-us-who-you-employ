require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject { described_class.new(
      surname: 'Lastname',
      forenames: 'Forenames', 
      employed_from: Date.today,
      date_of_birth: Date.today - 30.years,
      street_address: '1 The Street',
      postal_code: 'AB12CD',
      job_title: 'Childminder',
      currently_employed: true,
      qualifications: ['level 1', 'level 2']
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

  describe '.qualifications' do
    let!(:employee_1) { FactoryBot.create :employee, employed_from: Date.today - 1.year, qualifications: ['level 1']  }
    let!(:employee_2) { FactoryBot.create :employee, employed_from: Date.today - 1.year, qualifications: ['level 2']  }

    context 'when qualifications match' do
      it 'returns employees with matching qualifications' do
        expect(Employee.qualifications(['level 1'])).to include(employee_1)
        expect(Employee.qualifications(['level 1'])).not_to include(employee_2)
      end
    end

    context 'when qualifications do not match' do
      it 'returns no employees' do
        expect(Employee.qualifications(['nonexistent_level'])).to be_empty
      end
    end
  end

  describe '.status' do
    let!(:employee_1) { FactoryBot.create :employee, employed_from: Date.today - 1.year, currently_employed: true }
    let!(:employee_2) { FactoryBot.create :employee, employed_from: Date.today - 1.year, currently_employed: false, employed_to: Date.today - 1.month }

    context 'when status is inactive' do
      it 'returns employees with currently_employed as false' do
        expect(Employee.status('inactive')).to include(employee_2)
        expect(Employee.status('inactive')).not_to include(employee_1)
      end
    end

    context 'when status is active' do
      it 'returns employees with currently_employed as true' do
        expect(Employee.status('active')).to include(employee_1)
        expect(Employee.status('active')).not_to include(employee_2)
      end
    end

    context 'when status is invalid' do
      it 'raises an ArgumentError' do
        expect { Employee.status('unknown') }.to raise_error(ArgumentError, /Invalid status/)
      end
    end
  end
end
