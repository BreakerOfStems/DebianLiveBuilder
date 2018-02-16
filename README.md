# DebianLiveBuilder
Bash script for the automation of building a Debian live iso

by Tristram Quinn

Based heavily on tutorial by Will Haley at willhaley.com

https://willhaley.com/blog/create-a-custom-debian-stretch-live-environment-ubuntu-17-zesty/

This is a perfect guide to the topic, and should be read to help understand what 
is happening in this script.

Description:

All the steps for making a Debian Live ISO combined into an easy to use script.  
You must use this in a Debian environment, as the tools are exclusive 
(to my knowledge). The script requires admin priviliges for some steps.

The script allows for you to return to a pre-existing project, and to rebuild
your ISO.  Customisation of the OS is done in the "chroot" phase.  It is much
akin to a regular Debian environment, if you are not familiar with the concept.

You MUST install live-boot, systemd-sysv and a linux kernel.  To find this
use "apt-cache search linux-image" in the "chroot" phase.

Requirements:

The following packages are required; debootstrap syslinux isolinux squashfs-tools genisoimage memtest86+ rsync
However, the script does attempt to install them for you.

Usage:

sudo bash dlbuilder.sh

or

su -c "bash dlbuilder.sh"

NOTE: If a bash script of desired commands at $HOME/DebianLiveBuild/[project name]/[project name].setup is present,
it will be copied into $HOME/DebianCustomISO/[project name]/chroot.  From here you can run bash [project name].sh
to run all the commands you desire.  This can be handy for instances where you need to create your desired build
from scratch repeatedly.
