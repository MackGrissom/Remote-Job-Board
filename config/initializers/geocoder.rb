Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # geocoding service timeout (secs)
  lookup: :nominatim,         # name of geocoding service (symbol)
  http_headers: { "User-Agent" => "Freely" },
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  always_raise: [Geocoder::NetworkError, Geocoder::InvalidRequest],

  # Calculation options
  units: :km,                 # :km for kilometers or :mi for miles
  distances: :linear          # :spherical or :linear

  # Cache configuration
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }
)