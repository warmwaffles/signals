# Signals

[![Build Status](https://travis-ci.org/warmwaffles/signals.png?branch=master)](https://travis-ci.org/warmwaffles/signals)
[![Code Climate](https://codeclimate.com/github/warmwaffles/signals.png)](https://codeclimate.com/github/warmwaffles/signals)

A light weight publish / subscribe. It is similar to how the Wisper gem works.
Except that listeners must include `Signals::Subscriber` so that it can have a
nice DSL and listen for specific events and trigger actions based on those
events. This library also has no external dependencies.

## Installation

```
gem 'signals'
```

## Usage

```rb
require 'signals'

class Coach
  include Signals::Publisher
end

class Player
  include Signals::Subscriber

  listen_for :v_formation => :run
  listen_for [:hat_trick, :v_formation] => :audible
  listen_for :stop => [:look, :run]
  listen_for :stop => :audible

  def initialize(name)
    @name = name
  end

  def run(coach)
    puts "#{@name} is running"
  end

  def audible(coach)
    puts "#{@name} is calling an audible"
  end

  def look(coach)
    puts "#{@name} is looking"
  end
end

coach   = Coach.new
forward = Player.new('John')
center  = Player.new('Jeff')

coach.subscribe(forward)
coach.subscribe(center)

coach.on(:stop) do |c|
  puts "I'm telling you to stop"
end

coach.broadcast(:v_formation, coach)
coach.broadcast(:hat_trick, coach)
coach.broadcast(:stop, coach)
```

## Rails Usage

```rb
# app/controllers/something_controller.rb
class SomethingController < ApplicationController
  # ...
  def create
    service = CreateSomething.new(something_params)
    service.subscribe(AListener.new)
    service.subscribe(AnotherListener.new)
    service.on(:create_something_successful) do |something|
      redirect_to something_path(something)
    end
    service.on(:create_something_failed) do |something|
      @something = something
      render action: 'new'
    end
    service.execute
  end
  # ...
end
```

```rb
# app/services/create_something.rb
class CreateSomething
  include Signals::Publisher

  def initialize(something_params={})
    @something = Something.new(something_params)
  end

  def execute
    if @something.save
      broadcast(:create_something_successful, @something)
    else
      broadcast(:create_something_failed, @something)
    end
  end
end
```

```rb
# app/listeners/a_listener.rb
class AListener
  include Signals::Subscriber

  listen_for :create_something_success => :enqueue_send_email

  def enqueue_send_email
    # queue it up to send an email
  end
end
```

```rb
# app/listeners/another_listener.rb
class AnotherListener
  include Signals::Subscriber

  listen_for :create_something_failed => :log_failure

  def log_failure(something)
    Rails.logger.error "Something failed"
  end
end
```

## Contributing

  1. Fork it
  2. Create your feature branch
  3. Commit your changes
  4. Write tests for those changes
  5. Push the changes
  6. Create new Pull Request
