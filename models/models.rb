require 'sqlite3'
require_relative 'utils.rb'

$db = SQLite3::Database.new( "database" )

class TodoList
	def initialize(id, title, password)
		@id = id
		@title = title
		@password = password
	end

	def id
		return @id
	end

	def title
		return @title
	end

	def title?
		return @title.size > 0
	end

	def password
		return @password
	end

	def password?
		return @password.size > 0
	end

	def set_title(title)
		query = """
						UPDATE todos
						SET title=?
						WHERE list_id=?
		"""
		$db.execute(query, title, @id)
	end

	def set_password(raw_password)
		password = get_hash(raw_password)
		query = """
						UPDATE todos
						SET password=?
						WHERE list_id=?
		"""
		$db.execute(query, password, @id)
	end

	def get_items()
		query = """
						SELECT item_id, todo, done
						FROM items
						WHERE list_id=?
		"""
		rows = $db.execute(query, @id)
		list = []
		rows.each do |item|
			list.push({
				:id => item[0],
				:todo => item[1],
				:done => item[2] == 1
			})
		end
		return list
	end

	def add_item(todo)
		query = """
						INSERT INTO items
						(list_id, todo, done)
						VALUES (?, ?, 0)
		"""
		$db.execute(query, @id, todo)
	end

	def mark(item)
		query = """
						UPDATE items
						SET done=1
						WHERE list_id=? AND item_id=?
		"""
		$db.execute(query, @id, item)
	end

	def unmark(item)
		query = """
						UPDATE items
						SET done=0
						WHERE list_id=? AND item_id=?
		"""
		$db.execute(query, @id, item)
	end

	def remove_marked()
		query = """
						DELETE
						FROM items
						WHERE done=1 AND list_id=?
		"""
		$db.execute(query, @id)
	end

	def remove(item_id)
		query = """
						DELETE
						FROM items
						WHERE list_id=? AND item_id=?
		"""
		$db.execute(query, @id, item_id)
	end

	def self.get_by_id(list_id)
		query = """
						SELECT title, password
						FROM todos
						WHERE list_id=?
		"""
		rows = $db.execute(query, list_id)
		return TodoList.new(list_id, rows[0][0], rows[0][1])
	end

	def self.create(title="", raw_password="")
		if raw_password.size > 0
			password = get_hash(raw_password) 
		else 
			password = ''
		end
		hash = random_hash()
		query = """
						INSERT INTO todos (list_id, title, password)
						VALUES (?, ?, ?)
		"""
		$db.execute(query, hash, title, password)
		return TodoList.new(hash ,title, password)
	end
end

