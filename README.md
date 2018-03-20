# pusher-client

Pusher client for cystal language

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pusher-client:
    github: vusaalab/pusher-client
```

## Usage

```crystal
require "pusher-client"


client = Pusher::Client.new({
    :app_id    => "app-id",
    :key       => "your-pusher-key",
    :secret    => "your-pusher-scret",
    :cluster   => "your-cluster",
    :port      => "your-port",
    :encrypted => "false",
})

client.trigger(["my-channel"], "my-event", { name: "foo", title: "boo" } )

```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/vusaalab/pusher-client/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- vusaalab(https://github.com/vusaalab) nilanga - creator, maintainer
