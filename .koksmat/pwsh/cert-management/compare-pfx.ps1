<#
.SYNOPSIS
    Compares two PFX files provided as Base64-encoded strings.

.DESCRIPTION
    This script decodes Base64-encoded PFX strings, imports the certificates and private keys using provided passwords,
    extracts relevant details, and compares the contents to identify differences.

.PARAMETER Base64Pfx1
    The Base64-encoded string of the first PFX file.

.PARAMETER Password1
    The password for the first PFX file.

.PARAMETER Base64Pfx2
    The Base64-encoded string of the second PFX file.

.PARAMETER Password2
    The password for the second PFX file.

.EXAMPLE
    Compare-PfxFiles -Base64Pfx1 "BASE64_STRING_1" -Password1 "Password1" `
                  -Base64Pfx2 "BASE64_STRING_2" -Password2 "Password2"
#>

function Compare-PfxFiles {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true)]
    [string]$Base64Pfx1,

    [Parameter(Mandatory = $true)]
    [string]$Password1,

    [Parameter(Mandatory = $true)]
    [string]$Base64Pfx2,

    [Parameter(Mandatory = $true)]
    [string]$Password2
  )

  Begin {
    Write-Host "Starting PFX comparison..." -ForegroundColor Cyan
  }

  Process {
    try {
      # Step 1: Decode Base64 strings to byte arrays
      Write-Host "Decoding Base64 strings..." -ForegroundColor Green
      $pfxBytes1 = [Convert]::FromBase64String($Base64Pfx1)
      $pfxBytes2 = [Convert]::FromBase64String($Base64Pfx2)

      # Step 2: Import PFX files into X509Certificate2 objects
      Write-Host "Importing PFX files..." -ForegroundColor Green
      $certCollection1 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
      $certCollection1.Import($pfxBytes1, $Password1, 'Exportable,PersistKeySet')

      $certCollection2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
      $certCollection2.Import($pfxBytes2, $Password2, 'Exportable,PersistKeySet')

      # Function to extract certificate details
      function Get-CertificateDetails {
        Param (
          [System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert
        )

        # Initialize all properties upfront to avoid dynamic addition
        $details = [PSCustomObject]@{
          Subject             = $Cert.Subject
          Issuer              = $Cert.Issuer
          Thumbprint          = $Cert.Thumbprint
          NotBefore           = $Cert.NotBefore
          NotAfter            = $Cert.NotAfter
          SerialNumber        = $Cert.SerialNumber
          SignatureAlgorithm  = $Cert.SignatureAlgorithm.FriendlyName
          PublicKeyAlgorithm  = $Cert.PublicKey.Oid.FriendlyName
          PublicKey           = $null
          HasPrivateKey       = $Cert.HasPrivateKey
          PrivateKeyAlgorithm = $null
          Modulus             = $null
          Exponent            = $null
          Curve               = $null
        }

        # Safely extract PublicKey as XML string if possible
        try {
          if ($Cert.PublicKey.Key) {
            if ($Cert.PublicKey.Oid.FriendlyName -like "*RSA*") {
              $details.PublicKey = $Cert.PublicKey.Key.ToXmlString($false)
            }
            elseif ($Cert.PublicKey.Oid.FriendlyName -like "*ECDSA*") {
              $details.PublicKey = $Cert.PublicKey.Key.ToString()
            }
            else {
              $details.PublicKey = "Unsupporxted Public Key Type"
            }
          }
        }
        catch {
          $details.PublicKey = "Unable to extract Public Key"
        }

        # If certificate has a private key, extract key details
        if ($Cert.HasPrivateKey) {
          try {
            $privateKey = $Cert.GetRSAPrivateKey()
            if ($privateKey) {
              $params = $privateKey.ExportParameters($false)
              $details.PrivateKeyAlgorithm = "RSA"
              $details.Modulus = [BitConverter]::ToString($params.Modulus) -replace '-', ''
              $details.Exponent = [BitConverter]::ToString($params.Exponent) -replace '-', ''
            }
            else {
              $ecPrivateKey = $Cert.GetECDsaPrivateKey()
              if ($ecPrivateKey) {
                $params = $ecPrivateKey.ExportParameters()
                $details.PrivateKeyAlgorithm = "ECDSA"
                $details.Curve = $params.Curve.Oid.FriendlyName
              }
              else {
                $details.PrivateKeyAlgorithm = "Unsupported or unable to extract private key."
              }
            }
          }
          catch {
            $details.PrivateKeyAlgorithm = "Error extracting private key."
          }
        }

        return $details
      }

      # Extract details for all certificates in both PFX files
      Write-Host "Extracting certificate details..." -ForegroundColor Green
      $detailsList1 = @()
      foreach ($cert in $certCollection1) {
        $detailsList1 += Get-CertificateDetails -Cert $cert
      }

      $detailsList2 = @()
      foreach ($cert in $certCollection2) {
        $detailsList2 += Get-CertificateDetails -Cert $cert
      }

      # Step 3: Compare the certificate details
      Write-Host "Comparing certificate details..." -ForegroundColor Green

      # Function to convert PublicKey string to a comparable format
      function Convert-PublicKeyToString {
        Param (
          [string]$PublicKey
        )
        return $PublicKey
      }

      # Prepare comparison objects
      $comparisonObj1 = $detailsList1 | Select-Object `
        Subject,
      Issuer,
      Thumbprint,
      NotBefore,
      NotAfter,
      SerialNumber,
      SignatureAlgorithm,
      PublicKeyAlgorithm,
      @{Name = "PublicKeyString"; Expression = { Convert-PublicKeyToString -PublicKey $_.PublicKey } },
      HasPrivateKey,
      PrivateKeyAlgorithm,
      Modulus,
      Exponent,
      Curve

      $comparisonObj2 = $detailsList2 | Select-Object `
        Subject,
      Issuer,
      Thumbprint,
      NotBefore,
      NotAfter,
      SerialNumber,
      SignatureAlgorithm,
      PublicKeyAlgorithm,
      @{Name = "PublicKeyString"; Expression = { Convert-PublicKeyToString -PublicKey $_.PublicKey } },
      HasPrivateKey,
      PrivateKeyAlgorithm,
      Modulus,
      Exponent,
      Curve

      # Compare using Compare-Object
      $certComparison = Compare-Object -ReferenceObject $comparisonObj1 -DifferenceObject $comparisonObj2 -Property Subject, Issuer, Thumbprint, NotBefore, NotAfter, SerialNumber, SignatureAlgorithm, PublicKeyAlgorithm, PublicKeyString, HasPrivateKey, PrivateKeyAlgorithm, Modulus, Exponent, Curve -IncludeEqual -PassThru

      if ($certComparison) {
        Write-Host "Comparison Results:" -ForegroundColor Yellow
        foreach ($diff in $certComparison) {
          if ($diff.SideIndicator -eq '==') {
            Write-Host "Certificate is identical:" -ForegroundColor Green
            Write-Host "Subject: $($diff.Subject)" -ForegroundColor Green
            Write-Host "Issuer: $($diff.Issuer)" -ForegroundColor Green
            Write-Host "Thumbprint: $($diff.Thumbprint)" -ForegroundColor Green
            Write-Host ""
          }
          elseif ($diff.SideIndicator -eq '<=') {
            Write-Host "Only in PFX1:" -ForegroundColor Red
            $diff | Format-List
            Write-Host ""
          }
          elseif ($diff.SideIndicator -eq '=>') {
            Write-Host "Only in PFX2:" -ForegroundColor Red
            $diff | Format-List
            Write-Host ""
          }
        }
      }
      else {
        Write-Host "No differences found between the two PFX files." -ForegroundColor Green
      }

      # Optional: Further detailed comparison can be implemented as needed.

    }
    catch {
      Write-Error "An error occurred: $_"
    }
  }

  End {
    Write-Host "PFX comparison completed." -ForegroundColor Cyan
  }
}
