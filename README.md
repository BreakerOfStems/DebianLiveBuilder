# DebianLiveBuilder
Bash script for the automation of building a Debian live iso

by Tristram Quinn

Based heavily on tutorial by Will Haley at willhaley.com

https://willhaley.com/blog/create-a-custom-debian-stretch-live-environment-ubuntu-17-zesty/

This is a perfect guide to the topic, and should be read to help understand what 
is happening in this script.

All the steps for making a Debian Live ISO combined into an easy to use script.  
You must use this in a Debian environment, as the tools are exclusive 
(to my knowledge). The script requires admin priviliges for some steps.

The script allows for you to return to a pre-existing project, and to rebuild
your ISO.  Customisation of the OS is done in the "chroot" phase.  It is much
akin to a regular Debian environment, if you are not familiar with the concept.

You MUST install live-boot, systemd-sysv and a linux kernel.  To find this
use "apt-cache search linux-image" in the "chroot" phase.

Usage:

sudo bash dlbuilder.sh

or

su
bash dlbuilder.sh
