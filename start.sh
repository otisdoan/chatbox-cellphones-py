#!/bin/bash
# FastAPI Server Starter Script
set -e

echo "🚀 Starting CellphoneS AI Service..."
echo "===================================="

# Change to script directory
cd "$(dirname "$0")"

# Check if virtual environment exists, create if not
if [ ! -d "venv" ]; then
    echo "📦 Virtual environment not found. Creating..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Check if requirements are installed
if [ ! -f "venv/.requirements_installed" ]; then
    echo "📥 Installing dependencies..."
    pip install --upgrade pip -q
    pip install -r requirements.txt
    touch venv/.requirements_installed
    echo "✅ Dependencies installed"
fi

# Kill any existing process on port 8000
echo "🔍 Checking port 8000..."
PID=$(lsof -ti:8000 2>/dev/null || echo "")
if [ ! -z "$PID" ]; then
    echo "⚠️  Port 8000 is in use by PID $PID. Killing..."
    kill -9 $PID 2>/dev/null || true
    sleep 1
    echo "✅ Port 8000 is now free"
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  Warning: .env file not found!"
    if [ -f ".env.example" ]; then
        echo "💡 You can copy .env.example to .env and configure it"
        echo "   cp .env.example .env"
    fi
fi

# Start FastAPI server
echo ""
echo "🚀 Starting FastAPI server on http://0.0.0.0:8000"
echo "📚 Swagger UI: http://localhost:8000/docs"
echo "❤️  Health: http://localhost:8000/chat/health"
echo ""
echo "Press CTRL+C to stop the server"
echo "===================================="
echo ""

python -m uvicorn app.main:app --reload --host 0.0.0.0 --port $PORT
