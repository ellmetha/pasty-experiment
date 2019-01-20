require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#remember_me ensures that the user is remembered by default' do
    user = FactoryBot.build(:user)
    assert_equal '1', user.remember_me
  end
end
