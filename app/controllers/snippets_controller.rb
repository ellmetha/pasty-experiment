class SnippetsController < ApplicationController
  before_action :set_snippet, only: %i[show]

  # Displays a specific snippet.
  def show
  end

  # Allows to trigger the creation of a new snippet.
  def new
    @snippet = Snippet.new
  end

  # Performs the actual creation of a newly posted snippet.
  def create
  end

  private

  # Set a current snippet associated with an action.
  def set_snippet
    @snippet = Snippet.find(params[:id])
  end
end
