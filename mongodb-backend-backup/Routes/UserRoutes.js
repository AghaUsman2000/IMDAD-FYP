const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const User = require('../models/Users');

// GET all users
router.get('/', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET a specific user by ID
router.get('/:id', getUser, (req, res) => {
  res.json(res.user);
});

// CREATE a new user
router.post('/', async (req, res) => {
  const user = new User({
    name: req.body.name,
    email: req.body.email,
    password: req.body.password
  });

  try {
    const newUser = await user.save();
    res.status(201).json(newUser);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// UPDATE a user
router.post('/update', async (req, res) => {
    const id = req.body.id;
    const updates = req.body;

  try {
    const updatedUser = await User.findOneAndUpdate({ uid:id }, updates, { new: true });
    res.json(updatedUser);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// DELETE a user
router.delete('/:id', getUser, async (req, res) => {
  try {
    await res.user.remove();
    res.json({ message: 'User deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Middleware function to get a specific user by ID
async function getUser(req, res, next) {
  let user;
  const id = req.params.id;
  try {
    user = await User.findById(id);
    if (user == null) {
      return res.status(404).json({ message: 'Cannot find user' });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.user = user;
  next();
}

module.exports = router;
