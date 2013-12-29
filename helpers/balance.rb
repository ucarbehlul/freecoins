def get_balance
  # This method is used to get the balance of the faucet.
  # These values are defined in config.json.

  client = Bitcoind.new(settings.rpcuser , settings.rpcpass , settings.rpchost, settings.rpcport)

  # This is in a begin...rescue...end block because if Blockchain.info
  # is down, getting the balance will fail.
  begin
    amount = client.balance
    return amount
  rescue StandardError => err
    return "ERROR"
  end

end

