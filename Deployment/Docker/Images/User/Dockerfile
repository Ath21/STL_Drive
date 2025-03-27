# Base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5000

# SDK image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["services/user-service/UserService.csproj", "services/user-service/"]
RUN dotnet restore "services/user-service/UserService.csproj"
COPY . .
WORKDIR "/src/services/user-service"
RUN dotnet build "UserService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "UserService.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "UserService.dll"]
