Rails.autoloaders.main.ignore(
  "test",
  "spec",
  "vendor",
  "tmp"
)

# Create new arrays instead of modifying frozen ones
Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.to_a
Rails.application.config.autoload_paths = Rails.application.config.autoload_paths.to_a
