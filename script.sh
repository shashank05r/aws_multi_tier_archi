#!/bin/bash
dnf update -y
dnf install -y httpd

sudo tee /var/www/html/index.html > /dev/null <<'HTML_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Nature Inspired Web Page</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0; padding: 0; box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }
    body, html {
      scroll-behavior: smooth;
    }
    .section {
      height: 100vh;
      background-size: cover;
      background-position: center;
      display: flex;
      justify-content: center;
      align-items: center;
      color: white;
      text-align: center;
      position: relative;
    }
    .overlay {
      background: rgba(0, 0, 0, 0.5);
      padding: 40px;
      border-radius: 12px;
      max-width: 600px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
    }
    h1 { font-size: 2.8rem; margin-bottom: 20px; }
    p  { font-size: 1.2rem; margin-bottom: 30px; }
    a.button {
      display: inline-block;
      padding: 12px 24px;
      background-color: #00c9a7;
      color: #fff;
      text-decoration: none;
      border-radius: 8px;
      font-weight: 600;
      transition: background 0.3s;
    }
    a.button:hover {
      background-color: #009f86;
    }
    .bg1 {
      background-image: url('https://web-page-bucket-ncpl.s3.us-east-1.amazonaws.com/handmade_downscaled_h_vqse01v83e_2000x2000__15732.jpg');
    }
    .bg2 {
      background-image: url('https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1600&q=80');
    }
  </style>
</head>
<body>

  <section class="section bg1">
    <div class="overlay">
      <h1>Welcome to Nature's Page 🌲</h1>
      <p>This site is deployed using a custom AMI with Terraform. Enjoy the green simplicity!</p>
      <a href="#section2" class="button">Scroll Down</a>
    </div>
  </section>

  <section class="section bg2" id="section2">
    <div class="overlay">
      <h1>Explore More Beauty 🌄</h1>
      <p>This second section highlights another amazing natural view. All automated with infrastructure as code!</p>
      <a href="#section1" class="button">Go Back</a>
    </div>
  </section>

</body>
</html>
HTML_EOF

systemctl enable httpd.service
systemctl start httpd.service
