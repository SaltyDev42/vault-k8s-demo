path "transform/encode/*" {
  capabilities = ["read", "update"]
}

path "transform/decode/*" {
  capabilities = ["read", "update"]
}

path "transit/encrypt/*" {
  capabilities = ["read", "update"]
}

path "transit/decrypt/*" {
  capabilities = ["read", "update"]
}

path "database/creds/flask-app" {
  capabilities = ["read"]
}

