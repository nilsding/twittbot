# Twittbot

Twittbot is the next generation of my old Twitter bot, `twittbot-nd`.

## Installation

Installation is just as easy as installing the Rubygem:

    $ gem install twittbot

## Usage

Create a new bot:

    $ twittbot new bot-name
    $ cd bot-name

Authorize with Twitter:

    $ twittbot auth

Add a template, such as for a simple reply bot:

    $ twittbot generate random-reply

`random-reply` is a template that accepts a configuration.  You can configure
it by editing `./etc/random_reply.yml` with a text editor of your choice.
And, if you want to, you can also change its behaviour by editing
`./lib/random_reply.rb`.

To list available templates, try this:

    $ twittbot list-templates

Finally, run the bot:

    $ twittbot start
