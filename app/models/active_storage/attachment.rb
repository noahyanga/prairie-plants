module ActiveStorage
  class Attachment < ApplicationRecord
    self.table_name = "active_storage_attachments"

    def self.ransackable_attributes(_auth_object = nil)
      [ "blob_id", "created_at", "id", "name", "record_id", "record_type" ]
    end
  end
end
