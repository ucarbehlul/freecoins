# encoding: UTF-8
# Every time a payout is done, we create one of these Payout objects.
#
# This is primarially for graphing purposes.
class Payout
  include DataMapper::Resource

  property :id, Serial
  property :timestamp, DateTime

  has n, :transactions
end
