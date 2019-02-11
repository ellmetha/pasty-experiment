# frozen_string_literal: true

require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  test '#generate generates a new token for a specific user' do
    user = FactoryBot.create(:user)
    assert_operator AuthToken.generate(user).length, :>, 0
  end

  test '#verify returns the user associated with a valid token' do
    user = FactoryBot.create(:user)
    token = AuthToken.generate(user)
    assert_equal user, AuthToken.verify(token)
  end

  test '#verify returns nil if the user associated with a token no longer exists' do
    user = FactoryBot.create(:user)
    token = AuthToken.generate(user)
    user.delete
    assert_nil AuthToken.verify(token)
  end

  test '#verify returns nil if the token is not valid' do
    assert_nil AuthToken.verify('foobar')
  end
end
