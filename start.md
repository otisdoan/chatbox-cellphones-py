# Hướng Dẫn Start Dự Án CellphoneS AI Service

## 🚀 Cách Start Nhanh (Recommended)

### Bước 1: Chạy script start tự động

```bash
chmod +x start.sh
./start.sh
```

Script sẽ tự động:

- ✅ Kiểm tra và tạo virtual environment nếu chưa có
- ✅ Kích hoạt virtual environment
- ✅ Cài đặt dependencies từ requirements.txt
- ✅ Kiểm tra port 8000 và kill process cũ nếu cần
- ✅ Start FastAPI server với auto-reload

---

## 📋 Cách Start Từng Bước (Manual)

### 1. Tạo Virtual Environment (chỉ lần đầu)

```bash
# Sử dụng Python 3.9, 3.10, hoặc 3.11
python3 -m venv venv
```

### 2. Kích hoạt Virtual Environment

```bash
# macOS/Linux
source venv/bin/activate

# Windows
venv\Scripts\activate
```

### 3. Cài đặt Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. Cấu hình Environment Variables

```bash
# Copy file mẫu
cp .env.example .env

# Chỉnh sửa .env với các thông tin cần thiết:
# - OPENROUTER_API_KEY: API key từ OpenRouter
# - QDRANT_URL: URL của Qdrant (mặc định: http://localhost:6333)
# - EXPRESS_API_URL: URL của Express API backend
```

### 5. Start Qdrant Vector Database (nếu chạy local)

```bash
docker run -d \
  --name qdrant \
  -p 6333:6333 \
  -p 6334:6334 \
  -v $(pwd)/qdrant_storage:/qdrant/storage \
  qdrant/qdrant
```

### 6. Seed Product Embeddings (chỉ lần đầu hoặc khi update products)

```bash
source venv/bin/activate
python scripts/seed_embeddings.py
```

### 7. Start FastAPI Server

```bash
# Development mode (auto-reload)
source venv/bin/activate
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Production mode (background)
source venv/bin/activate
nohup python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 > /tmp/fastapi.log 2>&1 &
```

---

## 🔧 Quản Lý Server

### Kiểm tra server đang chạy

```bash
# Kiểm tra process
ps aux | grep "uvicorn app.main" | grep -v grep

# Kiểm tra port
lsof -i :8000

# Test health endpoint
curl http://localhost:8000/chat/health
```

### Stop server

```bash
# Tìm và kill process
pkill -f "uvicorn app.main"

# Hoặc kill theo PID cụ thể
kill -9 <PID>
```

### Xem logs

```bash
# Nếu chạy với nohup
tail -f /tmp/fastapi.log

# Hoặc chạy server trực tiếp trong terminal để xem logs realtime
source venv/bin/activate
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## 📚 Endpoints API

### 1. Health Check

```bash
curl http://localhost:8000/chat/health
```

### 2. Chat Message

```bash
curl -X POST http://localhost:8000/chat/message \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Tôi muốn mua iPhone",
    "session_id": "test_123",
    "user_id": 1
  }'
```

### 3. Swagger UI (Giao diện test API)

```
http://localhost:8000/docs
```

### 4. ReDoc (API Documentation)

```
http://localhost:8000/redoc
```

---

## 🐛 Troubleshooting

### Lỗi: Port 8000 đã được sử dụng

```bash
# Tìm process đang dùng port 8000
lsof -i :8000

# Kill process
kill -9 <PID>

# Hoặc dùng lệnh này để tự động kill
lsof -ti:8000 | xargs kill -9
```

### Lỗi: Collection 'cellphones_products' không tồn tại

```bash
# Chạy lại seed script
source venv/bin/activate
python scripts/seed_embeddings.py
```

### Lỗi: ModuleNotFoundError

```bash
# Đảm bảo venv đã được activate
source venv/bin/activate

# Cài lại dependencies
pip install -r requirements.txt
```

### Lỗi: Qdrant connection failed

```bash
# Kiểm tra Qdrant đang chạy
docker ps | grep qdrant

# Nếu chưa chạy, start Qdrant
docker run -d \
  --name qdrant \
  -p 6333:6333 \
  -p 6334:6334 \
  -v $(pwd)/qdrant_storage:/qdrant/storage \
  qdrant/qdrant

# Kiểm tra kết nối
curl http://localhost:6333/collections
```

### Lỗi: OpenRouter API key không hợp lệ

```bash
# Kiểm tra file .env
cat .env | grep OPENROUTER_API_KEY

# Đảm bảo key đúng format: sk-or-v1-...
```

---

## 🔄 Workflow Hàng Ngày

### Start dự án (sau khi đã setup)

```bash
# 1. Start Qdrant (nếu dùng Docker local)
docker start qdrant

# 2. Start FastAPI server
./start.sh

# Hoặc manual:
source venv/bin/activate
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Stop dự án

```bash
# 1. Stop FastAPI
pkill -f "uvicorn app.main"

# 2. Stop Qdrant (tùy chọn)
docker stop qdrant
```

---

## 📦 Structure

```
cellphones-ai-service/
├── app/
│   ├── main.py              # FastAPI application
│   ├── config.py            # Configuration settings
│   ├── models/              # Pydantic models
│   ├── routes/              # API routes
│   └── services/            # Business logic
│       ├── embedding.py     # Sentence transformers
│       ├── vector_search.py # Qdrant client
│       ├── llm.py          # OpenRouter integration
│       └── rag.py          # RAG pipeline
├── scripts/
│   └── seed_embeddings.py   # Seed product data
├── qdrant_storage/          # Qdrant data (local)
├── requirements.txt         # Python dependencies
├── .env                     # Environment variables
├── start.sh                 # Start script
└── start.md                 # This file
```

---

## 💡 Tips

- **Development**: Dùng `--reload` để auto-restart khi code thay đổi
- **Production**: Chạy với `nohup` hoặc process manager như `supervisor`, `pm2`
- **Logs**: Luôn check logs khi có lỗi: `tail -f /tmp/fastapi.log`
- **Testing**: Dùng Swagger UI (`/docs`) để test API nhanh
- **Performance**: Qdrant và embedding model sẽ load lần đầu, sau đó cache lại

---

## 🚀 Quick Commands Cheat Sheet

```bash
# Start everything
./start.sh

# Check status
curl http://localhost:8000/chat/health

# Stop server
pkill -f uvicorn

# View logs
tail -f /tmp/fastapi.log

# Reseed data
python scripts/seed_embeddings.py

# Test chat
curl -X POST http://localhost:8000/chat/message \
  -H "Content-Type: application/json" \
  -d '{"message": "Tôi muốn mua điện thoại", "session_id": "test"}'
```

---

**Chúc bạn code vui vẻ! 🎉**
