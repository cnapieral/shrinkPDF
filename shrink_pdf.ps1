# PDF-Datei per Drag-and-Drop oder Eingabeaufforderung komprimieren
param (
    [string]$inputFile = $args[0]
)

# Prüfen, ob Eingabedatei übergeben wurde
if (-not $inputFile) {
    $inputFile = Read-Host "Bitte geben Sie den Pfad zur PDF-Datei ein"
}

# Prüfen, ob die Datei existiert und eine PDF ist
if (-not $inputFile -or -not (Test-Path $inputFile) -or [System.IO.Path]::GetExtension($inputFile).ToLower() -ne ".pdf") {
    Write-Error "Keine gültige PDF-Datei angegeben."
    exit
}

# Prüfen, ob Ghostscript installiert ist
if (!(Get-Command "gswin64c" -ErrorAction SilentlyContinue)) {
    Write-Warning "Ghostscript nicht gefunden. Bitte laden Sie Ghostscript von https://www.ghostscript.com/releases/gsdnld.html herunter, installieren Sie es und fügen Sie es zum Pfad hinzu."
    exit
}

# Ausgabedatei im gleichen Verzeichnis mit _compressed
$outputFile = [System.IO.Path]::Combine(
    [System.IO.Path]::GetDirectoryName($inputFile),
    [System.IO.Path]::GetFileNameWithoutExtension($inputFile) + "_compressed.pdf"
)

# Ghostscript-Argumente als Array
$gsArgs = @(
    "-sDEVICE=pdfwrite",
    "-dCompatibilityLevel=1.4",
    "-dPDFSETTINGS=/screen",
    "-dNOPAUSE",
    "-dQUIET",
    "-dBATCH",
    "-sOutputFile=$outputFile",
    $inputFile
)

# Ausführen des Befehls
& "gswin64c" $gsArgs

# Prüfen, ob die Ausgabe erfolgreich war
if (Test-Path $outputFile) {
    Write-Output "PDF erfolgreich komprimiert: $outputFile"
} else {
    Write-Error "Fehler beim Komprimieren der PDF."
}