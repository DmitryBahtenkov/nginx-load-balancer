FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["./NginxTest/NginxTest.csproj", "NginxTest/"]
RUN dotnet restore "NginxTest/NginxTest.csproj"
COPY . .
WORKDIR "/src/NginxTest"
RUN dotnet build "NginxTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NginxTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NginxTest.dll"]
