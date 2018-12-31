# == Schema Information
#
# Table name: snippets
#
#  id          :uuid             not null, primary key
#  content     :text             not null
#  lexer       :string           not null
#  expire_in   :datetime
#  is_one_time :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Snippet < ApplicationRecord
end
