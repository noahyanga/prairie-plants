class Page < ApplicationRecord
  # Allow Ransack to search on the following attributes
  def self.ransackable_attributes(_auth_object = nil)
    [ "content", "created_at", "id", "title", "updated_at" ]
  end
end
