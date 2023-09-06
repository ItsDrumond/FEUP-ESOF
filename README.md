# FindIT - 2LEIC14T2

## Vision Statement
  IT jobs are scattered around multiple websites and applications. Our application intends to solve that problem by collecting the data from all of these places and displaying it in a way that eases our user's experience and allows them to search for a job that fits their expectations and helps them keep track of the jobs they have already applied for, making it your IT social network (without much of a hassle) for job seeking.

## Documentation

* Business modeling 
  * [Vision Statement](#vision-statement)
  * [Elevator Pitch](#elevator-pitch)
* Requirements
  * [User stories](https://github.com/orgs/FEUP-LEIC-ES-2022-23/projects/55)
  * [Domain model](#domain-model)
* Architecture and Design
  * [Logical architecture](#logical-architecture)
  * [Physical architecture](#physical-architecture)
  * [Vertical prototype](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC14T2/blob/5cd0a1f002cb14d9819d95200b9cb1fbb2a20ea3/images/vertical_prototype.png)
  * [Mockups](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC14T2/tree/main/images/Mockups)

## Members
  - Ana Rita Pereira - up202108798
  - Andreia Silva - up202108769
  - Bruno Drumond - up201202666
  - Óscar Esteves - up201906834
  - Tomás Ramos - up202108687

***

## Product Vision
IT jobs are scattered around multiple websites and applications. Our application intends to solve that problem by collecting the data from all of these places and displaying it in a way that eases our user's experience and allows them to search for a job that fits their expectations and helps them keep track of the jobs they have already applied for, making it your IT social network (without much of a hassle) for job seeking.

***

## Elevator Pitch

Have you ever found yourself overwhelmed when looking for job oportunities?

Imagine this: instead of bouncing around multiple websites and apps, wasting precious time and energy, and having trouble with keeping track of the offers you like, FindIT gathers all those scattered job postings into one convenient place.

With FindIT, you can easily browse through a wide range of IT job opportunities that fit your expectations. Our smart search feature lets you filter and refine results, ensuring you find the perfect match for your skills and aspirations.

But we didn't stop there! We understand how important it is to stay organized during your job hunt. FindIT allows you to effortlessly keep track of the jobs you've applied for, so you never miss an opportunity.

So, if you're ready to say goodbye to the chaos of job searching and hello to a streamlined and efficient experience, give FindIT a try. Your dream IT job is just a few clicks away. FindIT: Where IT job seekers thrive!

***

## Domain Model

![domain_model](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC14T2/blob/fef64121303ff3c9fc2275b0b0d617bd2f02abac/images/domain_model.png)

The domain model consists of three main entities: AppUser, JobOffer, Company and Application. These entities represent the key components and relationships within the app.

* AppUser
  * Represents individuals who are seeking IT jobs.
  * The "name" attribute represents the name of the app user.
  * The "picture" attribute represents the path for the profile image of the user.
  * The "email" attribute represents the email which the app user uses to log in the app.
  * The "favorite" attribute represents a list with all the job offers saved as favorites by the app user.
  * The "applied" attribute represents a list with all the job offers to which the app user has applied.

* JobOffer
  * Represents each available job offer.
  * The "id" attribute uniquely identifies each job offer.
  * The "title" attribute represents the title or position of the job.
  * The "description" attribute represents the description of the job.
  * The "location" attribute represents the location of the job.
  * The "type" attribute represents the workload of the job (part-time / full-time).
  * The "contract" attribute represents the contract type of the job (fixed term / permanent).
  * The "salary" attribute represents the monetary compensation of the job.
  * The "publishDate" attribute represents the date the job offer was posted.

* Company
  * Represents the enterprise who publishes the job offer.
  * The "logo" attribute represents the link that displays the logo of the company.
  * The "name" attribute represents the name of the company.
  * The "address" attribute represents the address of the company.
  * The "phone" attribute represents the phone number of the company.
  * The "email" attribute represents the email of the company.
  * The "url" represents the website of the company.

* Application
  * The "resume" attribute represents the Curriculum Vitae of the app user.
  * The "coverLetter" attribute represents the cover letter of the app user.

The relationships within the domain model are as follows:

* An "AppUser" can check multiple job offers and a "JobOffer" can be checked by multiple app users (many-to-many relationship with "JobOffer").

* A "Company" can have multiple job offers (one-to-many relationship with "JobOffer").

* A "JobOffer" can have multiple applications (one-to-many relationship with "Application").

* An "AppUser" can have multiple applications (one-to-many relationship with "Application").

***

## Logical Architecture

![logical_architecture](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC14T2/assets/92999066/70d3024c-c535-42b8-9e57-6dbf063ed9ac)

The app's logical architecture has five key components: User Interface, User Authentication and Synchronization logic, Business logic, APIs, and Database.

The User Interface component provides user-friendly pages and features.

The User Authentication and Synchronization logic component verifies the user's credentials and links them to their profile and related information.

The Business logic component allows users to browse, select, and comment on job offers.

The APIs component provides diverse job offers in the IT world and allows users to filter them according to their preferences.

The Database component stores the user's information and reviews on different companies, providing valuable insights into different companies.

***

## Physical Architecture
![physical_architecture](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC14T2/assets/92999066/08102ed1-797d-4680-b5fc-7e9a3d5afba8)

The app's physical architecture encompasses five essential components: User Interface, User Authentication and Synchronization logic, Business logic, APIs, and Database.

The User Interface component delivers a user-friendly interface with intuitive pages and features, enhancing the user experience.

The User Authentication and Synchronization logic component verifies user credentials, links them to their profile, and ensures data consistency across devices.

The Business logic component enables users to browse, select, and engage with job offers, facilitating a seamless job search experience.

The APIs component integrates diverse job offers from the IT industry, allowing users to filter and tailor their search based on their preferences.

The Database component securely stores user information, including their profile details and reviews on different companies, providing valuable insights into various organizations.
