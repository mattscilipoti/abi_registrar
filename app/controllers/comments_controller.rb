class CommentsController < ApplicationController

  def create
    @comment = Comment.new comment_params
    # @comment.user = current_user
    @comment.save
    redirect_to @comment.commentable, notice: "Your comment was successfully posted."
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :commentable_id, :commentable_type)
    end
end
