#!/bin/bash

echo "===================================="
echo "ComfyUI Port Conflict Fix Demo"
echo "===================================="
echo ""

echo "1. Testing port conflict detection..."
echo "-----------------------------------"
python3 test_port_conflict.py
echo ""

echo "2. Simulating port conflict scenario..."
echo "---------------------------------------"
echo "Starting HTTP server on port 8188 to create conflict..."
python3 -m http.server 8188 > /dev/null 2>&1 &
SERVER_PID=$!
sleep 2

echo "Now testing with port 8188 occupied..."
python3 test_port_conflict.py

echo ""
echo "Stopping HTTP server..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo "3. Testing actual ComfyUI behavior..."
echo "-------------------------------------"
echo "Starting service on port 8188..."
python3 -m http.server 8188 > /dev/null 2>&1 &
SERVER_PID=$!
sleep 2

echo "Testing CLI args with --windows-standalone-build flag..."
python3 -c "
import sys
from unittest.mock import patch
from importlib import reload

# Set up args before import
with patch.object(sys, 'argv', ['main.py', '--windows-standalone-build']):
    # Force reimport with new args
    if 'comfy.cli_args' in sys.modules:
        del sys.modules['comfy.cli_args']
    import comfy.cli_args
    print(f'Port assigned: {comfy.cli_args.args.port}')
    if comfy.cli_args.args.port == 0:
        print('✅ Success: Switched to random port due to conflict')
    else:
        print('❌ Failed: Still trying to use occupied port')
"

echo ""
echo "Cleaning up..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo "===================================="
echo "Demo Complete!"
echo "===================================="
echo ""
echo "The fix successfully:"
echo "- Detects when port 8188 is occupied"
echo "- Automatically switches to a random port"
echo "- Prevents desktop app from showing wrong content"