# encoding: UTF-8
require_relative 'transaction'
require_relative 'payout'

Transaction.auto_upgrade!
Payout.auto_upgrade!
