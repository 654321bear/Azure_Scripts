#Function for Colored Text
Function Set-Message([string]$Text,[string]$ForegroundColor="White"){

    Write-Host $Text -ForegroundColor $ForegroundColor 
    #Accepred Values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White
}

$c = Get-Credential -UserName "USER@COMPANY.com" -Message "password"

##Run Powershell as Administrator
#Install-Module -Name AzureAD
Import-Module AzureAD

###You will need to put in your creds
Connect-AzureAD -Credential $c

##Run Commands
#Get-AzureADUser > C:\Users\user\Desktop\az.txt
$Contractor = @()
$guest = Get-AzureADUser -Filter "usertype eq 'member'"
foreach ($person in $guest){
    $dummy = "" | select accountEnabled,DisplayName,UserPrincipalName,Licenses,UserType,Department,RefreshTokensValidFromDateTime,JobTitle
    $dummy.accountEnabled = $person.accountEnabled
    $dummy.DisplayName = $person.DisplayName
    $dummy.UserPrincipalName = $person.UserPrincipalName
    $dummy.UserType = $person.UserType
    $dummy.Department = $person.Department
    $dummy.Licenses = $person.AssignedPlans
    $dummy.RefreshTokensValidFromDateTime = $person.RefreshTokensValidFromDateTime
    $dummy.JobTitle = $person.JobTitle
    $Contractor += $dummy
}
echo $Contractor | Format-Table -AutoSize
$data += $Contractor
$data | Export-Csv C:\temp\Guest.csv -NoTypeInformation -UseCulture

#Pause script to let the report finish being generated
Start-Sleep -s 5 

#--------------------------------------------------------EMAIL REPORT SECTION------------------------------------------------------------
#Create attachments
$Guest_att = new-object Net.Mail.Attachment("C:\temp\Guest.csv")
$Report = 1
#Generate email and add attachments
	IF ($Report -ne ""){
	$SmtpClient = New-Object system.net.mail.smtpClient
	$SmtpClient.host = "alerts.COMPANY.com"   #Change to a SMTP server in your environment
    $SmtpClient.port = "25"
	$MailMessage = New-Object system.net.mail.mailmessage
	$MailMessage.from = "Azure.Automation@COMPANY.com"   #Change to email address you want emails to be coming from
	$MailMessage.To.add("USER@COMPANY.com")	#Change to email address you would like to receive emails.
	$MailMessage.IsBodyHtml = 1
	$MailMessage.Subject = "Azure Guest Accounts"
	$MailMessage.Body = $data.ToString()
    $MailMessage.Attachments.Add($Guest_att)
	#$SmtpClient.Send($MailMessage)
}

$Guest_att.Dispose()
Remove-Item c:\temp\Guest.csv

echo "Done with Email"
Disconnect-AzureAD
