param (
    [string]$targetUrl,
    [int]$requests = 1000, # Number of requests to send
    [int]$delayMs = 10 # Adjust this value to control request frequency
)

# Loop to generate load
for ($i = 1; $i -le $requests; $i++) {
    try {
        # Send a request to the target URL
        $response = Invoke-WebRequest -Uri $targetUrl -Method GET -TimeoutSec 5
        Write-Output "Request $i : Status - $($response.StatusCode)"
    }
    catch {
        # Handle any errors
        Write-Output "Request $i : Failed - $($_.Exception.Message)"
    }
    
    # Wait before sending the next request
    Start-Sleep -Milliseconds $delayMs
}
