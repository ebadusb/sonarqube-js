#! /usr/bin/pwsh

$version = $env:BCT_PRODUCT_VERSION 
$eventname = $env:BCT_EVENT_NAME
$isPublishing = $([System.Convert]::ToBoolean($env:BCT_IS_PUBLISHING))
$targetbranch = $env:TARGET_BRANCH
$sourcebranch = $env:SOURCE_BRANCH
$prnumber = $env:PR_NUMBER
$sonarqubeUrl = $env:BCT_SONARQUBE_URL
$sonarqubeToken = $env:BCT_SONARQUBE_TOKEN
$sonarqubeProjectKey = $env:BCT_SONARQUBE_PROJECT_KEY
$gitrepo = $env:GITHUB_REPOSITORY
$branchname = $env:BCT_BRANCH
$src = $env:SRC

if($null -ne $sonarqubeToken){
	# C# sonar analysis
		if ($eventname -like "pull_request") {
			Push-Location $src
				# Sonarscanner for static analysis
				dotnet tool install --global dotnet-sonarscanner
				   dotnet sonarscanner begin /k:$sonarqubeProjectKey `
				   /d:sonar.host.url=$sonarqubeUrl `
				   /d:sonar.login=$sonarqubeToken `
				   /v:$version `
				   /d:sonar.cs.xunit.reportsPaths=**/*.testresults.xml `
				   /d:sonar.cs.opencover.reportsPaths=**/*.coverage.xml `
				   /d:sonar.pullrequest.branch=$sourcebranch `
				   /d:sonar.pullrequest.key=$prnumber `
				   /d:sonar.pullrequest.base=$targetbranch `
				   /d:sonar.pullrequest.github.repository=$gitrepo `
				   /d:sonar.scm.disabled=true `
				   /d:sonar.scm.provider=git
			Pop-Location
		}    
	   ElseIf ($isPublishing) {
			Push-Location $src
				# Sonarscanner for static analysis
				dotnet tool install --global dotnet-sonarscanner           
	
				   dotnet sonarscanner begin /k:$sonarqubeProjectKey `
				   /d:sonar.host.url=$sonarqubeUrl `
				   /d:sonar.login=$sonarqubeToken `
				   /v:$version `
				   /d:sonar.cs.xunit.reportsPaths=**/*.testresults.xml `
				   /d:sonar.cs.opencover.reportsPaths=**/*.coverage.xml `
				   /d:sonar.scm.provider=git `
				   /d:sonar.scm.disabled=true `
				   /d:sonar.branch.name=$branchname                
			Pop-Location		
		  }
	}
