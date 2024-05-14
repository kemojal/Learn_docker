const express = require("express");
const app = express();
const port = 8000;

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

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
