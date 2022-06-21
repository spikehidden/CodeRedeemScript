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
# | Auto Generate Codes             |
# |                                 |
# | An Addon for                    |
# | Spikehidden's Redeemable Codes  |
# |                                 |
# +---------------------------------+
#
# @author Spikehidden
# @date 2022/06/10
# @denizen-build 1.2.4-SNAPSHOT (build 1766-REL)
# @script-version 1.0
#
# + REQUIREMENTS +
# - Spikehidden Redeemable Codes | https://github.com/spikehidden/
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

# =========== DO NOT EDIT ANYTHING BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU'RE DOING! ===========

# ++++++ Data for Updater Scripts ++++++
# This is in advance for a future project of mine.
SpikeCodeRedeemAutoUpdate:
    type: data

    github:
        profile: Spikehidden
        respository: CodeRedeemScript
        files:
        - SpikeCodeRedeemAutoGenerate.dsc
        version: 1.2
        prerelease: false

# ++++++ World ++++++
SpikeCodeRedeemAutoEvents:
    type: world
    debug: false
    events:
        #- Check if core script is loaded
        on server start:
            - if <server.has_flag[SpikehiddenUpdater]>:
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Spikehidden's Auto Updater has been found!" to_console
                - flag server SpikeCodeRedeemAutoUpdate:github
                - flag server SpikehiddenUpdater.data:->:SpikeCodeRedeemAutoUpdate
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Providing Update data of Auto Generate Addon for Spikehidden's Auto Updater" to_console
        after server start:
            - if <server.has_flag[SpikeCodeRedeem]>:
                - flag server SpikeCodeRedeem.addon.autogenerate
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Add-On <&dq>Auto Generate Codes<&dq> is loaded." to_console
            - else:
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Add-On <&dq>Auto Generate Codes<&dq> can't be used without core script." to_console
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Download core script from https://github.com/spikehidden/CodeRedeemScript" to_console

        #-The actual magic happens here
        on system time hourly:
            - define interval <script[SpikeCodeRedeemData].data_key[auto.interval]>
            # Check if an interval was set and if not throw an error to the console.
            - if <[interval]> == null:
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r There isn't an intervall specified for the auto generate feature." to_console
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Please check the <&dq>SpikeCodeRedeem-Config.dsc<&dq> in your Denizen Script directory" to_console
            # Check if the hour flag already exists.
            - if !<server.has_flag[spikeCodeRedeem.auto.hour]>:
                - flag server spikeCodeRedeem.auto.hour:0

            - define hour <server.flag[spikeCodeRedeem.auto.hour]>
            - if <[hour]> >= <[interval]>:
                - define code <script[SpikeCodeRedeemData].data_key[auto.code].if_null[null]>
                - define prefix <script[SpikeCodeRedeemData].data_key[auto.prefix].if_null[none]>
                - define amount <script[SpikeCodeRedeemData].data_key[auto.amount].if_null[null]>
                - define command <script[SpikeCodeRedeemData].data_key[auto.commands].if_null[null]>
                - define delete <script[SpikeCodeRedeemData].data_key[auto.delete].if_null[null]>
                - if <[code]> == null || <[prefix]> == null || <[amount]> == null || <[command]> == null || <[delete]> == null:
                    - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Couldn't auto generate Code. There are missing arguments in the config." to_console
                    - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Please check the <&dq>SpikeCodeRedeem-Config.dsc<&dq> in your Denizen Script directory" to_console
                    - stop
                # Delete old code
                - if <[delete]> && <server.has_flag[spikeCodeRedeem.auto.lastCode]>:
                    - define lastCode <server.flag[spikeCodeRedeem.auto.lastCode]>
                    - if <server.has_flag[redeemableCodes.<[lastCode]>]>:
                        - flag server redeemableCodes.<[lastCode]>:!
                        - flag server spikeCodeRedeem.auto.lastCode:!
                # Delete prefix if it's "none"
                - if <[prefix]> == none:
                    - define prefix:!
                # Inject code generator script.
                - inject SpikeCodeCreateCode
                - flag server spikeCodeRedeem.auto.lastCode:<[code]>

        #- Send current code to player on join.
        after player join permission:spikehidden.coderedeem.autocode:
            - if <server.has_flag[spikeCodeRedeem.auto.lastCode]>:
                - define interval <script[SpikeCodeRedeemData].data_key[auto.interval]>
                - define code <server.flag[spikeCodeRedeem.auto.lastCode]>
                - if <server.has_flag[redeemableCodes.<[code]>]>:
                    - narrate "The current <[interval]> hours code is <[code]>."