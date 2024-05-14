const express = require("express");
const app = express();
const port = process.env.PORT || 8000;

const pool = require("./database");

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

app.get("/habits", async (req, res) => {
  // const { userId } = req.session; // Assuming you have implemented user authentication
  const userId  = 1;
  try {
    const habits = await pool.query("SELECT * FROM habits WHERE user_id = $1", [
      userId,
    ]);
    res.json(habits.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Create a new habit
app.post("/habits", async (req, res) => {
  // const { userId } = req.session;
  const userId  = 1;
  const { name, targetDays } = req.body;
  try {
    const newHabit = await pool.query(
      "INSERT INTO habits (name, target_days, completed_days, user_id) VALUES ($1, $2, 0, $3) RETURNING *",
      [name, targetDays, userId]
    );
    res.json(newHabit.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Mark a habit as completed for the current day
app.post("/habits/:habitId/complete", async (req, res) => {
  // const { userId } = req.session;
  const userId  = 1;
  const { habitId } = req.params;
  try {
    const habit = await pool.query(
      "SELECT * FROM habits WHERE id = $1 AND user_id = $2",
      [habitId, userId]
    );
    if (habit.rows.length === 0) {
      return res.status(404).json({ error: "Habit not found" });
    }
    const updatedHabit = await pool.query(
      "UPDATE habits SET completed_days = completed_days + 1 WHERE id = $1 AND user_id = $2 RETURNING *",
      [habitId, userId]
    );
    res.json(updatedHabit.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Update a habit
app.put("/habits/:habitId", async (req, res) => {
  // const { userId } = req.session;
  const userId  = 1;
  const { habitId } = req.params;
  const { name, targetDays } = req.body;

  try {
    const habit = await pool.query(
      "SELECT * FROM habits WHERE id = $1 AND user_id = $2",
      [habitId, userId]
    );
    if (habit.rows.length === 0) {
      return res.status(404).json({ error: "Habit not found" });
    }

    const updatedHabit = await pool.query(
      "UPDATE habits SET name = $1, target_days = $2 WHERE id = $3 AND user_id = $4 RETURNING *",
      [name, targetDays, habitId, userId]
    );
    res.json(updatedHabit.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Delete a habit
app.delete("/habits/:habitId", async (req, res) => {
  // const { userId } = req.session;
  const userId  = 1;
  const { habitId } = req.params;

  try {
    const habit = await pool.query(
      "SELECT * FROM habits WHERE id = $1 AND user_id = $2",
      [habitId, userId]
    );
    if (habit.rows.length === 0) {
      return res.status(404).json({ error: "Habit not found" });
    }

    await pool.query("DELETE FROM habits WHERE id = $1 AND user_id = $2", [
      habitId,
      userId,
    ]);
    res.json({ message: "Habit deleted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
