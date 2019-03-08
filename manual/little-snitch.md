# Little Snitch

[Download](https://www.obdev.at/products/littlesnitch/download.html) and check integrity before installing.

```bash
codesign --verify -R="anchor apple generic and certificate leaf[subject.OU] = MLZF7K7B5R" ~/Downloads/LittleSnitch*.dmg
```

Install. Restart will be required.

**Preferences:**

* Alert
    * **Disable:** _Confirm with Return and Escape_
    * Detail Level: _Show Port and Protocol Details_
* Monitor
    * _Show data rates as numerical values_
    * _Show Helper XPC Processes_
* Security
    * **Disable:** _Ignore code signature for local network connections_
* Advanced
    * **Disable:** _Approve rules automatically_
    
**Rules:**

* Factory Rules: **Disable** all rules for _Any Process_
* Subscribe to rule groups (all or selected):
    * [Basic](https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Basic.lsrules)
 