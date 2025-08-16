<!DOCTYPE html>
<!--
Template name: Nova
Template author: FreeBootstrap.net
Author website: https://freebootstrap.net/
License: https://freebootstrap.net/license
-->
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title> Nova Free Bootstrap Template for Agency &mdash; by FreeBootstrap.net </title>

  <!-- ======= Google Font =======-->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&amp;display=swap" rel="stylesheet">
  <!-- End Google Font-->

  <!-- ======= Styles =======-->
  <link href="/client/vendors/bootstrap/bootstrap.min.css" rel="stylesheet">
  <link href="/client/vendors/bootstrap-icons/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="/client/vendors/glightbox/glightbox.min.css" rel="stylesheet">
  <link href="/client/vendors/swiper/swiper-bundle.min.css" rel="stylesheet">
  <link href="/client/vendors/aos/aos.css" rel="stylesheet">
  <!-- End Styles-->

  <!-- ======= Theme Style =======-->
  <link href="/client/css/style.css" rel="stylesheet">
  <!-- End Theme Style-->

  <!-- ======= Apply theme =======-->
  <script>
    // Apply the theme as early as possible to avoid flicker
    (function () {
      const storedTheme = localStorage.getItem('theme') || 'light';
      document.documentElement.setAttribute('data-bs-theme', storedTheme);
    })();
  </script>
</head>

<body>


  <!-- ======= Site Wrap =======-->
  <div class="site-wrap">


    <!-- ======= Header =======-->
    <header class="fbs__net-navbar navbar navbar-expand-lg dark" aria-label="freebootstrap.net navbar">
      <div class="container d-flex align-items-center justify-content-between">


        <!-- Start Logo-->
        <a class="navbar-brand w-auto" href="index.html">
          <!-- If you use a text logo, uncomment this if it is commented-->
          <!-- Vertex-->

          <!-- If you plan to use an image logo, uncomment this if it is commented-->

          <!-- logo dark--><img class="logo dark img-fluid setanh" src="/client/image/logo-dark.svg"
            alt="FreeBootstrap.net image placeholder">

          <!-- logo light--><img class="logo light img-fluid" src="/client/image/logo-light.svg"
            alt="FreeBootstrap.net image placeholder">

        </a>
        <!-- End Logo-->

        <!-- Start offcanvas-->
        <div class="offcanvas offcanvas-start w-75" id="fbs__net-navbars" tabindex="-1"
          aria-labelledby="fbs__net-navbarsLabel">


          <div class="offcanvas-header">
            <div class="offcanvas-header-logo">
              <!-- If you use a text logo, uncomment this if it is commented-->

              <!-- h5#fbs__net-navbarsLabel.offcanvas-title Vertex-->

              <!-- If you plan to use an image logo, uncomment this if it is commented-->
              <a class="logo-link" id="fbs__net-navbarsLabel" href="index.html">


                <!-- logo dark--><img class="logo dark img-fluid" src="/client/image/logo-dark.svg"
                  alt="FreeBootstrap.net image placeholder">

                <!-- logo light--><img class="logo light img-fluid" src="/client/image/logo-light.svg"
                  alt="FreeBootstrap.net image placeholder"></a>

            </div>
            <button class="btn-close btn-close-black" type="button" data-bs-dismiss="offcanvas"
              aria-label="Close"></button>
          </div>

          <div class="offcanvas-body align-items-lg-center">


            <ul class="navbar-nav nav me-auto ps-lg-5 mb-2 mb-lg-0">
              <li class="nav-item"><a class="nav-link scroll-link active" aria-current="page" href="#home">Home</a></li>
              <li class="nav-item"><a class="nav-link scroll-link" href="#about">About</a></li>
              <li class="nav-item"><a class="nav-link scroll-link" href="#how-it-works">How It Works</a></li>
              <li class="nav-item"><a class="nav-link scroll-link" href="#testimonials">Testimonials</a></li>
              </li>
              <li class="nav-item"><a class="nav-link scroll-link" href="#contact">Contact</a></li>
            </ul>

          </div>
        </div>
        <!-- End offcanvas-->

        <div class="ms-auto w-auto">


          <div class="header-social d-flex align-items-center gap-1"><a class="btn btn-primary py-2" href="/auth/login">Get
              Started</a>

            <button class="fbs__net-navbar-toggler justify-content-center align-items-center ms-auto"
              data-bs-toggle="offcanvas" data-bs-target="#fbs__net-navbars" aria-controls="fbs__net-navbars"
              aria-label="Toggle navigation" aria-expanded="false">
              <svg class="fbs__net-icon-menu" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                viewbox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                stroke-linejoin="round">
                <line x1="21" x2="3" y1="6" y2="6"></line>
                <line x1="15" x2="3" y1="12" y2="12"></line>
                <line x1="17" x2="3" y1="18" y2="18"></line>
              </svg>
              <svg class="fbs__net-icon-close" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                viewbox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                stroke-linejoin="round">
                <path d="M18 6 6 18"></path>
                <path d="m6 6 12 12"></path>
              </svg>
            </button>

          </div>

        </div>
      </div>
    </header>
    <!-- End Header-->

    <!-- ======= Main =======-->
    <main>


      <!-- ======= Hero =======-->
      <section class="hero__v6 section" id="home">
        <div class="container">
          <div class="row">
            <div class="col-lg-6 mb-4 mb-lg-0">
              <div class="row">
                <div class="col-lg-11"><span class="hero-subtitle text-uppercase" data-aos="fade-up"
                    data-aos-delay="0">Innovative Fintech Solutions</span>
                  <h1 class="hero-title mb-3" data-aos="fade-up" data-aos-delay="100">Smart, Efficient, and
                    User-Friendly Calendar Management</h1>
                  <p class="hero-description mb-4 mb-lg-5" data-aos="fade-up" data-aos-delay="200">Organize your time
                    effortlessly with B-Smart Calendar — the smart, efficient, and user-friendly way to manage your
                    tasks, events, and appointments.</p>
                  <div class="cta d-flex gap-2 mb-4 mb-lg-5" data-aos="fade-up" data-aos-delay="300"><a class="btn"
                      href="#">Get Started Now</a><a class="btn btn-white-outline" href="#">Learn More
                      <svg class="lucide lucide-arrow-up-right" xmlns="http://www.w3.org/2000/svg" width="18"
                        height="18" viewbox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round">
                        <path d="M7 7h10v10"></path>
                        <path d="M7 17 17 7"></path>
                      </svg></a></div>
                </div>
              </div>
            </div>
            <div class="col-lg-6">
              <div class="hero-img"><img class="img-card img-fluid" src="/client/image/card-expenses.png"
                  alt="Image card" data-aos="fade-down" data-aos-delay="600"><img class="img-main img-fluid rounded-4"
                  src="/client/image/hero-img-1-min.jpg" alt="Hero Image" data-aos="fade-in" data-aos-delay="500"></div>
            </div>
          </div>
        </div>
        <!-- End Hero-->
      </section>
      <!-- End Hero-->

      <!-- ======= About =======-->
      <section class="about__v4 section" id="about">
        <div class="container">
          <div class="row">
            <div class="col-md-6 order-md-2">
              <div class="row justify-content-end">
                <div class="col-md-11 mb-4 mb-md-0"><span class="subtitle text-uppercase mb-3" data-aos="fade-up"
                    data-aos-delay="0">About us</span>
                  <h2 class="mb-4" data-aos="fade-up" data-aos-delay="100">B-Smart Calendar to help you organize tasks,
                    events, and appointments efficiently, reduce stress,
                    and boost productivity.</h2>
                  <div data-aos="fade-up" data-aos-delay="200">
                    <p>With a user-friendly interface and convenient features such as quick event creation, automatic
                      reminders, group calendar sharing, and cross-platform synchronization, B-Smart delivers a smooth
                      experience for both individuals and businesses.</p>
                    <p>Our mission is to help you manage your time more intelligently so you can spend more of it on
                      what truly matters.</p>
                  </div>
                  <h4 class="small fw-bold mt-4 mb-3" data-aos="fade-up" data-aos-delay="300">Key Values and Vision</h4>
                  <ul class="d-flex flex-row flex-wrap list-unstyled gap-3 features" data-aos="fade-up"
                    data-aos-delay="400">
                    <li class="d-flex align-items-center gap-2"><span class="icon rounded-circle text-center"><i
                          class="bi bi-check"></i></span><span class="text">Innovation</span></li>
                    <li class="d-flex align-items-center gap-2"><span class="icon rounded-circle text-center"><i
                          class="bi bi-check"></i></span><span class="text">Security</span></li>
                    <li class="d-flex align-items-center gap-2"><span class="icon rounded-circle text-center"><i
                          class="bi bi-check"></i></span><span class="text">User-Centric Design </span></li>
                    <li class="d-flex align-items-center gap-2"><span class="icon rounded-circle text-center"><i
                          class="bi bi-check"></i></span><span class="text">Transparency</span></li>
                    <li class="d-flex align-items-center gap-2"><span class="icon rounded-circle text-center"><i
                          class="bi bi-check"></i></span><span class="text">Empowerment</span></li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="img-wrap position-relative"><img class="img-fluid rounded-4"
                  src="/client/image/about_2-min.jpg" alt="FreeBootstrap.net image placeholder" data-aos="fade-up"
                  data-aos-delay="0">
                <div class="mission-statement p-4 rounded-4 d-flex gap-4" data-aos="fade-up" data-aos-delay="100">
                  <div class="mission-icon text-center rounded-circle"><i class="bi bi-lightbulb fs-4"></i></div>
                  <div>
                    <h3 class="text-uppercase fw-bold">Mission Statement</h3>
                    <p class="fs-5 mb-0">Our mission is to empower individuals and teams by providing a smart,
                      efficient, and user-friendly calendar platform that simplifies scheduling, enhances collaboration,
                      and boosts productivity.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- End About-->

      <!-- ======= How it works =======-->
      <section class="section howitworks__v1" id="how-it-works">
        <div class="container">
          <div class="row mb-5">
            <div class="col-md-6 text-center mx-auto"><span class="subtitle text-uppercase mb-3" data-aos="fade-up"
                data-aos-delay="0">How it works</span>
              <h2 data-aos="fade-up" data-aos-delay="100">How It Works</h2>
              <p data-aos="fade-up" data-aos-delay="200">Our platform is designed to make managing your finances simple
                and efficient. Follow these easy steps to get started: </p>
            </div>
          </div>
          <div class="row g-md-5">
            <div class="col-md-6 col-lg-3">
              <div class="step-card text-center h-100 d-flex flex-column justify-content-start position-relative"
                data-aos="fade-up" data-aos-delay="0">
                <div data-aos="fade-right" data-aos-delay="500"><img class="arch-line" src="/client/image/arch-line.svg"
                    alt="FreeBootstrap.net image placeholder"></div><span
                  class="step-number rounded-circle text-center fw-bold mb-5 mx-auto">1</span>
                <div>
                  <h3 class="fs-5 mb-4">Log in</h3>
                  <p>Access the website and log in with your account credentials to verify your identity and unlock all
                    calendar management features.</p>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="600">
              <div
                class="step-card reverse text-center h-100 d-flex flex-column justify-content-start position-relative">
                <div data-aos="fade-right" data-aos-delay="1100"><img class="arch-line reverse"
                    src="/client/image/arch-line-reverse.svg" alt="FreeBootstrap.net image placeholder"></div><span
                  class="step-number rounded-circle text-center fw-bold mb-5 mx-auto">2</span>
                <h3 class="fs-5 mb-4">Fixed Scheduling</h3>
                <p>Manually add recurring or fixed events (e.g., classes every Monday, meetings every Wednesday) to
                  ensure these activities are always in your calendar.
                </p>
              </div>
            </div>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="1200">
              <div class="step-card text-center h-100 d-flex flex-column justify-content-start position-relative">
                <div data-aos="fade-right" data-aos-delay="1700"><img class="arch-line"
                    src="/client/image/arch-line.svg" alt="FreeBootstrap.net image placeholder"></div><span
                  class="step-number rounded-circle text-center fw-bold mb-5 mx-auto">3</span>
                <h3 class="fs-5 mb-4">Auto-Scheduling</h3>
                <p>Provide your tasks, free time slots, and priorities. The system then applies intelligent algorithms
                  (EDF, Greedy, Interval Scheduling, etc.) to generate an optimal schedule, avoiding overlaps.
                </p>
              </div>
            </div>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="1800">
              <div class="step-card last text-center h-100 d-flex flex-column justify-content-start position-relative">
                <span class="step-number rounded-circle text-center fw-bold mb-5 mx-auto">4</span>
                <div>
                  <h3 class="fs-5 mb-4">Calendar Management</h3>
                  <p>View, edit, or delete events. All changes are automatically synchronized and stored for easy access
                    and updates anytime, anywhere.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- End How it works-->

      <!-- ======= Testimonials =======-->
      <section class="section testimonials__v2" id="testimonials">
        <div class="container">
          <div class="row mb-5">
            <div class="col-lg-5 mx-auto text-center"><span class="subtitle text-uppercase mb-3" data-aos="fade-up"
                data-aos-delay="0">Testimonials</span>
              <h2 class="mb-3" data-aos="fade-up" data-aos-delay="100">What Our Users Are Saying</h2>
              <p data-aos="fade-up" data-aos-delay="200">Real Stories of Success and Satisfaction from Our Diverse
                Community</p>
            </div>
          </div>
          <div class="row g-4" data-masonry="{&quot;percentPosition&quot;: true }">
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="0">
              <div class="testimonial rounded-4 p-4">
                <blockquote class="mb-3">
                  &ldquo;
                  B-Smart Calendar has completely transformed the way I manage my work schedule and meetings. Real-time
                  synchronization and smart reminders have saved me so much time and effort!
                  &rdquo;
                </blockquote>
                <div class="testimonial-author d-flex gap-3 align-items-center">
                  <div class="author-img"><img class="rounded-circle img-fluid" src="/client/image/person-sq-2-min.jpg"
                      alt="FreeBootstrap.net image placeholder"></div>
                  <div class="lh-base"><strong class="d-block">Hoai Linh</strong><span>Student</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="100">
              <div class="testimonial rounded-4 p-4">
                <blockquote class="mb-3">
                  &ldquo;
                  As a freelancer, I often get overwhelmed with multiple projects and deadlines. B-Smart Calendar helps
                  me organize tasks clearly, plan effectively, and never miss any important deadline.
                  &rdquo;
                </blockquote>
                <div class="testimonial-author d-flex gap-3 align-items-center">
                  <div class="author-img"><img class="rounded-circle img-fluid" src="/client/image/person-sq-1-min.jpg"
                      alt="FreeBootstrap.net image placeholder"></div>
                  <div class="lh-base"><strong class="d-block">Min</strong><span>Student</span></div>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="200">
              <div class="testimonial rounded-4 p-4">
                <blockquote class="mb-3">
                  &ldquo;
                  The team management and task assignment features of B-Smart Calendar are amazing. They help our team
                  work in sync, stay on schedule, and achieve high efficiency.
                  &rdquo;
                </blockquote>
                <div class="testimonial-author d-flex gap-3 align-items-center">
                  <div class="author-img"><img class="rounded-circle img-fluid" src="/client/image/person-sq-5-min.jpg"
                      alt="FreeBootstrap.net image placeholder"></div>
                  <div class="lh-base"><strong class="d-block">Ly Na</strong><span>Student</span></div>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="300">
              <div class="testimonial rounded-4 p-4">
                <blockquote class="mb-3">
                  &ldquo;
                  I’m impressed with B-Smart Calendar’s security and data backup features. Managing my schedule has
                  never been this safe and convenient.
                  &rdquo;
                </blockquote>
                <div class="testimonial-author d-flex gap-3 align-items-center">
                  <div class="author-img"><img class="rounded-circle img-fluid" src="/client/image/person-sq-3-min.jpg"
                      alt="FreeBootstrap.net image placeholder"></div>
                  <div class="lh-base"><strong class="d-block">Mai Linh</strong><span>Student</span></div>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="400">
              <div class="testimonial rounded-4 p-4">
                <blockquote class="mb-3">
                  &ldquo;
                  I never thought managing my study schedule and extracurricular activities could be this easy! The
                  friendly interface and reminder feature help me stay organized at all times.
                  &rdquo;
                </blockquote>
                <div class="testimonial-author d-flex gap-3 align-items-center">
                  <div class="author-img"><img class="rounded-circle img-fluid" src="/client/image/person-sq-7-min.jpg"
                      alt="FreeBootstrap.net image placeholder"></div>
                  <div class="lh-base"><strong class="d-block">Van Tu</strong><span>Student</span></div>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="500">
              <div class="testimonial rounded-4 p-4">
                <blockquote class="mb-3">
                  &ldquo;
                  The intuitive design and powerful features make B-Smart Calendar an indispensable tool for my startup.
                  It allows me to focus on business growth instead of worrying about schedule management.
                  &rdquo;
                </blockquote>
                <div class="testimonial-author d-flex gap-3 align-items-center">
                  <div class="author-img"><img class="rounded-circle img-fluid" src="/client/image/person-sq-8-min.jpg"
                      alt="FreeBootstrap.net image placeholder"></div>
                  <div class="lh-base"><strong class="d-block">Ho Thi Yen</strong><span>Student</span></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- Testimonials-->

      <!-- ======= Contact =======-->
      <section class="section contact__v2" id="contact">
        <div class="container">
          <div class="row mb-5">
            <div class="col-md-6 col-lg-7 mx-auto text-center"><span class="subtitle text-uppercase mb-3"
                data-aos="fade-up" data-aos-delay="0">Contact</span>
              <h2 class="h2 fw-bold mb-3" data-aos="fade-up" data-aos-delay="0">Contact Us</h2>
              <p data-aos="fade-up" data-aos-delay="100">Have questions or suggestions? Our team is here to help you get
                the most out of B-Smart Calendar.
                Whether it’s feedback, feature requests, or support—reach out to us anytime and we’ll respond promptly.
              </p>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="d-flex gap-5 flex-column">
                <div class="d-flex align-items-start gap-3" data-aos="fade-up" data-aos-delay="0">
                  <div class="icon d-block"><i class="bi bi-telephone"></i></div><span> <span
                      class="d-block">Phone</span><strong>+ 84 123 456 789</strong></span>
                </div>
                <div class="d-flex align-items-start gap-3" data-aos="fade-up" data-aos-delay="100">
                  <div class="icon d-block"><i class="bi bi-send"></i></div><span> <span
                      class="d-block">Email</span><strong>Bsmart@gmail.com</strong></span>
                </div>
                <div class="d-flex align-items-start gap-3" data-aos="fade-up" data-aos-delay="200">
                  <div class="icon d-block"><i class="bi bi-geo-alt"></i></div><span> <span
                      class="d-block">Address</span>
                    <address class="fw-bold">66 Vo Van Tan, <br> BTEC FPT BRITISH COLLEGE</address>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-wrapper" data-aos="fade-up" data-aos-delay="300">
                <form id="contactForm">
                  <div class="row gap-3 mb-3">
                    <div class="col-md-12">
                      <label class="mb-2" for="name">Name</label>
                      <input class="form-control" id="name" type="text" name="name" required="">
                    </div>
                    <div class="col-md-12">
                      <label class="mb-2" for="email">Email</label>
                      <input class="form-control" id="email" type="email" name="email" required="">
                    </div>
                  </div>
                  <div class="row gap-3 mb-3">
                    <div class="col-md-12">
                      <label class="mb-2" for="subject">Subject</label>
                      <input class="form-control" id="subject" type="text" name="subject">
                    </div>
                  </div>
                  <div class="row gap-3 gap-md-0 mb-3">
                    <div class="col-md-12">
                      <label class="mb-2" for="message">Message</label>
                      <textarea class="form-control" id="message" name="message" rows="5" required=""></textarea>
                    </div>
                  </div>
                  <button class="btn btn-primary fw-semibold" type="submit">Send Message</button>
                </form>
                <div class="mt-3 d-none alert alert-success" id="successMessage">Message sent successfully!</div>
                <div class="mt-3 d-none alert alert-danger" id="errorMessage">Message sending failed. Please try again
                  later.</div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- End Contact-->

      <!-- ======= Footer =======-->
      <footer class="footer pt-5 pb-5">
        <div class="container">
          <div class="row mb-5 pb-4">
            <div class="col-md-7">
              <h2 class="fs-5">Join our newsletter</h2>
              <p>Stay updated with our latest tips, features, and updates—subscribe to the B-Smart Calendar newsletter
                today!</p>
            </div>
            <div class="col-md-5">
              <form class="d-flex gap-2">
                <input class="form-control" type="email" placeholder="Email your email" required="">
                <button class="btn btn-primary fs-6" type="submit">Subscribe</button>
              </form>
            </div>
          </div>
          <div class="row justify-content-between mb-5 g-xl-5">
            <div class="col-md-4 mb-5 mb-lg-0">
              <h3 class="mb-3">About</h3>
              <p class="mb-4">B-Smart Calendar helps you organize your time effectively by scheduling tasks, events, and
                appointments with ease. Boost productivity and reduce stress while keeping your plans in perfect order.
              </p>
            </div>
            <div class="col-md-7">
              <div class="row g-2">
                <div class="col-md-6 col-lg-4 mb-4 mb-lg-0">
                  <h3 class="mb-3">Accounts</h3>
                  <ul class="list-unstyled">
                    <li><a href="page-signup.html">Register</a></li>
                    <li><a href="page-signin.html">Sign in</a></li>
                    <li><a href="page-forgot-password.html">Fogot Password</a></li>
                    <li><a href="page-coming-soon.html">Coming soon</a></li>
                    <li><a href="page-portfolio-masonry.html">Portfolio Masonry</a></li>
                  </ul>
                </div>
                <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 quick-contact">
                  <h3 class="mb-3">Contact</h3>
                  <p class="d-flex mb-3"><i class="bi bi-geo-alt-fill me-3"></i><span>66 Vo Van Tan, <br> BTEC FPT
                      BRITISH COLLEGE</span></p><a class="d-flex mb-3" href="mailto:info@mydomain.com"><i
                      class="bi bi-envelope-fill me-3"></i><span>Bsmart@gmail.com</span></a><a class="d-flex mb-3"
                    href="tel://+123456789900"><i class="bi bi-telephone-fill me-3"></i><span>+84 123 456 789</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </footer>
      <!-- End Footer-->

    </main>
  </div>

  <!-- ======= Back to Top =======-->
  <button id="back-to-top"><i class="bi bi-arrow-up-short"></i></button>
  <!-- End Back to top-->

  <!-- ======= Javascripts =======-->
  <script src="/client/vendors/bootstrap/bootstrap.bundle.min.js"></script>
  <script src="/client/vendors/gsap/gsap.min.js"></script>
  <script src="/client/vendors/imagesloaded/imagesloaded.pkgd.min.js"></script>
  <script src="/client/vendors/isotope/isotope.pkgd.min.js"></script>
  <script src="/client/vendors/glightbox/glightbox.min.js"></script>
  <script src="/client/vendors/swiper/swiper-bundle.min.js"></script>
  <script src="/client/vendors/aos/aos.js"></script>
  <script src="/client/vendors/purecounter/purecounter.js"></script>
  <script src="/client/js/custom.js"></script>
  <script src="/client/js/send_email.js"></script>
  <!-- End JavaScripts-->
</body>

</html>