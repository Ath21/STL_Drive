# Base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5001

# SDK image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["services/traffic-service/TrafficService.csproj", "services/traffic-service/"]
RUN dotnet restore "services/traffic-service/TrafficService.csproj"
COPY . .
WORKDIR "/src/services/traffic-service"
RUN dotnet build "TrafficService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TrafficService.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TrafficService.dll"]
