const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  uid:{ type: String },
  number: { type: String },
  name: { type: String},
  organisation: { type: String },
  email: { type: String},
  isngo: { type: Number, default: 0 },
  password:{ type: String}
});

const Users= mongoose.model('Users', UserSchema,'Users');

module.exports = Users;
