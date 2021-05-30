# dhash-cr

Main inspiration from https://github.com/Nakilon/dhash-vips

Uses https://github.com/jhass/crystal-gobject to create bindings for https://github.com/davidbyttow/govips
govips is rather incomplete though, so still plenty of "native" bindings to libvips

# WIP

## Installation

1. `go get -v github.com/davidbyttow/govips/v2/vips`
2. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     dhash-cr:
       github: greenbigfrog/dhash-cr
   ```
3. Run `shards install`

## Usage

```crystal
require "dhash"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/greenbigfrog/dhash-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jonathan B.](https://github.com/greenbigfrog) - creator and maintainer
