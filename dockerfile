FROM mcr.microsoft.com/dotnet/sdk:5.0 AS base
WORKDIR /app

# Copy csproj and restore as distinct layers
WORKDIR /src
COPY ["dotnet-coverage.sln", "./"]
COPY ["Cover/Cover.csproj", "Cover/"]
COPY ["Cover.Tests/Cover.Tests.csproj", "Cover.Tests/"]
COPY . .

# restore for all projects
RUN dotnet restore dotnet-coverage.sln

# test
# use the label to identity this layer later
LABEL test=true

# install the report generator tool
RUN dotnet tool install dotnet-reportgenerator-globaltool --tool-path /tools

# install sonar scanner
RUN dotnet tool install dotnet-sonarscanner --tool-path /tools

# initialise sonar-scanner
# RUN /tools/dotnet-sonarscanner.exe begin -d:sonar.login=admin -d:sonar.password=@shl#y123 -d:sonar.host.url="http://localhost:9000" -k:"dotnet-coverage"

# run the test and collect code coverage (requires coverlet.msbuild to be added to test project)
# for exclude, use %2c for ,
RUN dotnet test --settings coverlet.runsettings --results-directory /testresults --logger "trx;LogFileName=test_results.xml" /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura /p:CoverletOutput=/testresults/coverage/ /p:Exclude="[xunit.*]*" Cover.Tests/Cover.Tests.csproj

# stop sonar-scanner
# RUN /tools/dotnet-sonarscanner.exe end -d:sonar.login=admin -d:sonar.password=@shl#y123

# generate html reports using report generator tool
RUN /tools/reportgenerator "-reports:/testresults/coverage/coverage.cobertura.xml" "-targetdir:/testresults/coverage/reports" "-reporttypes:HTMLInline;HTMLChart"
# RUN ls -la /testresults/coverage/reports

RUN dotnet publish "Cover/Cover.csproj" --no-restore -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cover.dll"]