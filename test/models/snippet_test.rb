require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  test 'is not one time by default' do
    snippet = FactoryBot.create(:snippet)
    assert_not snippet.is_one_time?
  end

  test 'validation fails if the lexer is unknown' do
    snippet = FactoryBot.build(:snippet, lexer: 'foolang')
    assert_not snippet.valid?
    assert_includes snippet.errors, :lexer
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
end
