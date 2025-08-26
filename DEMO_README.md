# ComfyUI Port Conflict Fix Demo

This branch demonstrates the fix for desktop app port conflicts when other services are using the same port.

## The Problem

The ComfyUI desktop app can show content from other services (like Docker) when they occupy the same port, causing confusion for users.

## The Solution

Automatic port conflict detection that switches to a random available port when the requested port is in use.

## Quick Demo

### 1. Test Port Conflict Detection

```bash
# Run the test script to see port conflict detection in action
python test_port_conflict.py
```

### 2. Docker Demonstration

```bash
# Build both versions
docker build -f Dockerfile.master -t comfyui-master .
docker build -f Dockerfile.fix -t comfyui-fix .

# Run master version (will fail if port 8188 is occupied)
docker run --rm -p 8188:8188 comfyui-master

# Run fixed version (automatically handles port conflicts)
docker run --rm comfyui-fix
```

### 3. Manual Test

```bash
# Start a service on port 8188 to simulate conflict
python3 -m http.server 8188 &

# Run ComfyUI with the fix
python main.py --windows-standalone-build --cpu

# The fix will detect the conflict and use a random port
```

## Key Changes

1. **Port Conflict Detection** (`comfy/cli_args.py`):
   - Checks if requested port is available
   - Automatically switches to random port if occupied

2. **Port Logging** (`server.py`):
   - Logs the actual assigned port when using random allocation

3. **Test Coverage** (`tests-unit/comfy_test/folder_path_test.py`):
   - Tests port conflict detection behavior

## Results

- ✅ No more conflicts with other services
- ✅ Desktop app always connects to ComfyUI
- ✅ Backward compatible with existing setups
- ✅ Works on all platforms (macOS, Windows, Linux)