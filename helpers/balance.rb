def get_balance
  # This method is used to get the balance of the faucet.
  # These values are defined in config.json.
  wallet_pass = settings.wallet_pass
  wallet_id = settings.wallet_id

  url = "http://blockchain.info/merchant/#{wallet_id}/balance"
  request_object = { :password => wallet_pass }

  # This is in a begin...rescue...end block because if Blockchain.info
  # is down, getting the balance will fail.
  begin
    body = Nestful.get(url, :params => request_object)
  rescue
    return "ERROR"
  end

  parsed = JSON.parse body

  # The balance is given in Satoshi, so we convert it into fractional
  # bitcoins.
  amount = parsed["balance"].to_i * 0.000_000_01
  return amount
end

