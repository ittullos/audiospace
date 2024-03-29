class Micropost < ApplicationRecord
  belongs_to       :user
  has_many_attached :images
  has_many_attached :audios
  has_many_attached :videos
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140 }
  validates :images,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format"},
                       size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB"}
end
