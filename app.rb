require 'sinatra'
require 'sinatra/reloader' if development?

set :public_folder, 'public'
set :views, 'views'

# helpers do
#   def partial(template, locals = {})
#     erb("_#{template}".to_sym, locals: locals)
#   end
# end

todos = []

get '/' do
  @todos = todos
  erb :index
end

post '/add' do
  content = params[:content]
  todos << content unless content.nil? || content.strip.empty?
  redirect '/'
end

post '/delete' do
  index = params[:index].to_i
  todos.delete_at(index)
  redirect '/'
end