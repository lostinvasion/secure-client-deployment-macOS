If you use a Cisco Meraki MX Firewall, Cisco restricts access to individual `.pkg` installers. The pre-deploy package available for download on the MX dashboard bundles all Cisco Secure Client modules into a single `.pkg` file:

- ✅ Core VPN (`choice_anyconnect_vpn`)
- ❌ FireAMP (`choice_fireamp`)
- ❌ DART (`choice_dart`)
- ❌ Secure Firewall Posture (`choice_secure_firewall_posture`)
- ❌ ISE Posture (`choice_iseposture`)
- ❌ Network Visibility Module (NVM) (`choice_nvm`)
- ❌ Umbrella Roaming Security Module (`choice_secure_umbrella`)
- ❌ ThousandEyes Endpoint Agent (`choice_thousandeyes`)
- ❌ Duo Integration Module (`choice_duo`)
- ❌ Zero Trust Agent (ZTA) (`choice_zta`)

In many cases, only the core VPN is needed.

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

[Policy File](https://github.com/lostinvasion/secure-client-deployment-macOS/blob/main/policy-template.json)

## 🚀 Deploy

It's recommended to create a deploy group and assign both the configuration profile and install script to that group (e.g. `[Software] Cisco Secure Client macOS`). Set up your scope tags as needed. feel free to contribute or open an issue if you have questions or improvements. hope this guide was helpful! 


