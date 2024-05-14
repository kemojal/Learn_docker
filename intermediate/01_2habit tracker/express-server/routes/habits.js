const express = require('express');
const router = express.Router();
const pool = require('../database');

// Get all habits for a user
router.get('/', async (req, res) => {
  const userId = req.userId; // Assuming you have implemented user authentication
  try {
    const habits = await pool.query('SELECT * FROM habits WHERE user_id = $1', [userId]);
    res.json(habits.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create a new habit
router.post('/', async (req, res) => {
  const userId = req.userId;
  const { name, targetDays } = req.body;
  try {
    const newHabit = await pool.query(
      'INSERT INTO habits (name, target_days, completed_days, user_id) VALUES ($1, $2, 0, $3) RETURNING *',
      [name, targetDays, userId]
    );
    res.json(newHabit.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Mark a habit as completed for the current day
router.post('/:habitId/complete', async (req, res) => {
  const userId = req.userId;
  const { habitId } = req.params;
  try {
    const habit = await pool.query('SELECT * FROM habits WHERE id = $1 AND user_id = $2', [habitId, userId]);
    if (habit.rows.length === 0) {
      return res.status(404).json({ error: 'Habit not found' });
    }
    const updatedHabit = await pool.query(
      'UPDATE habits SET completed_days = completed_days + 1 WHERE id = $1 AND user_id = $2 RETURNING *',
      [habitId, userId]
    );
    res.json(updatedHabit.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update a habit
router.put('/:habitId', async (req, res) => {
  const userId = req.userId;
  const { habitId } = req.params;
  const { name, targetDays } = req.body;

  try {
    const habit = await pool.query('SELECT * FROM habits WHERE id = $1 AND user_id = $2', [habitId, userId]);
    if (habit.rows.length === 0) {
      return res.status(404).json({ error: 'Habit not found' });
    }

    const updatedHabit = await pool.query(
      'UPDATE habits SET name = $1, target_days = $2 WHERE id = $3 AND user_id = $4 RETURNING *',
      [name, targetDays, habitId, userId]
    );
    res.json(updatedHabit.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete a habit
router.delete('/:habitId', async (req, res) => {
  const userId = req.userId;
  const { habitId } = req.params;

  try {
    const habit = await pool.query('SELECT * FROM habits WHERE id = $1 AND user_id = $2', [habitId, userId]);
    if (habit.rows.length === 0) {
      return res.status(404).json({ error: 'Habit not found' });
    }

    await pool.query('DELETE FROM habits WHERE id = $1 AND user_id = $2', [habitId, userId]);
    res.json({ message: 'Habit deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;