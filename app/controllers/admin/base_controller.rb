class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  before_action :update_services
  helper_method :admin?, :admin_users?

  private

  def update_services
    logger.debug ServiceSync.last_sync

    last_sync = ServiceSync.last_sync
    if last_sync && last_sync.updated_at < 1.week.ago || last_sync.nil?
      logger.debug "no sync or happenened less than 1 week ago"

      # Get all unique service_ids from the services table
      serviceids = Service.pluck(:id).uniq
      employeeids = Employee.pluck(:service_id).uniq

      service_ids = (serviceids + employeeids).uniq

      updated_services = fetch_service_names(service_ids)

      number_updated = 0
      updated_services.each_slice(100).with_index do |batch, i|
        records_updated = 0
        batch.each do |service_data|
          records = batch.map { |service_data| { id: service_data['id'], name: service_data['name'], created_at: Time.now, updated_at: Time.now } }
          Service.upsert_all(records, unique_by: :id)
          records_updated = records.size
        end
        number_updated += records_updated
      end


      ServiceSync.create({
        uid: session[:uid],
        number_changed: number_updated
      })
    end
  end



  def fetch_service_names(service_ids)
    services = []
    access_token = session[:access_token]
    headers = { "Authorization" => "Bearer #{access_token}" }
    service_ids.each_slice(20) do |group|
        # logger.debug "fetching from api for group #{group.join(',')}"
        response = HTTParty.get("#{ENV['OAUTH_SERVER']}/api/v1/services?format=mini&ids=#{group.join(',')}", headers: headers)
        break unless response.success?
        if response.parsed_response['content'].present? && response.parsed_response['content'].length > 0
          services.concat(response.parsed_response["content"].map do |hash| 
            { 'id' => hash['id'].to_i, 'name' => hash['name'].strip }
          end)
        end
    end
    services
  end



end






