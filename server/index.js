const express = require('express');
const nodemailer = require('nodemailer');
const bodyParser = require('body-parser');
const cors=require('cors');
require('dotenv').config();

const app = express();
const OTP_STORE = {}; // Store OTPs in memory


// Middleware to parse JSON and URL-encoded requests
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(cors());

// POST endpoint to send OTP to the user's email
app.post('/send-otp', async (req, res) => {
  const { email } = req.body;
  
  if (!email) {
    return res.status(400).send('Email is required');
  }

  // Generate a random 6-digit OTP
  const otp = Math.floor(100000 + Math.random() * 900000);

  // Store the OTP in memory for 5 minutes
  OTP_STORE[email] = { otp, expiresAt: Date.now() + 5 * 60 * 1000 }; // OTP expires in 5 minutes

  // Set up the transporter (using Gmail here, but you can use any SMTP service)
  let transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465, // Use 465 for SSL or 587 for TLS
    secure: true, // True for SSL (port 465)
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_PASS,
    },
    tls: {
      rejectUnauthorized: false, // Allows self-signed certificates (not recommended in production)
    },
  });
  

  // Define the email content
  let mailOptions = {
    from: process.env.GMAIL_USER,
    to: email,
    subject: 'Your OTP Code',
    text: `Your OTP code is ${otp}`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log('OTP sent to:', email);
    res.status(200).json({ message: 'OTP sent successfully' }); // Use .json() to send a JSON response
  } catch (error) {
    console.error('Error sending OTP:', error);
    res.status(500).json({ message: 'Failed to send OTP' }); // Return error message in JSON format
  }
  
});

// POST endpoint to verify OTP
app.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).send('Email and OTP are required');
  }

  // Check if the OTP exists and is valid
  if (!OTP_STORE[email]) {
    return res.status(400).send('No OTP sent for this email');
  }

  const storedOtp = OTP_STORE[email].otp;
  const expiresAt = OTP_STORE[email].expiresAt;

  // Check if the OTP has expired
  if (Date.now() > expiresAt) {
    delete OTP_STORE[email]; // Remove the expired OTP
    return res.status(400).send('OTP has expired');
  }

  // Verify if the OTP matches
  if (parseInt(otp) === storedOtp) {
    delete OTP_STORE[email]; // OTP verified, so delete it
    res.status(200).send('OTP verified successfully');
  } else {
    res.status(400).send('Invalid OTP');
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
