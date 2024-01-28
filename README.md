# RealmRover

RealmRover is a PowerShell script designed for Active Directory enumeration and information gathering. It provides a set of options to retrieve details about users, groups, computers, and users with Service Principal Names (SPNs) within the domain.

## Features

- **User Enumeration**: Enumerate all users in the domain and save the list to `domain-users.txt`.
- **Specific User Enumeration**: Enumerate information about specific user and save the output to `username-info.txt`
- **Group Enumeration**: Enumerate all groups in the domain and save the list to `domain-groups.txt`.
- **Specific Group Enumeration**: Enumerate information about specific group and save the output to `groupname-info.txt`
- **Computer Enumeration**: Enumerate all computers in the domain and save the list to `domain-computers.txt`.
- **SPN User Enumeration**: Enumerate users with SPNs and save the list to `user-spn-list.txt`.

## Usage
```powershell
.\RealmRover.ps1 -Option <1, 2, 3, 4, 5, 6>
```
## Options:
- 1: Enumerate all users in the Domain.
- 2: Enumerate information about a specific user
- 3: Enumerate all groups in Domain.
- 4: Enumerate information about a specific group
- 5: Enumerate Domain computers.
- 6: Enumerate users with SPNs.

# Independent Enumeration Commands

If you encounter issues running the script directly on your domain, you can use the following individual commands to manually enumerate your domain. Ensure you have the necessary permissions to query Active Directory.

## Commands

1. **Enumerate All Users:**
   ```powershell
   ([ADSISearcher]"ObjectClass=user").FindAll() | ForEach-Object { $_.Properties['sAMAccountName'][0] }
2. **Enumerate Info About Specific User**
   ```powershell
   ([ADSISearcher]"(&(objectClass=user)(samAccountName=username))").FindOne().Properties
3. **Enumerate All Groups:**
   ```powershell
   ([ADSISearcher]"(&(ObjectClass=group))").FindAll() | ForEach-Object { $_.Properties['member'] | ForEach-Object { $_ } }
4. **Enumerate Info About Specific Group**
   ```powershell
   ([ADSISearcher]"(&(objectClass=group)(samAccountName=groupname))").FindOne().Properties
5. **Enumerate All Computers:**
   ```powershell
   ([ADSISearcher]"(&(objectCategory=computer))").FindAll() | ForEach-Object { $_.Properties['name'][0] }
6. **Enumerate Users with SPNs:**
   ```powershell
   ([ADSISearcher]"(&(ObjectClass=user)(servicePrincipalName=*))").FindAll() | ForEach-Object {
    $user = $_.Properties['sAMAccountName'][0]
    $spns = $_.Properties['servicePrincipalName'] | ForEach-Object { $_ }
    "$user : $($spns -join ', ')"
   }

### Note
I am committed to continuously enhancing these commands and the script by incorporating intriguing inbuilt Active Directory (AD) commands. The goal is to provide robust functionality without the need for importing the AD module or Powerview.


   


