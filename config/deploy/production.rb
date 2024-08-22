set :stage, :production
set :rails_env, :production
set :branch, "main"
server "18.141.164.247", user: "ubuntu", roles: %w{app db web}