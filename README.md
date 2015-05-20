IdigbioClient
=============

[![Gem Version][gem_badge]][gem_link]
[![Continuous Integration Status][ci_badge]][ci_link]
[![Coverage Status][cov_badge]][cov_link]
[![CodeClimate][code_badge]][code_link]
[![Dependency Status][dep_badge]][dep_link]


`idigbio_client` is a Ruby wrapper for [iDigBio API][api]


Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'idigbio_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install idigbio_client

Usage
-----

Client functions can be grouped in 4 categories

* [inspect][inspect] - introspective methods
* [search][search] - search by provided parameters
* [show][show] - show any one object based on its UUID
* [stats][stats] - various statistical data

### Inspect

Methos in this section supply metainformation important for effective use
of the client.

#### Method `IdigbioClient.types`

Returns an array of types (resources) available via API.

```ruby
require "idigbio_client"

IdigbioClient.types
# returns ["records", "mediarecords", "recordsets", "publishers"]
```

#### Method `IdigbioClient.fields(type)`

Returns a hash with description of fields associated with a resource. Takes one
optional parameter `type`. If type is not given it returns fields to all types
in a hash.

| Parameter  | Type             | Description                                                   |
|------------|------------------|---------------------------------------------------------------|
| type       | String or Symbol | indicates which type to query for its fields; *default* `nil` |

```ruby
require "idigbio_client"

IdigbioClient.fields

# fields of a specific type
IdigbioClient.fields(:mediarecords)
IdigbioClient.fields("records")
```

### Search

#### Method `IdigbioClient.search(opts)`

Takes a hash of opts, returns a hash with results of a search.

| opts.keys  | Type             | Description                            |
|------------|------------------|----------------------------------------|
| :type      | String or Symbol | resource type; *default* `:records`    |
| :params    | search options hash; *default* `{}`                       |

##### params

| params.keys | Description                                          |
|-------------|------------------------------------------------------|
| :rq         | search query hash; *default* `{}`                    |
| :limit      | how many records to return in total; *default* `100` |
| :offset     | from which record to start; *default* `0`            |

```ruby
require "idigbio_client"

# specimen records search
params = { rq: { genus: "acer" }, limit: 15 }
IdigbioClient.search(params: params)

# setting offset: will return only 5 records, assuming 10 were done before
params = { rq: { genus: "acer" }, limit: 15, offset: 10 }
IdigbioClient.search(params: params)

# using non-default type
IdigbioClient.search(type: :mediarecords, params: params)
```
### Show

#### Method: `IdigbioClient.show(uuid)`

Takes uuid, returns record associated with UUID. Record can be of any type.

| Parameters | Type   | Description |
|------------|--------|-------------|
| uuid       | String | UUID        |


```ruby
require "idigbio_client"

IdigbioClient.show("1c29be70-24e7-480b-aab1-61224ded0f34")
```

### Stats

#### Method: `IdigbioClient.count(opts)`

Returns the number of records of a specified type

| opts.keys  | Type             | Description                            |
|------------|------------------|----------------------------------------|
| :type      | String or Symbol | resource type; *default* `:records`    |
| :params    | Hash             | search options hash; *default* `{}`    |

```ruby
require "idigbio_client"

IdigbioClient.count
IdigbioClient.count(type: :recordsets)
IdigbioClient.count(type: :mediarecords, params: { rq: { genus: "acer" } })
```

Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org][rubygems].

## Contributing

1. Fork it ( https://github.com/[my-github-username]/idigbio_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Copyright
---------

Authors -- [Greg Traub][greg], [Dmitry Mozzherin][dimus]

Copyright (c) 2015 [Greg Traub][greg], [Dmitry Mozzherin][dimus]
See [LICENSE][license] for details.


[gem_badge]: https://badge.fury.io/rb/idigbio_client.svg
[gem_link]: http://badge.fury.io/rb/idigbio_client
[ci_badge]: https://secure.travis-ci.org/GlobalNamesArchitecture/idigbio_client.svg
[ci_link]: http://travis-ci.org/GlobalNamesArchitecture/idigbio_client
[cov_badge]: https://coveralls.io/repos/GlobalNamesArchitecture/idigbio_client/badge.svg?branch=master
[cov_link]: https://coveralls.io/r/GlobalNamesArchitecture/idigbio_client?branch=master
[code_badge]: https://codeclimate.com/github/GlobalNamesArchitecture/idigbio_client/badges/gpa.svg
[code_link]: https://codeclimate.com/github/GlobalNamesArchitecture/idigbio_client
[dep_badge]: https://gemnasium.com/GlobalNamesArchitecture/idigbio_client.png
[dep_link]: https://gemnasium.com/GlobalNamesArchitecture/idigbio_client
[api]: https://www.idigbio.org/wiki/index.php/IDigBio_API
[inspect]: #inspect
[search]: #search
[show]: #show
[stats]: #stats
[rubygems]: https://rubygems.org
[license]: https://github.com/GlobalNamesArchitecture/idigbio-ruby-client/blob/master/LICENSE
[greg]: https://github.com/gete76
[dimus]: https://github.com/dimus
