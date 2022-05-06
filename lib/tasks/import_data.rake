require 'csv'

skills_mapping = {
  "Paediatric First Aid": "Paediatric first aid (PFA)",
  "Level 2": "Level 2",
  "Level 3": "Level 3",
  "Level 4": "Level 4",
  "Level 5": "Level 5",
  "Level 6": "Level 6",
}

# Only the easy ones in here
qualifications_mapping = {
  "EYC Full & Relevant - Level 2": "Level 2",
  "EYC Full & Relevant - Level 3": "Level 3",
  "EYC Full & Relevant - Level 4": "Level 4",
  "EYC Full & Relevant - Level 5": "Level 5",
  "EYC Full & Relevant - Level 6": "EYC",
  "EYPS (Level 6)": "EYPS",
  "QTS (Level 6)": "QTS",
}

desc 'Import employee data'
task :import_employee_data => :environment do
  if Employee.all.any?
    puts 'Please clear the DB first'
  else

    missing_services = []

    # Read the services data
    services_file = File.read(Rails.root.join('lib/seeds/outpost-services.csv'))
    services = CSV.parse(services_file, headers: true)

    # Read the employee data
    employees_file = File.read(Rails.root.join('lib/seeds/employees-to-import-csv.csv'))
    employees = CSV.parse(employees_file, headers: true)

    puts "Importing #{employees.length} employees..."
    employees.each do |row|
      # Find the service using its Open Objects id
      service = services.find{|s| s['old_open_objects_external_id'] == row['staff_member_at']}
      missing_services.push(row['staff_member_at']) and next unless service.present?

      # First get the data from the 'skills' column
      skills = row['skill']&.split("\n") || []
      skills_for_import = skills.map{ |s| skills_mapping[s.to_sym] }

      # Then the 'qualifications' column
      quals = row['qualification']&.split("\n") || []
      quals.each do |q|
        next if q == 'None'
        mapped_qual = qualifications_mapping[q.to_sym]
        next if skills_for_import.include? mapped_qual 

        # For the easy ones, just add them in
        skills_for_import.push mapped_qual and next if mapped_qual

      end

      # DBS check fields
      dbs_checked = nil
      if row['dbs_checked'] === 'Yes'
        dbs_checked = true
      elsif row['dbs_checked'] === 'No'
        dbs_checked  = false
      end

      # Address fields
      address = [row['ha_house_num'], row['ha_street'], row['ha_extra_address'], row['ha_village_town']].compact.join(', ')

      employee = Employee.new(
        surname: row['surname'],
        forenames: row['forenames'],
        role: row['job_title'],
        employed_from: row['start_date'],
        employed_to: row['end_date'],
        currently_employed: row['resource_type'] === 'Current Job',
        date_of_birth: row['date_of_birth'],
        service_id: service['service_id'],
        organisation_id: service['organisation_id'],
        street_address: address, 
        postal_code: row['ha_postcode'],
        has_dbs_check: dbs_checked,
        dbs_expires_at: row['dbs_date'],
        qualifications: skills_for_import,
        has_food_hygiene: row['skill'].include?('Food Hygiene')
      )

      employee.skip_validations = true
      employee.save
    end

    puts "Missing services: #{missing_services.uniq}"
    puts 'Done'
  end
end
