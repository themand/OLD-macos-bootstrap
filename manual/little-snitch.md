# Little Snitch

[Download](https://www.obdev.at/products/littlesnitch/download.html) and check integrity before installing.

```bash
codesign -v --verify -R="anchor apple generic and certificate leaf[subject.OU] = MLZF7K7B5R" ~/Downloads/LittleSnitch*.dmg
```

Install. Restart will be required.
* Configure in Alert mode

**Preferences:**

* Alert
    * **Disable:** _Confirm with Return and Escape_
    * Detail Level: _Show Port and Protocol Details_
* Monitor
    * _Show data rates as numerical values_
    * _Show Helper XPC Processes_
* Security
    * _Allow global rule editing*
    * **Disable:** _Respect privacy of other users_ 
    * **Disable:** _Ignore code signature for local network connections_
* Advanced
    * **Disable:** _Approve rules automatically_
    
**Rules:**

* Subscribe to rule groups (all or selected, remember to set them as _Active_):

    * **Basic:** basic networking rules to allow computer connect to network using DHCP, allow DNS queries, allow Little Snitch updates and helper.<br />
    `https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Basic.lsrules`

    * **macOS:** required for macOS and iCloud services.<br />
    `https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/macOS.lsrules`

    * **Restricted Networking:** Disables NetBIOS, Multicast DNS (Bonjour), etc. Recommended to use if you don't need this features all the time and disable ruleset when you need to use them.<br /> 
    `https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Restricted%20Networking.lsrules`

    * **Google Chrome**<br />
    `https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Google%20Chrome.lsrules`

    * **Webstorm**<br />
    `https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Webstorm.lsrules`
    
* Factory Rules: **Disable** all rules for _Any Process_
* If enabled, disable subscriptions to both rule groups:
    * iCloud Services
    * macOS Services
