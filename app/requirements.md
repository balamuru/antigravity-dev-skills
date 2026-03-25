# Sample App Requirements

## Goal
Build a lightweight Express.js microservice that serves a basic "Hello Framework" JSON response to demonstrate an isolated scaffolded project.

## Constraints
- **Strict Isolation**: All code, configuration, dependency files (`package.json`), and logic MUST be strictly constrained to the `/app` directory. Do not modify files in the orchestrator repository root.
- **Port**: The service should run on port 3000.
- **Endpoint**: The `/` endpoint should return `{"status": "success", "message": "Hello Framework"}`.
