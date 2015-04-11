# MicroMIDI

A Ruby DSL for MIDI

![micromidi](http://img855.imageshack.us/img855/9804/midi.png)

## Features

* Cross-platform compatible using MRI or JRuby.
* Simplified MIDI and Sysex message output
* MIDI Thru, processing and custom input events
* Optional shorthand for [live coding](http://en.wikipedia.org/wiki/Live_coding)

## Installation

`gem install micromidi`

or using Bundler, add this to your Gemfile

`gem "micromidi"`

## Usage

Here's a quick example that plays some arpeggios

```ruby
require "midi"

# prompt the user to select an input and output

@input = UniMIDI::Input.gets
@output = UniMIDI::Output.gets

MIDI.using(@output) do

  5.times do |oct|
    octave oct
    %w{C E G B}.each { |n| play n, 0.5 }
  end

end
```

This next example filters outs notes if their octave is between 1 and 3.  All other messages are sent thru.  

Output is also printed to the console by passing `$stdout` as though it's a MIDI device

```ruby
MIDI.using(@input, @output, $stdout) do

  thru_except :note { |msg| only(msg, :octave, (1..3)) }

  join

end
```

This is the same example redone using shorthand aliases

```ruby
M(@input, @output) do

  te :n { |m| only(m, :oct, (1..3)) }

  j

end
```

Finally, here is an example that maps some MIDI Control Change messages to SysEx

```ruby
MIDI.using(@input, @output) do

  *@the_map =
    [0x40, 0x7F, 0x00],
    [0x41, 0x7F, 0x00],
    [0x42, 0x7F, 0x00]

  node :roland, :model_id => 0x42, :device_id => 0x10

  receive :cc do |message|

    command @the_map[message.index - 1], message.value

  end

end
```

Here are a few posts explaining each of the concepts used here in greater detail:

* [Output](http://tx81z.blogspot.com/2011/08/micromidi-midi-messages-and-output.html)
* [MIDI Thru and Processing](http://tx81z.blogspot.com/2011/08/micromidi-midi-thru-and-midi-processing.html)
* [Binding Custom Input Events](http://tx81z.blogspot.com/2011/08/micromidi-custom-events.html)
* [Shorthand](http://tx81z.blogspot.com/2011/08/micromidi-shorthand.html)
* [Sysex](http://tx81z.blogspot.com/2011/09/generating-sysex-messages-with.html)
* [Etc](http://tx81z.blogspot.com/2011/09/more-micromidi-tricks.html)

## Documentation

* [rdoc](http://rubydoc.info/github/arirusso/micromidi)

## Author

* [Ari Russo](http://github.com/arirusso) <ari.russo at gmail.com>

## License

Apache 2.0, See the file LICENSE

Copyright (c) 2011-2015 Ari Russo
