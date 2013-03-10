# encoding: UTF-8
class Payout
  include DataMapper::Resource

  property :id, Serial
  property :timestamp, DateTime

  has n, :transactions
end
