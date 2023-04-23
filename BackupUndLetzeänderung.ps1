


#-------------------------------------------------------------------------------------------------------------


Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Point(50,100)
$Form.ClientSize = New-Object System.Drawing.Size(300, 250)
$Button.Size = New-Object System.Drawing.Size(200,100)
$Button.Text = "letze Änderung"

$Form.Controls.Add($Button)

$Button.Add_Click(
{

Add-Type -AssemblyName System.Windows.Forms

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = "C:\Users\"
$dialog.ShowDialog() 

$eingabe = Get-Item $dialog.FileName

$lastWriteTime = $eingabe.LastWriteTime

$now = Get-Date

$timespan = New-TimeSpan -Start $lastWriteTime -End $now

if($timespan.Days -eq 0) 
{
    $message = "Die Datei wurde heute bearbeitet."
} 

else 
{
    $message = "Die Datei wurde zuletzt vor " + $timespan.Days + " Tagen bearbeitet."
}

[System.Windows.Forms.MessageBox]::Show($message, "Letzte Bearbeitung", 0)

}
)


$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Point(50, 10)
$Button2.Size = New-Object System.Drawing.Size(200,100)
$Button2.Text = "Back up machen"



$Button2.add_Click(
{


$sourceFolder = New-Object System.Windows.Forms.FolderBrowserDialog
$sourceFolder.Description = "Wählen Sie das Quellverzeichnis für das Backup aus."
$sourceFolder.RootFolder = "MyComputer"

if ($sourceFolder.ShowDialog() -eq 'OK')
{
    $sourcePath = $sourceFolder.SelectedPath
}

# Dialog zum Auswählen des Zielverzeichnisses
$targetFolder = New-Object System.Windows.Forms.FolderBrowserDialog
$targetFolder.Description = "Wählen Sie das Zielverzeichnis für das Backup aus."
$targetFolder.RootFolder = "MyComputer"

if ($targetFolder.ShowDialog() -eq 'OK')
{
    # Erstellen des Backup-Verzeichnisses im Zielverzeichnis
    #Join-Path, um den Zielpfad und den Namen des Backup-Verzeichnisses zu kombinieren.
    $targetPath = Join-Path -Path $targetFolder.SelectedPath -ChildPath "Backup" 
    New-Item -ItemType Directory -Path $targetPath -Force

    # Kopieren der Dateien aus dem Quellverzeichnis in das Backup-Verzeichnis
    $files = Get-ChildItem -Path $sourcePath

    foreach ($file in $files)
    {

        # Wenn das Backup-Verzeichnis $backupPath neu erstellt wird, enthält es zu Beginn keine Dateien
        $backupFile = Join-Path -Path $targetPath -ChildPath $file.Name

        #Die Dateien werden erst kopiert, wenn der Befehl Copy-Item innerhalb der Schleife ausgeführt wird
        Copy-Item -Path $file.FullName -Destination $backupFile -Force
        
    }
}



}
)
$Form.Controls.Add($Button2)
$Form.ShowDialog() | Out-Null


#------------------------------------------------------------------------------

