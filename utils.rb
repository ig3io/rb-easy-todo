require 'digest'
require_relative 'models.rb'

def random_hash()
	el = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	hash = []
	5.times do
		hash << el.split('').sample()
	end
	return hash.join('')
end

def get_hash(raw_password)
	d = Digest::SHA256.new
	return d.update(raw_password)
end

def verify_password(list_id, raw_password)
	todo = TodoList.get_by_id(list_id)
	return get_hash(raw_password) == todo.password
end

def todo_action(params)
	list_id = params[:list_id]
	item_id = params[:item_id]
	todo = TodoList.get_by_id(list_id)
	yield todo, item_id
end
