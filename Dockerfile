ARG RUBY_VERSION
ARG DISTRO_NAME=bullseye

# Here we add the the name of the stage ("base")
FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME AS base

ARG PG_MAJOR

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \

WORKDIR /app

EXPOSE 3000
CMD ["/usr/bin/bash"]

# Then, we define the "development" stage from the base one
FROM base AS development

ENV RAILS_ENV=development

# The major difference from the base image is that we may have development-only system
# dependencies (like Vim or graphviz).
# We extract them into the Aptfile.dev file.
COPY Aptfile.dev /tmp/Aptfile.dev
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/Aptfile.dev | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# The production-builder image is responsible for installing dependencies and compiling assets
FROM base as production-builder

# First, we create and configure a dedicated user to run our application
RUN groupadd --gid 1005 booky_user \
  && useradd --uid 1005 --gid booky_user --shell /bin/bash --create-home booky_user
USER booky_user
RUN mkdir /home/booky_user/app
WORKDIR /home/booky_user/app

# Then, we re-configure Bundler
ENV RAILS_ENV=production \
  LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_APP_CONFIG=/home/booky_user/bundle \
  BUNDLE_PATH=/home/booky_user/bundle \
  GEM_HOME=/home/booky_user/bundle

# Install Ruby gems
COPY --chown=booky_user:booky_user Gemfile Gemfile.lock ./
RUN mkdir $BUNDLE_PATH \
  && bundle config --local deployment 'true' \
  && bundle config --local path "${BUNDLE_PATH}" \
  && bundle config --local without 'development test' \
  && bundle config --local clean 'true' \
  && bundle config --local no-cache 'true' \
  && bundle install --jobs=${BUNDLE_JOBS} \
  && rm -rf $BUNDLE_PATH/ruby/3.1.0/cache/* \
  && rm -rf /home/booky_user/.bundle/cache/*

# Copy code
COPY --chown=booky_user:booky_user . .

# Finally, our production image definition
# NOTE: It's not extending the base image, it's a new one
FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME AS production

# Production-only dependencies
RUN apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl \
    gnupg2 \
    less \
    tzdata \
    time \
    locales \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Create and configure a dedicated user (use the same name as for the production-builder image)
RUN groupadd --gid 1005 booky_user \
  && useradd --uid 1005 --gid booky_user --shell /bin/bash --create-home booky_user
RUN mkdir /home/booky_user/app
WORKDIR /home/booky_user/app
USER booky_user

# Ruby/Rails env configuration
ENV RAILS_ENV=production \
  BUNDLE_APP_CONFIG=/home/booky_user/bundle \
  BUNDLE_PATH=/home/booky_user/bundle \
  GEM_HOME=/home/booky_user/bundle \
  PATH="/home/booky_user/app/bin:${PATH}" \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

EXPOSE 3000

# Copy code
COPY --chown=booky_user:booky_user . .

# Copy artifacts
# 1) Installed gems
COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH
# 2) Compiled assets (by Webpacker in this case)
COPY --from=production-builder /home/booky_user/app/public/packs /home/booky_user/app/public/packs
# 3) We can even copy the Bootsnap cache to speed up our Rails server load!
COPY --chown=booky_user:booky_user --from=production-builder /home/booky_user/app/tmp/cache/bootsnap* /home/booky_user/app/tmp/cache/

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]