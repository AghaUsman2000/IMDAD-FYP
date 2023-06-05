const express = require('express');
const router = express.Router();
const Riders = require('../models/Riders');

// GET all riders
router.get('/', async (req, res) => {
  try {
    const riders = await Riders.find();
    res.json(riders);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET a specific rider by ID
router.get('/:id', getRider, (req, res) => {
  res.json(res.rider);
});

// CREATE a new rider
router.post('/', async (req, res) => {
  const rider = new Riders({
    name: req.body.name,
    age: req.body.age,
    email: req.body.email,
    isRider: req.body.isRider,
    join_date: req.body.join_date,
    location: req.body.location,
    phone_number: req.body.phone_number,
    rating: req.body.rating,
    status: req.body.status,
    vehicle_number: req.body.vehicle_number,
    vehicle_type: req.body.vehicle_type
  });

  try {
    const newRider = await rider.save();
    res.status(201).json(newRider);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// UPDATE a rider
router.post('/update', async (req, res) => {
    const id = req.body.id;
    const updates = req.body;

  try {
    const updatedRider = await Riders.findOneAndUpdate({ _id: id }, updates, { new: true });
    res.json(updatedRider);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// DELETE a rider
router.delete('/:id', getRider, async (req, res) => {
  try {
    await res.rider.remove();
    res.json({ message: 'Rider deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Middleware function to get a specific rider by ID
async function getRider(req, res, next) {
  let rider;
  const id = req.params.id;
  try {
    rider = await Riders.findById(id);
    if (rider == null) {
      return res.status(404).json({ message: 'Cannot find rider' });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.rider = rider;
  next();
}

module.exports = router;
