# == Schema Information
#
# Table name: snippets
#
#  content     :text             not null
#  created_at  :datetime         not null
#  expire_in   :datetime
#  id          :uuid             not null, primary key
#  is_one_time :boolean          default(FALSE), not null
#  lexer       :string           not null
#  updated_at  :datetime         not null
#

class Snippet < ApplicationRecord
end
