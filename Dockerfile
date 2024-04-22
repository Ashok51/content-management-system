# Use an official Ruby runtime as a parent image
FROM ruby:3.0.0

# Install essential dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Set working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock from the current directory to the container
COPY Gemfile Gemfile.lock ./

# Install dependencies specified in Gemfile
RUN bundle install

# Copy the rest of the application code to the container
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Use ENTRYPOINT to define the default command
ENTRYPOINT ["sh", "-c", "/bin/sh entrypoint.sh"]
