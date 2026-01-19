# System Architecture

## Overview
Whatomate is a WhatsApp Business Platform with backend in Go and frontend in Vue.js.

## Components
- Backend: API server, workers for processing
- Frontend: Vue.js SPA
- Database: PostgreSQL for data, Redis for caching
- External: WhatsApp API, AI providers

## API Endpoints
- /api/accounts
- /api/messages
- /api/templates
- /api/campaigns
- /api/chatbot
- See docs/api-reference/ for details