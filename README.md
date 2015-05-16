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

### Search

#### Search Parameters

parameter keys can be symbols or strings

| Parameter | Description                                        |
|-----------|----------------------------------------------------|
| method    | `"post"` or `"get"`, default `"post"`              |
| path      | search path, default `"search/records/"`           |
| params    | search options hash, default `{}`                  |

##### Params parameters

| Parameter | Description                                        |
|-----------|----------------------------------------------------|
| rq        | search query hash, default `{}`                    |
| limit     | how many records to return in total, default `100` |
| offset    | from which record to start, default `0`            |

```ruby
require "idigbio_client"

params = { rq: { genus: "acer" }, limit: 15 }
IdigbioClient.search(params: params)

# using get method
IdigbioClient.search(params: params, method: :get)

# using other path
IdigbioClient.search(params: params, method: :get, path: "search/")
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


[gem_badge]: https://badge.fury.io/rb/idigbio-ruby-client.svg
[gem_link]: http://badge.fury.io/rb/idigbio-ruby-client
[ci_badge]: https://secure.travis-ci.org/GlobalNamesArchitecture/idigbio-ruby-client.svg
[ci_link]: http://travis-ci.org/GlobalNamesArchitecture/idigbio-ruby-client
[cov_badge]: https://coveralls.io/repos/GlobalNamesArchitecture/idigbio-ruby-client/badge.svg?branch=master
[cov_link]: https://coveralls.io/r/GlobalNamesArchitecture/idigbio-ruby-client?branch=master
[code_badge]: https://codeclimate.com/github/GlobalNamesArchitecture/idigbio-ruby-client/badges/gpa.svg
[code_link]: https://codeclimate.com/github/GlobalNamesArchitecture/idigbio-ruby-client
[dep_badge]: https://gemnasium.com/GlobalNamesArchitecture/idigbio-ruby-client.png
[dep_link]: https://gemnasium.com/GlobalNamesArchitecture/idigbio-ruby-client
[api]: https://www.idigbio.org/wiki/index.php/IDigBio_API
[rubygems]: https://rubygems.org
[license]: https://github.com/GlobalNamesArchitecture/idigbio-ruby-client/blob/master/LICENSE
[greg]: https://github.com/gete76
[dimus]: https://github.com/dimus
