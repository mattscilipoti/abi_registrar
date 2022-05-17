class CommentContentIsRequired < ActiveRecord::Migration[7.0]
  def change
    change_column_null :comments, :content, false
  end
end
