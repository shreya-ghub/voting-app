# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /src

# Copy the project file and restore dependencies
# Adjust 'Worker.csproj' if your project file has a different name
COPY Worker.csproj ./
RUN dotnet restore

# Copy the entire source code into the container
COPY . ./

# Publish the application in Release mode to the /app/publish directory
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/runtime:7.0 AS runtime

# Set the working directory inside the runtime container
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish .

# (Optional) Set environment variables with default values
# These can be overridden at runtime using Docker's `-e` flag or Docker Compose
ENV DB_HOST=db
ENV DB_USERNAME=postgres
ENV DB_PASSWORD=postgres
ENV DB_NAME=postgres
ENV REDIS_HOST=redis

# (Optional) Expose ports if your application listens on any (not required for background workers)
# EXPOSE 80

# Define the entry point for the container to run the application
ENTRYPOINT ["dotnet", "Worker.dll"]