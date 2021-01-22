#######################################################
# Step 1: Build the application in a container        #
#######################################################
# Download the official ASP.NET Core SDK image
# to build the project while creating the docker image
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build
WORKDIR /src
EXPOSE 9000:9000

COPY ["dotnet-coverage.sln", "./"]
COPY ["Cover/Cover.csproj", "Cover/"]
COPY ["Cover.Tests/Cover.Tests.csproj", "Cover.Tests/"]

# restore for all projects
RUN dotnet restore dotnet-coverage.sln -v:diag
COPY . .

# test
# use the label to identity this layer later
LABEL test=true

# Install Sonar Scanner, Coverlet and Java (required for Sonar Scanner)
RUN apt-get update && apt-get install -y openjdk-11-jdk
RUN dotnet tool install --global dotnet-sonarscanner
RUN dotnet tool install --global dotnet-reportgenerator-globaltool
ENV PATH="$PATH:/root/.dotnet/tools"

# initialise sonar-scanner
RUN dotnet sonarscanner begin -k:dotnet-coverage -d:sonar.host.url="http://localhost:9000/" -d:sonar.password=admin -d:sonar.login=admin -d:sonar.cs.opencover.reportsPaths=/coverage.opencover.xml -d:sonar.verbose=true

# Build and test the application
RUN dotnet publish --output /out/
RUN dotnet test "Cover.Tests/Cover.Tests.csproj" \
  /p:CollectCoverage=true \
  /p:CoverletOutputFormat=opencover \
  /p:CoverletOutput="/coverage"




#RUN dotnet build "Cover/Cover.csproj"

# run the test and collect code coverage (requires coverlet.msbuild to be added to test project)
# for exclude, use %2c for ,
#RUN dotnet test "Cover.Tests/Cover.Tests.csproj" --settings coverlet.runsettings --results-directory /testresults --logger "trx;LogFileName=test_results.xml" /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura /p:CoverletOutput=/testresults/coverage/ /p:Exclude="[xunit.*]*"

# stop sonar-scanner
RUN dotnet-sonarscanner end -d:sonar.login=admin -d:sonar.password=admin

# generate html reports using report generator tool
# RUN reportgenerator "-reports:/testresults/coverage/coverage.cobertura.xml" "-targetdir:/testresults/coverage/reports" "-reporttypes:HTMLInline;HTMLChart"

#######################################################
# Step 2: Run the build outcome in a container        #
#######################################################
# Download the official ASP.NET Core Runtime image
# to run the compiled application
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app

# Open port
EXPOSE 8080

# Copy the build output from the SDK image
COPY --from=build /out .

# Start the application
ENTRYPOINT ["dotnet", "Cover.dll"]