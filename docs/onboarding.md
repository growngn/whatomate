# Developer Onboarding

## Quick Start
1. Clone the repo: `git clone https://github.com/shridarpatil/whatomate.git`
2. Install Go and Node.js
3. Run `make run-migrate` for backend
4. `cd frontend && npm install && npm run dev` for frontend
5. Access at http://localhost:8080

## Important Commands
- Build: `make build-prod`
- Test: `npm run test` (frontend), `go test` (backend)
- Lint: ESLint for frontend, go vet for backend