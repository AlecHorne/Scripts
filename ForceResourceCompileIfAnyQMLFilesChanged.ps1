Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

$qmlDir = Join-Path -Path ( Split-Path -Path $MyInvocation.MyCommand.Definition -Parent ) -ChildPath "\"
$qrcFileName = "qml.qrc"
$qrcFilePath = $qmlDir + $qrcFileName

Write-Host "Checking for updated QML files to force the resource compiler to run..." -ForegroundColor cyan -BackgroundColor black
Write-Host "QML directory:" $qmlDir -ForegroundColor cyan -BackgroundColor black
Write-Host "QRC file path:" $qrcFilePath -ForegroundColor cyan -BackgroundColor black

$q = $( ls $qrcFilePath );

foreach ( $i in Get-ChildItem -Force $qmlDir* -Include *.qml -Exclude "*.qrc" )
{
   $fileName = Split-Path -Path $i -Leaf -Resolve

   if ( $i.LastWriteTime -gt $q.LastWriteTime )
   {
      Get-ItemProperty -Path $q | % { if($_.IsReadOnly){$_.IsReadOnly= $false} }
      $q.LastWriteTime = $i.LastWriteTime
      Write-Host "-------------------------------------------------------------------------------------------------" -ForeGroundColor red -BackgroundColor black
      Write-Host "Changes detected:" $fileName -ForegroundColor red -BackgroundColor black
      Write-Host "The QRC resource file -" $qrcFileName " will now be recompiled to ensure any changes are present." -ForegroundColor red -BackgroundColor black
      Write-Host "-------------------------------------------------------------------------------------------------" -ForeGroundColor red -BackgroundColor black
      Exit
   }
   else
   {
      Write-Host "No changes detected:" $fileName -ForegroundColor green -BackgroundColor black
   }
}

Write-Host "No changes detected in any QML file in directory:" $qmlDir -ForegroundColor cyan -BackgroundColor black
