#!/data/data/com.termux/files/usr/bin/bash -e
# Copyright ©2018 by Hax4Us. All rights reserved.  🌎 🌍 🌏 🌐 🗺
#
# https://hax4us.com
################################################################################

# colors

red='\033[1;31m'
yellow='\033[1;33m'
blue='\033[1;34m'
reset='\033[0m'


# Destination

DESTINATION=${HOME}/TermuxAlpine
[ -d $DESTINATION ] && rm -rf $DESTINATION
mkdir $DESTINATION
cd $DESTINATION

# Utility function for Unknown Arch

unknownarch() {
	printf "$red"
	echo "[*] Unknown Architecture :("
	printf "$reset"
	exit 1
}

# Utility function for detect system

checksysinfo() {
	printf "$blue [*] Checking host architecture ..."
	case $(getprop ro.product.cpu.abi) in
		arm64-v8a)
			SETARCH=aarch64
			;;
		armeabi|armeabi-v7a)
			SETARCH=armhf
			;;
		x86)
			SETARCH=x86
			;;
		x86_64)
			SETARCH=x86_64
			;;
		*)
			unknownarch
			;;
	esac
}

# Check if required packages are present

checkdeps() {
	printf "${blue}\n"
	echo " [*] Updating apt cache..."
	apt update -y &> /dev/null
	echo " [*] Checking for all required tools..."

	for i in proot bsdtar curl; do
		if [ -e $PREFIX/bin/$i ]; then
			echo "  • $i is OK"
		else
			echo "Installing ${i}..."
			apt install -y $i || {
				printf "$red"
				echo " ERROR: check your internet connection or apt\n Exiting..."
				printf "$reset"
				exit 1
			}
		fi
	done
}

# URLs of all possibls architectures

seturl() {
	ALPINE_VER=$(curl -s http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$SETARCH/latest-releases.yaml | grep -m 1 -o version.* | sed -e 's/[^0-9.]*//g' -e 's/-$//')
	if [ -z "$ALPINE_VER" ] ; then
		exit 1
	fi
	ALPINE_URL="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$SETARCH/alpine-minirootfs-$ALPINE_VER-$SETARCH.tar.gz"
}

# Utility function to get tar file

gettarfile() {
	printf "$blue [*] Getting tar file...$reset\n\n"
	seturl $SETARCH
	curl --progress-bar -L --fail --retry 4 -O "$ALPINE_URL"
	rootfs="alpine-minirootfs-$ALPINE_VER-$SETARCH.tar.gz"
}

# Utility function to get SHA

getsha() {
	printf "\n${blue} [*] Getting SHA ... $reset\n\n"
	curl --progress-bar -L --fail --retry 4 -O "${ALPINE_URL}.sha256"
}

# Utility function to check integrity

checkintegrity() {
	printf "\n${blue} [*] Checking integrity of file...\n"
	echo " [*] The script will immediately terminate in case of integrity failure"
	printf ' '
	sha256sum -c ${rootfs}.sha256 || {
		printf "$red Sorry :( to say your downloaded linux file was corrupted or half downloaded, but don't worry, just rerun my script\n${reset}"
		exit 1
	}
}

# Utility function to extract tar file

extract() {
	printf "$blue [*] Extracting... $reset\n\n"
	proot --link2symlink -0 bsdtar -xpf $rootfs 2> /dev/null || :
}

# Utility function for login file

createloginfile() {
	bin=${PREFIX}/bin/startalpine
	cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash -e
unset LD_PRELOAD
exec proot --link2symlink -0 -r ${HOME}/TermuxAlpine/ -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w $HOME /usr/bin/env -i HOME=/root TERM="$TERM" LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/sh --login
EOM

	chmod 700 $bin
}

# Utility function to touchup Alpine

finalwork() {
	[ ! -e ${FINALDIR}/finaltouchup.sh ] && curl --silent -LO https://raw.githubusercontent.com/Hax4us/TermuxAlpine/master/finaltouchup.sh
chmod +x ${FINALDIR}/finaltouchup.sh && ${FINALDIR}/finaltouchup.sh
}



# Utility function for cleanup

cleanup() {
	if [ -d $DESTINATION ]; then
		rm -rf $DESTINATION
	else
		printf "$red not installed so not removed${reset}\n"
		exit
	fi
	if [ -e $PREFIX/bin/startalpine ]; then
		rm $PREFIX/bin/startalpine
		printf "$yellow uninstalled :) ${reset}\n"
		exit
	else
		printf "$red not installed so not removed${reset}\n"
	fi
}

printline() {
	printf "${blue}\n"
	echo " #-----------------------------------------------#"
}

usage() {
	printf "$red Must be bash TermuxAlpine.sh [uninstall] or [--termuxalpine-dir (git dir of TermuxAlpine)]\n"
	exit 1
}

# Start
clear
EXTRAARGS="default"
if [[ ! -z "$1" ]]
	then
	EXTRAARGS=$1
	shift 1
fi
if [[ $EXTRAARGS = "uninstall" ]]
then
	cleanup
	exit
elif [[ $EXTRAARGS = "--termuxalpine-dir" ]]
then
	FINALDIR="$1"
	if [ ! -d $FINALDIR ]
	then
		printf "$red Directory doesn't exist or isn't a directory $FINALDIR. Exiting.\n"
		exit 1
	fi
elif ( $# -ge 1 )
then
	usage
else
	FINALDIR="$HOME"
fi
printf "\n${yellow} You are going to install Alpine in termux ;) Cool\n Only 1mb Yes to continue?"
read resp
if [ "$resp" != "Yes" ] ; then
	printf "$red Must choose Yes to install. Exiting.\n"
	exit 1
fi

checksysinfo
checkdeps
gettarfile
getsha
checkintegrity
extract
createloginfile

printf "$blue [*] Configuring Alpine For You ..."
cd; finalwork

printline
printf "\n${yellow} Now you can enjoy a very small (just 1 MB!) Linux environment in your Termux :)\n Don't forget to like my hard work for termux and many other things\n"
printline
printline
printf "\n${blue} [∆] My official email:${yellow}		lokesh@hax4us.com\n"
printf "$blue [∆] My website:${yellow}		https://hax4us.com\n"
printf "$blue [∆] My YouTube channel:${yellow}	https://youtube.com/hax4us\n"
printline
printf "$reset"
