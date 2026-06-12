# pruebas.ps1 — Suite de pruebas para la API Copa Mundial FIFA
# Uso: .\pruebas.ps1
# Requiere: xh en el PATH (https://github.com/ducaale/xh)

$ResultsFile  = Join-Path $PSScriptRoot 'pruebas-resultados.txt'
$ImagenesDir  = Join-Path $PSScriptRoot 'public\imagenes'

# Borrar resultados anteriores
if (Test-Path $ResultsFile) { Remove-Item $ResultsFile }

# Contadores
$count200      = 0
$count400      = 0
$count404      = 0
$countOther    = 0
$imgMismatches = @()

# -----------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------

function Write-Section {
    param([string]$Title, [string]$Cmd)
    $sep  = '=' * 60
    $text = "`n$sep`n  $Title`n  Comando: $Cmd`n$sep"
    $text | Out-File -Append -Encoding utf8 $ResultsFile
    Write-Host $text
}

function Get-HttpStatus {
    param([string[]]$Lines)
    $line = $Lines | Where-Object { $_ -match '^HTTP/' } | Select-Object -First 1
    if ($line -match '\b(\d{3})\b') { return [int]$Matches[1] }
    return 0
}

function Register-Status {
    param([int]$Code)
    switch ($Code) {
        200     { $script:count200++ }
        400     { $script:count400++ }
        404     { $script:count404++ }
        default { $script:countOther++ }
    }
}

# -----------------------------------------------------------------------
# Encabezado del archivo
# -----------------------------------------------------------------------
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
@"
================================================================
  RESULTADOS DE PRUEBAS — API Copa Mundial FIFA
  Generado : $timestamp
  Servidor : http://localhost:4321
================================================================
"@ | Out-File -Encoding utf8 $ResultsFile

# -----------------------------------------------------------------------
# PRUEBA 1: GET /mundiales
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 1: GET /mundiales' 'xh GET :4321/mundiales'
$out1 = xh GET :4321/mundiales
$out1 | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out1)

# -----------------------------------------------------------------------
# PRUEBA 2: GET /mundiales?include=full
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 2: GET /mundiales include==full' 'xh GET :4321/mundiales include==full'
$out2 = xh GET :4321/mundiales include==full
$out2 | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out2)

# -----------------------------------------------------------------------
# PRUEBA 3: GET /mundial/qatar-2022
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 3: GET /mundial/qatar-2022' 'xh GET :4321/mundial/qatar-2022'
$out = xh GET :4321/mundial/qatar-2022
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 4: GET /mundial/inexistente  [esperado 404]
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 4: GET /mundial/inexistente  [esperado 404]' 'xh GET :4321/mundial/inexistente'
$out = xh GET :4321/mundial/inexistente
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 5: GET /campeon/Argentina
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 5: GET /campeon/Argentina' 'xh GET :4321/campeon/Argentina'
$out = xh GET :4321/campeon/Argentina
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 6: GET /random
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 6: GET /random' 'xh GET :4321/random'
$out = xh GET :4321/random
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 7: GET /search/final
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 7: GET /search/final' 'xh GET :4321/search/final'
$out = xh GET :4321/search/final
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 8: GET /search/ab  [esperado 400]
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 8: GET /search/ab  [esperado 400]' 'xh GET :4321/search/ab'
$out = xh GET :4321/search/ab
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 9: GET /imagenes/qatar-2022.avif  [solo cabeceras]
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 9: GET /imagenes/qatar-2022.avif  [solo cabeceras, sin binario]' 'xh --print=h GET :4321/imagenes/qatar-2022.avif'
$out = xh --print=h GET :4321/imagenes/qatar-2022.avif
$out | Out-File -Append -Encoding utf8 $ResultsFile
Register-Status (Get-HttpStatus $out)

# -----------------------------------------------------------------------
# PRUEBA 10: Verificacion imagen JSON vs public/imagenes/
# -----------------------------------------------------------------------
Write-Section 'PRUEBA 10: Verificacion imagenes (JSON vs public/imagenes/)' 'xh --print=b GET :4321/mundiales include==full'

$archivosReales = Get-ChildItem -Path $ImagenesDir -File |
    Where-Object { $_.Extension -ne '.md' } |
    ForEach-Object { $_.Name }

"`nArchivos en public/imagenes/:" | Out-File -Append -Encoding utf8 $ResultsFile
$archivosReales | ForEach-Object { "  - $_" | Out-File -Append -Encoding utf8 $ResultsFile }

# Obtener solo el cuerpo JSON para parsear (llamada separada con --print=b)
$jsonRaw  = xh --print=b GET :4321/mundiales include==full
$jsonFull = $null
try {
    $jsonFull = ($jsonRaw -join "`n") | ConvertFrom-Json
} catch {
    "`nERROR: No se pudo parsear el JSON de /mundiales?include=full" |
        Out-File -Append -Encoding utf8 $ResultsFile
}

if ($null -ne $jsonFull) {
    $camposImagen = @()
    foreach ($item in $jsonFull) {
        if ($null -ne $item.imagen) {
            $camposImagen += [pscustomobject]@{
                Slug    = $item.slug
                Imagen  = $item.imagen
                Archivo = [System.IO.Path]::GetFileName($item.imagen)
            }
        }
    }

    "`nCampo 'imagen' en el JSON:" | Out-File -Append -Encoding utf8 $ResultsFile
    if ($camposImagen.Count -eq 0) {
        "  (ningun elemento tiene campo 'imagen')" | Out-File -Append -Encoding utf8 $ResultsFile
    } else {
        foreach ($ci in $camposImagen) {
            "  slug: $($ci.Slug)  =>  $($ci.Imagen)" | Out-File -Append -Encoding utf8 $ResultsFile
        }
    }

    "`nVerificacion de coincidencias:" | Out-File -Append -Encoding utf8 $ResultsFile
    foreach ($ci in $camposImagen) {
        if ($archivosReales -contains $ci.Archivo) {
            "  [OK]       $($ci.Archivo)  (slug: $($ci.Slug))" | Out-File -Append -Encoding utf8 $ResultsFile
        } else {
            $msg = "  [MISMATCH] '$($ci.Archivo)' referenciado en '$($ci.Slug)' no existe en public/imagenes/"
            $msg | Out-File -Append -Encoding utf8 $ResultsFile
            $imgMismatches += $msg
        }
    }

    $archivosEnJson = $camposImagen | ForEach-Object { $_.Archivo }
    foreach ($archivo in $archivosReales) {
        if ($archivosEnJson -notcontains $archivo) {
            $msg = "  [HUERFANO] '$archivo' existe en public/imagenes/ pero no aparece en el JSON"
            $msg | Out-File -Append -Encoding utf8 $ResultsFile
            $imgMismatches += $msg
        }
    }

    if ($imgMismatches.Count -eq 0) {
        "  Todos los archivos de imagen coinciden correctamente." |
            Out-File -Append -Encoding utf8 $ResultsFile
    }
}

# -----------------------------------------------------------------------
# RESUMEN FINAL
# -----------------------------------------------------------------------
$totalPruebas = $count200 + $count400 + $count404 + $countOther
$imgStatus    = if ($imgMismatches.Count -eq 0) { 'OK (sin mismatches)' } else { "$($imgMismatches.Count) mismatch(es)" }

$resumen = @"

================================================================
  RESUMEN FINAL
================================================================
  Respuestas 200 : $count200
  Respuestas 400 : $count400
  Respuestas 404 : $count404
  Otras          : $countOther
  Total pruebas  : $totalPruebas
  Imagenes       : $imgStatus
================================================================
"@

$resumen | Out-File -Append -Encoding utf8 $ResultsFile
Write-Host $resumen
Write-Host "Resultados guardados en: $ResultsFile"
