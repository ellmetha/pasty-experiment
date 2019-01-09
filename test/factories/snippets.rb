# == Schema Information
#
# Table name: snippets
#
#  content       :text             not null
#  created_at    :datetime         not null
#  expire_in     :datetime
#  id            :uuid             not null, primary key
#  is_one_time   :boolean          default(FALSE), not null
#  lexer         :string           not null
#  updated_at    :datetime         not null
#  user_id       :bigint(8)
#  views_counter :integer          default(0), not null
#
# Indexes
#
#  index_snippets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :snippet do
    lexer { :python }
    content { 'import datetime as dt' }
  end
end
