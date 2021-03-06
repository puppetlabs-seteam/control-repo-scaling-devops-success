# Bolt Demo Preparation Guide

After setting up a hydra environment for demo purposes, you'll need to perform the following to setup the Bolt demo.
Things may be slow if using default EC2 sizes with only 1 CPU for windows. Recommend using "t2.medium" for "studentwindows" and "t2.small" for "studentlinux" in your manifest.yaml.

You will need:
* Some form of workstation to perform the prep work (should work on Windows, Linux or Mac, tested on Mac)
* Bolt installed on said workstation
* git command line tools installed on said workstation
* RDP client for performing the demo
* A previously deployed hydra-based SE Demo environment

On your workstation do this prep work:
* git clone https://github.com/puppetlabs-seteam/control-repo-scaling-devops-success.git
* cd control-repo-scaling-devops-success
* Run the bolt plan to prepare your windows host
  * `bolt plan run roadshow::prep_boltdemo branch_name=<Your Branch Here> reboot_windows_hosts=<true|false> -u puppetinstructor -p '@Pupp3t1abs' --transport winrm --no-ssl`
  * if you want to use a different student vm for the demo, you can add the `demo_host_id` parameter to change the host (default is `demo_host_id=0`)

You should now have your windows host prepared for the demo. The demo will be performed via an RDP session to this host.

NOTE: for the demo, run a `bolt plan show` and a `bolt task show` before going live. This will preload things into memory and make things faster during the demo. 
There is a small pause when using bolt from windows in a new session (known issue), once bolt has run once it's faster going forward.

NOTE2: Reboot all your windows hosts before demo time to make sure there are no reboots pending, this will cause the demo to fail. (didn't have time to properly implement a test/fix for this). This can be done with `bolt command run 'shutdown /r /t 0' -n allwindows`
