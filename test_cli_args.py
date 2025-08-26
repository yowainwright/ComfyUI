#!/usr/bin/env python3
import sys
import socket

# Simulate port 8188 being occupied
print("Testing with port 8188 occupied...")
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('', 8188))

# Now test CLI args
sys.argv = ["main.py", "--windows-standalone-build"]

# Enable args parsing before import
import comfy.options
comfy.options.enable_args_parsing()

# Import after setting argv and enabling parsing
import comfy.cli_args

print(f"Port assigned: {comfy.cli_args.args.port}")
print(f"Auto launch: {comfy.cli_args.args.auto_launch}")

if comfy.cli_args.args.port == 0:
    print("✅ Success: Automatically switched to random port due to conflict")
else:
    print("❌ Failed: Still trying to use occupied port")

sock.close()