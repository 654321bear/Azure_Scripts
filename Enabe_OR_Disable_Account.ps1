# Import the module first
Import-Module AzureAD

#Change to username that is running the script
$username = "USER@COMPANY.com"   #<<----- Change me!!!!!!! ------------------------------->>

# Create credential string
$c = Get-Credential -UserName $username -Message "password"

# You will need to put in your creds
Connect-AzureAD -Credential $c

#--- Enable Account -------
#Set-AzureADUser -ObjectID  <OBJECTID HERE>  -AccountEnabled $true

#--- Disable Account -------
#Set-AzureADUser -ObjectID  <OBJECTID HERE>  -AccountEnabled $false


#--- Enable Multiple Accounts From File -------
#$azurelist = Get-Content C:\temp\disableAzureAccount.txt
#ForEach($account in $azurelist){
#    Set-AzureADUser -ObjectID  $account  -AccountEnabled $true
#}

#--- Disable Multiple Accounts From File -------
#$azurelist = Get-Content C:\temp\disableAzureAccount.txt
#ForEach($account in $azurelist){
#    Set-AzureADUser -ObjectID  $account  -AccountEnabled $false
#}