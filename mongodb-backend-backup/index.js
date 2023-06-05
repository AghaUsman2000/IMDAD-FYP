const fs = require('fs');
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (authHeader) {
    const token = authHeader.split(' ')[1];
    jwt.verify(token, 'your_secret_key', (err, user) => {
      if (err) {
        return res.sendStatus(403);
      }
      req.user = user;
      next();
    });
  } else {
    res.sendStatus(401);
  }
};

const MongoClient = require('mongodb').MongoClient;
mongoose.connect('mongodb+srv://MASINNERX:KfU4xdm3irxtJTVx@cluster0.3ihlz.mongodb.net/FOOD_WASTAGE?retryWrites=true&w=majority', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() =>{ console.log('Connected to MongoDB');
  
  //console.log("hi")
  mongoose.connection.db.listCollections().toArray(function(err, collections) {
    if (err) {
      console.error('Error listing collections:', err);
      mongoose.connection.close();
      return;
    }
    console.log('Collections in the database:');
    collections.forEach(function(collection) {
      console.log(collection.name);
    });
  
  });

})
  .catch((err) => console.error('Failed to connect to MongoDB', err));

  
 

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


// async function connectToDatabase() {
//     const uri = "mongodb+srv://MASINNERX:KfU4xdm3irxtJTVx@cluster0.3ihlz.mongodb.net/?retryWrites=true&w=majority"; // replace with your own MongoDB URI
//     const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
  
//     try {
//       await client.connect(); // connect to the database
//       console.log('Connected to database');
//       return client.db("FOOD_WASTAGE"); 
//       } 
//       catch (err) {
//       console.log('Error connecting to database', err);
//       throw err;
//     }
//   }


  //connectToDatabase();
const PostRoutes = require('./Routes/PostRoutes');
const UserRoutes = require('./Routes/UserRoutes');
const RiderRoutes =require('./Routes/RiderRoutes');
const OrganizationRoutes =require('./Routes/OrganizationRoutes');

// Configure middleware to parse JSON and handle CORS
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept'
  );
  res.setHeader(
    'Access-Control-Allow-Methods',
    'GET, POST, PATCH, DELETE, OPTIONS'
  );
  next();
});

app.get("/",(req,res) =>{
    // console.log('hi');
    res.json({message: "Hello, World!"})
});
// Use API routes
app.use('/api/posts', PostRoutes);
app.use('/api/user', UserRoutes);
app.use('/api/Rider', RiderRoutes);
app.use('/api/Organization', OrganizationRoutes);

// Start server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});