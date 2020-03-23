# frozen_string_literal: true

# Make sure we initialize a Redis connection pool before multi-threaded execution starts by
#
#   1. Rails.cache
#   2. HTTP clients
#
Booky::Redis::Cache.with { nil }
