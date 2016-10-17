# Changelog

## 0.4.0

* Add `tweet.favourite` method
* Add `:favorite` to `on :tweet` options
* Fix periodic blocks being called 1 minute later than expected
* Add `twittbot cron` for interacting with the bot outside from Twittbot processes, e.g. via cron
* Modify `retweet-bot` template to ignore retweets from ourselves
* Add new `big-ben-clock` template which demonstrates the usage of `twittbot cron`.

## 0.3.0

* Add `on :load` event.

## 0.2.0

* Bot callbacks are now stored in an array

## 0.1.2

* Automatically reconnect to user streams after 5 seconds

## 0.1.1

* Fix EOFError occurring when streams are open for a long time

## 0.1.0

* Add `add-admin` and `del-admin` commands
* Add support for direct messages
* Add new BotPart method for commands over direct messages
* Add a basic direct message template
* Add ability to save config for each BotPart
* Add example direct message command to `random-tweet` template

## 0.0.1

* Initial release
