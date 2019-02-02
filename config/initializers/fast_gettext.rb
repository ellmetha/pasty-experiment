# frozen_string_literal: true

FastGettext.add_text_domain 'app', path: 'locale'
FastGettext.default_available_locales = ['en']
FastGettext.default_text_domain = 'app'
