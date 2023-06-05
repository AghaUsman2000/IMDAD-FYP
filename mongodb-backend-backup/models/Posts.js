const mongoose = require('mongoose');
const PostSchema = new mongoose.Schema({
    uid: {
      type: String,
      required: true
    },
    number: {
      type: String,
      required: true
    },
    quantity: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    description: {
      type: String
    },
    title: {
      type: String
    },
    long: {
      type: Number
    },
    lat: {
      type: Number
    },
    nid: {
      type: String
    },
    nname: {
      type: String
    },
    nnumber: {
      type: String
    },
    accepted: {
      type: Number
    }, imageFilePath: {
      type: String
    } // Save the image file path along with the other fields
  });
  const Posts = mongoose.model('Posts', PostSchema,'Posts');
  
  module.exports=Posts;