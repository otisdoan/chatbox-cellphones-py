#!/bin/bash
# FastAPI Server Background Starter Script
set -e

echo "🚀 Starting CellphoneS AI Service (Background Mode)..."
echo "===================================="

# Change to script directory
cd "$(dirname "$0")"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Run ./start.sh first to setup."
    exit 1
fi

# Kill any existing process on port 8000
PID=$(lsof -ti:8000 2>/dev/null || echo "")
if [ ! -z "$PID" ]; then
    echo "⚠️  Port 8000 is in use by PID $PID. Killing..."
    kill -9 $PID 2>/dev/null || true
    sleep 1
fi

# Activate virtual environment and start in background
echo "🔄 Starting server in background..."
source venv/bin/activate
nohup python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 > /tmp/fastapi.log 2>&1 &

# Get PID
sleep 2
NEW_PID=$(lsof -ti:8000 2>/dev/null || echo "")

if [ ! -z "$NEW_PID" ]; then
    echo "✅ Server started successfully!"
    echo "   PID: $NEW_PID"
    echo "   URL: http://localhost:8000"
    echo "   Logs: /tmp/fastapi.log"
    echo ""
    echo "📚 Swagger UI: http://localhost:8000/docs"
    echo "❤️  Health: http://localhost:8000/chat/health"
    echo ""
    echo "💡 To view logs: tail -f /tmp/fastapi.log"
    echo "💡 To stop: ./stop.sh or pkill -f uvicorn"
else
    echo "❌ Failed to start server. Check logs: tail /tmp/fastapi.log"
    exit 1
fi
