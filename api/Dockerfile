FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS build

ARG TARGETARCH

WORKDIR /src

COPY Minions.Api.csproj ./
RUN dotnet restore Minions.Api.csproj -a $TARGETARCH

COPY . .
RUN dotnet publish Minions.Api.csproj -c Release -o /out -a $TARGETARCH --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

COPY --from=build /out ./

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_HTTP_PORTS=4000

USER app

EXPOSE 4000

ENTRYPOINT ["dotnet", "Minions.Api.dll"]
