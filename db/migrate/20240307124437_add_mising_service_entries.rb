class AddMisingServiceEntries < ActiveRecord::Migration[6.1]
  def change
    # Get all unique service_ids from the Employee table
    service_ids = Employee.pluck(:service_id).uniq

    # For each service_id, create a Service if it doesn't already exist
    service_ids.each do |service_id|
      Service.find_or_create_by(id: service_id) do |service|
        service.name = "Unknown service name #{service_id}"
      end
    end
  end
end