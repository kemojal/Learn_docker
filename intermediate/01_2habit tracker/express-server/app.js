const express = require("express");
const app = express();
app.use(express.json());
const usersRoutes = require("./routes/users");
const habitsRoutes = require("./routes/habits");
require("dotenv").config();
const port = process.env.PORT || 8000;

// const pool = require("./database");

// Mock data for products
const users = [
  { id: 1, name: "John" },
  { id: 2, name: "Alice" },
];

// Route to get all products
app.get("/users", (req, res) => {
  res.json(users);
});

app.get("/", (req, res) => {
  res.send("Hello, World! Habit tracker");
});

//Habit tracking routes (protected)
app.use("/api/habits", authenticateToken, habitsRoutes);

// User authentication routes
app.use("/api/users", usersRoutes);

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

app.get('*', function(req, res){
  res.send('what???', 404);
});

// Middleware function to authenticate JWT token
function authenticateToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ error: "Access denied. No token provided." });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(403).json({ error: "Invalid token" });
    }

    req.userId = decoded.userId;
    next();
  });
}
