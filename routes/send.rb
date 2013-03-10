# encoding: UTF-8
post '/send' do
  address = params[:address]
  ip = request.ip

  same_address = Transaction.first(:address => address)
  same_ip = Transaction.first(:ip => ip)

  current_date = Time.now

  if !same_address.nil?
    same_address_difference = Time.diff(same_address.timestamp, current_date)
    if same_address_difference[:week] < 1
      return {  :success => false,
        :error   => "bad_addr" }.to_json
    end
  elsif !same_ip.nil?
    same_ip_difference = Time.diff(same_ip.timestamp, current_date)
    if same_ip_difference[:week] < 1
      return {  :success => false,
        :error   => "bad_ip" }.to_json
    end
  end

  transaction = Transaction.create(
    :ip => ip,
    :address => address,
    :timestamp => Time.now).o

    return { :success => true }.to_json
end
