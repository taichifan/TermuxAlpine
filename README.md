# TermuxAlpine

#### _powered by_

![powered by Alpine](../master/docs/images/alpinelinux-logo.svg)

![Optional Text](../master/docs/images/ss.png)


This Termux bash setup shell script will attempt to set Alpine Linux up in your Termux environment.
This is modified from the Hax4us to use the latest version with changes suggested by user j16180339887.
The modifications are on the enhancements branch.  You can use uninstall as a parameter or
--termuxalpine-dir to specify the termuxalpine directory containing the finaltouchup.sh script.
I have also made replying Yes to continue a requirement. Installing gives an error with the trigger script, but
it appears that things are installed.

## _Steps For Installation_
1. First goto home directory
`cd $HOME`
2. Get the script
`curl -LO https://raw.githubusercontent.com/taichifan/TermuxAlpine/enhancements/TermuxAlpine.sh`
3. Execute the script
`bash TermuxAlpine.sh`
4. Reply Yes
5. Start Alpine
`startalpine`
6. For exit just execute
`exit`

## _Steps For First Time Use (Recommended)_
1. Update Alpine
`apk update`
2. Now you can install any package by
`apk add package_name`

## Size Comparision
Size  | Alpine  | Arch | Ubuntu
--- | --- | --- | ---
before installation | Around 1 MB 😱  | Around 400 MB | Around 35 MB
after installation | Around 80 MB | Around 2000 MB | Around 1200 MB

#### here is full usage details of apk https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management


Comments are welcome at https://github.com/taichifan/TermuxAlpine/issues ✍

Pull requests are welcome https://github.com/taichifan/TermuxAlpine/pulls ✍
