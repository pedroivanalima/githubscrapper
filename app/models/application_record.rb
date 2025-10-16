class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def created_at
    self[:created_at].in_time_zone(-3)
  end

  def updated_at
    self[:updated_at].in_time_zone(-3)
  end
end
