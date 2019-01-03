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
  # Defines the supported lexers as a hash containinga <language codename, language label> pairs.
  # The underlying list of languages is far from being exhaustive.
  LEXERS = {
    html: 'HTML',
    javascript: 'Javascript',
    markdown: 'Markdown',
    plaintext: 'Plain text',
    python: 'Python',
    ruby: 'Ruby'
  }.freeze

  validates :lexer, inclusion: { in: LEXERS.keys.map(&:to_s) }

  # Defines specific is_lexer? methods = and scopes for each considered lexer. Unique constants are
  # also generated for each lexer.
  LEXERS.keys.each do |lexer|
    define_method("is_#{lexer}?") { self.lexer == lexer.to_s }
    scope lexer, -> { where(lexer: lexer) }
    const_set(lexer.upcase, lexer)
  end
end
