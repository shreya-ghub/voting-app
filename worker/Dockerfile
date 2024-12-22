# # Stage 1: Build
# FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
# WORKDIR /source

# # Copy the project file and restore dependencies
# COPY *.csproj ./
# RUN dotnet restore

# # Copy the remaining source code and publish
# COPY . ./
# RUN dotnet publish -c Release -o /app --runtime linux-arm64 --self-contained false --no-restore

# # Stage 2: Runtime
# FROM mcr.microsoft.com/dotnet/runtime:7.0
# WORKDIR /app
# COPY --from=build /app .
# ENTRYPOINT ["dotnet", "Worker.dll"]



##### Dockerfile V2 #####

# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy and restore project files
COPY ./*.csproj ./
RUN dotnet restore

# Copy all source files and build
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app

# Copy the build output
COPY --from=build /app/out ./

# Expose port if necessary (e.g., for health checks or specific APIs)
EXPOSE 80

# Environment variables for runtime (customize as needed)
ENV DOTNET_EnableDiagnostics=0

# Command to run the application
CMD ["dotnet", "Worker.dll"]
