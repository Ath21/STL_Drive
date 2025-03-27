# Base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5002

# SDK image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["services/vehicle-service/VehicleService.csproj", "services/vehicle-service/"]
RUN dotnet restore "services/vehicle-service/VehicleService.csproj"
COPY . .
WORKDIR "/src/services/vehicle-service"
RUN dotnet build "VehicleService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "VehicleService.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "VehicleService.dll"]
