require 'openssl'
require 'base64'

class AesEncrypt
  def self.encryption(msg)
    begin
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.encrypt()
      cipher.key = ENV['VERIFY_KEY']
      crypt = cipher.update(msg) + cipher.final()
      crypt_string = Base64.encode64 crypt
      return crypt_string
    rescue Exception => exc
      puts exc.message
    end
  end

  def self.decryption(msg)
    begin
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.decrypt()
      cipher.key = ENV['VERIFY_KEY']
      tempkey = Base64.decode64 msg
      crypt = cipher.update(tempkey)
      crypt << cipher.final()
      return crypt
    rescue Exception => exc
      puts exc.message
    end
  end
end
