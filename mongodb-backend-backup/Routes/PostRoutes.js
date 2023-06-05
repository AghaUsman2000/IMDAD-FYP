const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Posts = require('../models/Posts')
const multer = require('multer');
const path = require('path');
const fs =require('fs');
//const posts = mongoose.model('posts',PostSchema);
//const posts = require('../models/PostSchema');

// GET all posts

function generateUniqueIdentifier() {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let identifier = '';
  for (let i = 0; i < 8; i++) {
    identifier += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return identifier;
}

router.get('/', async (req, res) => {
  try {

    const posts = await Posts.find();
    res.json(posts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET a specific post by ID
router.get('/new', getPost, (req, res) => {
  
  
 res.json(res.posts);
});


router.post('/update', async (req, res) => {
  const id = req.body.uid; // get the uid from the request parameters
  console.log(id);
  const updates = req.body; // get the updates from the request body
  try {

    
    const post = await Posts.findOneAndUpdate({ uid: id }, updates, { new: true });
    if (!post) {
      return res.status(404).send({ error: 'Post not found' });
    }
    res.send(post);
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: 'Server error' });
  }
});



const app = express();

// Set up the storage engine for multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './Public/images'); // Specify the destination directory for storing images
  },
  filename: function (req, file, cb) {
   //{uniqueIdentifier}_ const uniqueIdentifier = generateUniqueIdentifier(); // Generate a unique identifier for the file
    // const fileName = `${file.originalname}`; // Prepend the unique identifier to the original file name
    const uniqueIdentifier = generateUniqueIdentifier(); // Generate a unique identifier for the file
    const fileName = `${uniqueIdentifier}_${file.originalname}`; // Prepend the unique identifier to the original file name

    // Save the file name to a separate variable
    req.fileName = fileName;
    cb(null, fileName);
  }
});
const upload = multer({ storage: storage });

router.post('/', upload.single('image'), async (req, res) => {
  try {
    const { uid, number, quantity, name } = req.body;

    //description, title, long, lat, nid, nname, nnumber, accepted
    const imageFilePath = req.file.path; // File path of the uploaded image
   const newpath = "Public/images/"+req.fileName;
// imageFilePath

    // Save the fields, including the image file path and unique identifier, to the database
    const post = new Posts({
      uid,
      number,
      quantity,
      name,
      imageFilePath:newpath// Save the image file path along with the other fields
      //uniqueIdentifier // Save the unique identifier in the database
    });

    const newPost = await post.save();
    res.status(201).json(newPost);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});


// router.post('/', async (req, res) => {
//   try {
//     const { uid, number, quantity, name, description, title, long, lat, nid, nname, nnumber, accepted } = req.body;
    
//     const post = new Posts({
//       uid,
//       number,
//       quantity,
//       name,
//       description,
//       title,
//       long,
//       lat,
//       nid,
//       nname,
//       nnumber,
//       accepted
//     });

//     const newPost = await post.save();
//     res.status(201).json(newPost);
//   } catch (error) {
//     res.status(400).json({ message: error.message });
//   }
// //});

// Delete a post
router.delete('/:id', getPost, async (req, res) => {
  try {
    await res.post.remove();
    res.json({ message: 'Post deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
router.get('/image', (req, res) => {///:imageName
 // const imageName = req.params.imageName;
  const imagePath = path.join( __dirname,"../", "Public/images/0e0BLCSZ_45.jfif");
  console.log(imagePath);

  res.sendFile(imagePath);
});
// Middleware function to get a single post by ID

// Middleware function to get a specific post by ID
async function getPost(req, res, next) {
  let posts;
  const id = req.params.id;
  const uid =req.body.uid;
  const nid = req.body.nid;
  console.log(nid);
  
  try {
    if (!nid){
    posts = await Posts.find({uid:uid});}
    else{
      posts= await Posts.find({nid:nid});
    }//,}
    if (posts == null) {
      return res.status(404).json({ message: 'Cannot find post' });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }// Modify each post object to include the complete image file path and image data
  
  posts = posts.map((post) => {
    const imageFilePath = post.imageFilePath; // Assuming the imageFilePath is stored as "./Public/images/0e0BLCSZ_45.jfif"
    let imageData = null; // Default value for posts without imageFilePath

    if (imageFilePath) {
      imageData = fs.readFileSync(path.join("./", imageFilePath)); // Read the image data
    }
    return {
      ...post._doc,
      imageFilePath: post.imageFilePath,
      //imageFilePath: path.join('images', posts.imageFilePath), // Assuming the imageFilePath is stored as "images/fileName"
   
      imageData// Read the image data
    
  }});

  res.posts = posts;
  next();
  
}

module.exports = router;
