class ServiceSync < ApplicationRecord
  def self.last_sync 
    last_sync = ServiceSync.order(id: :asc).limit(1)
    last_sync.first if last
  end
end
