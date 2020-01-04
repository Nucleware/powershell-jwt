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
