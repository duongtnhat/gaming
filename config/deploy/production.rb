set :stage, :production
set :rails_env, :production
set :branch, "main"
server "52.74.44.167", user: "ubuntu", roles: %w{app db web}