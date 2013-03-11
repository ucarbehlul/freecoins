# encoding: UTF-8
require_relative 'transaction'
require_relative 'payout'

# This is done so that if the models don't exist in the database yet,
# or are changed, they will be created or updated accordingly.
Transaction.auto_upgrade!
Payout.auto_upgrade!
