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
# @script-version 1.2
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

# ++++++ World ++++++
SpikeCodeRedeemWizebotSystem:
    type: world
    debug: true
    events:
        #- Check if core script is loaded
        on scripts loaded:
            - if <server.has_flag[SpikehiddenUpdater]>:
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Spikehidden's Auto Updater has been found!" to_console
                - flag server SpikeCodeRedeemAutoUpdate:github
                - flag server SpikehiddenUpdater.data:->:SpikeCodeRedeemAutoUpdate
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Providing Update data of Auto Generate Addon for Spikehidden's Auto Updater" to_console
        after scripts loaded:
            - if <server.has_flag[SpikeCodeRedeem]>:
                - define port <script[SpikeCodeRedeemData].data_key[wizebot.web.port]>
                - flag server SpikeCodeRedeem.addon.wizebot
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Add-On <&dq>Wizebot<&dq> is loaded." to_console
                - webserver start port:<[port]>
            - else:
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Add-On <&dq>Wizebot<&dq> can't be used without core script." to_console
                - announce "<&ss>9[SpikeCodeRedeem]<&ss>r Download core script from https://github.com/spikehidden/CodeRedeemScript" to_console

SpikeCodeRedeemWizebotAPI:
    type: world
    debug: true
    events:
        on webserver web request method:post path:/wizebot/create:
            # Get query parameters
            - define query <context.query>
            - define code <[query].get[code].if_null[random]>
            - define queryKey <[query].get[key].if_null[null]>
            - define duration <[query].get[duration].if_null[unlimited]>
            - define prefix <[query].get[prefix].if_null[<empty>]>
            - define group <[query].get[group].if_null[null]>

            #headers
            - define heads <context.headers>
            - define type <[heads].get[content-type].get[1]>
            - define boundary <[type].replace_text[multipart/form-data; boundary=]>

            # Map POST parameters:
            - define prepost <context.body.replace_text[Content-Disposition: form-data; name=<&dq>]>
            - define prepost <[prepost].split[<&chr[000D]><&chr[000A]>]>
            - define prepost <[prepost].separated_by[]>
            - define post_list <[prepost].split[--<[boundary]>].remove[first].remove[last]>
            - define post <[post_list].to_map[<&dq>]>
            - define item_id <[post].get[item_id].if_null[null]>
            - define item_name <[post].get[item_name].if_null[null]>
            - define viewer_id <[post].get[item_id].if_null[null]>
            - define viewer_name <[post].get[item_id].if_null[null]>

            # Get stuff from config
            - define key <script[SpikeCodeRedeemData].data_key[wizebot.api.key].if_null[none]>
            - define mode <script[SpikeCodeRedeemData].data_key[wizebot.shop.mode].if_null[ID]>
            - define groupList <script[SpikeCodeRedeemData].data_key[wizebot.shop.groups].if_null[none]>

            # If key is missing, invalid or not configerured send 401 ERROR
            - if <[key]> == none || <[queryKey]> != <[key]>:
                - define answer "UNAUTHORIZED - KEY IS MISSING OR INVALID"
                - determine code:401 passively
                - determine headers:[Content-Type=text/plain] passively
                - determine RAW_TEXT_CONTENT:<[answer]>

            # If nothing is set up in the Config send KO status and ERROR
            - if <[groupList]> == none:
                - define text "Configuration Error! - Please tell the Streamer that something went wrong."
                - define status KO
                - definemap answer:
                    status: <[status]>
                    text_to_return: <[text]>
                - determine code:200 passively
                - determine headers:[Content-Type=application/json] passively
                - determine RAW_TEXT_CONTENT:<[answer].to_json>

            # Get group if in ID mode
            - if <[mode]> == ID:
                - foreach <[groupList]>:
                    - if <[value].get[ids].contains_text[<[item_id]>]>:
                        - define group <[key]>
                        - foreach stop

            # Get group Data
            - define groupData <script[SpikeCodeRedeemData].data_key[wizebot.shop.groups.<[group]>].if_null[none]>
            - define randomAmount <[groupData].deep_get[commands.amount].if_null[0]>
            - define random <[groupData].deep_get[commands.random].if_null[null]>
            - define always <[groupData].deep_get[commands.always].if_null[none]>

            # Add always commands.
            - if <[always]> != none:
                - define commands <[always].as[list]>

            # Choose radnom commands.
            - if <[randomAmount]> >= 1 && <[random]> != null:
                - define commands:->:<[random].random[<[randomAmount]>]>

            # If commands are empty run error.
            - if <[commands].if_null[<list>].is_empty>:
                - define text "Configuration Error! - Please tell the Streamer that something went wrong."
                - define status KO
                - definemap answer:
                    text_to_return: <[text]>
                    status: <[status]>
                - determine code:200 passively
                - determine headers:[Content-Type=application/json] passively
                - determine RAW_TEXT_CONTENT:<[answer].to_json>

            #Inject Code Creation Task
            - define amount 1
            - define permission null
            - inject SpikeCodeCreateCode

            # Finaly send the code to Wizebot
            - definemap answer:
                text_to_return: Your code for Foxcraft is: <[code]>
                status: OK
            - determine passively code:200
            - determine passively headers:[Content-Type=application/json]
            - determine RAW_TEXT_CONTENT:<[answer].to_json>

