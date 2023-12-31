# Use the official Microsoft .NET 8 SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY Auth.MicroService.sln .
COPY src/Auth.MicroService.WebApi/*.csproj ./src/Auth.MicroService.WebApi/
COPY src/Auth.MicroService.Application/*.csproj ./src/Auth.MicroService.Application/
COPY src/Auth.MicroService.Infrastructure/*.csproj ./src/Auth.MicroService.Infrastructure/
COPY src/Auth.MicroService.Domain/*.csproj ./src/Auth.MicroService.Domain/
COPY test/Auth.MicroService.Application.UnitTests/*.csproj ./test/Auth.MicroService.Application.UnitTests/
RUN dotnet restore --no-cache

# Copy everything else and build
COPY src/Auth.MicroService.WebApi/. ./src/Auth.MicroService.WebApi/
COPY src/Auth.MicroService.Application/. ./src/Auth.MicroService.Application/
COPY src/Auth.MicroService.Infrastructure/. ./src/Auth.MicroService.Infrastructure/
COPY src/Auth.MicroService.Domain/. ./src/Auth.MicroService.Domain/
COPY test/Auth.MicroService.Application.UnitTests/. ./test/Auth.MicroService.Application.UnitTests/
# Copy appsettings.json
COPY src/Auth.MicroService.WebApi/appsettings.json ./src/Auth.MicroService.WebApi/
WORKDIR /app/src/Auth.MicroService.WebApi
RUN dotnet build -c Release -o out

# Run the unit tests
WORKDIR /app/test/Auth.MicroService.Application.UnitTests
RUN dotnet test --verbosity normal

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/src/Auth.MicroService.WebApi/out .
COPY --from=build-env /app/src/Auth.MicroService.WebApi/appsettings.json ./
ENV ASPNETCORE_ENVIRONMENT=Development
ENTRYPOINT ["dotnet", "Auth.MicroService.WebApi.dll"]
