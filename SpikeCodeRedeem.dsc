# ++++++ License Notice ++++++
#
#   The following code is distributed under
#   the CC-BY-SA-4.0 license (Attribution-ShareAlike 4.0 International).
#
# | You are free to:
# - Share
#   copy and redistribute the material in any medium or format
#
# - Adapt
#   remix, transform, and build upon the material
#   for any purpose, even commercially.
#
# | Under the following terms:
# - Attribution
#   You must give appropriate credit,
#   provide a link to the license, and indicate if changes were made.
#   You may do so in any reasonable manner,
#   but not in any way that suggests the licensor endorses you or your use.
#
# - ShareAlike
#   If you remix, transform, or build upon the material,
#   you must distribute your contributions under the same license as the original.
#
# - A copy of the full license can be found here: https://creativecommons.org/licenses/by-sa/4.0/
#
# ++++++ License End ++++++
#
# +---------------------------------+
# |                                 |
# | Redeemable Codes                |
# |                                 |
# | A Script to create and          |
# | use redeemable Codes.           |
# |                                 |
# +---------------------------------+
#
# @author Spikehidden
# @date 2022/06/10
# @denizen-build 1.2.5-SNAPSHOT (build 6477-DEV)
# @script-version 1.1.1
#
# + REQUIREMENTS +
# - None
#
# + Required or recommended for some features +
# - A Pastebin Account + DevKey if you want to use that feature.

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
    # You can find more info in the readme at https://github.com/spikehidden/CodeRedeemScript
    # Default is false as it is not recommended to use this feature when bulk creating codes!
    UsePastebin: false
    # Put your pastebin devKey in here as it's not possible to retrieve it from the "secrets.secret" file at the moment.
    # As soon as it is possible we'll do it that way.
    devKey: Put Your Key Here!

    # ------ Debug & Log ------
    # Shall redemption be logged?
    redemptionLog: true
    logPath: spikehidden/logs/

    # ------ Advanced Settings ------
    # Don't change this unless Pastebin changed their API endpoints
    API:
        endpoint: pastebin.com/api/
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
        filename: SpikeCodeRedeem.dsc
    version: 1.0

# ++++++ Tasks ++++++
# + Create Code Task +
SpikeCodeCreateCode:
    type: task
    debug: false
    definitions: code|amount|command|permission|prefix|code_amount|group

    script:
    # Check if a random code shall be generated
    - if <[code]> == random:
        - define url https://www.random.org/strings/?num=<[code_amount].if_null[1]>&len=8&digits=on&upperalpha=off&loweralpha=on&unique=on&format=plain&rnd=new
        - ~webget <[url]> save:newcodelist
        - define newCodeList <entry[newcode].result.split[<&nl>]>
        # - define code <entry[newcode].result.replace_text[<&dq>]>
        # - define code <[code].replace_text[<&nl>]>
        # - if <[prefix].exists>:
        #     - define code <[prefix]><[code]>
    - else:
        - define newCodeList <list[<[code]>]>
    - define codeList <list>
    - foreach <[newCodeList]> as:code:
        # Add prefix
        - if <[prefix].exists>:
            - define code <[prefix]><[code]>
        # Sets the amount how often the code can be used.
        - flag server redeemableCodes.<[code]>.amount:<[amount]>
        # Sets the commands that shall be executed!
        - if <[command]> == group:
            - flag server redeemableCodes.<[code]>.commands:<player.flag[spikehidden.coderedeem.commandgroup]>
        - else:
            - flag server redeemableCodes.<[code]>.commands:<list>
            - flag server redeemableCodes.<[code]>.commands:->:<[command]>
        # Add code group if existing
        - if <[group].exists>:
            - flag server redeemableCodes.<[code]>.group:<[group]>
            - flag server redeemableGroups.<[group]>.codes:->:<[code]>
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
    debug: false
    definitions: player|paste_name|paste_content|format|paste_format

    script:
    - define useAPI <script[SpikeCodeRedeemData].data_key[UsePastebin].as_boolean>
    - define API <script[SpikeCodeRedeemData].data_key[API.endpoint]>
    - define endpoint <script[SpikeCodeRedeemData].data_key[API.paste]>
    - define URI https://<[API]><[endpoint]>
    - define devKey <script[SpikeCodeRedeemData].data_key[devKey].if_null[null]>
    - if <[devKey]> == null:
        - narrate 'No dev key found! For more info look into the configs!'
    - else if <[useAPI].if_null[false]>:
        # If there is a userkey create a private paste.
        - if <[player].has_flag[pastebin.userkey]>:
            - ~webget <[URI]> data:api_dev_key=<[devKey]>&api_option=paste&api_paste_code=<[paste_content].url_encode>&api_paste_name=<[paste_name]>&api_paste_private=2&api_user_key=<player.flag[pastebin.userkey]> save:link
            - define link <entry[link].result>
            - define msg 'You can find your code list in the <[format]>-format at <[link]>'
            - narrate <[msg]>
        # If there is no userkey, create an unlisted one as pasword protected is not possible with the API at the moment.
        # - NOTE: Maybe use Pastebin alternative in future?
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

SpikeCodeRedeemCreateList:
    type: task
    debug: false
    definitions: player|paste_name|paste_content|format|paste_format
    script:
    - choose <[format]>:
        - case list:
            - ~log <[paste_content]> type:none file:plugins/Denizen/spikehidden/code_redeem/codes/<[paste_name]>.txt
        - case wizebot:
            - ~log <[paste_content]> type:none file:plugins/Denizen/spikehidden/code_redeem/codes/<[paste_name]>.csv
        - default:
            - ~log <[paste_content]> type:none file:plugins/Denizen/spikehidden/code_redeem/codes/<[paste_name]>.txt

# ++++++ World ++++++
SpikeCodeRedeemSystem:
    type: world
    debug: false
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
    debug: false
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
        - define devKey <script[SpikeCodeRedeemData].data_key[devKey]>
        - define endpoint <script[SpikeCodeRedeemData].data_key[API.endpoint]>
        - define API <script[SpikeCodeRedeemData].data_key[API.login]>
        - define url https://<[endpoint]><[API]>
        # Check if DevKey exists.
        - if <[devKey]> != null:
            - ~webget <[url]> data:api_dev_key=<[devKey]>&api_user_name=<[username]>&api_user_password=<[password]> save:userkey
            - if !<entry[userkey].failed>:
                - define userkey <entry[userkey].result.replace_text[<&nl>]>
                - flag <player> pastebin.userkey:<[userkey]>
                - define msg 'Your userkey "<Element[<[userkey]>].on_click[<[userkey]>].type[COPY_TO_CLIPBOARD]>" was succesfully saved.<&nl>'
                - define msg '<[msg]>There is no reason to regenerate the userkey unless you run into an invalid userkey error!'
                - narrate <[msg]>
            - else:
                - narrate "An error occured! Please check the console log for more info!"
        - else:
            - narrate "Dev Key is not specified in secrets.secret! Check the readme on GitHub!"

# + Command for creating, deleting and editing codes +
SpikeCodeRedeemAdminCommand:
    type: command
    debug: false
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
    tab complete:
    - if <context.raw_args.split_args.size> >= 2:
        # If create
        - if <context.raw_args.split_args.get[1]> == create:
            - if <context.raw_args.split_args.size> == 2:
                - determine random|<&lt>code<&gt>
            - else if <context.raw_args.split_args.size> == 3:
                - determine 1|10|100|unlimited
            - else if <context.raw_args.split_args.size> == 4:
                - determine group|<server.commands>
            - else if <context.raw_args.split_args.size> >= 5:
                - determine <&lt>argument<&gt>
        # If Edit
        - else if <context.raw_args.split_args.get[1]> == edit:
            # 2
            - if <context.raw_args.split_args.size> == 2:
                - determine code|group
            # 3..
            - else if <context.raw_args.split_args.size> >= 3:
                # if code
                - if <context.raw_args.split_args.get[2]> == code:
                    # 3
                    - if <context.raw_args.split_args.size> == 3:
                        - determine "<server.flag[redeemableCodes].keys.if_null[No codes found]>"
                    # 4
                    - else if <context.raw_args.split_args.size> == 4:
                        - determine command|amount
                    # 5
                    - else if <context.raw_args.split_args.size> == 5:
                        # If command
                        - if <context.raw_args.split_args.get[4]> == command:
                            - determine group|<server.commands>
                        - else if <context.raw_args.split_args.get[4]> == amount:
                            - determine 1|10|100|unlimited
                # if group
                - else if <context.raw_args.split_args.get[2]> == group:
                    # 3
                    - if <context.raw_args.split_args.size> == 3:
                        - determine "<server.flag[redeemableGroups].keys.if_null[No groups found]>"
                    # 4
                    - else if <context.raw_args.split_args.size> == 4:
                        - determine command|amount
                    # 5
                    - else if <context.raw_args.split_args.size> == 5:
                        # If command
                        - if <context.raw_args.split_args.get[4]> == command:
                            - determine group|<server.commands>
                        - else if <context.raw_args.split_args.get[4]> == amount:
                            - determine 1|10|100|unlimited
        # If delete
        - else if <context.raw_args.split_args.get[1]> == delete:
            - if <context.raw_args.split_args.size> == 2:
                - determine code|group
            # if code
            - else if <context.raw_args.split_args.size> == 3 && <context.raw_args.split_args.get[2]> == code:
                - determine "<server.flag[redeemableCodes].keys.if_null[No codes found]>"
            # if group
            - else if <context.raw_args.split_args.size> == 3 && <context.raw_args.split_args.get[2]> == group:
                - determine "<server.flag[redeemableGroups].keys.if_null[No groups found]>"
            - else if <context.raw_args.split_args.size> >= 4:
                - determine "Too many arguments!"
    - else:
        - determine <empty>
    script:
    - define args <context.raw_args.split_args.if_null[null]>
    - define setting <[args].get[1].if_null[null]>
    # check if setting is specified
    - if <[setting]> == null:
        - narrate "Missing arguments!"
        - stop

    - else:
        # Check what type of setting
        - choose <[setting]>:

            # - Create
            - case create:
                # define stuff for the create command
                - define code <[args].get[2].if_null[null]>
                - define amount <[args].get[3].if_null[null]>
                - define command <[args].get[4].to[last].space_separated.if_null[null]>
                - define permission null
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
            - case edit:
                - if !<[args].get[2].exists> || !<[args].get[3].exists> || !<[args].get[4].exists> || !<[args].get[5].exists>:
                    - define msg "Missing arguments."
                - else:
                    # defining stuff
                    - define type <[args].get[2]>
                    - define name <[args].get[3]>
                    - define edit <[args].get[4]>
                    - define value <[args].get[5]>
                    # Code or Group
                    - choose <[type]>:

                        # If Code
                        - case code:
                            # Check if the code exists
                            - if <server.has_flag[redeemableCodes.<[name]>]>:
                                # Check what shall be edited.
                                - choose <[edit]>:
                                    # If command
                                    - case command:
                                        # Check if command group shall be used.
                                        - choose <[value]>:
                                            # If group
                                            - case group:
                                                - flag server redeemableCodes.<[name]>.commands:<player.flag[spikehidden.coderedeem.commandgroup]>
                                                - define msg "Commands were succesfully added to the code <&dq><[name]><&dq>."
                                            # If not
                                            - default:
                                                - flag server redeemableCodes.<[name]>.commands:<[value]>
                                                - define msg "Command was succesfully added to the code <&dq><[name]><&dq>."
                                    # If amount
                                    - case amount:
                                        # Check if amount is valid
                                        - if <[value].is_decimal> || <[value]> == unlimited:
                                            - flag server redeemableCodes.<[name]>:<[value]>
                                            - define msg "Amount of the code <&dq><[name]><&dq> was succesfully changed to <[value]>."
                                        # Show error if invalid amount is specified.
                                        - else:
                                            - define msg "Invalid amount specified!"
                                    - default:
                                        - define msg "You can only edit the amount or commands of a code. For anything else delete and recreate the code."
                            # Show error if it doesn't
                            - else:
                                - define msg "The code <&dq><[name]><&dq> does not exist."

                        # If Group
                        - case group:
                            - if <server.has_flag[redeemableGroups.<[name]>]>:
                                # Check what shall be edited.
                                - choose <[edit]>:
                                    # If command
                                    - case command:
                                        # Check if command group shall be used.
                                        - choose <[value]>:
                                            # If group
                                            - case group:
                                                - define loopCount 0
                                                - foreach <server.flag[redeemableGroups.<[name]>.codes]> as:code:
                                                    - flag server redeemableCodes.<[code]>.commands:<player.flag[spikehidden.coderedeem.commandgroup]>
                                                    - define loopCount:++
                                                - define msg "Commands were succesfully added to <[loopCount]> codes of group <&dq><[name]><&dq>."
                                            # If not
                                            - default:
                                                - define loopCount 0
                                                - foreach <server.flag[redeemableGroups.<[name]>.codes]> as:code:
                                                    - flag server redeemableCodes.<[code]>.commands:<[value]>
                                                    - define loopCount:++
                                                - define msg "Command were succesfully added to <[loopCount]> codes of group <&dq><[name]><&dq>."
                                    # If amount
                                    - case amount:
                                        # Check if amount is valid
                                        - if <[value].is_decimal> || <[value]> == unlimited:
                                            - define loopCount 0
                                            - foreach <server.flag[redeemableGroups.<[name]>.codes]> as:code:
                                                - flag server redeemableCodes.<[code]>.amount:<[value]>
                                                - define loopCount:++
                                            - define msg "Amount was succesfully updated to <[value]> for <[loopCount]> codes of group <&dq><[name]><&dq>."
                                        # Show error if invalid amount is specified.
                                        - else:
                                            - define msg "Invalid amount specified!"
                                    # If invalid argument
                                    - default:
                                        - define msg "You can only edit the amount or commands of a group. For anything else delete and recreate the group."
                            - else:
                                - define msg "The group <&dq><[name]><&dq> does not exist."

                        # Invalid Argument
                        - default:
                            - define msg "Invalid arguments!"
            # - Delete
            - case delete:
                # Define stuff
                - define type <[args].get[2]>
                - define name <[args].get[3]>
                # If code
                - if <[type]> == code:
                    - if <server.has_flag[redeemableCodes.<[name]>]>:
                        - flag server redeemableCodes.<[name]>:!
                        - define msg 'The code "<[name]>" was succesfully deleted!'
                    - else:
                        - define msg 'The specified Code does not exits! To create it use "/redeemsettings create <[code]>..."'
                # If group
                - if <[type]> == group:
                    - if <server.has_flag[redeemableGroups.<[name]>]>:
                        - define codeCount 0
                        - foreach <server.flag[redeemableGroups.<[name]>.codes]> as:code:
                            - flag server redeemableCodes.<[code]>:!
                            - define codeCount:++
                        - flag server redeemableGroups.<[name]>:!
                        - define msg "The code group <&dq><[name]><&dq> with <[codeCount]> code/s was succesfully deleted."
                    - else:
                        - define msg 'The specified group does not exits!"'
    - narrate <[msg]>

# + Command for redeeming codes.
spikeCodeRedeemCommand:
    type: command
    debug: false
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
    - define code <context.args.get[1].if_null[null]>
    - define log <script[SpikeCodeRedeemData].data_key[redemptionLog]>
    - define logPath <script[SpikeCodeRedeemData].data_key[logPath]>CodeRedemption_<util.time_now.format[yyyy-MM-dd]>.log
    # Check if the code exists!
    - if <[code]> == null:
        - narrate "You have not specified any code."
        - stop
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
    - if <[mayRedeem].if_null[false]>:
        # Check if player not already used the code.
        - if not <server.flag[redeemableCodes.<[code]>.usedBy].contains_any[<player>].if_null[false]>:
            # If so execute the saved commands.
            - foreach <[commands]> as:cmd:
                - define command <[cmd].replace_text[<&lt>p<&gt>].with[<player.name>]>
                - execute as_server <[command]>
            # Log execution of each command if it's enabled in the settings.
                - if <[log]>:
                    - ~log '<player.name> <&lb><player.uuid><&rb> | Player used "<[code]>" to execute "/<[command]>" as console' file:<[logPath]>
            # Define message
            - define msg 'Code succesfully redeemed!'
            - flag server redeemableCodes.<[code]>.usedBy:->:<player>
            # Reduce amount if not unlimited
            - if <[amount].is_decimal> && <[amount]> != unlimited:
                - flag server redeemableCodes.<[code]>.amount:--
                # Check if amount is now 0 or below
                - if <server.flag[redeemableCodes.<[code]>.amount]> <= 0:
                    # If so check if the code has a group
                    - if <server.has_flag[redeemableCodes.<[code]>.group]>:
                        # If so define group for easy mapping
                        - define group <server.has_flag[redeemableCodes.<[code]>.group]>
                        # remove code from group
                        - flag server redeemableGroups.<[group]>.codes:<-:<[code]>
                        # Check if group is now empty
                        - if <server.flag[redeemableGroups.<[group]>.codes].size> <= 0:
                            # If so delete group
                            - flag server redeemableGroups.<[group]>:!
                    # Delete code if it has an amount of 0 or below
                    - flag server redeemableCodes.<[code]>:!
        - else:
            - define msg 'You already have redeemed this code.'
    - narrate <[msg]>

# + Command for bulk creating codes +
SpikeCodeRedeemBulkCreate:
    type: command
    debug: false
    name: bulkcodecreate
    description: Admin Settings for Spike's redeemable codes.
    usage: /bulkcodecreate  <&lb><&lt>code group name<&gt><&rb> <&lb><&lt>amount of codes<&gt><&rb> <&lb><&lt>command<&gt>/group<&lt>command group<&gt><&rb> (<&lt>format for list export<&gt>) (<&lt>permission<&gt>)
    aliases:
    - bulkcreate
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.codes
    allowed help:
    - determine <player.has_permission[spikehidden.admin]>||<context.server>||<player.has_permission[spikehidden.coderedeem.admin]>||<player.has_permission[spikehidden.coderedeem.codes]>
    tab completions:
        # Code group
        1: <&lt>Code_Group_Name<&gt>
        # amount of codes
        2: 1|2|3|4|5|10|100|1000
        # format
        3: list|wizebot
        default: <empty>

    tab complete:
    - if <context.raw_args.split_args.size> == 4:
        - determine group|<server.commands>
    - else if <context.raw_args.split_args.size> == 5:
        - determine <&lb>prefix<&rb>
    - else if <context.raw_args.split_args.size> >= 5:
        - determine "Too many arguments! Try putting the arguments in quotes (<&dq><&dq>)!"

    script:
    - define args <context.raw_args.split_args>
    - define group <[args].get[1].if_null[null]>
    - define groupAmount <[args].get[2].if_null[null]>
    - define command <[args].get[4].if_null[null]>
    - define format <[args].get[3].if_null[null]>
    - define prefix <[args].get[5].if_null[<empty>]>
    - define UsePastebin <script[SpikeCodeRedeemData].data_key[UsePastebin].if_null[false]>
#    - define permission <context.args.get[5].if_null[null]>
    - define permission null
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
            - ~webget https://www.random.org/strings/?num=1&len=8&digits=on&upperalpha=off&loweralpha=on&unique=on&format=plain&rnd=new save:newgroup
            - while <server.has_flag[redeemableGroups.<entry[newgroup].result.replace_text[<&dq>]>]>:
                - ~webget https://www.random.org/strings/?num=1&len=8&digits=on&upperalpha=off&loweralpha=on&unique=on&format=plain&rnd=new save:newgroup
                - if <[loop_index].if_null[1]> >= 10:
                    - narrate 'Could not create an unused random code group name. Try again or if this error persists open an issue on GitHub.'
                    - stop
            - define group <entry[newgroup].result.replace_text[<&dq>]>
        # Sets the amount how may codes are in the group.
        - flag server redeemableGroups.<[group]>.amount:<[amount]>
        # Creates the specified amount of codes by injecting Code creation script
        - inject SpikeCodeCreateCode
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
        - if <[UsePastebin]>:
            - choose <[format]>:
                - case list:
                    - run SpikeCodeSendPastebin def:<player>|<[group]>|<server.flag[redeemableGroups.<[group]>.codes].separated_by[<&nl>]>|<[format]>
                - case wizebot:
                    - define csv "<list[Your Information;Your description;Extra]>"
                    - foreach <server.flag[redeemableGroups.<[group]>.codes]> as:data:
                        - define "csv:->:<[data]>;Use the code together with <&dq>/redeem<&dq> on the Minecraft Server.;<empty>"
                    - run SpikeCodeSendPastebin def:<player>|<[group]>|<[csv].separated_by[<&nl>]>|<[format]>
                - default:
                    - run SpikeCodeSendPastebin def:<player>|<[group]>|<server.flag[redeemableGroups.<[group]>.codes].separated_by[<&nl>]>|list
        - else:
            - choose <[format]>:
                - case list:
                    - run SpikeCodeRedeemCreateList def:<player>|<[group]>|<server.flag[redeemableGroups.<[group]>.codes].separated_by[<&nl>]>|<[format]>
                - case wizebot:
                    - define csv "<list[Your Information;Your description;Extra]>"
                    - foreach <server.flag[redeemableGroups.<[group]>.codes]> as:data:
                        - define "csv:->:<[data]>;Use the code together with <&dq>/redeem<&dq> on the Minecraft Server.;<empty>"
                    - run SpikeCodeRedeemCreateList def:<player>|<[group]>|<[csv].separated_by[<&nl>]>|<[format]>
                - default:
                    - run SpikeCodeRedeemCreateList def:<player>|<[group]>|<server.flag[redeemableGroups.<[group]>.codes].separated_by[<&nl>]>|list
    - narrate <[msg]>

SpikeCodeRedeemCommandGroup:
    type: command
    debug: false
    name: createcommandgroup
    description: Admin Settings for Spike's redeemable codes.
    usage: /createcommandgroup  <&dq><&lb><&lt>command1<&gt><&rb><&dq> <&dq><&lb><&lt>command2<&gt><&rb><&dq> ...
    aliases:
    - commandgroup
    permission: spikehidden.admin;spikehidden.coderedeem.admin;spikehidden.coderedeem.codes
    allowed help:
    - determine <player.has_permission[spikehidden.admin]>||<context.server>||<player.has_permission[spikehidden.coderedeem.admin]>||<player.has_permission[spikehidden.coderedeem.codes]>
    tab completions:
        # Code group
        default: <server.commands>

    script:
    - define commands <context.raw_args.split_args>
    - if <[commands]> == null:
        - define msg "You didn't provided any arguments."
    - else:
        - flag <player> spikehidden.coderedeem.commandgroup:<[commands]>