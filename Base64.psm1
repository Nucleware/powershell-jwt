Function Convert-HashtableToJsonBase64 {
    param (
        [Parameter(Mandatory = $True)]
        [hashtable]
        $Hashtable
    )

    $json = $Hashtable | ConvertTo-Json -Compress
    $jsonbase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($json)).Split('=')[0].Replace('+', '-').Replace('/', '_')

    $jsonbase64
}

Function Convert-JsonBase64ToHashtable {
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $JsonBase64
    )

    $JsonBase64 = $JsonBase64 -replace '-', '+' -replace '_', '/'
    switch ($JsonBase64.Length % 4) {
        0 { break }
        2 { $JsonBase64 += '==' }
        3 { $JsonBase64 += '=' }
    }

    $json = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($JsonBase64))
    $hashtable = $json | ConvertFrom-Json -AsHashtable

    $hashtable
}
