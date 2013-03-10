# encoding: UTF-8
post '/payout' do
  if params[:secret] != settings.payout_key
    return { :success => false }.to_json
  end

  payout = Payout.create(:timestamp => Time.now)

  amount = (settings.payout_amount * 100000000).to_i
  wallet_id = settings.wallet_id
  wallet_pass = settings.wallet_pass

  url = "http://blockchain.info/merchant/#{wallet_id}/sendmany"

  not_paid_out = Transaction.all(:paid_out => false)

  recipients = {}
  not_paid_out.each do |transaction|
    recipients[transaction.address] = amount
    transaction.paid_out = true
    transaction.save!

    payout.transactions << transaction
    payout.save
  end

  recipients = recipients.to_json

  request_object = {  :password => wallet_pass,
    :recipients    => recipients }

  JSON.parse(Nestful.get(url, :params => request_object))

  return { :success => true }.to_json
end
