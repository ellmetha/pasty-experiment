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

class Snippet < ApplicationRecord
  attr_reader :expiration
  belongs_to :user, optional: true

  # Defines the supported lexers as a hash containing <language codename, language label> pairs.
  # The underlying list of languages is far from being exhaustive.
  LEXERS = {
    abnf: _('ABNF'),
    accesslog: _('Access'),
    ada: _('Ada'),
    actionscript: _('ActionScript'),
    apache: _('Apache'),
    applescript: _('AppleScript'),
    asciidoc: _('AsciiDoc'),
    aspectj: _('AspectJ'),
    autohotkey: _('AutoHotkey'),
    autoit: _('AutoIt'),
    awk: _('Awk'),
    axapta: _('Axapta'),
    bash: _('Bash'),
    basic: _('Basic'),
    bnf: _('BNF'),
    brainfuck: _('Brainfuck'),
    cs: _('C#'),
    cpp: _('C++'),
    cal: _('C/AL'),
    cos: _('Cache'),
    cmake: _('CMake'),
    coq: _('Coq'),
    csp: _('CSP'),
    css: _('CSS'),
    clojure: _('Clojure'),
    coffeescript: _('CoffeeScript'),
    crmsh: _('Crmsh'),
    crystal: _('Crystal'),
    d: _('D'),
    dns: _('DNS'),
    dos: _('DOS'),
    dart: _('Dart'),
    delphi: _('Delphi'),
    diff: _('Diff'),
    django: _('Django'),
    dockerfile: _('Dockerfile'),
    dsconfig: _('dsconfig'),
    dts: _('DTS'),
    dust: _('Dust'),
    ebnf: _('EBNF'),
    elixir: _('Elixir'),
    elm: _('Elm'),
    erlang: _('Erlang'),
    excel: _('Excel'),
    fsharp: _('F#'),
    fix: _('FIX'),
    fortran: _('Fortran'),
    gcode: _('G-Code'),
    gams: _('Gams'),
    gauss: _('GAUSS'),
    gherkin: _('Gherkin'),
    go: _('Go'),
    golo: _('Golo'),
    gradle: _('Gradle'),
    groovy: _('Groovy'),
    html: _('HTML,'),
    http: _('HTTP'),
    haml: _('Haml'),
    handlebars: _('Handlebars'),
    haskell: _('Haskell'),
    haxe: _('Haxe'),
    hy: _('Hy'),
    ini: _('Ini'),
    inform7: _('Inform7'),
    irpf90: _('IRPF90'),
    json: _('JSON'),
    java: _('Java'),
    javascript: _('JavaScript'),
    leaf: _('Leaf'),
    lasso: _('Lasso'),
    less: _('Less'),
    ldif: _('LDIF'),
    lisp: _('Lisp'),
    livecodeserver: _('LiveCode'),
    livescript: _('LiveScript'),
    lua: _('Lua'),
    makefile: _('Makefile'),
    markdown: _('Markdown'),
    mathematica: _('Mathematica'),
    matlab: _('Matlab'),
    maxima: _('Maxima'),
    mel: _('Maya'),
    mercury: _('Mercury'),
    mizar: _('Mizar'),
    mojolicious: _('Mojolicious'),
    monkey: _('Monkey'),
    moonscript: _('Moonscript'),
    n1ql: _('N1QL'),
    nsis: _('NSIS'),
    nginx: _('Nginx'),
    nimrod: _('Nimrod'),
    nix: _('Nix'),
    ocaml: _('OCaml'),
    objectivec: _('Objective'),
    glsl: _('OpenGL'),
    openscad: _('OpenSCAD'),
    ruleslanguage: _('Oracle'),
    oxygene: _('Oxygene'),
    pf: _('PF'),
    php: _('PHP'),
    parser3: _('Parser3'),
    perl: _('Perl'),
    pony: _('Pony'),
    powershell: _('PowerShell'),
    processing: _('Processing'),
    prolog: _('Prolog'),
    protobuf: _('Protocol'),
    puppet: _('Puppet'),
    python: _('Python'),
    k: _('Q'),
    qml: _('QML'),
    r: _('R'),
    rib: _('RenderMan'),
    rsl: _('RenderMan'),
    graph: _('Roboconf'),
    ruby: _('Ruby'),
    rust: _('Rust'),
    scss: _('SCSS'),
    sql: _('SQL'),
    p21: _('STEP'),
    scala: _('Scala'),
    scheme: _('Scheme'),
    scilab: _('Scilab'),
    shell: _('Shell'),
    smali: _('Smali'),
    smalltalk: _('Smalltalk'),
    stan: _('Stan'),
    stata: _('Stata'),
    stylus: _('Stylus'),
    subunit: _('SubUnit'),
    swift: _('Swift'),
    tap: _('Test'),
    tcl: _('Tcl'),
    tex: _('TeX'),
    thrift: _('Thrift'),
    tp: _('TP'),
    twig: _('Twig'),
    typescript: _('TypeScript'),
    vbnet: _('VB.Net'),
    vbscript: _('VBScript'),
    vhdl: _('VHDL'),
    vala: _('Vala'),
    verilog: _('Verilog'),
    vim: _('Vim'),
    x86asm: _('x86'),
    xl: _('XL'),
    xpath: _('XQuery'),
    zephir: _('Zephir')
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
            inclusion: { in: proc { |s| s.expirations.keys.map(&:to_s) } },
            presence: true,
            if: :expiration_required?

  scope :expired, -> { where(arel_table[:expire_in].lt(Time.now.utc)) }

  # Defines specific is_lexer? methods = and scopes for each considered lexer. Unique constants are
  # also generated for each lexer.
  LEXERS.keys.each do |lexer|
    define_method("is_#{lexer}?") { self.lexer == lexer.to_s }
    scope lexer, -> { where(lexer: lexer) }
    const_set(lexer.upcase, lexer)
  end

  # Returns the applicable unique expiration identifiers that can be used for the considered Snippet
  # instance. This mostly depends on the fact that a user is associated with the snippet or not: if
  # a snippet is associated with a specific user, the snippet can be saved with a never ending
  # expiration.
  def expirations
    EXPIRATIONS.dup.delete_if { |key| user_id.nil? && key == :never }
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

  # Returns true if the current Snippet instance is a one-time snippet and should be removed because
  # it should no longer be possible to view it.
  def one_time_view_consumed?
    is_one_time? && views_counter.positive?
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
