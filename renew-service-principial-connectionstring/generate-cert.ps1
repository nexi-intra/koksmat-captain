. (join-path  $PSScriptRoot ".." ".koksmat" "pwsh" "koksmat.ps1")
function New-AzureAdSelfSignedCert {
  <#
  .SYNOPSIS
      Creates a self-signed certificate for Sharepoint Online Certificate-Based Authentication and exports it as PFX, Base64-encoded PFX, and CER files without a password using OpenSSL.

  .DESCRIPTION
      Generates a self-signed certificate with the necessary properties for Sharepoint Online CBA, including Client Authentication EKU. Exports the certificate and its private key to a PFX file without a password, creates a Base64-encoded version of the PFX, and exports the public key as a CER file. All output files are saved in the script's directory.

  .PARAMETER SubjectName
      The subject name for the certificate (e.g., "CN=User@example.com").

  .PARAMETER CertValidityDays
      (Optional) The number of years the certificate will be valid. Default is 2 years.

  .EXAMPLE
      New-SharepointOnlineSelfSignedCert -SubjectName "CN=User@example.com"

  .EXAMPLE
      New-SharepointOnlineSelfSignedCert -SubjectName "CN=User@example.com" -CertValidityDays 3
  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = "The subject name for the certificate (e.g., 'CN=User@example.com').")]
    [string]$SubjectName,

    [Parameter(Mandatory = $true, HelpMessage = "The base file name for the certificate files.")]
    [string]$BaseFileName,

    [Parameter(Mandatory = $false, HelpMessage = "Number of days the certificate is valid. Default is 90 days.")]
    [int]$CertValidityDays = 90,

    [Parameter(Mandatory = $true, HelpMessage = "The directory where the script is writing to.")]
    [string]$scriptDirectory

  )

  try {
    Write-Verbose "Generating self-signed certificate with Subject: $SubjectName"

    # Ensure OpenSSL is available
    if (-not (Get-Command openssl -ErrorAction SilentlyContinue)) {
      throw "OpenSSL is not installed or not found in PATH."
    }



    $privateKeyPath = Join-Path -Path $scriptDirectory -ChildPath "$baseFileName.key"
    $certPath = Join-Path -Path $scriptDirectory -ChildPath "$baseFileName.crt"
    $pfxPath = Join-Path -Path $scriptDirectory -ChildPath "$baseFileName.pfx"
    $cerPath = Join-Path -Path $scriptDirectory -ChildPath "$baseFileName.cer"
    $base64Path = Join-Path -Path $scriptDirectory -ChildPath "$baseFileName.b64pfx"
    $base64CerPath = Join-Path -Path $scriptDirectory -ChildPath "$baseFileName.b64cer"

    # Define certificate validity period in days
    $validityDays = $CertValidityDays 
    Write-Verbose "Generating Private Key at: $privateKeyPath"

    # Generate Private Key
    openssl genrsa -out "$privateKeyPath" 2048

    Write-Verbose "Generating Self-Signed Certificate at: $certPath"

    # Generate Self-Signed Certificate with EKU for Client Authentication
    # Create a config file for OpenSSL to include EKU
    $opensslConfigPath = Join-Path -Path $scriptDirectory -ChildPath "openssl.cnf"

    @"
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
CN = $($SubjectName -replace '^CN=', '')

[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
"@ | Out-File -FilePath $opensslConfigPath -Encoding ascii

    # Generate Self-Signed Certificate
    openssl req -x509 -nodes -days $validityDays -new -key "$privateKeyPath" -out "$certPath" -config "$opensslConfigPath"

    # Clean up the temporary OpenSSL config file
    Remove-Item -Path "$opensslConfigPath" -Force

    Write-Verbose "Exporting to PFX at: $pfxPath"

    # Export to PFX without password
    openssl pkcs12 -export -out "$pfxPath" -inkey "$privateKeyPath" -in "$certPath" -passout pass:

    Write-Verbose "Exporting public certificate to CER at: $cerPath"

    # Convert CRT to CER (PEM to DER format)
    openssl x509 -outform der -in "$certPath" -out "$cerPath"

    Write-Verbose "Generating Base64-encoded PFX at: $base64Path"

    
    # Convert PFX to Base64 using .NET method compatible across platforms
    [byte[]]$pfxBytes = [System.IO.File]::ReadAllBytes("$pfxPath")
    $base64String = [Convert]::ToBase64String($pfxBytes)
    Set-Content -Path "$base64Path" -Value $base64String -Encoding ascii

    [byte[]]$pfxBytes = [System.IO.File]::ReadAllBytes("$cerPath")
    $base64String = [Convert]::ToBase64String($pfxBytes)
    Set-Content -Path "$base64CerPath" -Value $base64String -Encoding ascii

    Write-Output "Certificate generation completed successfully."

    Write-Output "Files generated:"
    Write-Output " - Private Key: $privateKeyPath"
    Write-Output " - Certificate: $certPath"
    Write-Output " - PFX (no password): $pfxPath"
    Write-Output " - CER: $cerPath"
    Write-Output " - Base64 PFX: $base64Path"
  }
  catch {
    Write-Error "An error occurred: $_"
  }
}

function New-Cert() {
  param(
    [Parameter(Mandatory = $true, HelpMessage = "The subject name for the certificate (e.g., cn=xx@domainname.com")]

    [string]$SubjectName,
    [Parameter(Mandatory = $true, HelpMessage = "The base file name for the certificate files.")]
    [string]$BaseFileName

  )
  $certDir = join-path (Set-KoksmatWorkdir) "certs"
  if (-not (Test-Path $certDir)) {
    New-Item -Path $certDir -ItemType Directory | Out-Null
  }
  # Execute the function with the desired SubjectName and validity period
  New-AzureAdSelfSignedCert -SubjectName $SubjectName -CertValidityDays 90 -scriptDirectory $certDir -BaseFileName $BaseFileName
  $env:CERTDIR = $certDir
}