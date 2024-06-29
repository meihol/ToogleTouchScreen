# Load the required assembly for MessageBox
Add-Type -AssemblyName System.Windows.Forms

# Function to enable or disable touchscreen based on choice
function Toggle-Touchscreen($choice) {
    $action = if ($choice -eq "Yes") { "Disable-PnpDevice" } else { "Enable-PnpDevice" }
    $device = Get-PnpDevice | Where-Object { $_.FriendlyName -like '*touch screen*' } 
    if ($device) {
        # Apply -Confirm only to the action cmdlet
        $result = &$action -InputObject $device -Confirm:$false  

        # Only show the message if the action was successful
        if ($result.Status -ne $currentStatus) {
            $statusMessage = if ($choice -eq "Yes") { "disabled" } else { "enabled" }
            [System.Windows.Forms.MessageBox]::Show("Touchscreen $statusMessage.", 'Touchscreen Toggle')
        }
    }
}

# Get current state of the touchscreen
$currentStatus = (Get-PnpDevice | Where-Object { $_.FriendlyName -like '*touch screen*' }).Status
$message = if ($currentStatus -eq 'OK') { 
    "Touchscreen is currently enabled. Do you want to disable it?" 
} else { 
    "Touchscreen is currently disabled. Do you want to enable it?" 
}

# Prompt user with message box with Yes/No buttons
$result = [System.Windows.Forms.MessageBox]::Show($message, 'Touchscreen Toggle', [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)

# Check user's choice and call the function
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    # Determine the action based on the current status (toggle)
    $action = if ($currentStatus -eq 'OK') { "Yes" } else { "No" } 
    Toggle-Touchscreen($action)
} 
