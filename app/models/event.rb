class Event < ApplicationRecord
  default_scope -> { order(start_time: :asc) }
  
  validate :start_end_check
  
  def start_end_check
    if self.start_time.present? && self.end_time.present?
      errors.add(:end, "が開始後国を上回っています。正しく記入してください。") if self.start > self.end
    end
  end
end
