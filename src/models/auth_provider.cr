class AuthProvider < Jennifer::Model::Base
  GOOGLE_PROVIDER = "google"

  AVAILABLE_PROVIDERS = [
    GOOGLE_PROVIDER
  ]

  mapping(
    id: Primary64,

    user_id: Int64,
    token: String,
    provider: String,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  with_timestamps

  belongs_to :user, User

  validates_presence :token
  validates_presence :provider
  validates_presence :user_id

  validates_inclusion :provider, in: AVAILABLE_PROVIDERS
end
