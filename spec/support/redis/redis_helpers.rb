module RedisHelpers
  #
  # Usage: performance enhancement
  #
  def redis_cache_cleanup!
    Booky::Redis::Cache.with(&:flushall)
  end
end
