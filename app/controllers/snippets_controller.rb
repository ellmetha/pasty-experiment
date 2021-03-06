# frozen_string_literal: true

class SnippetsController < ApplicationController
  before_action :set_snippet, only: %i[show]
  before_action :authenticate_user!, only: %i[user_list]

  # Displays a specific snippet.
  def show
    # The snippet should be destroyed in the case where it is one-time and it should no longer be
    # pe possible to access to it. In other cases, the views counter of the snippet is incremented.
    if @snippet.one_time_view_consumed?
      @snippet.destroy
    else
      @snippet.increment!(:views_counter)
    end

    # Returns the raw snippet content if it was explicitely requested by the client.
    return render(plain: @snippet.content) if params.include?('raw')

    # Users have the ability to create a new snippet using the content of the currently displayed
    # snippet. This is why a new Snippet instance is created at this point.
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
    @snippet.user = current_user
    @snippet.require_expiration

    if @snippet.save
      redirect_to @snippet, notice: _('Snippet was successfully created.')
    else
      render :new
    end
  end

  # Renders the list of user's snippets.
  def user_list
    @snippets = Snippet
                .where(user: current_user)
                .paginate(page: params[:page], per_page: 30)
                .order(created_at: :desc)
    render 'user_list'
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
