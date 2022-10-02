# Utility to set time to OnlyKey device

This little utility program set time make onlykey (https://onlykey.io) generate Google Authentificator OTP codes.
I borrowed the idea of this program from https://github.com/IGLOU-EU/onlyKeySetTime but translated to ziglang.

One requirement of TOTP (Time-based One-time Password) is having the correct
If OnlyKey is used on a system where the OnlyKey app is not running it
will display “NOTSET” instead of the OTP code. Because OnlyKey has no battery
it requires an app to send it the correct time to be able to generate TOTP
codes. 


## Why I use Zig:
- because I like Zig and I first time tried to interacting with existing C lib (hidapi).
- because I don't like Python even their ubiquity (see onlykey-cli )
- because I don't like size of Golang programs(binary onlyKeySetTime is about 1.8 Mb size(!) instead of dozens Kb of Zig binary

## How to build:
- install hidapi library:
```
	apt install libhidapi-dev
```
- clone this repository
- compile it: 
```
	zig build 
	strip zig-out/bin/only
```
## how to install:
- copy executable from zig-out/bin/only to whatever you like (/usr/local/bin for example)
- put file 49-onlykey.rules from this repository to /etc/udev/rules.d
- correct this file to make sure proper path to only binary 
- udevadm control --reload-rules && udevadm trigger

## Works on Linux mint 20.1 with hidapi ver 0.9.0+dfsg-1 installed (may be in never versions)
## Compiled with the latest master branch ver of Zig (0.10.0-dev.80+042b770d6)
