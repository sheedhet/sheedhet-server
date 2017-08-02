Rack::Timeout.timeout = ENV.fetch('REQUEST_TIMEOUT') { 10 }.to_i
