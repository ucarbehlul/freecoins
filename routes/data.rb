# This method is used for returning the data that is used for
# drawing the graphs on the graphs page of the faucet.
get '/data' do
  # First, we get all of the payouts in the database. These are
  # created each time a payout happens (see routes/payout.rb)
  payouts = Payout.all

  payouts_array = []
  payouts.each do |payout|
    # We loop through each payout in the database, getting
    # its timestamp and how many payouts it contained.
    payouts_array << {
      :transactions => payout.transactions.count,
      :timestamp    => payout.timestamp.to_i * 1000 }
  end

  # success is just automatically assumed here, the other data
  # is defined above and the payout_amount is defined in the
  # config.json file
  { :success       => true,
    :payouts       => payouts_array,
    :payout_amount => settings.payout_amount }.to_json
end
