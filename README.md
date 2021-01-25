# dotnet-coverage

The goal of this project is to demonstrate how to use Sonar Scanner in a dockerfile to generate code coverage for .NET core projects.

### Prerequisites / Background knowledge
* [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
* [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download/dotnet-core/thank-you/sdk-3.1.405-windows-x64-installer)
* [SonarQube](https://www.sonarqube.org/)
* [Sonar Scanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)

### Usage

#### 1. Setup SonarQube
* Run Docker Desktop for Windows (Ensure running as Linux Containers)

* Run SonarQube server

```
docker run -d --name sonarqube -p 9000:9000 sonarqube:7.5-community
 ```

* Run docker ps and check if the server is up and running

```
docker image
```

* Wait for the server to start and log in to SonarQube server on http://localhost:9000 using default credentials: login: admin password: admin

#### 2. Clone repository

```
git clone https://github.com/AshleyDhevalall/dotnet-coverage.git
```

* Navigate to cloned repository folder

#### 3. Building the docker image
* Run the command below in the cloned repository folder to build the docker image
```
docker build --network=host --no-cache .
```

#### 4. View the code coverage results
* Go to SonarQube server on http://localhost:9000
* The project will displayed on the home page with the code coverage percentage.

## Troubleshooting
#### No code coverage being published?
* Install coverlet.msbuild package in all unit test projects.
  
```
<PackageReference Include="coverlet.msbuild" Version="2.6.1">
  <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
  <PrivateAssets>all</PrivateAssets>
</PackageReference>
```

## License

MIT License

Copyright (c) 2019 AshleyDhevalall

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
