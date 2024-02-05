require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:service) { FactoryBot.create :service }

  subject { described_class.new(
      surname: 'Lastname',
      forenames: 'Forenames', 
      employed_from: Date.today,
      date_of_birth: Date.today - 30.years,
      street_address: '1 The Street',
      postal_code: 'AB12CD',
      job_title: 'Childminder',
      currently_employed: true,
      qualifications: ['level 1', 'level 2'],
      service: service
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
    let!(:service) { FactoryBot.create :service, name: 'Service Name' }
    let!(:employee_1) { FactoryBot.create :employee, employed_from: Date.today - 1.year, qualifications: ['level 1'], service: service }
    let!(:employee_2) { FactoryBot.create :employee, employed_from: Date.today - 1.year, qualifications: ['level 2'], service: service }

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
    let!(:service) { FactoryBot.create :service, name: 'Service Name' }
    let!(:employee_1) { FactoryBot.create :employee, employed_from: Date.today - 1.year, currently_employed: true, service: service}
    let!(:employee_2) { FactoryBot.create :employee, employed_from: Date.today - 1.year, currently_employed: false, employed_to: Date.today - 1.month, service: service}

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

  describe '.service' do
    let!(:service_1) { FactoryBot.create :service, name: 'Service 1' }
    let!(:service_2) { FactoryBot.create :service, name: 'Service 2' }
    let!(:employee_1) { FactoryBot.create :employee, employed_from: Date.today - 1.year, service: service_1 }
    let!(:employee_2) { FactoryBot.create :employee, employed_from: Date.today - 1.year, service: service_2 }

    context 'when service_id is given' do
      it 'returns employees with the given service_id' do
        expect(Employee.service(service_1.id)).to include(employee_1)
        expect(Employee.service(service_1.id)).not_to include(employee_2)
      end
    end

    context 'when service_id is not given' do
      it 'returns all employees' do
        expect(Employee.service(nil)).to include(employee_1, employee_2)
      end
    end
  end

  describe '.options_for_status' do
    it 'returns an array of options for status' do
      expect(Employee.options_for_status).to eq([['Active', 'active'], ['Inactive', 'inactive']])
    end
  end

  describe '.options_for_job_title' do
    it 'returns an array of options for job_title' do
      expect(Employee.options_for_job_title).to eq([
        ['Acting Deputy Manager/Leader/Supervisor', 'Acting Deputy Manager/Leader/Supervisor'],
        ['Acting Manager/Leader/Supervisor', 'Acting Manager/Leader/Supervisor'],
        ['Apprentice/Intern', 'Apprentice/Intern'],
        ['Assistant Childminder', 'Assistant Childminder'],
        ['Chair Person', 'Chair Person'],
        ['Childminder', 'Childminder'],
        ['Cleaner/Caretaker/Catering', 'Cleaner/ Caretaker/Catering'],
        ['Deputy Manager/Leader/Supervisor', 'Deputy Manager/Leader/Supervisor'],
        ['Finance/Administration/Secretary', 'Finance/Administration/Secretary'],
        ['Lead Practitioner', 'Lead Practitioner'],
        ['Manager/Leader/Supervisor', 'Manager/Leader/Supervisor'],
        ['Nanny', 'Nanny'],
        ['Not Applicable', 'Not Applicable'],
        ['Nursery/Pre-School Assistant', 'Nursery/Pre-School Assistant'],
        ['On maternity leave', 'On maternity leave'],
        ['Owner/Proprietor/Director', 'Owner/Proprietor/Director'],
        ['Playworker', 'Playworker'],
        ['Room Leader/Supervisor', 'Room Leader/Supervisor'],
        ['Treasurer', 'Treasurer'],
        ['Volunteer', 'Volunteer']
      ])
    end
  end

  describe '.options_for_qualifications' do
    it 'returns an array of options for qualifications' do
      expect(Employee.options_for_qualifications).to eq([
        ['Level 2', 'Level 2'],
        ['Level 3', 'Level 3'],
        ['Level 4', 'Level 4'],
        ['Level 5', 'Level 5'],
        ['Level 6', 'Level 6'],
        ['EYPS', 'EYPS'],
        ['QTS', 'QTS'],
        ['EYC', 'EYC']
      ])
    end
  end

  describe '.options_for_service' do
    let!(:service_1) { FactoryBot.create :service, name: 'Service 1' }
    let!(:service_2) { FactoryBot.create :service, name: 'Service 2' }
    let!(:employee_1) { FactoryBot.create :employee, employed_from: Date.today - 1.year, service: service_1 }
    let!(:employee_2) { FactoryBot.create :employee, employed_from: Date.today - 1.year, service: service_2 }

    it 'returns an array of options for service' do
      expect(Employee.options_for_service).to match_array([['Service 1', service_1.id], ['Service 2', service_2.id]])
    end
  end
end
