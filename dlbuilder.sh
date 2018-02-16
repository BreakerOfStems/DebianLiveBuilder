#!/bin/bash

echo "Debian ISO Builder Script."

echo "Getting required packages."
apt-get -y update
apt-get -y install debootstrap syslinux isolinux squashfs-tools genisoimage memtest86+ rsync

read -p "Enter project name: "
name=$REPLY

phase="0"
if [ -d "$HOME/DebianCustomISO/$name" ]; 
	then
		read -p "Project exists, do you wish to edit chroot and rebuild? y/n: "
		if [ $REPLY == 'y' ]; 
			then
				phase="1"
		fi
fi

if [ $phase == "0" ]; 
	then
		read -p "Enter architecture (i386,amd64,etc): "
		arch=$REPLY
		read -p "Enter Debian version (jessie,stretch,wheezy,etc): "
		version=$REPLY
		
		echo "Creating project folders."
		rm -r $HOME/DebianCustomISO/$name > /dev/null
		mkdir -pv $HOME/DebianCustomISO/$name/chroot/		
		mkdir -pv $HOME/DebianCustomISO/$name/image/{live,isolinux}
		
		echo "Generating file system."
		debootstrap --arch=$arch --variant=minbase $version $HOME/DebianCustomISO/$name/chroot/ http://ftp.us.debian.org/debian/
fi

if [ -f "$HOME/DebianCustomISO/$name/$name.setup" ];
	then
		cp -v $HOME/DebianCustomISO/$name/$name.setup $HOME/DebianCustomISO/$name/chroot/$name.sh
fi
cp -rv /etc/skel/* $HOME/DebianCustomISO/$name/chroot/etc/skel/
echo "Entering chroot environment.
If running a gui, you can use another terminal to
copy files and folders into the chroot environment.
Suggested steps:
	1. Set hostname for live system.
	2. Update package manager, install kernel.
	   Note you MUST install live-boot and systemd-sysv
	   along with the kernel, or your iso will not work.
	3. Install your desired software.
	4. Set root password.
Once done use 'exit' to exit the chroot environment and
continue building the image."
chroot $HOME/DebianCustomISO/$name/chroot/

if [ -d "$HOME/DebianCustomISO/$name/chroot/$name.sh" ];
	then
		rm $HOME/DebianCustomISO/$name/chroot/$name.sh
fi

read -p "Do you want to create iso image now? y/n: "
if [ $REPLY == 'y' ];
	then
		echo "Creating squashfs."
		rm -r $HOME/DebianCustomISO/$name/image/live/filesystem.squashfs
		mksquashfs $HOME/DebianCustomISO/$name/chroot/ $HOME/DebianCustomISO/$name/image/live/filesystem.squashfs -e boot
		
		echo "Copying necessary files."
		cp $HOME/DebianCustomISO/$name/chroot/boot/vmlinuz-* $HOME/DebianCustomISO/$name/image/live/vmlinuz1
		cp $HOME/DebianCustomISO/$name/chroot/boot/initrd.img-* $HOME/DebianCustomISO/$name/image/live/initrd1
		
		echo "UI menu.c32

		prompt 0
		menu title $name

		timeout 300

		label $name
		menu label ^$name
		menu default
		kernel /live/vmlinuz1
		append initrd=/live/initrd1 boot=live

		label hdt
		menu label ^Hardware Detection Tool (HDT)
		kernel hdt.c32
		text help
		HDT displays low-level information about the systems hardware.
		endtext

		label memtest86+
		menu label ^Memory Failure Detection (memtest86+)
		kernel /live/memtest" > $HOME/DebianCustomISO/$name/image/isolinux/isolinux.cfg
		
		cp /usr/lib/ISOLINUX/isolinux.bin $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/menu.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/hdt.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/ldlinux.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/libutil.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/libmenu.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/libcom32.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/lib/syslinux/modules/bios/libgpl.c32 $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /usr/share/misc/pci.ids $HOME/DebianCustomISO/$name/image/isolinux/ && \
		cp /boot/memtest86+.bin $HOME/DebianCustomISO/$name/image/live/memtest
		
		echo "Generating iso image..."
		genisoimage -rational-rock -volid $name -cache-inodes -joliet -hfs -full-iso9660-filenames -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -output $HOME/DebianCustomISO/$name/$name.iso $HOME/DebianCustomISO/$name/image/
		
		echo "Finished. You can find your iso at $HOME/DebianCustomISO/$name/$name.iso"		
fi
