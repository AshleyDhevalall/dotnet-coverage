#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["Cover/Cover.csproj", "Cover/"]
RUN dotnet restore "Cover/Cover.csproj"
COPY . .
WORKDIR "/src/Cover"
RUN dotnet build "Cover.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Cover.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cover.dll"]