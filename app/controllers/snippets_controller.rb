class SnippetsController < ApplicationController
  before_action :set_snippet, only: %i[show]

  # Displays a specific snippet.
  def show
    @new_snippet_from_current = Snippet.new(
      lexer: @snippet.lexer, content: @snippet.content, user: current_user
    )
  end

  # Allows to trigger the creation of a new snippet.
  def new
    @snippet = Snippet.new(user: current_user)
    @snippet.require_expiration
  end

  # Performs the actual creation of a newly posted snippet.
  def create
    @snippet = Snippet.new(snippet_params)

    if @snippet.save
      redirect_to @snippet, notice: 'Employee was successfully created.'
    else
      render :new
    end
  end

  private

  # Set a current snippet associated with an action.
  def set_snippet
    @snippet = Snippet.find(params[:id])
  end

  def snippet_params
    params.require(:snippet).permit(:lexer, :content, :expiration)
  end
end
