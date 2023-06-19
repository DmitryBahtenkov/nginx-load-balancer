FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["./NginxTest2/NginxTest2.csproj", "NginxTest2/"]
RUN dotnet restore "NginxTest2/NginxTest2.csproj"
COPY . .
WORKDIR "/src/NginxTest2"
RUN dotnet build "NginxTest2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NginxTest2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NginxTest2.dll"]
