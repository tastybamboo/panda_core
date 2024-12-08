# The base model class that all other models inherit from.
# Provides common functionality and configuration for database records.
#
# @abstract Subclass and use as a base model class
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
