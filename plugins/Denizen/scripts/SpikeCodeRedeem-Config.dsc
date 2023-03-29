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
# | Redeemable Codes - Configs      |
# |                                 |
# | This is only the config file    |
# | DO NOT DELETE THIS FILE!        |
# |                                 |
# +---------------------------------+
#
# @author Spikehidden
# @date 2022/06/10
# @denizen-build 1.2.4-SNAPSHOT (build 1766-REL)
# @script-version 1.0
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

# ++++++ Config ++++++
SpikeCodeRedeemData:
    type: data
    # + Core configs
    # ------ Pastebin ------
    # Do you want to use private or public pastes on Pastebin.com ?
    # You can find more info in the readme at https://github.com/spikehidden/CodeRedeemScript
    # Default is false as it is not recommended to use this feature when bulk creating codes!
    UsePastebin: false
    # Put your pastebin devKey in here as it's not possible to retrieve it from the "secrets.secret" file at the moment.
    # As soon as it is possible we'll do it that way.
    devKey: Put Your Key Here!

    # + Not AddOn specific configs
    # This setting is used by the following AddOns:
    # - Wizebot API
    server:
        name: My Minecraft Server
        ip: mc.example.tld

    # + Add-On configs.
    # ------ Auto Generate ------
    # For these feature you need the Auto Generate Addon
    auto:
        # The prefix of the auto genereated code.
        # Set to "none" (without quotes) to disable.
        prefix: daily-

        # The name of the code after the prefix.
        # Use "random" (without quotes) to generate a random code
        code: random

        # A list of commands that should be executed when redeeming the code.
        commands:
        - say this is a command.
        - minecraft:give <p> 64 diamonds

        # The intervall in hours of when the code gets generated.
        interval: 24

        # Amount of how many players can use the code.
        # Set to "unlimited" (without quotes) to have no limit.
        amount: unlimited

        # Should we delete the old code?
        # Set to false to keep the old one but you need to
        # set auto.code to random then or it will throw errors.
        delete: true

    # ------ Wizebot API -------
    # For these feature you need the Wizebot Addon
    wizebot:
            web:
                # Only change this if you use nginx or something similar. If you do it anyway Wizebot won't be able to connect to your server.
                port: 80
            API:
                # Set here a SECURE API key.
                # If set to none it's not usable
                key: none

            shop:
                # ID = Uses the item_id to check which commands to assign.
                # group = Uses the "group" query parameter to get the - Easier
                # For more info and to get t know how to get the item IDs take a look at the wiki on Github
                # https://github.com/spikehidden/coderedeemscript/wiki
                mode: ID

                # Map of group IDs which will be used for group mode.
                groups:
                    # Group ID
                    group_01:
                        # List of Wizebot item IDs that shall be part of this group.
                        # Won't be used if mode is set to group
                        ids:
                        - 64509
                        commands:
                            # The amount of random commands to choose.
                            amount: 1
                            # The commands to randomly assign.
                            # Set amount to 0 to disable
                            random:
                            - minecraft:give <&lt>p<&gt> diamond 64
                            # A list of commands that are always assigned to a code.
                            # Set to "alwaysCommand: none" to disable
                            always:
                            - minecraft:say <&lt>p<&gt> redeemed <[code]>


    #+ ------ Debug & Log ------
    # Shall redemption be logged?
    redemptionLog: true
    logPath: spikehidden/logs/

    #+ ------ Advanced Settings ------
    # Don't change this unless Pastebin changed their API endpoints
    API:
        endpoint: pastebin.com/api/
        data: api_raw.php
        login: api_login.php
        paste: api_post.php