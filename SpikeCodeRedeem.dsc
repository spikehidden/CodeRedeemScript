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

    # The ID at the end of your paste URL (https://pastebin.com/PASTEBIN_ID)
    PasteID: 0nQAhZpT

    # If you want to use a static user key (recommended) or generate a new one each time with your Username and Password.
    # You can use "/pastebin <username> <password> to get your User Key."
    UseUserKey: true

    # If you for whatever reason don't want to use your own dev key...
    #- (!It's free! You do not need to have Pastebin Pro! There is really no reason to not use your own!)
    # ...you can use mine by setting the following to true. The script will then send a request to my server which will forward any requests using my dev key.
    # The /pastebin will also work differently then! It will still give you the user key but it won't change it as my server will save it and won't request it again.
    # And my server will only handle 5 requests per day and IP/user.
    UseSpikeDevKey: false

    # If it is a public or unlisted paste you don't need to have a user key nor a dev key.
    # But it will ONLY allow the use of md5 hashes as public pastes can be viewed by anyone.
    ## NOT RECOMMEND TO USE PUBLIC PASTES AS EVERYONE COULD SEE THE CODES EVEN THOUGH THEY ARE ENCRYPTED!
    IsPublic: false
    #- Dev Key has to be defined in the "secrets.secret" file as "PastebinDevKey"
    #- User Key has to be defined in the "secrets.secret" file as "PastebinUserKey"
    #- Username has to be defined in the "secrets.secret" file as "PastebinUsername"
    #- Password has to be defined in the "secrets.secret" file as "PastebinPassword"
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


# =========== DO NOT EDIT ANYTHING BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU'RE DOING! ===========

SpikeCodeRedeemStartup:
    type: world
    events:
        on server start:
            - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Script loaded."
            - flag server SpikeCodeRedeem

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
                - narrate <Element[<entry[userkey].result>].on_click[<entry[userkey].result>].type[COPY_TO_CLIPBOARD]>
            - else:
                - narrate "An error occured! Please check the console log for more info!"
        - else:
            - narrate "Dev Key is not specified in secrets.secret! Check the readme!"

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

# + Command for bulk creating codes+
SpikeCodeBulkCode:
    type: command
    name: bulkcode
    description: Admin Settings for Spike's redeemable codes.
    usage: /bulkcode <&lb>create/edit/delete<&rb> <&lb><&lt>code<&gt>/random<&rb> <&lb><&lt>amount of uses<&gt>/unlimited<&rb> <&lb><&lt>command<&gt>/group:<&lt>command group<&gt><&rb> (<&lt>permission<&gt>)
    aliases:
    - bulkcreate
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.codes
    allowed help:
    - determine <player.has_permission[spikehidden.admin]>||<context.server>||<player.has_permission[spikehidden.coderedeem.admin]>||<player.has_permission[spikehidden.coderedeem.codes]>
    tab completions:
        1: create|edit|delete
        2: <server.flag[redeemableCodeGroup].if_null[No groups found]>|random
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