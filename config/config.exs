import Config

if File.exists?("#{config_env()}.exs") do
  import_config "#{config_env()}.exs"
end
