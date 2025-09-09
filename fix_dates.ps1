# Script to fix date fields in Hugo markdown files
$files = Get-ChildItem -Path "content" -Recurse -Filter "*.md" | Where-Object { (Get-Content $_.FullName -Raw) -match 'date\s*:\s*.*`r Sys\.Date\(\)`' }

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    
    # Read the file content
    $content = Get-Content $file.FullName -Raw
    
    # Remove the date line completely
    $content = $content -replace 'date\s*:\s*.*`r Sys\.Date\(\)`.*\r?\n', ''
    
    # Write back to file
    Set-Content -Path $file.FullName -Value $content -NoNewline
}

Write-Host "Date fixing completed!"
