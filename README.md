# pusher-client

Pusher client for crystal language works with https://pusher.com/ or https://github.com/edgurgel/poxa. 

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pusher-client:
    github: vusaalab/pusher.cr
```

## Usage

```crystal
require "pusher-client"


client = Pusher::Client.new({
    :app_id    => "app-id",
    :key       => "your-pusher-key",
    :secret    => "your-pusher-scret",
    :port      => "your-port",
    :encrypted => "false",
})

client.trigger(["my-channel"], "my-event", { name: "foo", title: "boo" } )

```



## Development TODO:

1. GET channels (fetch multiple channels)
2. GET channel (fetch channel)
3. GET users
4. Batches 
5. Asynchronous requests
    pusher.get_async
    pusher.post_async
    pusher.trigger_async

## Contributing

1. Fork it ( https://github.com/vusaalab/pusher-client/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- vusaalab(https://github.com/vusaalab) Nilanga - creator, maintainer
- vince-kyklo(https://github.com/vince-kyklo)
