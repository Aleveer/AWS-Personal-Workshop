---
title: "Week 9 Worklog"
weight: 1
chapter: false
pre: " <b> 1.9. </b> "
---

### Week 9 Objectives:
- Set up a complete local development environment.
- Build a monorepo project structure with Vue.js (frontend) and Nest.js (backend).
- Develop a basic chat interface and real-time connection.
- Build WebSocket backend, manage messages and users.
- Design MongoDB schema and Dockerize the entire application.
- Run local tests with Docker Compose, ensure real-time chat works.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material | Note |
| ---- | ---- | ---------- | --------------- | ------------------ | ---- |
| 2 | - Set up local development environment: Node.js, MongoDB, Docker, VS Code.<br>- Initialize monorepo with 2 apps: frontend (Vue.js), backend (Nest.js). | 11/03/2025 | 11/03/2025 | - https://doc.vueframework.com/ <br> - https://docs.nestjs.com/ |  |
| 3 | - Develop Vue.js frontend: basic chat UI (login, room list, chat box).<br>- Integrate Socket.IO client to send/receive real-time messages. | 11/04/2025 | 11/04/2025 | https://socket.io/docs/v4  |  |
| 4 | - Develop Nest.js backend: WebSocket gateway, message service, user controller, etc.<br>- Handle user connections, broadcast messages by room. | 11/05/2025 | 11/05/2025 | |  |
| 5 | - Design MongoDB schema: collections for users, rooms, messages, etc.<br>- Connect Mongoose in Nest.js, perform message CRUD. | 11/06/2025 | 11/06/2025 | | Database modeling |
| 6 | - Dockerize the application: Dockerfile for frontend, backend, mongo.<br>- Write docker-compose.yml to run the full stack locally.<br>- Test real-time chat across multiple tabs/users. | 11/07/2025 | 11/07/2025 | | Containerization & local run |

### Week 9 Achievements:
- Completed local development environment:
  - Monorepo runs smoothly with Vue.js frontend and Nest.js backend.
  - IDE, Git, Docker fully ready.
- Basic chat interface operational:
  - Login, room selection, send/receive real-time messages.
  - Responsive UI, state management with Pinia.
- Nest.js backend handles WebSocket stably:
  - Manages user connections and chat rooms.
  - Accurate message broadcasting, no data loss.
- Well-designed MongoDB schema:
  - Stores user, room, message with optimized indexes.
  - Message CRUD via API and WebSocket.
- Successfully Dockerized:
  - 3 containers: vue-frontend, nest-backend, mongo-db.
  - docker-compose up runs the entire local system.
- Real-time chat works across multiple users:
  - Tested with 3–5 tabs/browsers, instant message sync.