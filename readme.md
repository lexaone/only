# Utility to set time to OnlyKey device

This little utility program set time to make onlykey (https://onlykey.io) generate Google Authentificator OTP codes
I borrowed the idea of this program from https://github.com/IGLOU-EU/onlyKeySetTime but translated to Ziglang
###Why I use zig:
- because I like Zig and first time I tried to interacting with existing C lib (hidapi).
- because I don't like Python even their ubiquity
- because I don't like size of Golang programs

##How to compile:
- install hidapi library:
	apt install libhidapi-dev
- clone this repository
- compile it 
	zig build -Drelease-small 
	strip zig-cache/bin/only

works on Linux mint 20.1 with hidapi ver 0.9.0+dfsg-1 installed
compiled with the latest ver of Zig (0.8.0-dev.1401+34ca6b7b4)
