FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app

#Copy cs project into distinct layers
#this creates a build image from which build can be done.

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

#Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime

WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT [ "dotnet","ToDoApi.dll" ]