# <%= @app_name %>

<%= @app_name %> is a bot created using Twittbot <%= ::Twittbot::VERSION %>.

See [nilsding/twittbot](https://github.com/nilsding/twittbot) to find out
more about Twittbot.

## Installation and usage

Install this bot's dependencies:

    $ bundle install

Authorize with Twitter for the first time:

    $ bundle exec twittbot auth

And finally run the bot:

    $ bundle exec twittbot start
