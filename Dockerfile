# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY DemoDockerLinux/*.csproj ./DemoDockerLinux/
RUN dotnet restore

# copy everything else and build app
COPY DemoDockerLinux/. ./DemoDockerLinux/
WORKDIR /source/DemoDockerLinux
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "DemoDockerLinux.dll"]
