# Name         -     RealmRover.ps1
# Description  -     A PowerShell script for streamlined Active Directory enumeration.
# Author       -     rushikeshhh-patil            

param (
    [string]$Option
)

function ShowMenu {
    Write-Host "==================== Menu ====================="
    Write-Host
    Write-Host "Usage: ./RealmRover.ps1 -Option <1, 2, 3, 4, 5, 6>"
    Write-Host "Options:"
    Write-Host "  1. Enumerate all users in domain"
    Write-Host "  2. Enumerate information about a specific user"
    Write-Host "  3. Enumerate all groups in domain"
    Write-Host "  4. Enumerate information about a specific group"
    Write-Host "  5. Enumerate computers in domain"
    Write-Host "  6. Enumerate users with SPNs"
    Write-Host
    Write-Host "==============================================="
}

function EnumerateSPNUsers {
    $usersWithSPNs = ([ADSISearcher]"(&(ObjectClass=user)(servicePrincipalName=*))").FindAll()

    $userSPNList = @()

    $usersWithSPNs | ForEach-Object {
        $user = $_.Properties['sAMAccountName'][0]
        $spns = $_.Properties['servicePrincipalName'] | ForEach-Object {
            $_
        }

        $userSPNList += "$user : $($spns -join ', ')"
    }

    $userSPNList | Out-File -FilePath "user-spn-list.txt" -Append
}

function EnumerateUsers {
    $users = ([ADSISearcher]"ObjectClass=user").FindAll()
    $userList = $users | ForEach-Object {
        $_.Properties['sAMAccountName'][0]
    }
    $userList | Out-File -FilePath "domain-users.txt" -Append
}

function EnumerateGroups {
    $groups = ([ADSISearcher]"(&(ObjectClass=group))").FindAll()
    $groupList = $groups | ForEach-Object {
        $_.Properties['member'] | ForEach-Object {
            $_
        }
    }
    $groupList | Out-File -FilePath "domain-groups.txt" -Append
}

function EnumerateComputers {
    $computers = ([ADSISearcher]"(&(objectCategory=computer))").FindAll()
    $computerList = $computers | ForEach-Object {
        $_.Properties['name'][0]
    }
    $computerList | Out-File -FilePath "domain-computers.txt" -Append
}

function EnumerateSpecificUser {
    param (
        [string]$username
    )

    $user = ([ADSISearcher]"(&(ObjectClass=user)(sAMAccountName=$username))").FindOne()
    $userInfo = $user.Properties

    $userInfo | Out-File -FilePath "$username-info.txt" -Append
}

function EnumerateSpecificGroup {
    param (
        [string]$groupname
    )

    $group = ([ADSISearcher]"(&(ObjectClass=group)(sAMAccountName=$groupname))").FindOne()
    $groupInfo = $group.Properties

    $groupInfo | Out-File -FilePath "$groupname-info.txt" -Append
}

if (-not $Option) {
    ShowMenu
} else {
    switch ($Option) {
        1 {
            EnumerateUsers
            Write-Host "User enumeration complete. Output saved to domain-users.txt" -ForegroundColor Green
            break
        }
        2 {
            $username = Read-Host "Enter the username for specific user enumeration"
            EnumerateSpecificUser -username $username
            Write-Host "Specific user enumeration complete. Output saved to $username-info.txt" -ForegroundColor Green
            break
        }
        3 {
            EnumerateGroups
            Write-Host "Group enumeration complete. Output saved to domain-groups.txt" -ForegroundColor Green
            break
        }
        4 {
            $groupname = Read-Host "Enter the group name for specific group enumeration"
            EnumerateSpecificGroup -groupname $groupname
            Write-Host "Specific group enumeration complete. Output saved to $groupname-info.txt" -ForegroundColor Green
            break
        }
        5 {
            EnumerateComputers
            Write-Host "Computer enumeration complete. Output saved to domain-computers.txt" -ForegroundColor Green
            break
        }
        6 {
            EnumerateSPNUsers
            Write-Host "User SPN enumeration complete. Output saved to user-spn-list.txt" -ForegroundColor Green
            break
        }
        default {
            Write-Host "Invalid option. Please provide a valid option (1, 2, 3, 4, 5, or 6)." -ForegroundColor Red
            ShowMenu
        }
    }
}
