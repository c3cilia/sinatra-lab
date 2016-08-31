#Sinatra

###What is it
Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort:

###Simple Hello world program 
hello.rb
```
require 'sinatra'

get '/' do
  'Hello world!'
end
```

run `$ ruby hello.rb` and then open `http://localhost:4567/` in your browser.

###Routes
In Sinatra, a route is an HTTP method paired with a URL-matching pattern. Each route is associated with a block: The HTTP methods 'get, post, put, patch, delete, options, link, unlink'

Route patterns may include named parameters, accessible via the params hash:

```
require 'sinatra'
require 'sinatra/reloader'

get '/:foo' do
    "Hello #{params['foo']}"
end
```
Route patterns may also include `splat` (or wildcard) parameters, accessible via the params['splat'] array:

```
require 'sinatra'
require 'sinatra/reloader'

get '/say/*/to/*' do
    # matches /say/hello/to/world
    params['splat']
end

get '/download/*.*' do
    # matches /download/path/to/file.xml
    params['splat']
end 
```
Or with block parameters:
```
get '/download/*.*' do |path, extension|
    # matches /download/path/to/file.xml
    [path, extension]
end 
```

Route matching with Regular Expressions:
I have absolutely no idea
```
get /\A\/hello\/([\w]+)\z/ do
  "Hello, #{params['captures'].first}!"
end
```
Or with a block parameter:

```
get %r{/hello/([\w]+)} do |c|
  # Matches "GET /meta/hello/world", "GET /hello/world/1234" etc.
  "Hello, #{c}!"
end
```

Route patterns may have optional parameters:
```
get '/posts.?:format?' do
  # matches "GET /posts" and any extension "GET /posts.json", "GET /posts.xml" etc.
end
```

Routes may also utilize query parameters:
```
get '/post' do
    # matches "GET /posts?title=foo&author=bar"
    title = [params['title']]
    title << params['author']
end
```
Dont know what this means 'By the way, unless you disable the path traversal attack protection (see below), the request path might be modified before matching against your routes.'


###Sinatra::Base - Middleware, Libraries, and Modular Apps
Defining your app at the `top-level` works well for `micro-apps` but has considerable drawbacks when building reusable components such as `Rack middleware`, `Rails metal`, simple libraries with a server component, or even `Sinatra extensions`. The `top-level` assumes a `micro-app style configuration` (e.g., a single application file, ./public and ./views directories, logging, exception detail page, etc.). That’s where Sinatra::Base comes into play:

When you use Sinatra::Base you have to use rack server. 

To get everything to work you require 
* a `Gemfile`
```
source 'https://rubygems.org'

gem 'sinatra', require: 'sinatra/base'
```
* an `app.rb` file
```
class MySinatraApp < Sinatra::Base
  get '/' do
    "Hello, World!"
  end
end
```
* a `config.ru` file

```
require 'bundler'
Bundler.require

require './app'

run MySinatraApp
```

To start the server run this `rackup -p 4567`

The methods available to Sinatra::Base subclasses are exactly the same as those available via the top-level DSL.
Most top-level apps can be converted to Sinatra::Base components with two modifications:
* Your file should require sinatra/base instead of sinatra; otherwise, all of Sinatra’s DSL methods are imported into the main namespace.
* Put your app’s routes, error handlers, filters, and options in a subclass of Sinatra::Base.

Sinatra::Base is a blank slate. Most options are disabled by default, including the built-in server. See Configuring Settings for details on available options and their behavior. If you want behavior more similar to when you define your app at the top level (also known as Classic style), you can subclass Sinatra::Application.
```
require 'sinatra/base'

class MyApp < Sinatra::Application
  get '/' do
    'Hello world!'
  end
end
```

###Filters
######Before and after blocks in sinatra
`before do...end` is a block of code executed *before* every SaaS request. It can modify the request and response.

```
before do
  @note = 'Hi!'
  request.path_info = '/foo/bar/baz'
end

get '/foo/*' do
  @note #=> 'Hi!'
  params['splat'] #=> 'bar/baz'
end
```

`after do...end` is executed *after* every SaaS request. It modify the request and response as well.
Filters optionally take a pattern, causing them to be evaluated only if the request path matches that pattern:

```
before '/protected/*' do
  authenticate!
end

after '/create/:slug' do |slug|
  session[:last_slug] = slug
end

```
Like routes, filters also take conditions:

```
before :agent => /Songbird/ do
  # ...
end

after '/blog/*', :host_name => 'example.com' do
  # ...
end
```

###Using sessions 
A session is used to keep state during requests. If activated, you have one session hash per user session:

```
enable :sessions
```

###Register 
Modular applications must include any desired extensions explicitly by calling register ExtensionModule within the application’s class scope.

