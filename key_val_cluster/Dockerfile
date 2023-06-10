# Use the official Elixir base image
FROM elixir:1.14

# Set the working directory inside the container
WORKDIR /app

# Copy the Elixir project files to the container
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy the rest of the application files to the container
COPY . .

# Compile the Elixir project
RUN mix compile

# Set environment variables, if needed
# ENV MY_ENV_VAR=value

# Expose any necessary ports
# EXPOSE 4000

# Run the Elixir application
CMD ["mix", "run", "--no-halt"]