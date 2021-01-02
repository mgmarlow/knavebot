# Knavebot

[Add knavebot to your server](https://discord.com/oauth2/authorize?client_id=777590604459671562&scope=bot&permissions=514112)

## Usage

```
!roll <expression>
  Roll dice and calculate expressions.
  Example: `!r 2d8 + 10`

  Special rolls
  -------------
  - Roll reactions with `!r $reaction`
  - Roll fates with `!r $fate`

!about
  About Knavebot.

!help
  View help.
```

## Development

Clone the repo

```
gh repo clone mgmarlow/knavebot
```

Install dependencies

```
bin/setup
```

Run tests

```
bundle exec rake rspec
```

Run linter

```
bundle exec standardrb --fix
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mgmarlow/knavebot.

## License

The gem is available as open source under the terms of the [GPL 3.0 License](https://opensource.org/licenses/GPL-3.0).
