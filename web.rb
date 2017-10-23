require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
end

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!

get '/new' do
	@headline = "Your about to create a new post"
	@paragraph = "Remember only create posts about tech!!!!!!"
	erb :new
end

post '/create' do
	newPost = Post.new
	newPost.title = params[:title]
	newPost.body =  params[:body]
	newPost.save
	@postTitle = newPost.title
	@postBody = newPost.body
	erb :success
end

get '/' do
	#load all posts
	#display them
	@title = "All posts"
	@headline = "Welcome to my tech blog"
	@paragraph = "You can create posts about anything tech, only tech please!!!!!!"
	@posts = Post.all


	erb :index
end
