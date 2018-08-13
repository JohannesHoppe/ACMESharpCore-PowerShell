function New-Nonce {
    <#
        .SYNOPSIS
            Gets a new nonce.

        .DESCRIPTION
            Issues a web request to receive a new nonce from the service directory


        .PARAMETER State
            The nonce will be written into the provided state instance.

        .PARAMETER PassThrough
            If set, the nonce will be returned to the pipeline.


        .EXAMPLE
            PS> New-Nonce -Uri "https://acme-staging-v02.api.letsencrypt.org/acme/new-nonce"
    #>
    [CmdletBinding()]
    [OutputType("AcmeNonce")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [ValidateScript({$_.Validate("ServiceDirectory")})]
        [AcmeState]
        $State,

        [Parameter()]
        [switch]
        $PassThrough
    )

    $Url = $State.ServiceDirectory.NewNonce;

    $response = Invoke-AcmeWebRequest $Url -Method Head
    $nonce = [AcmeNonce]::new($response.NextNonce);

    $State.Nonce = $nonce;

    if($PassThrough) {
        return $nonce;
    }
}