# AmbientIot

This is a Gem library to access Ambient ( https://ambidata.io ) service which is provided by AmbientData Inc.  
You can upload data (such as a IoT) to Ambient.  
Then Ambient draw a Graph of the data.  

AmbientIot is a port from [ambient-python-lib](https://github.com/AmbientDataInc/ambient-python-lib).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ambient_iot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ambient_iot

## Usage

First, you should get an account for Ambient.  
Next you make a channel on the Ambient.  
Then you can get a channel id, a write key and a read key for the channel.  

### Uploading data:

Ambient data take keys d1 to d8.  
You set a data as a hash.  

    channel_id = 1234     # set your channel id here
    write_key = "abc.."   # set write key of the channel
    client = AmbientIot::Client.new channel_id, write_key:write_key # create a client
    client << { d1:1, d2:2, d3:3}   # append a data
    client.sync                     # send to Ambient site

Timestamp is automatically added.  
If you don't want to set timestamp, set false the timestamp property.

    client.append_timestamp = false

In this case, timestamp is set by Ambient.


### Getting uploaded data:

    channel_id = 1234     # set your channel id here
    read_key = "abc.."    # set read key of the channel
    client = AmbientIot::Client.new channel_id, read_key:read_key # create a client
    client.read

    # with specific date
    client.read date:Time.new(2018, 4, 26)

    # with specific range
    client.read start:Time.new(2018, 4, 20), end:Time.new(2018, 4, 26)

    # with number of data
    client.read n:1, step:5

### Getting a channel information and recent updated data

    channel_id = 1234     # set your channel id here
    read_key = "abc.."    # set read key of the channel
    client = AmbientIot::Client.new channel_id, read_key:read_key # create a client
    client.info


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ito-soft-design/ambient_iot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AmbientIot project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ito-soft-design/ambient_iot/blob/master/CODE_OF_CONDUCT.md).
