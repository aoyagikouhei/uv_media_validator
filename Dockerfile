FROM ruby:2.7.6-slim

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    ffmpeg \
    git

RUN mkdir -p /app
COPY ./ /app
WORKDIR /app
RUN bundle install

