#Create New Group

function CreateNewAzureADGroup {
    $new_group_display_name = Read-Host -Prompt 'Enter a cool name to create new group'
    $new_group_description = Read-Host -Prompt 'Enter a description for new group (leave blank and press enter for default description)'

    #If no description provided by user, set default description
    if ($null -eq $new_group_description -or "" -eq $new_group_description) {
        $new_group_description = "MAAD-AF Azure AD Group"
    }

    #Create the group with set parameters
    try {
        Write-Host "`nCreating a new Group ..."
        $new_group = New-AzureADGroup -DisplayName $new_group_display_name -Description $new_group_description -MailEnabled $false -SecurityEnabled $true -ErrorAction Stop
        Start-Sleep -Seconds 10
        Write-Host "`n[Success] Created new group" -ForegroundColor Yellow
        $allow_undo = $true
    }
    catch {
        Write-Host "`n[Error] Failed to create new group" -ForegroundColor Red
    }

    #Undo changes
    if ($allow_undo -eq $true) {
        $user_confirm = Read-Host -Prompt "`nWould you like to undo changes by deleting the new group? (yes/no)"
        if ($user_confirm -notin "No","no","N","n") {
            try {
                $group_details = Get-AzureADGroup -SearchString $new_group_display_name
                $group_id = $group_details.ObjectId
                Remove-AzureADGroup -ObjectId $group_id -ErrorAction Stop
                Write-Host "`n[Success] Deleted new group: $new_group_display_name" -ForegroundColor Yellow
            }
            catch {
                Write-Host "`n[Error] Could not delete new group: $new_group_display_name" -BackgroundColor Red
            }
        }
    }
    Pause
}
    

function CreateNewM365Group{
    [string]$new_group_display_name = Read-Host -Prompt 'Enter a cool name to create new group'

    #Create the group with set parameters
    try {
        Write-Host "`nCreating a new Group ..." -ForegroundColor Gray
        $new_group = New-UnifiedGroup -DisplayName $new_group_display_name -AccessType Public -Confirm:$false -ErrorAction Stop
        Start-Sleep -Seconds 10
        Write-Host "`n[Success] Created new group" -ForegroundColor Yellow
        $allow_undo = $true
    }
    catch {
        Write-Host "`n[Error] Failed to create new group" -ForegroundColor Red
    }

    #Undo changes
    if ($allow_undo -eq $true) {
        try {
            Remove-UnifiedGroup -Identity $new_group_display_name -Force -Confirm:$false -ErrorAction Stop
            Write-Host "`n[Undo Success] Deleted new group: $new_group_display_name" -ForegroundColor Yellow
        }
        catch {
            Write-Host "`n[Undo Error] Failed to delete new group: $new_group_display_name" -BackgroundColor Red
        }
    }
    Pause
}

