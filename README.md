# Spikehidden's Code Redeem Script
 A Denizen Script do create redeemable codes with pastebin support.
## Configs

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
### Pastebin
#### UsePastebin
Set this to true if you want to export code lists to Pastebin but don't forget to input your devkey in the next point.

#### devKey
Put here your dev key which you can find on [Pastebin API documentation](https://pastebin.com/doc_api)

### Debug & Log
#### redemptionLog
Set this to `false` if you want to disable logging redemptions.

#### logPath
Set this to where the log should be saved.
Beware that the start of the path is your Sever's base directory and not the Denizen folder.

### Advanced Settings
You shouldn't have to edit any of this at all and if you do I will not provide any support.  
Though you might have to edit it if Pastebin changes their API endpoints but in this case I will update the script.

## Twitch/YouTube Bot Support
Currently we are supporting export formats for easier import of codelists for the following Bots/Softwares:
| Bot                           | Premium available | Premium needed for import? |
| :---------------------------- | :---------------: | :------------------------: |
| [Wizebot](https://wizebot.tv) | yes               | yes                        |

If you want me to support more bots/software then just open an issue to request it and I happily will if possible.
