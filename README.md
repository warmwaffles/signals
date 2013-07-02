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
class Coach
  include Signals::Publisher

  def run_play
    broadcast(:v_formation, self)
  end
end

class Player
  def v_formation(coach)
    puts "I'm in position"
  end
end

coach = Coach.new
player = Player.new

coach.subscribe(player)

coach.run_play
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
