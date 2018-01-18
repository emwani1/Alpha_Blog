class Article < ApplicationRecord
  belongs_to :user
  has_many :article_cateogies
  has_many :categories , through: :article_cateogies
  validates :title,  presence: true, length: {minimum: 3, maximum: 10}
  validates :description, presence:true, length: {minimum: 10, maximum:300}
  validates :user_id, presence:true
end