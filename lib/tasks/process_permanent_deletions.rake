desc "Remove inactive employees marked for deletion after 90 days"
task process_permanent_deletions: :environment do
  destroyed_employees_count = 0
  
  Employee.where("currently_employed = ? AND marked_for_deletion < ?", false, 90.days.ago).find_each(batch_size: 100) do |employee|
    employee.destroy
    puts "Destroyed employee: #{employee.id}"
    destroyed_employees_count += 1
  end
  puts "Destroyed #{destroyed_employees_count} employees."
end
