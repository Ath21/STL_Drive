# Base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5003

# SDK image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["services/notification-service/NotificationService.csproj", "services/notification-service/"]
RUN dotnet restore "services/notification-service/NotificationService.csproj"
COPY . .
WORKDIR "/src/services/notification-service"
RUN dotnet build "NotificationService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NotificationService.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NotificationService.dll"]
