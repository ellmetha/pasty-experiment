FactoryBot.define do
  factory :snippet do
    lexer { :python }
    content { 'import datetime as dt' }
  end
end
