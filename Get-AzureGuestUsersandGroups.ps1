# Run Powershell as Administrator
# You may need to install the stuff first
# Install-Module -Name AzureAD
# Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
# Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
# [Net.ServicePointManager]::SecurityProtocol
# Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Clear the screen just for fun
clear

# Import the module first
Import-Module AzureAD

#Change to username that is running the script
$username = "user@COMPANY.com"   #<<----- Change me!!!!!!! ------------------------------->>

# Create credential string
$c = Get-Credential -UserName $username -Message "password"

# You will need to put in your creds
Connect-AzureAD -Credential $c

$Contractor = @()
$ContractorGroup = @()
$guest = Get-AzureADUser -Filter "usertype eq 'guest'"
foreach ($person in $guest){
    $gm = Get-AzureADUser -ObjectId $person.UserPrincipalName | Get-AzureADUserMembership 
    $lic = Get-AzureADUserLicenseDetail -ObjectId $person.UserPrincipalName  | Select SkuPartNumber
    $LicTally = ""
    foreach ($license in $lic) {
        $entry = $license.SkuPartNumber + ""
        $LicTally += $entry
    }
    foreach ($G in $gm){

        $Group1 = "" | select accountEnabled,Name,Status,GroupMembership,Licenses,Description,LastLogon,JobTitle,Department,UserPrincipalName
        $Group1.accountEnabled = $person.accountEnabled
        $Group1.Name = $person.DisplayName
        $Group1.Status = $person.UserType
        $group1.LastLogon = $person.RefreshTokensValidFromDateTime
        $Group1.GroupMembership = $G.DisplayName
        $Group1.Description = $G.Description
        $Group1.Department = $person.Department
        $Group1.JobTitle = $person.JobTitle
        $Group1.Licenses = $LicTally
        $Group1.UserPrincipalName = $person.UserPrincipalName
        $ContractorGroup += $Group1
        
    }
    if (!$gm) {
        $Group1 = "" | select accountEnabled,Name,Status,GroupMembership,Licenses,Description,LastLogon,JobTitle,Department,UserPrincipalName
        $Group1.accountEnabled = $person.accountEnabled
        $Group1.Name = $person.DisplayName
        $Group1.Status = $person.UserType
        $group1.LastLogon = $person.RefreshTokensValidFromDateTime
        $Group1.Department = $person.Department
        $Group1.JobTitle = $person.JobTitle
        $Group1.Licenses = $LicTally
        $Group1.UserPrincipalName = $person.UserPrincipalName
        $ContractorGroup += $Group1
        }
}
echo $ContractorGroup | Format-Table -AutoSize
$ContractorGroup | Format-Table -AutoSize | Out-File -Width 512 C:\temp\log.txt
Disconnect-AzureAD
