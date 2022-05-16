class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true

  validates_presence_of :comment, :commentable_type, :commentable_id
end
