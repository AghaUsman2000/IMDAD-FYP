const mongoose = require('mongoose');

//const Schema = mongoose.Schema;

const organizationSchema = new   mongoose.Schema({
  description: {
    type: String
  
  },
  image: {
    type: String
  },
  lat: {
    type: Number
  },
  long: {
    type: Number
  },
  name: {
    type: String
  }
});

const Organizations = mongoose.model('Organizations', organizationSchema,'Organizations');

module.exports = Organizations;
