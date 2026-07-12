# Party Server

REST API backend for the Party-Fun platform built with Node.js, Express, and MongoDB.

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express 5
- **Database**: MongoDB + Mongoose
- **Auth**: JWT (jsonwebtoken) + bcryptjs
- **Payments**: Stripe
- **Real-time**: Socket.io
- **File uploads**: Multer

## Setup

```bash
npm install
npm start
```

Server runs on `http://localhost:3000`.

## Configuration

Edit `config.js` to set your environment values:

```js
module.exports = {
  secret: '<jwt_secret>',
  ip: '<server_ip>',
  port: 3000,
  user_email: '<email>',
  pass_email: '<email_password>',
  user_db: '<mongo_username>',
  pass_db: '<mongo_password>',
};
```

## API Routes

| Prefix | Description |
|---|---|
| `POST /user/*` | Auth & user management |
| `GET/POST /product/*` | Product listing & management |
| `GET/POST /payment/*` | Payments (JWT required) |
| `POST /webhook` | Stripe webhook handler |
| `GET /open_image` | Serve uploaded images |
