class Message < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  validates :content, length: { maximum: 400,
    too_long: "%{count} characters is the maximum allowed" }
end
