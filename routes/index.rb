# encoding: UTF-8

# The get_balance method is defined in helpers/balance. It
# gives us the current balance of the faucet for displaying
# in the sidebar. The session_id is used for the captcha.
get '/' do
  @balance = get_balance
  @session_id = SecureRandom.uuid
  haml :index
end
