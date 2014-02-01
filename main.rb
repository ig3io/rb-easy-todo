require 'sinatra'
require_relative 'models.rb'
require_relative 'utils.rb'

get '/' do
	haml :index
end

get '/:list_id' do
	list_id = params[:list_id]
	todo = TodoList.get_by_id(list_id)
	password_cookie = verify_password(list_id, request.cookies["password"])
	if password_cookie or not todo.password?
		@logged = true
	end
	@id = todo.id
	@title = todo.title
	@has_title = todo.title?
	@has_password = todo.password?
	@items = todo.get_items()
	haml :todo
end

post '/login/:list_id' do
	list_id = params[:list_id]
	raw_password = params[:password]
		response.set_cookie('password', {
			:value => get_hash(raw_password),
			:path => "/#{list_id}"
		})
	redirect "/#{list_id}"
end

post '/create' do
	title = params[:title]
	password = params[:password]
	todo = TodoList.create(title, password)
	redirect "/#{todo.id}" if todo
	redirect '/'
end

post '/settitle/:list_id' do
	list_id = params[:list_id]
	title = params[:title]
	todo = TodoList.get_by_id(list_id)
	todo.set_title(title)
	redirect "/#{list_id}"
end

post '/setpassword/:list_id' do
	list_id = params[:list_id]
	password = params[:password]
	todo = TodoList.get_by_id(list_id)
	todo.set_password(password)
	response.set_cookie('password', {
		:value => 'aadf',
		:path => "#{list_id}"
	})
	redirect "/#{list_id}"
end

post '/add/:list_id' do
	list_id = params[:list_id]
	item = params[:todo]
	todo = TodoList.get_by_id(list_id)
	todo.add_item(item)
	redirect "/#{list_id}"
end

get '/remove/:list_id/:item_id' do
	list_id = params[:list_id]
	item_id = params[:item_id]
	todo = TodoList.get_by_id(list_id)
	if params[:item_id] == 'marked'
		todo.remove_marked()
	else
		todo.remove(item_id)
	end
	redirect "/#{list_id}"
end

post '/mark/:list_id/:item_id' do
	list_id = params[:list_id]
	item_id = params[:item_id]
	todo = TodoList.get_by_id(list_id)
	todo.mark(item_id)
end

post '/unmark/:list_id/:item_id' do
	list_id = params[:list_id]
	item_id = params[:item_id]
	todo = TodoList.get_by_id(list_id)
	todo.unmark(item_id)
end
