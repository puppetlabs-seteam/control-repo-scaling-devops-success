Bolt Demo Preparation Guide
==========================

After setting up a hydra environment for demo purposes, you'll need to perform the following to setup the Bolt demo.
Things may be slow if using default EC2 sizes with only 1 CPU for windows. Recommend using "t2.medium" for "studentwindows" and "t2.small" for "studentlinux" in your manifest.yaml.

## You will need:
* Some form of workstation to perform the prep work (should work on Windows, Linux or Mac, tested on Mac)
* Bolt installed on said workstation
* git command line tools installed on said workstation
* RDP client for performing the demo
* A previously deployed hydra-based SE Demo environment

## On your workstation do this prep work:
* `git clone https://github.com/puppetlabs-seteam/control-repo-scaling-devops-success.git`
* `cd control-repo-scaling-devops-success`
* Get your **inventory.yaml** from #team-svcsport-chatter and drop it into `./Boltdir/modules/roadshow/files`
  * NOTE: This file is in the .gitignore, so you can't push it back up.
  * remove any duplicate entries that may be in that file (this happened on multiple apply/destory cycles with hydra)
  * Append the to your **inventory.yaml** the **supplemental-inventory.yaml** found in the `Boltdir` root
  * Update node entries in supplemental inventory structure to include Linux nodes from your existing node groups
  * One Linux host needs to be selected as the sole member of the **search_head** group and any number of Linux hosts, EXCEPT for the one used for **search_head** can be added to the **forwarders** group
  * Update **reg_email** to a valid email if you plan on doing the SSL part of the demo
  * Update **reg_fqdn** to the fqdn of the node you picked for **search_head** in the previous step
  * update the puppetinstructor password entries (multiple) to `'@Pupp3t1abs'`, with the single quotes intact.
  * change references to linux private key from `private-key: ~/.ssh/student.pem` to `private-key: Boltdir\\student.pem`
* Get your **student.pem** from **https://${your_branch}.classroom.puppet.com** and drop it into `./Boltdir/modules/roadshow/files`
  * NOTE: This file is in the .gitignore, so you can't push it back up. In fact \*.pem is in .gitignore for safety.
* Run the bolt plan to prepare your windows host
  * `bolt plan run roadshow::prep_boltdemo branch_name=${your_hydra_branch}`
  * if you want to use a different student vm for the demo, you can add the **demo_host_id** parameter to change the host (default is demo_host_id=0)

You should now have your windows host prepared for the demo. The demo will be performed via an RDP session to this host.

NOTE: for the demo, run a "bolt plan show" and a "bolt task show" before going live. This will preload things into memory and make things faster during the demo.
There is a small pause when using bolt from windows in a new session (known issue), once bolt has run once it's faster going forward.

NOTE2: Reboot all your windows hosts before demo time to make sure there are no reboots pending, this will cause the demo to fail. (didn't have time to properly implement a test/fix for this). This can be done with "bolt command run 'shutdown /r /t 0' -n allwindows"

## Running Splunk management w/ Bolt demo
* The purpose here is to illustrate how Bolt and existing Puppet ecosystem content can be used here to solve immediate problems without first investing all your time into understanding out Puppet Enterprise work but that by leveraging conent in this way you can easily grow over time into a fully managed PE environment without having to retool everything you've been doing up until now
* The initial run of the core **splunk_qd** is the whole enchilads, it will deploy a fresh installation of Splunk Enterprise onto the node you chose and configure a set of nodes to forward their logs to the newly deployed instance
  * `bolt plan run splunk_qd`
* You can now go to the **http://${your_chosen_host}.classroom.puppet.com:8000** and login with **user:** *admin* and **password:** *changeme*
* There will already be data in the instance that can be browsed but Puppet related addons will not be configured so save a dinve into Puppet Report Viewer for a later demo
* The next part of the demo is illustrating that Bolt can be used for more than just simple one time actions but even for complex changes over time
* Here we'll illustrate that with Bolt you can easily configure an existing Splunk Enterprise serve to be more production ready by enabling and provisioning a valid SSL certificate from Let's Encrypt for the Web UI
  * `bolt plan run splunk_qd manage_forwarders=false web_ssl=true` (we're only disabling forwarder management here to speed up the Bolt run)
* After running the previous command, your Splunk Enterprise instance will stop responding on **port:** *8000*
* The instance is now available at **https://${your_chosen_host}.classroom.puppet.com**
* After demonstrating that we can use Bolt to install new things and manage them over time, we close things off by showing people that we can do it on Windows too
  * `bolt plan run splunk_qd manage_search=false forwarder_group=allwindows` (this time we are not managing search to once again just speed up the Bolt run)
