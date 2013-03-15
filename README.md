This is the code for the site [Freecoins](http://freecoins.herokuapp.com), a
simple bitcoin faucet that pays out 0.00005BTC.

If you want to use this as your own faucet, check out `config.example.json` for
some values you'll need to change. Be sure to change things like the footer file
(`views/_footer.haml`) and the ad files, either deleting them (and the
references to them) or changing them to reflect your own ads.

Attribution to this source would be greatly appreciated if you use this as your
own faucet.

# Setting up on Heroku

This can be done entirely free, that's how I run it. Here's how.

1.  Set up a new Heroku site.
2.  Set up a cleardb:ignite instance. (The only free one, sorta limited, but
    it's worked so far for me.
3.  Make sure Heroku's DATABASE_URL is set to whatever ClearDB's URL is.
4.  Deploy!

If you want automatic payouts, set up a cron job somewhere that runs
`curl -F secret=yoursecret http://yourapp.herokuapp.com/payout`
