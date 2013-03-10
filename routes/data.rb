get '/data' do
  payouts = Payout.all

  payouts_array = []
  payouts.each do |payout|
    payouts_array << {
      :transactions => payout.transactions.count,
      :timestamp    => payout.timestamp.to_i * 1000 }
  end

  { :success       => true,
    :payouts       => payouts_array,
    :payout_amount => settings.payout_amount }.to_json
end
