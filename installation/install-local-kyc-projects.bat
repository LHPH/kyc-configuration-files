@ECHO OFF
ECHO INSTALL KYC-PROJECTS IN LOCAL WINDOWS ENVIRONMENT
SET API_URL=https://api.github.com/users/LHPH/repos?per_page=100

SET "KYC_PROJECTS="
SET "PATTERN=kyc-"
SETLOCAL EnableDelayedExpansion

FOR /F "tokens=*" %%A IN ('curl -s "%API_URL%" ^| jq -r ".[].name"') DO (
    
    SET "REPOSITORY=%%A"
    IF NOT "!REPOSITORY!" == "!REPOSITORY:%PATTERN%=!" (
        SET "KYC_PROJECTS=!KYC_PROJECTS! !REPOSITORY!"
    )
)
SET KYC_PROJECTS=%KYC_PROJECTS:~1%

FOR %%G IN ( %KYC_PROJECTS% ) DO (

    ECHO %%G
    IF EXIST %%G (
        
        ECHO NOT DOWNLOAD %%G
    ) ELSE (

        ECHO DOWNLOAD %%G
        git clone https://github.com/LHPH/%%G.git
    )

    cd %%G
    git fetch
    git ls-remote --exit-code --heads origin develop

    IF !ERRORLEVEL! == 0 (
        git checkout develop
    )
    
    cd ..
)