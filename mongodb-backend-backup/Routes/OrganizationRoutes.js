const express = require('express');
const router = express.Router();
const Organization = require('../models/Organizations');

// GET all organizations
router.get('/', async (req, res) => {
  try {
    const organizations = await Organization.find();
    res.json(organizations);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET a specific organization by ID
router.get('/:id', getOrganization, (req, res) => {
  res.json(res.organization);
});

// CREATE a new organization
router.post('/', async (req, res) => {
  try {
    const organization = new Organization(req.body);
    const newOrganization = await organization.save();
    res.status(201).json(newOrganization);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// UPDATE an organization
router.patch('/:id', getOrganization, async (req, res) => {
  try {
    const updates = req.body;
    Object.assign(res.organization, updates);
    const updatedOrganization = await res.organization.save();
    res.json(updatedOrganization);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// DELETE an organization
router.delete('/:id', getOrganization, async (req, res) => {
  try {
    await res.organization.remove();
    res.json({ message: 'Organization deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Middleware function to get a specific organization by ID
async function getOrganization(req, res, next) {
  try {
    const organization = await Organization.findById(req.params.id);
    if (!organization) {
      return res.status(404).json({ message: 'Organization not found' });
    }
    res.organization = organization;
    next();
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
}

module.exports = router;
