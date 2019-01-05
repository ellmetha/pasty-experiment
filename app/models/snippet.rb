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
  attr_reader :expiration

  # Defines the supported lexers as a hash containing a <language codename, language label> pairs.
  # The underlying list of languages is far from being exhaustive.
  LEXERS = {
    html: _('HTML'),
    javascript: _('Javascript'),
    markdown: _('Markdown'),
    plaintext: _('Plain text'),
    python: _('Python'),
    ruby: _('Ruby')
  }.freeze

  # Defines common expiration identifiers that will be used by users when creating snippets to
  # define the expiration date & time of the created snippets.
  EXPIRATIONS = {
    one_time: _('One Time Snippet'),
    hours_1: _('Expire in 1 hour'),
    hours_24: _('Expire in 24 hours'),
    days_7: _('Expire in 7 days'),
    never: _('Never expire')
  }.freeze

  validates :lexer, inclusion: { in: LEXERS.keys.map(&:to_s) }, presence: true
  validates :content, presence: true
  validates :expiration,
            inclusion: { in: EXPIRATIONS.keys.map(&:to_s) },
            presence: true,
            if: :expiration_required?

  # Defines specific is_lexer? methods = and scopes for each considered lexer. Unique constants are
  # also generated for each lexer.
  LEXERS.keys.each do |lexer|
    define_method("is_#{lexer}?") { self.lexer == lexer.to_s }
    scope lexer, -> { where(lexer: lexer) }
    const_set(lexer.upcase, lexer)
  end

  # Allows to set the expiration datetime and one-time state of the snippet depending on a unique
  # expiration identifier.
  def expiration=(expiration)
    @expiration = expiration
    now_dt = Time.now
    case @expiration.to_sym
    when :one_time
      set_expiration_and_one_time_state(nil, true)
    when :hours_1
      set_expiration_and_one_time_state(now_dt + 1.hour, false)
    when :hours_24
      set_expiration_and_one_time_state(now_dt + 1.day, false)
    when :days_7
      set_expiration_and_one_time_state(now_dt + 7.days, false)
    when :never
      set_expiration_and_one_time_state(nil, false)
    end
  end

  # Ensures that the expiration virtual attribute will be required at validation time. This method
  # exists because it is possible to create snippets without using the 'expire_in' and 'is_one_time'
  # accessors; but by using a simplified 'expiration' virtual attribute instead. In that case
  # validation of the 'expiration' values could be required and this is why this method exists.
  # It is still possible to create snippet by manually setting 'expire_in' and 'is_one_time' values
  # though.
  def require_expiration
    @expiration_required = true
  end

  private

  # Allows to set expiration and one time state columns, both at the same time.
  def set_expiration_and_one_time_state(expire_in, is_one_time)
    self.expire_in = expire_in
    self.is_one_time = is_one_time
  end

  # Indicates whether the expiration virtual attribute is required or not.
  def expiration_required?
    @expiration_required
  end
end
