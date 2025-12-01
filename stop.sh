#!/bin/bash
# FastAPI Server Stop Script

echo "🛑 Stopping CellphoneS AI Service..."
echo "===================================="

# Find and kill uvicorn process
PID=$(lsof -ti:8000 2>/dev/null || echo "")

if [ -z "$PID" ]; then
    echo "ℹ️  No server running on port 8000"
    exit 0
fi

echo "🔍 Found server process: PID $PID"
kill -9 $PID 2>/dev/null || true

# Wait and verify
sleep 1

# Check if really stopped
PID=$(lsof -ti:8000 2>/dev/null || echo "")
if [ -z "$PID" ]; then
    echo "✅ Server stopped successfully"
else
    echo "❌ Failed to stop server (PID: $PID still running)"
    exit 1
fi
