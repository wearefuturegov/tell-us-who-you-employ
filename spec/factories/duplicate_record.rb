FactoryBot.define do
  factory :duplicate_record do
    employee1 { FactoryBot.create :employee, surname: 'Smith', date_of_birth: Date.today - 30.years }
    employee2 { FactoryBot.create :employee, surname: 'Smith', date_of_birth: Date.today - 30.years }
  end
end
