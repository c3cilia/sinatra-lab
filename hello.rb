require 'sinatra/base'

#get '/say/*/to/*' do
	# matches /say/hello/to/world
#	params['splat']
#end

#get '/download/*.*' do |path, extension|
	# matches /download/path/to/file.xml
#	[path, extension]
#end 

#get /\A\/hello\/([\w]+)\z/ do
#  "Hello, #{params['captures'].first}!"
#end

#get '/post' do
#	title = [params['title']]
#	title << params['author']
#end

class HelloApp < Sinatra::Base

	get '/' do
		"Hello world cess"
	end 
end 

