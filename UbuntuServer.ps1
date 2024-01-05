# Builds a virtualbox environment for a server install.

$vmname = "CentOS8" # Update Name
$installpath = "C:\Users\$($env:USERNAME)\$vmname\$vmname"
$path = "C:\Program Files\Oracle\VirtualBox\"

# Create Lab VM Container
& "$path\VBoxManage.exe" createvm --name $vmname --ostype "RedHat_64" --register --basefolder "D:\Labwork"

# Set System specifications
& "$path\VBoxManage.exe" modifyvm $vmname --memory 4096 --cpus 2 --ostype "RedHat_64" --clipboard bidirectional

# Build storage controller
& "$path\VBoxManage.exe" storagectl $vmname --bootable on --name sata --add sata --bootable on --controller IntelAHCI --portcount 2 

# Create storage medium
& "$path\VBoxManage.exe" createmedium disk --filename "$installpath.vdi" --size 50000 --format VDI --variant Standard

# Attach VDI File
& "$path\VBoxManage.exe" storageattach $vmname --storagectl sata --port 0 --type hdd --medium "$installpath.vdi"

# Link Shared File
& "$path\VBoxManage.exe" sharedfolder add $vmname --hostpath="D:\CodeLab" --readonly --automount --name="Toolkit"

# Unattended Install
& "$path\VBoxManage.exe" unattended install $vmname --user=root --password=root --country=US --time-zone=MST --iso="D:\ISO\ubuntu.-22.04.2-live-server-amd64.iso" --install-additions

# Launch Virtual Machine
& $path\VBoxManage.exe startvm $vmname