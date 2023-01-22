<#
.SYNOPSIS
    .
.DESCRIPTION
    Encrypts\Decrypts files\folders
.PARAMETER source
    The path to the source file or folder you wish to encrypt/decrypt.
.PARAMETER out
    The path to the output directory.
.PARAMETER decrpyt
    Switch. Omit to encrypt, provide to decrpyt
.EXAMPLE
    C:\locker\ps\locker.ps1 -source "C:\Users\YOU\Documents"
.NOTES
    Author: Another-Salad
    Date:   21st January 2023
#>

param(
    [Parameter(Mandatory=$true)][string]$source,
    [switch]$decrpyt
)

$ErrorActionPreference = "Stop"

function isFolder($source) {
    return (Get-Item $source) -is [System.IO.DirectoryInfo]
}

function getFiles($path) {
    $fullPath = Resolve-Path $path
    return Get-ChildItem $fullPath -Recurse -File
}

Function zipToOutputDir($sourceDir, $outDir) {
    $outputZipPath = "$outDir/Hello.zip"  # needs changing
    Compress-Archive -Path "$sourceDir/*" -CompressionLevel Optimal -DestinationPath $outputZipPath
}

function Encryptor($source) {
    $filesToEncrpyt = getFiles $source
    $encryptedFiles = @()
    $currentDir = (pwd).path
    $outDir = "$currentDir/output"
    if (!(Test-Path $outDir)) {
        mkdir $outDir
    }
    # Move to Function
    $inputKey = $(Read-Host -AsSecureString "Input encryption key/password/phrase")
    $inputKeyLen = $inputKey.Length
    switch ($inputKeyLen) {
        {$_ -lt 16} {
            Write-Host "Padding your input to 16 characters. You do not need to keep this extra padding stored."
            Write-Host "You really should think about updating to a 16 character input though..."
            $paddingChars = @(".") * (16 - $_)
            foreach ($char in $paddingChars) {
                $inputKey.AppendChar($char)
            }
        }
        {$_ -gt 16} {
            # Removes the first x chars to conform to the 16 char limit for the AES 256bit key
            $lenDiff = $_ - 16
            Write-Host "Removing the first $lenDiff characters from input string. Conforming to AES 256bit key limits."
            for ($i=0; $i -lt $lenDiff; $i++) {
                $inputKey.RemoveAt($i)
            }
        }
    }
    # Move to Function
    foreach ($file in $filesToEncrpyt) {
        $fname = $file.Name  # We should encrypt the name
        $fileData = Get-Content $file.FullName -Raw | ConvertTo-SecureString -AsPlainText -Force
        ConvertFrom-SecureString $fileData -SecureKey $inputKey | Out-File -FilePath "$outDir/$fname"
    }
}
