# frozen_string_literal: true

class AuthToken
  def self.key
    Rails.application.secrets.secret_key_base.byteslice(0..31)
  end

  def self.generate(user)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.encrypt_and_sign("user-id:#{user.id}")
  end

  def self.verify(token)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    token = crypt.decrypt_and_verify(token)
    user_id = token.gsub('user-id:', '').to_i
    User.find_by(id: user_id)
  rescue ActiveSupport::MessageEncryptor::InvalidMessage,
         ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end
end
