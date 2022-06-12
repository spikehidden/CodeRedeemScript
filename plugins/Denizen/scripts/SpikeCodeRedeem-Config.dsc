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
    # ------ Pastebin ------
    # Do you want to use private or public pastes on Pastebin.com ?
    # You can find more info in the readme at https://github.com/spikehidden/CodeRedeemScript
    # Default is false as it is not recommended to use this feature when bulk creating codes!
    UsePastebin: false
    # Put your pastebin devKey in here as it's not possible to retrieve it from the "secrets.secret" file at the moment.
    # As soon as it is possible we'll do it that way.
    devKey: Put Your Key Here!

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