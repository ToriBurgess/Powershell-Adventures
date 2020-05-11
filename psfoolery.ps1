<#IMPORTANT TO NOTE!!!

root\CIMv2 is the namespace.
Think of CIMv2 as just a subdirectory off of the root.
The rest of what you find under CIMv2, such as Win32_TSGeneralSetting, Win32_ComputerSystem, etc. are called 'Classes' in WMI terminology.

Nearly all of the useful classes in WMI are in the CIMv2 namespace, which is a good thing, as it makes scripting easier.
#>

#====================================================
#====================================================

# NEAT COMMENT THING
<#
.SYNOPSIS
.DESCRIPTION
.NOTES
.EXAMPLE
.PARAMETER IDK
#>

#==========================================================
#==========================================================
<#
****OUTPUT CODES*****
.DESCRIPTION
Stream 1 (default): regular output ("STDOUT")
Stream 2: error messages ("STDERR"), including error messages from external programs
Stream 3: warning messages
Stream 4: verbose messages
Stream 5: debug messages
#>

#==========================================================
#==========================================================

#REGION - RANDOM STUFF??

# GET SYSTEM INFO (Name,Model,Domain)
Get-WmiObject -Class win32_computersystem -Property *

# GET BIOS INFO (+ filter SerialNumber)
get-WmiObject win32_bios | fl SerialNumber
# encapuslate serialnumber BIYAAAA
#$ser = Get-WmiObject win32_bios | Select-Object serialnumber | ForEach-Object -PipelineVariable ser -Process {$_} | ForEach-Object{$ser.serialnumber}
$ser = Get-WmiObject win32_bios | ForEach-Object -PipelineVariable ser -Process {$_.serialnumber}

# GET & REMOVE MS APPS
Get-AppxPackage *3dbuilder* | Remove-AppxPackage

#*****test this*******
New-Object DateTime(2008, 11, 18, 1, 40, 02)

# DATE FORMAT VERIFIER....?
if ( ([datetime]"6/22/2019") -gt (get-date)) {write-host "This is later than today."} else {Write-Host "This earlier than today"}

# weird time elapse counter...?
$inputPC = ""
$starttime = (get-date)
while ((ping $inputPC)) {$counter = ((get-date) - $starttime).minutes,((get-date) - $starttime).seconds; "This has lasted {0} minutes and {1} seconds since `$starttime was first initialized..." -f $counter[0,1]


## set shortcut
$targetfile = "C:\Program Files (x86)\Windows Resource Kits\Tools\lockoutstatus.exe"
$destshortcut = "$env:userprofile\Desktop\lockoutstatus.lnk"
$ws = New-Object -ComObject WScript.Shell;
$s = $ws.CreateShortcut($destshortcut);
$S.TargetPath = $targetfile; $S.Save()


## map to networked/remote drive
New-PSDrive -Name "V" -PSProvider "FileSystem" -Root "\\Ae1ItWCtxVdi003\c$\temp" -Credential(Get-Credential) -Persist:$false;
#do stuff
Remove-PSDrive -name V
### OORRRR
## soft-map to networked/remote drive (nonpersistent)
Set-Location "\\Ae1ItWCtxVdi003\c$\temp"
#do stuff
Pop-Location
## or
pushd "\\Ae1ItWCtxVdi003\c$\temp"
#do stuff
popd


### lazy search cuz I'm lazy
Function lazyls {
    $filename = read-host -prompt "name of file you're looking for"
    $rootpath = read-host -prompt "top level path to start searching? (pls use literal path e.g. 'C:\Users')"
    gci -Recurse -path $rootpath -ea 0 | ?{$_.fullname -like "*$filename*"} | select -ExpandProperty fullname | sort
    } #lazyls



#ENDREGION

#==========================================================
#==========================================================

#REGION - CONNECT TO & CREATE FILE IN NETWORK PATH

$dir = "\\3wp88h2\c$"
net use $dir
test-path \\3wp88h2\c$
dir '\\3wp88h2\c$\temp\'
new-item '\\3wp88h2\c$\temp\' -ItemType File -name 'win_produ_apply.txt'

#ENDREGION

#==========================================================
#==========================================================

#REGION - STR CHARA COUNT + TRIM STRINGS

$test = 'https://google.com'
$test | measure-object -character

$test.length #does same as measure-object... (inherently)


# TRIMMING STR OUTPUTS BY CHARA (maybe pass into array?)

<# TEST
.EXAMPLE OUTPUT
i
am
a
string
#>
$test = "i am a string"
$test.Split(' ') #<SPACE> is the delimiter



# STRSPLIT LETTERS "MAK" FROM CONTENTS OF TXT FILE
$test = cat \\ncfs02\appdeploy\win_10_ent.txt
$test.Length
$test[2]
$test[0]
$str = "a String a `t eh"
$str1 = $str.trimend("e", " ")
$str = "a String a `t e"
$str1 = $str.trimend("e", " ")
$str1 = $str.trimend("e", "h")
$str = "a String a `t eh"
$str1 = $str.trimend("e", "h")
$str = "a String a `t ehh"
$str1 = $str.trimend("e", "h")
$str = "a String a `t ehk"
$str1 = $str.trimend("e", "h", "k")
$burp = "m","a","k"
$ser = $test[2].trimstart($burp)
$burp = "M","A","K"
$ser = $test[2].trimstart($burp)
$burp = "M","A","K","-"," "
$ser = $test[2].trimstart($burp)


#ENDREGION

#====================================================
#====================================================


#REGION - REVERSE STRING IN A VARIABLE
$b = "Powershell" #declare var
$c = $b.tochararray() #call ToCharArray method to split string into array of single characters
[array]::Reverse($c) #specify array & call reverse procedure using var as
$c = -join($c)

# EZ MODE
"Powershell" | %{ -join $_[$_.Length..0] }

# ENDREGION

# REGION - ITERATE THROUGH JAGGED ARRAYS AND HASH TABLES

# THIS CAN BE CLEANED UP - ***copied mess for continuity in array length....***
$test = @("this","is","a","test")
$test += @("not sure what i'm doing","ehn")
$test2 = @("what","am","i","trying","to","accomplish")
$test3 = @{chi="even";ba="wat";ha="lel"}
$array = $test,$test2
$array += $test
$array += $test3
# $array = $test,$test2,$test3

# ITERATE THROUGH THE ENTIRE SET (of arrays in $array) - MAKE SURE TO NEST THE NEXT FOR LOOP IN THE INITIAL FOR LOOP STATEMENT
# THIS ONLY WORKS FOR ARRAYS! NOT HASH TABLES!!!!
# can also use ($i -lt $array.length instead)
for ($i = 0; $i -le $array.length-1; $i++) {
    for ($n = 0; $n -le $array[$i].length-1; $n++) {
        "`$array[{0}][{1}] = {2}" -f $i,$n,$array[$i][$n]
    }
}

# ITERATE THROUGH HASH TABLE IN THE SET - KEYS WILL GRAB ALL KEYS/HASH NAME, $array[$i].item($_) WRITES OUT THE VALUE INDIVIDUALLY IN THE LOOP
# SPECIFICALLY FOR HASH TABLES!! NOT NECESSARILY ARRAYS...
$array[8].keys | ForEach-Object{Write-Output "`$array[8] has" $array[8].item($_)} #writes '$array[$i] has' on separate line from returned key value
$array[8].keys | ForEach-Object{"`$array[8] has " + '"' + $array[8].item($_) + '"'} #writes each statement on one line

# RETURN EACH KEY & VALUE IN SINGLE LINE******
$array[8].keys | ForEach-Object{"`$array[8] has '$_ " + '=> '  + $array[8].item($_) + "'"}


### SO SIMPLE!!!!!
### SIMULTANEOUSLY ITERATE THROUGH 2+ ARRAYS OF THE SAME LENGTH
$test1 = "one","two","three","four"
$test2 = "1","2","3","4"
for ($i=0; $i -lt ($test1).count-1; $i++) {
Write-Host $test1[$i]':' $test2[$i];
}


#ENDREGION

#====================================================
#====================================================

#REGION - LIST INDEX OF VALUE IN AN ARRAY (PS SCRIPTING GUY)

<#
.SYNOPSIS
Use the FOR statement to list index values in an array
.DESCRIPTION
Now, I use a for statement with a pipeline that begins at zero, a test pipeline that continues until i is 1 less than the length of the array, and an increment pipeline that increases the value of i by 1. Here is the for condition.
.EXAMPLE
for($i=0;$i-le $array.length-1;$i++)

The script block that is associated with the for statement uses *parameter substitution** and the **format operator** to display the counter ($i) value and the value that is contained in the specific array element. Here is the script block portion of the for statement.
.EXAMPLE
{"`$array[{0}] = {1}" -f $i,$array[$i]}
.NOTES
https://blogs.technet.microsoft.com/heyscriptingguy/2011/12/07/find-the-index-number-of-a-value-in-a-powershell-array/
#>

for($i=0;$i-le $array.length-1;$i++) {
    "`$array[{0}] = {1}" -f $i,$array[$i]
}

#ENDREGION

#====================================================
#====================================================


#REGION - RETRIEVE INPUT FROM SHELL AND CONSOLE-WRITE OUTPUT

Function TestInNOut {
$word = Read-Host "Enter a word"
if ([string]::IsNullorWhiteSpace($word)){
	Write-Host "UNSABLE! Please enter something!!";
	TestInNOut} Else{
Write-Host "You said" $word"!"
    }

#$UserCheck = Get-ADUser $word
<#
if ($UserCheck -eq $null){
	Write-Host "Invalid word, please verify this is the logon id for the account"
	TestInNOut}
#>

TestInNOut


#ENDREGION

#====================================================
#====================================================

#REGION - RANDOM STUFF IDK WHERE TO PUT

# computer mgmt console
%windir%\system32\compmgmt.msc /s

# map drives/folders
New-PSDrive -Name "P" -PSProvider "FileSystem" -Root "\\Server01\Public"
New-PSDrive -Name "S" -Root "\\Server01\Scripts" -Persist -PSProvider "FileSystem"


#ENDREGION

#====================================================
#====================================================

#REGION - ADD-EDIT-REMOVE REGISTRY KEYS AND VALUES

# FIND A KEY IN REGISTRY FOR HKLM and HKCU HIVES:
<# hive shortnames
HKEY_LOCAL_MACHINE or HKLM
HKEY_CURRENT_CONFIG or HKCC
HKEY_CLASSES_ROOT or HKCR
HKEY_CURRENT_USER or HKCU
HKEY_USERS or HKU
USE -DEPTH PARAMATER TO LIMIT RECURSION :OOO
#>

# DON'T USE RECURSION ON A HIVE!!!..??? causes stack overflow
# ****NOOOOOO*****!!! IT WORKS - USE -DEPTH PARAMATER TO LIMIT RECURSION :OOO
dir hklm:*adobe*,hkcu:*adobe* -rec -ea 0

# OR - IGNORE ACCESS DENIED ERROR - or is "-ea 0" the same...
ls hklm:*key* -ErrorAction:SilentlyContinue

# TEST REGISTRY KEY VALUE

test-path HKLM:\SOFTWARE\Fortinet
(Get-ItemProperty -path HKLM:\SOFTWARE\Fortinet).version
(Get-ItemProperty -path HKLM:\SOFTWARE\Fortinet -name version).version


# CHECK FOR & REMOVE REGISTRY KEY

Push-Location (pushd) #store current directory location
Set-Location (sl) HKLM:\Software
Test-Path fortinet
#dir *adobe* -rec -ea 0
remove-Item fortinet -whatif
remove-Item fortinet
Set-Location HKLM:\Software\WOW6432Node
Test-Path fortinet
Remove-Item fortinet -whatif
Remove-Item fortinet
Pop-Location (popd) #return to original directory location


# ALT
Get-ChildItem -path HKLM:\SOFTWARE\ -Recurse |
    where { $_.Name -match 'Cisco' -or $_.Name -match 'Anyconnect'} |
        Remove-Item -Force;




#ENDREGION

#====================================================
#====================================================

#REGION - Install NET-Framework-Core (.NET 2.5, .NET 3.0, .NET 3.5)
# $dotNet35State = (Get-WindowsFeature NET-Framework-Core).InstallState # Servers
$dotNet35State = (Get-WindowsFeature NET-Framework-Core).InstallState
If ($dotNet35State -eq 'Removed')
{
    Write-Output "$(Get-Date -UFormat "%Y%m%d %T") - Starting installation of dotNet 2.0, dotNet 3.0, and dotNot 3.5"
    Install-WindowsFeature NET-Framework-Core -Source \\ncfs02\ISO_Repository\Win2012r2\sxs
    Write-Output "$(Get-Date -UFormat "%Y%m%d %T") - dotNet 2.0, dotNet 3.0, and dotNot 3.5 have been successfully installed"
}
#endregion

#REGION - INSTALL WINDOWS THINGS/FEATURES IN WINDOWS


# RUN WINDOWS SETUP/UPGRADE INSTALL FILE - TEST FOR OTHER SETUP PACKAGES (CMD)
setup.exe /auto upgrade /showoobe none /silent

# INSTALL FEATURES
Get-WindowsOptionalFeature -Online
<#
Microsoft-Windows-NetFx3-OC-Package
Microsoft-Windows-NetFx4-US-OC-Package
Microsoft-Windows-NetFx3-WCF-OC-Package
Microsoft-Windows-NetFx4-WCF-US-OC-Package
#>
Enable-WindowsOptionalFeature

# Particular Windows features
Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Get-WindowsCapability -Online -Name RSAT.* | Add-WindowsCapability -Online

mount-diskimage "\\ncfs02\iso_repository\ea\SW_DVD9_WIN_ENT_10_1703.1_64BIT_English_MLF_X21-47750.iso"
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:[ISOVOL]:\sources\sxs




#ENDREGION

#REGION - SEARCH FOR UPDATES/SOFTWARE

# GET WINDOWS UPDATES???
# (from: https://community.spiceworks.com/how_to/139222-how-to-list-all-windows-updates-using-powershell)

$Session = New-Object -ComObject "Microsoft.Update.Session";
$Searcher = $Session.CreateUpdateSearcher();
$historyCount = $Searcher.GetTotalHistoryCount();
$Searcher.QueryHistory(0, $historyCount) | Select-Object Date,@{name="Operation"; expression={switch($_.operation){1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}}, @{name="Status"; expression={switch($_.resultcode){1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};4 {"Failed"}; 5 {"Aborted"} }}}, Title, Description | Export-Csv -NoType "$Env:userprofile\Desktop\Windows Updates.csv"


## GET INSTALLED UPDATES; WORK ON *********
Get-Hotfix | sort installedon[-1] | ft -wrap

## GET INSTALLED SOFTWARE
get-wmiobject win32_product | sort name | ft -wrap
## GET SPECIFIED SOFTWARE + UNINSTALL
Get-CimInstance -ClassName Win32_Product -Filter "name like 'Exclaimer Outlook Signature Update Agent'" | Invoke-CimMethod -MethodName Uninstall



#ENDREGION

#REGION - SCRIPTS FOR INSTALLING WIN APPS FROM WEB??
# FROM: https://www.reddit.com/r/PowerShell/comments/9pcu1f/anyone_have_move_in_scripts/
# WGET BRUH!!!


# Sublime Text 3
$HTML = wget https://www.sublimetext.com/3
$HREF = ($HTML.Links |? {$_.innerText -eq "Windows 64 bit"}).href
$EXE = $HREF.Split('/')[-1]
wget $HREF -OutFile $EXE
& .\$EXE /SP-

#7-xip ul


# CHROME (TEST)
$html = wget https://www.google.com/chrome/
$href = $html.links | ?{$_.innertext -like "*Windows*"}
ls c:\temp | ?{$_.psiscontainer -eq $true}
cd C:\temp\winderp\
$href = $html.links | ?{$_.innertext -like "*Windows 10*" -and $_.innertext -like "*64*"}
# NG - HREF RETURNS "#" :(...


#REGION - File Explorer advanced settings
#FROM: https://www.reddit.com/r/PowerShell/comments/9pcu1f/anyone_have_move_in_scripts/
$sid = (Get-CimInstance Win32_UserProfile |? {$_.LocalPath -like "*$installUser"}).SID
New-PSDrive HKU -PSProvider Registry -Root HKEY_USERS
cd HKU:\$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\
Set-ItemProperty -Path . -Name Hidden                   -Value 1
Set-ItemProperty -Path . -Name HideDrivesWithNoMedia    -Value 0
Set-ItemProperty -Path . -Name HideFileExt              -Value 0
Set-ItemProperty -Path . -Name SeparateProcess          -Value 0
Set-ItemProperty -Path . -Name SharingWizardOn          -Value 0
& $installDrive
#ENDREGION

switch
#REGION - DISABLE CORTANA
#FROM: https://www.reddit.com/r/PowerShell/comments/9pcu1f/anyone_have_move_in_scripts/
Function DisableCortana {
    Write-Output "Disabling Cortana..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
}


#DISABLE PEOPLE BAR ON TASKBAR
<#
HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer

HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer

HidePeopleBar DWORD

(delete) = Enable
1 = Disable
#>

#ENDREGION


#================================
#================================

#REGION DISM REPAIR


test-path \\ncfs02\ISO_Repository
net use \\ncfs02\ISO_Repository
mount-diskimage -ImagePath "\\ncfs02\ISO_Repository\EA\SW_DVD9_WIN_ENT_10_1703.1_64BIT_English_MLF_X21-47750.ISO"
get-volume
explorer \\ncfs02\ISO_Repository\EA\

dism /online /cleanup-image /restorehealth /source:WIM:G:\Sources\Install.wim:1 /limitaccess
dism /online /cleanup-image /restorehealth /source:WIM:G:\Sources\

get-volume
ls G:\sources\

dism /online /cleanup-image /restorehealth /source:WIM:"G:\Sources\install.wim"
dism /online /cleanup-image /restorehealth /source:WIM:G:\Sources\install.wim

Get-WindowsImage -ImagePath G:\sources\install.wim
dism /online /cleanup-image /restorehealth /source:WIM:G:\Sources\install.wim:1

C:\WINDOWS\Logs\DISM\dism.log
C:\WINDOWS\Logs\CBS\cbs.log

#ENDREGION

#====================================================
#====================================================

#REGION - POWERSHELL HISTORY


<# F8 => Search your command history for a command matching the text on the current command line.

**DO THIS!!!** Search your history by PIPING THE RESULTING OUTPUT to SELECT-STRING cmdlet & specify text to search for.
USE CTRL + R for a similar search filter (works in Linux too!)#>
Get-History |  Select-String -Pattern "Example"


#To view a more detailed command history that displays the execution status of each command along with its start and end times, run the following command:
Get-History | Format-List -Property *

#To run a command from your history, use the following cmdlet, specifying the Id number of the history item as shown by the Get-History cmdlet:
Invoke-History #numbercmldet

#ENDREGION

#====================================================
#====================================================


#====================================================
#====================================================


# KEEP-ALIVE

$sleepytime = 60; $key = '^';
While (1) {
    start-sleep -seconds $sleepytime
    $obj = New-Object -COM WScript.Shell
    $obj.SendKeys($key)
    Write-Host "Sending invisi-keys"
}



