# Build stage
FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore HelloFunctionApp.csproj
COPY . ./
RUN dotnet publish HelloFunctionApp.csproj -c Release -o /app/publish --no-restore

# Runtime stage (Azure Functions .NET isolated)
FROM --platform=linux/amd64 mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated8.0
WORKDIR /home/site/wwwroot
COPY --from=build /app/publish .


# Optional: expõe porta e define probe, se quiser controlar via Kubernetes
# EXPOSE 80
# HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:80 || exit 1