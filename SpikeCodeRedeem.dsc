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
    # - Pastebin -
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

    # Don't change this unless Pastebin changed thier API endpoints
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

#- Command to get Pastebin Userkey
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

SpikeCodeRedeemAdminCommand:
    type: command
    name: redeemsettings
    description: Admin Settings for Spike's redeemable codes.
    usage: /redeemsettings <&lb>create/edit/delete<&rb> <&lb><&lt>code<&gt>/random<&rb> <&lb><&lt>amount of uses<&gt>/unlimited<&rb> <&lb><&lt>command<&gt>/group:<&lt>command group<&gt><&rb> (<&lt>permission<&gt>)
    aliases:
    - redeemadmin
    - codeadmin
    - newcode
    - code
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
    #- Create
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
                - webget https://random.justyy.workers.dev/api/random/?n=8&x=6 save:newcode
                - define code <entry[newcode].result.replace_text[<&dq>]>
            # Sets the amount how often the code can be used.
            - flag server redeemableCodes.<[code]>.amount:<[amount]>
            # Check if a persmission shall be set.
            - if <[permission]> != null:
                - define msg 'The code "<[code]>" with <[amount]> possible redemption(s) and the "<[permission]>" permission required was created!'
                - flag server redeemableCodes.<[code]>.permission:<[permission]>
            # If so set the permission.
            - else:
                - define msg 'The code "<[code]>" with <[amount]> possible redemption was created!'
                - flag server redeemableCodes.<[code]>.permission:<[permission]>
    #- Edit
    - else if <[setting]> == edit:
        - if !<server.has_flag[redeemableCodes.<[code]>]>:
            - define msg 'The specified Code does not exits! To create one use "/redeemsettings create <[code]>"'
    #- Delete
    - else if <[setting]> == delete:
        - if !<server.has_flag[redeemableCodes.<[code]>]>:
            - define msg 'The specified Code does not exits! To create one use "/redeemsettings create <[code]>"'
    - narrate <[msg]>