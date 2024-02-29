require 'rails_helper'

RSpec.describe 'process_permanent_deletions' do
  let!(:employee_1) { FactoryBot.create :employee, marked_for_deletion: Time.now, currently_employed: false }
  let!(:employee_2) { FactoryBot.create :employee, marked_for_deletion: Time.now, currently_employed: false }
  let!(:employee_3) { FactoryBot.create :employee, marked_for_deletion: Time.now, currently_employed: false }
  let!(:employee_4) { FactoryBot.create :employee, marked_for_deletion: nil, currently_employed: true }

  it 'decreases the count of employees' do
    employees_count = Employee.count

    process_permanent_deletions()

    expect(Employee.count).to eq(employees_count - 3)

  it 'increments destroyed_employees_count' do
    destroyed_employees_count = 0

    process_permanent_deletions()

    expect(destroyed_employees_count).to eq(3)
  end

  it 'does not destroy employees not marked for deletion' do
    process_permanent_deletions()

    expect(Employee.find(employee_4.id)).to be_present
  end
end