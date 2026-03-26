FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore HelloFunctionApp.csproj
RUN dotnet publish HelloFunctionApp.csproj -c Release -o /app/publish --no-restore

FROM --platform=linux/arm64 mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated8.0
WORKDIR /home/site/wwwroot
COPY --from=build /app/publish .