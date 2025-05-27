If you use a Cisco Meraki MX Firewall, Cisco restricts access to individual pkg files. The pre-deploy package available for download on the MX Dashboard bundles all Cisco Secure Client packages into one `.pkg` file. In many cases, only the core VPN is needed.

This script creates a temporary `choices.xml` file on the client used during installation to only install the needed packages (in this case, only the core VPN module).
## Profile deployment

This script also creates a default profile at `/opt/cisco/secureclient/vpn/profile/$companyName-default.xml`, so you can pre-deploy the connection URL to your users.

> **Note:** If you use the "Profile Update" setting in Meraki MX to push Secure Client configurations, an additional profile will be created when users connect to the VPN for the first time.

## ⚙️ Intune Deployment Properties

- **Name:** [Software] Cisco Secure Client Install
- **Run script as signed-in user:** No
- **Hide script notifications on devices:** Not configured
- **Script frequency:** Not configured
- **Max number of retries if script fails:** 3

## 📖 Intune Silent Installation

For Intune deployment, you need to configure a configuration profile that allows the necessary system extensions, notifications, and network filters for the client. Without this, the first run after installation will require manual approval by the user (who must be a local admin).

will be adding the configuration profile for deployment with intune to the repo soon. 
