# + License Notice +

# - Spikehidden's Redeemable Codes can be used to create redeemable codes in Minecraft.
# - Copyright (C) 2022 Spikehidden

# - This program is free software: you can redistribute it and/or modify
# - it under the terms of the GNU Affero General Public License as published
# - by the Free Software Foundation, either version 3 of the License, or
# - (at your option) any later version.

# - This program is distributed in the hope that it will be useful,
# - but WITHOUT ANY WARRANTY; without even the implied warranty of
# - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# - GNU Affero General Public License for more details.

# - You should have received a copy of the GNU Affero General Public License
# - along with this program.  If not, see https://spikey.biz/karga.

# +---------------------------------+
# |                                 |
# | Redeemable Codes                |
# |                                 |
# | A Script to create and          |
# | use redeemable Codes.           |
# |                                 |
# +---------------------------------+
#
# @Spikehidden
# @date 2022/MM/dd
# @denizen-build version
# @script-version 0.1-ALPHA
#
# + REQUIREMENTS +
# - List of required Plugins
#
# + Required or recommended for some features +
# - List of required Plugins for optional features
#
# + CONTACT +
#
# If you need help with the setup
# or want me to add a feature please
# contact me via Twitter or Discord
# or open an issue at GitHub!
#
# - Twitter:    https://spikey.biz/twitter
# - Discord:    https://spikey.biz/discord
# - Twitch:     https://spikey.biz/twitch
# - Ko-Fi:      https://spikey.biz/kofi

# + Config +
SpikeCodeRedeemData:
    type: data
    # ------ Pastebin ------
    # Do you want to use private or public pastes on Pastebin.com ?
    # You can find more info in the readme at https://github.com/spikehidden/XXX
    # Default is false as it is NOT recommended to use this feature!
    UsePastebin: false

    # If it is a public or unlisted paste you don't need to have a user key nor a dev key.
    # But it will ONLY allow the use of md5 hashes as public pastes can be viewed by anyone.
    ## NOT RECOMMEND TO USE PUBLIC PASTES AS EVERYONE COULD SEE THE CODES EVEN THOUGH THEY ARE ENCRYPTED!
    IsPublic: false
    #- Dev Key has to be defined in the "secrets.secret" file as "PastebinDevKey"
    # More Info about "secrets.secret" can be found here: https://meta.denizenscript.com/Docs/ObjectTypes/SecretTag


    # ------ Debug & Log ------
    # Shall redemption be logged?
    redemptionLog: true
    logPath: spikehidden/logs/CodeRedemption.log

    # ------ Advanced Settings ------
    # Don't change this unless Pastebin changed their API endpoints
    API:
        endpoint: https://pastebin.com/api/
        data: api_raw.php
        login: api_login.php
        paste: api_post.php

# =========== DO NOT EDIT ANYTHING BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU'RE DOING! ===========

# ++++++ Data for Updater Scripts ++++++
SpikeCodeRedeemUpdate:
    type: data

    Github:
        profile: Spikehidden
        respository: CodeRedeemScript
        filename: XXX
    version: XXX

# ++++++ Tasks ++++++
# + Create Code Task +
SpikeCodeCreateCode:
    type: task
    definitions: code|amount|command|permission

    script:
    # Check if a random code shall be generated
    - if <[code]> == random:
        - ~webget https://random.justyy.workers.dev/api/random/?n=8&x=6 save:newcode
        - define code <entry[newcode].result.replace_text[<&dq>]>
    # Sets the amount how often the code can be used.
    - flag server redeemableCodes.<[code]>.amount:<[amount]>
    # Sets the commands that shall be executed!
    - flag server redeemableCodes.<[code]>.commands:<list>
    - flag server redeemableCodes.<[code]>.commands:->:<[command]>
    # Check if a permission shall be set.
    - if <[permission]> != null:
        - define msg 'The code "<[code]>" with <[amount]> possible redemption(s) and the "<[permission]>" permission required was created!'
        - flag server redeemableCodes.<[code]>.permission:<[permission]>
    # If so set the permission.
    - else:
        - define msg 'The code "<[code]>" with <[amount]> possible redemption was created!'

# + Send Code List to Pastebin +
SpikeCodeSendPastebin:
    type: task
    definitions: paste_name|paste_content|format|paste_format

    script:
    - define useAPI <script[SpikeCodeRedeemData].data_key[UsePastebin].as_boolean>
    - define API <script[SpikeCodeRedeemData].data_key[API.endpoint]>
    - define endpoint <script[SpikeCodeRedeemData].data_key[API.paste]>
    - define URI <[API]><[endpoint]>
    - define devKey <secret[pastebinDevKey].if_null[null]>
    - if <[devKey]> == null:
        - narrate 'No dev key found! For more info look into the configs!'
    - else if <[useAPI].if_null[false]>:
        # If there is a userkey create a private paste.
        - if <player.has_flag[pastebin.userkey]>:
            - ~webget <[URI]> data:api_dev_key=<[devKey]>&api_option=paste&api_paste_code=<[paste_content].url_encode>&api_paste_name=<[paste_name]>&api_paste_private=2&api_user_key=<player.flag[pastebin.userkey]> save:link
            - define link <entry[link].result>
            - define msg 'You can find your code list in the <[format]>-format at <[link]>'
            - narrate <[msg]>
        # If there is no userkey, create an unlisted one as pasword protected is not possible with the API at the moment.
        # - NOTE: Maybe use Pastebin alternative?
        - else:
            - ~webget <[URI]> data:api_dev_key=<[devKey]>&api_option=paste&api_paste_code=<[paste_content].url_encode>&api_paste_name=<[paste_name]>&api_paste_private=1&api_paste_expire_date=10M save:link
            - define link <entry[link].result>
            - define msg 'You can find your code list in the <[format]>-format at <[link]><&nl>'
            - define msg '<[msg]><&e>[WARNING] The pastebin is unlisted but public and will be deleted in 10 minutes to keep it contents as save as possible!<&nl>'
            - define msg '<[msg]><&e>It is recommended that you generate a user key with "/pastebin" to create private pastes!'
            - narrate <[msg]>
    - else:
        - narrate 'You have disabled the use of Pastebin! So you will not be able to get a list of all codes! Please enable it and get a Pastebin dev key!'
        - narrate 'Run "/getlist <&lb><&lt>code group ID<&gt><&rb> (<&lt>format<&gt>)" to get the List of codes!'

# ++++++ World ++++++
SpikeCodeRedeemSystem:
    type: world
    events:
        on server start:
            - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Script loaded." to_console
            - flag server SpikeCodeRedeem
            - if <server.has_flag[SpikehiddenUpdater]>:
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Spikehidden's Auto Updater has been found!" to_console
                - flag server SpikehiddenUpdater.data:->:SpikeCodeRedeem.update
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Providing Update data for the Spikehidden's Auto Updater" to_console
        on shutdown:
            - flag server SpikeCodeRedeem:!

# ++++++ Commands ++++++
# + Command to get Pastebin Userkey +
SpikeCodeRedeemPastebinCommand:
    type: command
    name: pastebin
    description: Generate your Pastebin Userkey
    usage: /pastebin <&lb><&lt>username<&gt><&rb> <&lb><&lt>password<&gt><&rb>
    aliases:
    - spikebin
    - pastebinkey
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.pastebin
    allowed help:
    - determine <player.has_permission[spikehidden.admin]>||<context.server>||<player.has_permission[spikehidden.coderedeem.admin]>||<player.has_permission[spikehidden.coderedeem.pastebin]>
    script:
    - define username <context.args.get[1].if_null[null]>
    - define password <context.args.get[2].if_null[null]>
    # Checks for missing arguments.
    - if <[username]> == null || <[password]> == null:
        - narrate Missing either username or password!
        - stop
    - else:
        - define devKey <secret[pastebinDevKey].if_null[null]>
        - define endpoint <script[SpikeCodeRedeemData].data_key[API.endpoint]>
        - define API <script[SpikeCodeRedeemData].data_key[API.login]>
        - define url <[endpoint]><[API]>
        # Check if DevKey exists.
        - if <[devKey]> != null:
            - ~webget <[url]> data:api_dev_key=<secret[pastebinDevKey]>&api_user_name=<[username]>&api_user_password=<[password]> save:userkey
            - if !<entry[userkey].failed>:
                - define msg 'Your userkey "<Element[<entry[userkey].result>].on_click[<entry[userkey].result>].type[COPY_TO_CLIPBOARD]>" was succesfully saved.<&nl>'
                - define msg '<[msg]>There is no reason to regenerate the userkey unless you run into an invalid userkey error!'
                - narrate <[msg]>
            - else:
                - narrate "An error occured! Please check the console log for more info!"
        - else:
            - narrate "Dev Key is not specified in secrets.secret! Check the readme on GitHub!"

# + Command for creating, deleting and editing codes +
SpikeCodeRedeemAdminCommand:
    type: command
    name: redeemsettings
    description: Admin Settings for Spike's redeemable codes.
    usage: /redeemsettings <&lb>create/edit/delete<&rb> <&lb><&lt>code<&gt>/random<&rb> <&lb><&lt>amount of uses<&gt>/unlimited<&rb> <&lb><&lt>command<&gt>/group:<&lt>command group<&gt><&rb> (<&lt>permission<&gt>)
    aliases:
    - redeemadmin
    - codeadmin
    - newcode
    - ca
    - redeemsetting
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.codes
    allowed help:
    - determine <player.has_permission[spikehidden.admin]>||<context.server>||<player.has_permission[spikehidden.coderedeem.admin]>||<player.has_permission[spikehidden.coderedeem.codes]>
    tab completions:
        1: create|edit|delete
        2: <server.flag[redeemableCodes].if_null[No codes found]>|random
        3: 1|10|100|unlimited
        4: <server.commands>|<server.flag[commandGroups].as_list>
        5: permission
        default: Too many arguments! Try putting the arguments in quotes (<&dq><&dq>)!
    script:
    - define setting <context.args[1].if_null[null]>
    - define code <context.args[2].if_null[null]>
    - define amount <context.args[3].if_null[null]>
    - define command <context.args[4].if_null[null]>
    - define permission <context.args[5].if_null[null]>
    - if <[setting]> == null || <[code]> == null:
        - narrate "Missing arguments!"
    # - Create
    - else if <[setting]> == create:
        # Check if arguments exist
        - if <[amount]> == null || <[command]> == null:
            - define msg "Missing arguments!"
        # Check if amount is decimal or unlimited
        - else if !<[amount].is_decimal> && <[amount]> != unlimited:
            - define msg "You specified an invalid ammount of available uses!"
        # Check if Code already exists
        - else if <server.has_flag[redeemableCodes.<[code]>]>:
            - define msg 'The specified code already exists! Please use "/redeemsettings edit <[code]>..." instead!'
        - else:
            - inject SpikeCodeCreateCode
    # - Edit
    - else if <[setting]> == edit:
        - if !<server.has_flag[redeemableCodes.<[code]>]>:
            - define msg 'The specified Code does not exits! To create one use "/redeemsettings create <[code]>"'
            - narrate <[msg]>
            - stop
        - else if !<[amount].is_decimal> && <[amount]> != unlimited:
            - define msg 'You have not specified a correct amount!'
            - narrate <[msg]>
            - stop
        - if <[command]> == null:
            - define command <server.flag[redeemableCodes.<[code]>.commands]>
        - flag server redeemableCodes.<[code]>.commands:<[command].as_list>
        - flag server redeemableCodes.<[code]>.amount:<[amount]>
        - define msg 'The code "<[code]>" with <[amount]> possible redemption was sucessfully edited!'
    # - Delete
    - else if <[setting]> == delete:
        - if !<server.has_flag[redeemableCodes.<[code]>]>:
            - define msg 'The specified Code does not exits! To create one use "/redeemsettings create <[code]>"'
        - else:
            - flag server redeemableCodes.<[code]>:!
            - define msg 'The code "<[code]>" was succesfully deleted!'
    - narrate <[msg]>

# + Command for redeeming codes.
spikeCodeRedeemCommand:
    type: command
    name: redeem
    description: Command to redeem codes
    usage: /redeem <&lb><&lt>code<&gt><&rb>
    aliases:
    - redeemcode
    - coderedeem
    - code
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.redeem
    allowed help:
    - if <player.has_permission[spikehidden.admin]> || <player.has_permission[spikehidden.coderedeem.admin]> || <player.has_permission[spikehidden.coderedeem.redeem]> || <context.server>:
        - determine true
    - else:
        - determine false
    script:
    # Check if the one who executes the command is a player.
    - if <context.source_type> != PLAYER:
        - narrate 'This command can only be executed by a player!'
        - stop
    # Define stuf!! STUFF!!
    - define code <context.args[1].as_string>
    - define log <script[SpikeCodeRedeemData].data_key[redemptionLog]>
    - define logPath <script[SpikeCodeRedeemData].data_key[logPath]>
    # Check if the code exists!
    - if <server.has_flag[redeemableCodes.<[code]>]>:
        # Define more stuff!
        - define commands <server.flag[redeemableCodes.<[code]>.commands]>
        - define amount <server.flag[redeemableCodes.<[code]>.amount]>
        # Check if the Code requires a permission
        - if <server.has_flag[redeemableCodes.<[code]>.permission]>:
            - define permission <server.flag[redeemableCodes.<[code]>.permission]>
            # If so check if the player hast the permission
            - if <player.has_permission[<[permission]>]>:
                # Save that the player may use the code.
                - define mayRedeem true
            # If they are not allowed save that and create reply
            - else:
                - define mayRedeem false
                - define msg 'You are not allowed to use this Code!'
        # If no permission is required save that they may use the code.
        - else:
            - define mayRedeem true
    # Send Error if the Code does not exist.
    - else:
        - define msg 'The specified code "<[code]>" does not exist!'
    # Check if the Player can redeem the code
    - if <[mayRedeem]>:
        # If so execute the saved commands.
        - foreach <[commands]> as:cmd:
            - define command <[cmd].replace_text[$(player)].with[<player.name>]>
            - execute as_server <[command]>
            # Log execution of each command if it's enabled in the settings.
            - if <[log]>:
                - ~log '<player.name> <&lb><player.uuid><&rb> | Player used "<[code]>" to execute "/<[command]>" as console' file:<[logPath]>
        # Define message
        - define msg 'Code succesfully redeemed!'
        # Reduce amount if not unlimited
        - if <[amount].is_decimal> && <[amount]> != unlimited:
            - flag server redeemableCodes.<[code]>.amount:--
    - narrate <[msg]>

# + Command for bulk creating codes +
SpikeCodeBulkCodeCreate:
    type: command
    name: bulkcodecreate
    description: Admin Settings for Spike's redeemable codes.
    usage: /bulkcodecreate  <&lb><&lt>code group name<&gt><&rb> <&lb><&lt>amount of codes<&gt><&rb> <&lb><&lt>command<&gt>/group:<&lt>command group<&gt><&rb> (<&lt>format for list export<&gt>) (<&lt>permission<&gt>)
    aliases:
    - bulkcreate
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.codes
    allowed help:
    - determine <player.has_permission[spikehidden.admin]>||<context.server>||<player.has_permission[spikehidden.coderedeem.admin]>||<player.has_permission[spikehidden.coderedeem.codes]>
    tab completions:
        # Code group
        1: <server.flag[redeemableCodeGroups].as_list>|random
        # amount of codes
        2: 1|2|3|4|5|10|100|1000
        # commands as list
        3: <server.commands>|<server.flag[commandGroups].as_list>
        # format
        4: list|wizebot
        # permission
        5: <empty>
        default: Too many arguments! Try putting the arguments in quotes (<&dq><&dq>)!
    script:
    - define group <context.args[1].if_null[null]>
    - define groupAmount <context.args[2].if_null[null]>
    - define command <context.args[3].if_null[null]>
    - define format <context.args[4].if_null[null]>
    - define permission <context.args[5].if_null[null]>
    - define amount 1
    # check for missing arguments
    - if <[group]> == null || <[groupAmount]> == null || <[command]> == null:
        - narrate "Missing arguments!"
        - stop
    # - Create
    # Check if arguments exist
    - if <[groupAmount]> == null || <[command]> == null:
        - define msg "Missing arguments!"
    # Check if groupAmount is decimal
    - else if !<[groupAmount].is_decimal>:
        - define msg "You specified an invalid amount!"
    # Check if group already exists
    - else if <server.has_flag[redeemableGroups.<[group]>]>:
        - define msg 'The specified group already exists! Please use "/redeemsettings edit <[group]>..." instead!'
    - else:
        # Check if a random group shall be generated
        - if <[group]> == random:
            - ~webget https://random.justyy.workers.dev/api/random/?n=8&x=6 save:newgroup
            - while <server.has_flag[redeemableGroups.<entry[newgroup].result.replace_text[<&dq>]>]>:
                - ~webget https://random.justyy.workers.dev/api/random/?n=8&x=6 save:newgroup
                - if <[loop_index]> >= 10:
                    - narrate 'Could not create an unused random code group name. Try again or if this error persists open an issue on GitHub.'
                    - stop
            - define group <entry[newgroup].result.replace_text[<&dq>]>
        # Sets the amount how may codes are in the group.
        - flag server redeemableGroups.<[group]>.amount:<[amount]>
        # Creates the specified amount of codes.
        - while <[loop_index]> <= <[groupAmount]>:
            - ~webget https://random.justyy.workers.dev/api/random/?n=8&x=6 save:newcode
            - while <server.has_flag[redeemableCodes.<entry[newcode].result.replace_text[<&dq>]>]>:
                - ~webget https://random.justyy.workers.dev/api/random/?n=8&x=6 save:newgroup
            - define code <entry[newcode].result.replace_text[<&dq>]>
            # Inject Code creation script
            - inject SpikeCodeCreateCode
            - flag server redeemableCodes.<[code]>.group:<[group]>
            - flag server redeemableGroups.<[group]>.codes:->:<[code]>
        # Sets the commands that shall be executed!
        - flag server redeemableGroups.<[group]>.commands:<list>
        - flag server redeemableGroups.<[group]>.commands:->:<[command]>
        # Check if a permission shall be set.
        - if <[permission]> != null:
            - define msg 'The group "<[group]>" with <[amount]> possible redemption(s) and the "<[permission]>" permission required was created!'
            - flag server redeemableGroups.<[group]>.permission:<[permission]>
        # If so set the permission.
        - else:
            - define msg 'The group "<[group]>" with <[amount]> possible redemption was created!'


    # # - Edit
    # - else if <[setting]> == edit:
    #     - if !<server.has_flag[redeemableGroups.<[group]>]>:
    #         - define msg 'The specified group does not exits! To create one use "/redeemsettings create <[group]>"'
    #         - narrate <[msg]>
    #         - stop
    #     - else if !<[amount].is_decimal> && <[amount]> != unlimited:
    #         - define msg 'You have not specified a correct amount!'
    #         - narrate <[msg]>
    #         - stop
    #     - if <[command]> == null:
    #         - define command <server.flag[redeemableGroups.<[group]>.commands]>
    #     - flag server redeemableGroups.<[group]>.commands:<[command].as_list>
    #     - flag server redeemableGroups.<[group]>.amount:<[amount]>
    #     - define msg 'The group "<[group]>" with <[amount]> possible redemption was sucessfully edited!'
    # # - Delete
    # - else if <[setting]> == delete:
    #     - if !<server.has_flag[redeemableGroups.<[group]>]>:
    #         - define msg 'The specified group does not exits! To create one use "/redeemsettings create <[group]>"'
    #     - else:
    #         - flag server redeemableGroups.<[group]>:!
    #         - define msg 'The group "<[group]>" was succesfully deleted!'
    # - narrate <[msg]>