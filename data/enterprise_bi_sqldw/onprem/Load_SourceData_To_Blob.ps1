param(
  
  # Provide the file containing the database objects to be exported 
    [Parameter(Mandatory=$true, ParameterSetName="FileParameterSet")]
    [ValidateScript({Test-Path $_})]
    [System.IO.FileInfo]$File,
  
  # alternative , if file is not input, array could be provided as input 
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName="NamesParameterSet")]
    [string[]]$TableArray = @(),
  
  # path of the script home 
    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [System.IO.DirectoryInfo]$Path = $PSScriptRoot,
  
  # Storage account URI 
    [Parameter(Mandatory=$true)]
    [ValidateScript({
      return [System.Uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)
    })]
    [System.Uri]$Destination,
  
    #Storage account key 
    [Parameter(Mandatory=$false)]
    [ValidateScript({
      try {
        if ([System.String]::IsNullOrWhitespace($_)) {
          return $false
        }
        [System.Convert]::FromBase64String($_) | Out-Null
        return $true
      } catch [System.FormatException] {
        return $false
      }
    })]
    [string]$StorageAccountKey,
  
    # Path in the system where AZ copy is installed 
    [Parameter(Mandatory=$false)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$AzCopyPath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\azcopy.exe",
  
    #retires count 
    [Parameter(Mandatory=$false)]
    [string]$MaxRetries = -1
    
  )
  
  $VerbosePreference = "Continue"
  $ErrorActionPreference = "Stop"
  
  switch ($PSCmdlet.ParameterSetName) {
    "FileParameterSet" {
      $TableNames = Get-Content $File
    }
    "NamesParameterSet" {
      $TableNames = $TableArray
    }
  }
  
  function New-GZipArchive {
    param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [ValidateScript({$_.Exists})]
      [System.IO.FileInfo]$InputFile
    )
  
    begin {}
    process {
      $InputStream = $null
      $OutputStream = $null
      try {
        $InputStream = $InputFile.OpenRead()
        $OutputFileInfo = [System.IO.FileInfo]"$($InputFile.BaseName).gz"
        $OutputStream = New-Object System.IO.Compression.GZipStream(([System.IO.File]::Create($OutputFileInfo.FullName)), `
            [System.IO.Compression.CompressionLevel]::Optimal)
        $InputStream.CopyTo($OutputStream)
        $OutputStream.Flush()
      } finally {
        if ($InputStream) {
          $InputStream.Dispose()
        }
  
        if ($OutputStream) {
          $OutputStream.Dispose()
        }
      }
    }
    end {}
  }
  
  function Invoke-TableBulkCopy {
    [CmdLetBinding()]
    param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [string]$TableName
    )
  
    begin{}
    process {
  
      # -C65001
      $OutputFilename = "$($TableName.Replace('.', '_')).csv"
      Write-Verbose "Executing $TableName..."
      $Path = (Resolve-Path .\).Path + "\Exports"
      New-Item -Path $Path -Name $($TableName.Replace('.', '_')) -ItemType "directory"
      $FullPath =  $Path+"\"+$($TableName.Replace('.', '_'))+"\"+$OutputFilename
      Write-Verbose $FullPath
      &"bcp.exe" $TableName out $FullPath  -t"|" -c -C65001 -T | Write-Host
      Write-Output ([System.IO.FileInfo]$OutputFilename)
    }
    end{}
  }
  
  
  function Invoke-StoredProcedure {
    [CmdLetBinding()]
    param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [string]$StoredProcedureName
    )
  
    begin{}
    process {
      $OutputFilename = "$($StoredProcedureName.Replace('.', '_')).csv"
      Write-Verbose "Executing $StoredProcedureName..."
      $Path = (Resolve-Path .\).Path+ "\Exports"
      New-Item -Path $Path -Name $($StoredProcedureName.Replace('.', '_')) -ItemType "directory"
      $FullPath =  $Path+"\"+$($StoredProcedureName.Replace('.', '_'))+"\"+$OutputFilename
      Write-Verbose $FullPath
      &"bcp.exe" "exec $StoredProcedureName" queryout $FullPath -c -C65001 -t"|" -T | Write-Host
      Write-Output ([System.IO.FileInfo]$OutputFilename)
    }
    end{}
  }
  
  function Copy-FilesToBlobStorage {
    param(
      [Parameter(Mandatory=$true)]
      [ValidateScript({
        return [System.Uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)
      })]
      [System.Uri]$Destination,
      [Parameter(Mandatory=$true)]
      [ValidateScript({ Test-Path -Path $_ -PathType Container })]
      [System.IO.DirectoryInfo]$Source,
      [Parameter(Mandatory=$true)]
      [string]$StorageAccountKey,
      [Parameter(Mandatory=$false)]
      [string]$Pattern = "*"
    )
      Write-Verbose "Transferring $(Join-Path $Source $Pattern) files to $Destination"
      $azJournal = ".\Journal"     
      Write-Verbose  "Source is $($Source.FullName)"
       
  
      $ActualSource =  $($Source.FullName)+'\'
  
      Write-Verbose  "ActualSource is $ActualSource"
  
      $Options = @("/Dest:$Destination", "/DestKey:$StorageAccountKey", "/Source:$ActualSource", "/Y", "/Pattern:$Pattern", "/Z:$azJournal", "/NC:10","/S") 
  
      & "$AzCopyPath" $Options | Write-Host
  
      if ($LASTEXITCODE -ge 0) {
          return
        
      }
  
      $i = 0
      while (($MaxRetries -eq -1) -or ($i -le $MaxRetries)) {
          $i++
          Write-Warning "RETRY: $i"
          & "$AzCopyPath" $Options | Write-Host
          if ($LASTEXITCODE -eq 0) {
              return
          }
      }
  }
  
  $StoredProcArray =@(
    "WideWorldImporters.dbo.GetDateDimensions"
  )
  $TableNames |Invoke-TableBulkCopy | Out-Null 
  $StoredProcArray | Invoke-StoredProcedure | Out-Null
  $Path = (Resolve-Path .\).Path+ "\Exports"
  
  Copy-FilesToBlobStorage -Destination $Destination -Source $Path -StorageAccountKey $StorageAccountKey
  