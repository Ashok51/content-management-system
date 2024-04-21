# Use an official Ruby runtime as a parent image
FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y postgresql-client

# freezes gemfile.lock, raise error if modify
RUN bundle config --global frozen 1

# working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock from the current directory to the container
COPY Gemfile Gemfile.lock ./

# Install dependencies specified in Gemfile
RUN bundle install

# Copy the rest of the application code to the container
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server when the container starts
CMD ["rails", "server", "-b", "0.0.0.0"]
