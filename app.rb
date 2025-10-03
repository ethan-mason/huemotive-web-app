# app.rb
require 'sinatra'
require 'sinatra/reloader' if development?
require 'securerandom'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(64)
end

# デフォルトテーマ
THEMES = {
  "light" => {
    body: "bg-white text-slate-800",
    input: "bg-white border-slate-300 placeholder:text-slate-400",
    todo: "bg-slate-100",
    button: "bg-slate-800 text-slate-50"
  },
  "dark" => {
    body: "bg-slate-800 text-white",
    input: "bg-slate-700 border-slate-600 placeholder:text-slate-500 text-slate-50",
    todo: "bg-slate-700",
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

  # Editモード（グローバル）
  def edit_mode?
    session[:edit_mode] ||= false
  end

  # Edit用テーマ
  def edit_theme(theme_name)
    session[:edit_themes] ||= {}
    session[:edit_themes][theme_name] ||= THEMES[theme_name].dup
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

# テーマ切替
post '/theme/:name' do
  if THEMES.keys.include?(params[:name])
    session[:theme] = params[:name]
  end
  redirect '/'
end

# Editモード切替（グローバル）
post '/edit_mode' do
  session[:edit_mode] = !edit_mode?

  # 初期値をコピー（まだ保存されていない場合）
  session[:edit_themes] ||= {}
  THEMES.each_key do |theme_name|
    session[:edit_themes][theme_name] ||= THEMES[theme_name].dup
  end

  redirect '/'
end

# テーマ編集保存
post '/update_theme/:theme_name' do
  theme_name = params[:theme_name]
  params[:classes].each do |key, value|
    session[:edit_themes][theme_name][key] = value.strip
    THEMES[theme_name][key] = value.strip
  end
  redirect '/'
end
