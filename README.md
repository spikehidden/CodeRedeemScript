[![GitHub release](https://img.shields.io/github/release/Spikehidden/CodeRedeemScript?include_prereleases=&sort=semver&color=blue)](https://github.com/Spikehidden/CodeRedeemScript/releases/)
[![License](https://img.shields.io/github/license/Spikehidden/CodeRedeemScript?logo=Creative%20commons)](#LICENSE)
[![issues - CodeRedeemScript](https://img.shields.io/github/issues/Spikehidden/CodeRedeemScript)](https://github.com/Spikehidden/CodeRedeemScript/issues)

[![Discord](https://img.shields.io/discord/731894292557201529?label=Discord&logo=Discord)](https://spikey.biz/discord)
[![Ko-Fi - Donate](https://img.shields.io/badge/Ko--Fi-Donate-FF5E5B?logo=Ko-Fi&logoColor=white)](https://spikey.biz/kofi)
[![Twitch - Subscribe](https://img.shields.io/badge/Twitch-Subscribe-9146FF?logo=Twitch&logoColor=white)](https://spikey.biz/twitch)

[![Spiget Stars](https://img.shields.io/spiget/stars/102540?label=spigotmc.org&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8%2F9hAAAAmklEQVQ4jaVTORKAIAzcOD6CRt9AbWPHv%2F2Bb9CGX8RGHCQHzrgVQ5LdTQgECVbuWpA4GKjJ1NyhJ8W7H%2FcI2lbU1lwHRd1z0W0BAM6wmjFtMFyr1sVz2ETNCKU3rXjK20ugEI29KWvEAEARDICodWCpU5TDpGjM4Miy%2BLbMjQtzE7U3L7kPiUfg4ctf8bGkzEvKDHxcJA%2B%2FCS5YrDUokhVf1AAAAABJRU5ErkJggg%3D%3D&style=flat)](https://www.spigotmc.org/resources/102540/)
[![GitHub all releases](https://img.shields.io/github/downloads/Spikehidden/CodeRedeemScript/total?logo=github&style=flat)](https://github.com/spikehidden/CodeRedeemScript/releases/latest)

# Spikehidden's Code Redeem Script
 A Denizen Script do create redeemable codes with pastebin support.
## Config

### __**Default Config**__
```yaml
# + Config +
SpikeCodeRedeemData:
    type: data
    # ------ Pastebin ------
    # Do you want to use private or public pastes on Pastebin.com ?
    # You can find more info in the readme at https://github.com/spikehidden/CodeRedeemScript
    # Default is false as it is not recommended to use this feature when bulk creating codes!
    UsePastebin: false
    # Put your pastebin devKey in here as it's not possible to retrieve it from the "secrets.secret" file at the moment.
    # As soon as it is possible we'll do it that way.
    devKey: XXXX

    # ------ Debug & Log ------
    # Shall redemption be logged?
    redemptionLog: true
    logPath: plugins/Denizen/spikehidden/code_redeem/logs/

    # ------ Advanced Settings ------
    # Don't change this unless Pastebin changed their API endpoints
    API:
        endpoint: pastebin.com/api/
        data: api_raw.php
        login: api_login.php
        paste: api_post.php
```
### **Pastebin**
#### UsePastebin
Set this to true if you want to export code lists to Pastebin but don't forget to input your devkey in the next point.

#### devKey
Put here your dev key which you can find on [Pastebin API documentation](https://pastebin.com/doc_api)

### **Debug & Log**
#### redemptionLog
Set this to `false` if you want to disable logging redemptions.

#### logPath
Set this to where the log should be saved.
Beware that the start of the path is your Sever's base directory and not the Denizen folder.

### **Advanced Settings**
You shouldn't have to edit any of this at all and if you do I will not provide any support.  
Though you might have to edit it if Pastebin changes their API endpoints but in this case I will update the script.

## Twitch/YouTube Bot Support
Currently we are supporting export formats for easier import of codelists for the following Bots/Softwares:
| Bot                           | Premium available | Premium needed for import? |
| :---------------------------- | :---------------: | :------------------------: |
| [Wizebot](https://wizebot.tv) | yes               | yes                        |

If you want me to support more bots/software then just open an issue to request it and I happily will if possible.

## Commands
| Command                  | arguments                                                    | Feature                             | Permissions                                                                      |
| :----------------------- | :----------------------------------------------------------- | :---------------------------------- | :------------------------------------------------------------------------------- |
| redeemadmin create       | (\<code\>/random) \<amount\> (\<command\>/group)             |  Create a new code                  | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.codes    |
| redeemadmin edit         | (code/group) \<name\> (amount/command) \<new value\>         |  Edit a code or group               | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.codes    |
| redeemadmin delete       | (code/group) \<name\>                                        |  Delete a code or group             | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.codes    |
| redeem                   | \<code\>                                                     |  Redeem a code                      | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.redeem   |
| bulkcreate               | (\<groupName\>/random) \<amountOfCodes\> (\<command\>/group) |  Create a bunch of codes (group)    | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.codes    |
| pastebin                 | \<username\> \<password\>                                    |  Get and save your pastebin userkey | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.pastebin |
| commandgroup             | "\<command1\>" "\<command2\>" (...)                          |  Creates a temporary command group  | spikehidden.admin, spikehidden.coderedeem.admin, spikehidden.coderedeem.codes    |


## License

Released under [CC-BY-SA-4.0](/LICENSE.md) by [@Spikehidden](https://github.com/Spikehidden).
