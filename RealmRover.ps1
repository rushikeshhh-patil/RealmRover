# Name         -     RealmRover.ps1
# Description  -     A PowerShell script for streamlined Active Directory enumeration.
# Author       -     rushikeshhh-patil            

param (
    [string]$Option
)

function ShowMenu {
    Write-Host "==================== Menu ====================="
    Write-Host
    Write-Host "Usage: ./RealmRover.ps1 -Option <1, 2, 3, 4>"
    Write-Host "Options:"
    Write-Host "  1. Enumerate all users in domain"
    Write-Host "  2. Enumerate all groups in domain"
    Write-Host "  3. Enumerate computers in domain"
    Write-Host "  4. Enumerate users with SPNs"
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
            EnumerateGroups
            Write-Host "Group enumeration complete. Output saved to domain-groups.txt" -ForegroundColor Green
            break
        }
        3 {
            EnumerateComputers
            Write-Host "Computer enumeration complete. Output saved to domain-computers.txt" -ForegroundColor Green
            break
        }
        4 {
            EnumerateSPNUsers
            Write-Host "User SPN enumeration complete. Output saved to user-spn-list.txt" -ForegroundColor Green
            break
        }
        default {
            Write-Host "Invalid option. Please provide a valid option (1, 2, 3, or 4)." -ForegroundColor Red
            ShowMenu
        }
    }
}
