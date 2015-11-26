class EmailProcessor
  def initialize(email)
    @email = email
  end

  # incomming mail
  def process
    puts @email.inspect
  end
end
