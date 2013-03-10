# encoding: UTF-8
class Transaction
  include DataMapper::Resource

  property :id, Serial
  property :timestamp, DateTime
  property :address, String
  property :ip, String
  property :paid_out, Boolean, :default => false

  belongs_to :payout, :required => false
end
