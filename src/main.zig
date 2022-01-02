//!This little utility program set time to make onlykey (https://onlykey.io) generate Google Authentificator OTP codes
//! I borrowed the idea of this program from https://github.com/IGLOU-EU/onlyKeySetTime but translated to Ziglang

const std = @import("std");
const builtin = std.builtin;

const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
// we depends on hidapi library https://github.com/libusb/hidapi
// work for me with linux hidraw implementation!!! need to link libhidapi-hidraw.so.0
const c = @cImport({
    @cInclude("hidapi/hidapi.h");
});

//function open usb device and set current time
//@param devpath - device file to open
//@return - nothing 
fn setTime(devpath: [*:0]u8) anyerror!void {

    //first 5 bytes is the header
    var data = [_]u8{ 255, 255, 255, 255, 228, 0, 0, 0, 0, 0, 0, 0, 0 };
    var timedata = [_]u8{ 0, 0, 0, 0, 0, 0, 0, 0 };
    var curr_time: u64 = 0;
    var device_handle: ?*c.hid_device = null;
    curr_time = @bitCast(u64, std.time.timestamp());
    //linux x64: we need to use BigEndian, so @byteSwap is needed
    @memcpy(&timedata, @ptrCast([*]align(8) const u8, &@byteSwap(u64, curr_time)), 8);
    //shift 4 zero bytes
    @memcpy(data[5..], timedata[4..], 4);

    //try stdout.print("data is {any}\n", .{data});
    device_handle = c.hid_open_path(devpath);
    if (device_handle == null) {
        try stderr.print("Unable to open device {s}\n", .{devpath});
        std.os.exit(1);
    }
    defer c.hid_close(device_handle);

    if (c.hid_write(device_handle, &data, data.len) == 0) {
        try stderr.print("Unable to open device {s}\n", .{devpath});
        std.os.exit(1);
    }
}

pub fn main() anyerror!void {
    var res: c_int = 0;
    var devs: [*c]c.hid_device_info = undefined;
    var cur_dev: [*c]c.hid_device_info = undefined;
    res = c.hid_init();
    defer res = c.hid_exit();

    //usb vid and pid for onlykey (this is work for me, but you need to change it if you have different)
    devs = c.hid_enumerate(0x1d50, 0x60fc);
    defer c.hid_free_enumeration(devs);
    if (devs == null) {
        try stderr.print("Please check if the onlykey device connected!\n", .{});
        std.os.exit(1);
    }
    cur_dev = devs;
    while (cur_dev != null) {
        //    try stdout.print("Device Found\n  type: 0x{x} 0x{x}\n  path: {s}\n", .{ cur_dev.*.vendor_id, cur_dev.*.product_id, @ptrCast([*:0]u8, cur_dev.*.path) });
        //   try stdout.print("  Interface:    {d}\n", .{cur_dev.*.interface_number});
        //we need only interface 1 and 2
        if (cur_dev.*.interface_number == 1 or cur_dev.*.interface_number == 2) {
            try setTime(@ptrCast([*:0]u8, cur_dev.*.path));
        }
        cur_dev = cur_dev.*.next;
    }
}
