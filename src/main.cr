require "./pusher-client.cr"

module Pusher
  client = Pusher::Client.new({
    :app_id    => "212619",
    :key       => "0d2eefde9434db9ea804",
    :secret    => "0880ab1fd78471e087f9",
    :cluster   => "mt1",
    :port      => "122",
    :encrypted => "true",
  })

  client.trigger(["my-channel"], "my-event", {name: "dddd", title: "ddd"})
end
