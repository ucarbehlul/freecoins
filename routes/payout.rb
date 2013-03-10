# encoding: UTF-8
post '/payout' do
  # Whenever the Payout request is sent, in order to keep just
  # anyone from sending payouts, a secret key (that is defined in
  # config.json) must be sent along with it. This tests
  # if the secret key is correct, and if not we cancel the payout.
  if params[:secret] != settings.payout_key
    return { :success => false }.to_json
  end

  # This payout object is used mostly for the graphs
  payout = Payout.create(:timestamp => Time.now)

  # This is the amount we'll send to Blockchain.info's API.
  # We multiply by 100_000_000 to get the amount in Satoshi.
  amount = (settings.payout_amount * 100_000_000).to_i
  # These are defined in the config.json file
  wallet_id = settings.wallet_id
  wallet_pass = settings.wallet_pass

  url = "http://blockchain.info/merchant/#{wallet_id}/sendmany"

  # Now we get all the Transactions from the database that haven't
  # been paid out yet.
  not_paid_out = Transaction.all(:paid_out => false)

  # One of the items in the request we send to bc.info's API is
  # a recipients object, in the form of { "address": amount }.
  recipients = {}
  not_paid_out.each do |transaction|
    recipients[transaction.address] = amount
    transaction.paid_out = true
    transaction.save!

    payout.transactions << transaction
    payout.save
  end

  # This recipients object must be in JSON
  recipients = recipients.to_json

  request_object = {  :password => wallet_pass,
    :recipients    => recipients }

  Nestful.get(url, :params => request_object)

  return { :success => true }.to_json
end
