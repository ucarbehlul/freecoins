# encoding: UTF-8
# A transaction object here is created every time a user requests
# a payout. We store their IP address and the timestamp for
# duplicate-checking
class Transaction
  include DataMapper::Resource

  property :id, Serial
  property :timestamp, DateTime
  property :address, String
  property :ip, String
  property :paid_out, Boolean, :default => false

  # This is :required => false because it doesn't actually
  # belong to a Payout object until the payout happens, which
  # is only once every day.
  belongs_to :payout, :required => false
end
