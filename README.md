# RealmRover

RealmRover is a PowerShell script designed for Active Directory enumeration and information gathering. It provides a set of options to retrieve details about users, groups, computers, and users with Service Principal Names (SPNs) within the domain.

## Features

- **User Enumeration**: Enumerate all users in the domain and save the list to `domain-users.txt`.
- **Group Enumeration**: Enumerate all groups in the domain and save the list to `domain-groups.txt`.
- **Computer Enumeration**: Enumerate all computers in the domain and save the list to `domain-computers.txt`.
- **SPN User Enumeration**: Enumerate users with SPNs and save the list to `user-spn-list.txt`.

## Usage
```powershell
.\RealmRover.ps1 -Option <1, 2, 3, 4>
```
## Options:
- 1: Enumerate all users in the Domain.
- 2: Enumerate all groups in Domain.
- 3: Enumerate Domain computers.
- 4: Enumerate users with SPNs.

# Independent Enumeration Commands

If you encounter issues running the script directly on your domain, you can use the following individual commands to manually enumerate your domain. Ensure you have the necessary permissions to query Active Directory.

## Commands

1. **Enumerate All Users:**
   ```powershell
   ([ADSISearcher]"ObjectClass=user").FindAll() | ForEach-Object { $_.Properties['sAMAccountName'][0] }
2. **Enumerate All Groups:**
   ```powershell
   ([ADSISearcher]"(&(ObjectClass=group))").FindAll() | ForEach-Object { $_.Properties['member'] | ForEach-Object { $_ } }
3. **Enumerate All Computers:**
   ```powershell
   ([ADSISearcher]"(&(objectCategory=computer))").FindAll() | ForEach-Object { $_.Properties['name'][0] }
4. **Enumerate Users with SPNs:**
   ```powershell
   ([ADSISearcher]"(&(ObjectClass=user)(servicePrincipalName=*))").FindAll() | ForEach-Object {
    $user = $_.Properties['sAMAccountName'][0]
    $spns = $_.Properties['servicePrincipalName'] | ForEach-Object { $_ }
    "$user : $($spns -join ', ')"
   }

### Note
I am committed to continuously enhancing these commands and the script by incorporating intriguing inbuilt Active Directory (AD) commands. The goal is to provide robust functionality without the need for importing the AD module or Powerview.


   


