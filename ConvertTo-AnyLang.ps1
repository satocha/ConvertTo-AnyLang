function ConvertTo-URIEncode([Parameter(Mandatory,ValueFromPipeline)]$text){
    [uri]::EscapeDataString($text)
}
function ConvertFrom-URIEncode([Parameter(Mandatory,ValueFromPipeline)]$text){
    [uri]::UnescapeDataString($text)
}

function ConvertTo-AnyLang {
    param (
        [Parameter(Mandatory,Position =0, ValueFromPipeline)][string[]]$texts,
        [ValidateScript({ ( ( "ja en zh ko es fr de it ru pt" -split " " ) -contains $_ ) })]
        [string]$destLang = "ja"
    )
    $url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$destLang&dt=t&q="
    foreach ($text in $texts) {
        if (!$text.trim()) { CONTINUE }
        $FromStr = ConvertTo-URIEncode $text
        try {
            $jsonRAW = (Invoke-WebRequest "$url$FromStr").Content #-ErrorAction SilentlyContinue
            $json = $jsonRAW|ConvertFrom-Json
            $ToStr = $json[0][0][0]
        }catch{}
        sleep -m 400
        if (!$ToStr.trim()){
            $ToStr = $FromStr
        }
        $ToStr
    } 
}
Set-Alias -Name translate -Value ConvertTo-AnyLang
