namespace :employees do

  desc "Compares all employee records and flags duplicates"
  task :duplicates => :environment do
    puts "\n** Testing record validating in #{Rails.env.capitalize} environment**\n"
    
    Employee.find_each do |employee|
      duplicates = Employee.where(
        forenames: employee.forenames,
        surname: employee.surname,
        date_of_birth: employee.date_of_birth,
        postal_code: employee.postal_code
      ).where.not(id: employee.id)

      puts "Found #{duplicates.count} duplicate(s) for #{employee.id} #{employee.forenames} #{employee.surname}"  if duplicates.count > 0

      duplicates.find_each do |duplicate|
        Duplicate.find_or_create_by!(
          employee_id: duplicate.id,
          is_duplicate: true
        )
      end
    end

      
  end

end