require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  test 'is not one time by default' do
    snippet = FactoryBot.create(:snippet)
    assert_not snippet.is_one_time?
  end

  test 'validation fails if the lexer is next an expected one' do
    snippet = FactoryBot.build(:snippet, lexer: 'foolang')
    assert_not snippet.valid?
    assert_includes snippet.errors, :lexer
  end

  test 'validation fails if the lexer is not present' do
    snippet = FactoryBot.build(:snippet, lexer: nil)
    assert_not snippet.valid?
    assert_includes snippet.errors, :lexer
  end

  test 'validation fails if the content is not present' do
    snippet = FactoryBot.build(:snippet, content: nil)
    assert_not snippet.valid?
    assert_includes snippet.errors, :content
  end

  test 'validations succeeds without expiration by default' do
    snippet = Snippet.new(lexer: :python, content: 'import datetime', expire_in: Time.now + 6.hours)
    assert_predicate snippet, 'valid?'
  end

  test 'validation fails if expiration is required' do
    snippet = Snippet.new(lexer: :python, content: 'import datetime')
    snippet.require_expiration
    assert_not snippet.valid?
  end

  test 'validations succeeds with an expiration value when expiration is required' do
    snippet = Snippet.new(lexer: :python, content: 'import datetime', expiration: 'days_7')
    snippet.require_expiration
    assert_predicate snippet, 'valid?'
  end

  test 'validations fails with an invalid expiration value when expiration is required' do
    snippet = Snippet.new(lexer: :python, content: 'import datetime', expiration: 'foobar')
    snippet.require_expiration
    assert_not snippet.valid?
  end

  test 'validations succeeds with a never-ending expiration when a user is associated' do
    snippet = Snippet.new(
      lexer: :python,
      content: 'import datetime',
      expiration: 'never',
      user: FactoryBot.create(:user)
    )
    snippet.require_expiration
    assert_predicate snippet, 'valid?'
  end

  test 'validations fails with a never-ending expiration when no user is associated' do
    snippet = Snippet.new(
      lexer: :python, content: 'import datetime', expiration: 'never', user: nil
    )
    snippet.require_expiration
    assert_not snippet.valid?
  end

  test 'knows if it corresponds to a specific language' do
    snippet = FactoryBot.create(:snippet, lexer: :python)
    assert_predicate snippet, :is_python?
    assert_not snippet.is_ruby?
  end

  test 'generates a scope for each supported language' do
    python_snippet = FactoryBot.create(:snippet, lexer: :python)
    ruby_snippet = FactoryBot.create(:snippet, lexer: :ruby)
    assert_equal Snippet.python, [python_snippet]
    assert_equal Snippet.ruby, [ruby_snippet]
  end

  test 'associates a constant for each support language to itself' do
    assert_equal Snippet::PYTHON, :python
  end

  test 'one-time expiration can be set using the expiration virtual attribute' do
    snippet = FactoryBot.create(:snippet, lexer: :python)
    snippet.expiration = :one_time
    assert_nil snippet.expire_in
    assert_predicate snippet, 'is_one_time?'
  end

  test '1-hour expiration can be set using the expiration virtual attribute' do
    snippet = FactoryBot.create(:snippet, lexer: :python)
    snippet.expiration = :hours_1
    now_dt = Time.now
    assert now_dt + 1.hour - 2.seconds < snippet.expire_in
    assert now_dt + 1.hour + 2.seconds > snippet.expire_in
    assert_not snippet.is_one_time?
  end

  test '24-hours expiration can be set using the expiration virtual attribute' do
    snippet = FactoryBot.create(:snippet, lexer: :python)
    snippet.expiration = :hours_24
    now_dt = Time.now
    assert now_dt + 1.day - 2.seconds < snippet.expire_in
    assert now_dt + 1.day + 2.seconds > snippet.expire_in
    assert_not snippet.is_one_time?
  end

  test '7-days expiration can be set using the expiration virtual attribute' do
    snippet = FactoryBot.create(:snippet, lexer: :python)
    snippet.expiration = :days_7
    now_dt = Time.now
    assert now_dt + 7.days - 2.seconds < snippet.expire_in
    assert now_dt + 7.days + 2.seconds > snippet.expire_in
    assert_not snippet.is_one_time?
  end

  test 'endless expiration can be set using the expiration virtual attribute' do
    snippet = FactoryBot.create(:snippet, lexer: :python)
    snippet.expiration = :never
    assert_nil snippet.expire_in
    assert_not snippet.is_one_time?
  end
end
