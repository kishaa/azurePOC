#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["TestApp2/TestApp2.csproj", "TestApp2/"]
RUN dotnet restore "TestApp2/TestApp2.csproj"
COPY . .
WORKDIR "/src/TestApp2"
RUN dotnet build "TestApp2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestApp2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestApp2.dll"]