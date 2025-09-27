# app.rb
require 'sinatra'
require 'sinatra/reloader' if development?
require 'securerandom'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(64)
end

THEMES = {
  "light" => {
    body: "bg-blue-100 text-gray-800",
    container: "bg-white",
    input: "bg-white border-gray-300 ring-blue-100 text-black",
    todo: "bg-gray-50 text-black",
    button: "bg-blue-600 text-white"
  },
  "dark" => {
    body: "bg-gray-900 text-white",
    container: "bg-gray-800",
    input: "bg-gray-700 border-gray-600 ring-blue-500/40 text-white",
    todo: "bg-gray-700 text-white",
    button: "bg-green-600 text-white"
  },
  "forest" => {
    body: "bg-green-100 text-green-900",
    container: "bg-green-50",
    input: "bg-white border-green-400 ring-green-200 text-green-900",
    todo: "bg-green-200 text-green-900",
    button: "bg-green-600 text-white"
  },
  "sunset" => {
    body: "bg-orange-100 text-orange-900",
    container: "bg-orange-50",
    input: "bg-white border-orange-400 ring-orange-200 text-orange-900",
    todo: "bg-orange-200 text-orange-900",
    button: "bg-orange-600 text-white"
  }
}

helpers do
  def todos
    session[:todos] ||= []
  end

  def theme
    session[:theme] || "light"
  end

  def theme_classes
    THEMES[theme] || THEMES["light"]
  end
end

# Todo一覧
get '/' do
  @todos = todos
  erb :index
end

# Todo追加
post '/add' do
  content = params[:content].strip
  unless content.empty?
    todos << { id: SecureRandom.uuid, content: content }
    session[:todos] = todos
  end
  redirect '/'
end

# Todo削除
post '/delete/:id' do
  session[:todos] = todos.reject { |todo| todo[:id] == params[:id] }
  redirect '/'
end

# テーマ切り替え
post '/theme/:name' do
  if THEMES.keys.include?(params[:name])
    session[:theme] = params[:name]
  end
  redirect '/'
end
