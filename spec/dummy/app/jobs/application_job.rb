# The base job class that all other jobs inherit from.
# Provides common functionality and configuration for background jobs.
#
# @abstract Subclass and use as a base job class
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
