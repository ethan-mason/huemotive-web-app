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
    body: "bg-white text-slate-900",
    input: "bg-white border-slate-300 placeholder:text-slate-400 text-slate-900",
    todo: "bg-slate-50 text-slate-900",
    button: "bg-slate-800 text-slate-50"
  },
  "dark" => {
    body: "bg-slate-900 text-slate-50",
    input: "bg-slate-700 border-slate-600 placeholder:text-slate-500 text-slate-50",
    todo: "bg-slate-700 text-slate-50",
    button: "bg-slate-50 text-slate-800"
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
