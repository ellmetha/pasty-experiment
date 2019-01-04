# Extends the FormBuilder in order to allow form helpers to smoothly behave with the frontend
# framework used to style forms and inputs.
class AppFormBuilder < ActionView::Helpers::FormBuilder
  %w[text_field email_field password_field].each do |selector|
    define_method selector do |method, options = {}|
      super(method, insert_class("input #{'is-danger' if errors? method}", options))
    end
  end

  def text_area(method, options = {})
    super(method, insert_class("textarea #{'is-danger' if errors? method}", options))
  end

  def errors(method)
    object.errors.full_messages_for(method).map { |m| help_block(m, 'is-danger') }.join.html_safe
  end

  def label(method, text = nil, options = {}, &block)
    super(method, text, insert_class('label', options), &block)
  end

  def submit(method, options = {})
    super(method, insert_class('button is-link', options))
  end

  def help_block(message, class_name = '')
    %(<p class="help #{class_name}">#{message}</p>).html_safe
  end

  private

  # Returns true if at least one error is found for the considered attribute.
  def errors?(attr_name)
    object.errors[attr_name].any?
  end

  # Inserts a class name into the passed options hash.
  def insert_class(class_name, options)
    output = options.dup
    output[:class] = ((output[:class] || '') + " #{class_name}").strip
    output
  end
end
