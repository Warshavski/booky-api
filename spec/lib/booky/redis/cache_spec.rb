require 'rails_helper'

describe Booky::Redis::Cache do
  let(:class_redis_url) { Booky::Redis::Cache::DEFAULT_REDIS_CACHE_URL }

  include_examples 'redis_shared_examples'
end
