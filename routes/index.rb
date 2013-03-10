# encoding: UTF-8

def get_balance
  wallet_pass = settings.wallet_pass
  wallet_id = settings.wallet_id

  url = "http://blockchain.info/merchant/#{wallet_id}/balance"
  request_object = { :password => wallet_pass }

  begin
    body = Nestful.get(url, :params => request_object)
  rescue
    return "ERROR"
  end

  parsed = JSON.parse body

  amount = parsed["balance"].to_i * 0.000_000_01
  return amount
end

get '/' do
  @balance = get_balance
  @session_id = SecureRandom.uuid
  haml :index
end
