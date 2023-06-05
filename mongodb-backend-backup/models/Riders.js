const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const RiderSchema = new Schema({
  age: {
    type: Number
  },
  email: {
    type: String
  },
  isRider: {
    type: Boolean
  },
  join_date: {
    type: Date
  },
  location: {
    type: [Number]
  },
  name: {
    type: String
  },
  phone_number: {
    type: String
  },
  rating: {
    type: Number
  },
  status: {
    type: String
  },
  vehicle_number: {
    type: String
  },
  vehicle_type: {
    type: String
  }
});

const Riders = mongoose.model('Riders', RiderSchema,'Riders');

module.exports = Riders;
