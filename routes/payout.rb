# encoding: UTF-8
post '/payout' do
  # Whenever the Payout request is sent, in order to keep just
  # anyone from sending payouts, a secret key (that is defined in
  # config.json) must be sent along with it. This tests
  # if the secret key is correct, and if not we cancel the payout.
#  if params[:secret] != settings.payout_key
#    return { :success => false }.to_json
#  end

  # This payout object is used mostly for the graphs
  payout = Payout.create(:timestamp => Time.now)

  # This is the amount we'll send to bitcoind via RPC.
  amount = (settings.payout_amount).to_f
  # These are defined in the config.json file

  client = Bitcoind.new(settings.rpcuser , settings.rpcpass , settings.rpchost, settings.rpcport)

  # Now we get all the Transactions from the database that haven't
  # been paid out yet.
  not_paid_out = Transaction.all(:paid_out => false)

  # One of the items in the request we send to bc.info's API is
  # a recipients object, in the form of { "address": amount }.
  recipients = {}
  not_paid_out.each do |transaction|
    recipients[transaction.address] = amount
  end
    
  #recipient object should be a dictionary
  begin
      client.request("sendmany", "faucet", recipients)
  rescue
      #client gives 500 error if anything wrong
      return {":success" => false}.to_json
  end
  #only clear transactions if success
  not_paid_out.each do |transaction|
    transaction.paid_out = true
    transaction.save!

    payout.transactions << transaction
    payout.save
  end
  return { :success => true }.to_json
end
