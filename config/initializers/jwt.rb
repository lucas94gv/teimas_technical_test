JWT_SECRET = ENV.fetch("JWT_SECRET") do
  raise "JWT_SECRET is not defined in the environment variables"
end
