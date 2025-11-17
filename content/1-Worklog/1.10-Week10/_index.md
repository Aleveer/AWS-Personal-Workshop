---
title: "Week 10 Worklog"
weight: 2
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:
- Test, polish UI, and prepare for deployment.
- Add missing backend features and thoroughly test API & real-time.
- Finalize frontend UI and handle connection/state errors.
- Design AWS deployment architecture.
- Prepare API documentation and system diagrams.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material | Note |
| ---- | ---- | ---------- | --------------- | ------------------ | ---- |
| 2 | - Test backend: REST API and WebSocket (real-time).<br> | 11/10/2025 | 11/10/2025 | https://www.postman.com/ |  |
| 3 | - Finalize frontend UI.<br>- Implement error handling and reconnection logic. | 11/11/2025 | 11/11/2025 | |  |
| 4 | - Design AWS architecture:<br> • Frontend: S3 + CloudFront<br> • Backend: Serverless(AWS Lambda, Amazon API Gateway)<br> • Database: DynamoDB<br> • Real-time: WebSocket | 11/12/2025 | 11/12/2025 | AWS Architecture Icons<br>Draw.io / Lucidchart |  |
| 5 | - Prepare documentation:<br> • API docs (Swagger)<br> • Deployment guide | 11/13/2025 | 11/13/2025 | Swagger UI<br>C4-PlantUML |  |
| 6 | - Team review: review documents, diagrams, and local demo.<br>- Fix bugs, optimize performance (lazy loading, debounce).<br>- Prepare deployment scripts (Docker + AWS CLI). | 11/14/2025 | 11/14/2025 | |  |

### Week 10 Achievements:
- Backend stable and feature-complete:
  - 100% REST API coverage, WebSocket connection never drops.
- Frontend fully polished:
  - Beautiful, responsive UI and emoji support.
- Clear AWS architecture:
  - Detailed system diagram (frontend → CDN → backend → DB).
  - Services chosen for optimal cost and performance.
- Complete documentation:
  - Auto-generated API docs via Swagger.
  - Step-by-step deployment guide.
- All code reviewed and successfully tested locally with multiple users.
- Fully ready for AWS deployment.