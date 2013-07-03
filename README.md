# Signals

A light weight publish / subscribe. It is similar to how the gem Wisper works
but without extra functionality. This library assumes nothing and concurrency is
not a priortiy.

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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
