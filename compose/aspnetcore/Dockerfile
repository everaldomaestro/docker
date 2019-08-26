FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["APICotacoes/APICotacoes.csproj", "APICotacoes/"]
RUN dotnet restore "APICotacoes/APICotacoes.csproj"
COPY . .
WORKDIR "/src/APICotacoes"
RUN dotnet build "APICotacoes.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "APICotacoes.csproj" -c Release -o /app

FROM base AS final
MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "APICotacoes.dll"]
