#!/bin/sh
set -eu

# ___                   __                                                               
#/\_ \                 /\ \__  __                                  __                    
#\//\ \     ___     ___\ \ ,_\/\_\    ___   __  __    __      ____/\_\    ___     ___    
#  \ \ \   / __`\  /',__\ \ \/\/\ \ /' _ `\/\ \/\ \ /'__`\   /',__\/\ \  / __`\ /' _ `\  
#   \_\ \_/\ \L\ \/\__, `\ \ \_\ \ \/\ \/\ \ \ \_/ /\ \L\.\_/\__, `\ \ \/\ \L\ \/\ \/\ \ 
#   /\____\ \____/\/\____/\ \__\\ \_\ \_\ \_\ \___/\ \__/.\_\/\____/\ \_\ \____/\ \_\ \_\
#   \/____/\/___/  \/___/  \/__/ \/_/\/_/\/_/\/__/  \/__/\/_/\/___/  \/_/\/___/  \/_/\/_/

# ⚙️ set deployment-specific variables below:
# 📥 use a direct download URL for the installer (e.g. azure blob storage)
# 📦 ensure the package filename matches your actual .pkg file
 
downloadLink="https://yourserver/path/to/anyconnect.pkg"
pkgName="anyconnect.pkg"
companyName="company"
vpnHostname="vpn.domain.com"
profilePath="/opt/cisco/secureclient/vpn/profile/${companyName}-default.xml"

#check-installed
if [ -x "/opt/cisco/secureclient/bin/vpn" ]; then
    version=$(/opt/cisco/secureclient/bin/vpn --version 2>/dev/null | head -n 1)
    echo "✅ Cisco Secure Client already installed."
    echo "📦 Version: $version"
    exit 0
else

#create-xml-choices
cat > /tmp/vpn_install_choice.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
    <!-- Install AnyConnect VPN -->
    <dict>
        <key>attributeSetting</key>
        <integer>1</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_anyconnect_vpn</string>
    </dict>
    
    <!-- Exclude all other modules -->
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_fireamp</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_dart</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_secure_firewall_posture</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_iseposture</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_nvm</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_secure_umbrella</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_thousandeyes</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_duo</string>
    </dict>
    <dict>
        <key>attributeSetting</key>
        <integer>0</integer>
        <key>choiceAttribute</key>
        <string>selected</string>
        <key>choiceIdentifier</key>
        <string>choice_zta</string>
    </dict>
</array>
</plist>
EOF

#download-pkg
curl -L -o /tmp/$pkgName $downloadLink

#install-pkg
/usr/sbin/installer -pkg /tmp/$pkgName -applyChoiceChangesXML /tmp/vpn_install_choice.xml -target /

#add-profile
cat > /opt/cisco/secureclient/vpn/profile/$companyName-default.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.xmlsoap.org/encoding/ AnyConnectProfile.xsd">
    <ServerList>
        <HostEntry>
            <HostName>$companyName</HostName>
            <HostAddress>$vpnHostname</HostAddress>
        </HostEntry>
    </ServerList>
</AnyConnectProfile>
EOF

#confirmation
echo "✅ Cisco Secure Client (VPN module) installed successfully."

if [ -x "/opt/cisco/secureclient/bin/vpn" ]; then
  version=$(/opt/cisco/secureclient/bin/vpn --version 2>/dev/null | head -n 1)
  echo "📦 Version: $version"
else
  echo "⚠️ Could not determine version. Binary not found."
fi

echo "📂 Installed at: /Applications/Cisco/"
echo "📄 VPN profile created at: /opt/cisco/secureclient/vpn/profile/$companyName-default.xml"

#cleanup
rm -f /tmp/$pkgName /tmp/vpn_install_choice.xml
fi