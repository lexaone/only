# Utility to set time to OnlyKey device

This little utility program set time make onlykey (https://onlykey.io) generate Google Authentificator OTP codes.
I borrowed the idea of this program from https://github.com/IGLOU-EU/onlyKeySetTime but translated to Ziglang.
## Why I use Zig:
- because I like Zig and I first time tried to interacting with existing C lib (hidapi).
- because I don't like Python even their ubiquity (see onlykey-cli )
- because I don't like size of Golang programs(binary onlyKeySetTime is about 1.8 Mb size(!) instead of 5Kb of Zig binary

## How to build:
- install hidapi library:
```
	apt install libhidapi-dev
```
- clone this repository
- compile it: 
```
	zig build -Drelease-small ;
	strip zig-cache/bin/only #optional
```
## Works on Linux mint 20.1 with hidapi ver 0.9.0+dfsg-1 installed
## Compiled with the latest ver of Zig (0.8.0-dev.1401+34ca6b7b4)
