Dry::Validation.load_extensions(:monads)

Dry::Validation::Contract.config.messages.backend = :i18n
Dry::Validation::Contract.config.messages.default_locale = :pt
Dry::Validation::Contract.config.messages.load_paths << Rails.root.join("config/locales/pt.yml")
