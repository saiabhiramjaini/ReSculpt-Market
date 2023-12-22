
# ReSculpt - Market

Today, we face a big problem with a lot of waste in our society, which is harmful to people and animals. This happens because we buy and throw away things quickly, especially things we use once and then throw away. The way we get rid of our trash also makes the problem worse. Our plan is to improve how we deal with waste by turning things we use at home into new and useful things. This way, we can use them again instead of throwing them away. This not only helps the environment but also lets us create cool and useful items for our homes.

## Problem Statement

Empowering Sustainable Practices: Bridging Waste Contributors and Artisans Through an Innovative Upcycling App.


## Solution

**1) App for Artisans :**
We generate a significant amount of household waste regularly.
This waste can be repurposed to create decorative and innovative products by collaborating with skilled artisans.
Anyone can contribute their household waste for this purpose, fostering a sense of community engagement.

**2) App for Uploading Innovative products:**
Artisans can sell the creative products they make through a dedicated marketplace app.
This app exclusively focuses on providing a platform for showcasing and selling innovative products crafted by artisans.

## Tech Stack

**Flutter** : Front-end framework
**Firebase** : Back-end as a service 

## Workflow

![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/781a9601-0292-43f1-a7f8-646fcc32077c)



## Resculpt app for Market place

**App Link :** https://drive.google.com/file/d/1gnVQTrAhCM8fOhN7SazEvk_Xr0gOMzVm/view?usp=sharing

![black1](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/90e077d8-2000-4aae-bb22-ac76273d5e0e)

App registration and login
Using firebase authentication, users can be authenticated.

Once the user registers using his email a verification mail will be sent to user's entered email.

By clicking on the link user will be verified and he will be redirected to a Home page of application

![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/bd32d79b-259c-4a67-918e-6198cd2f7755)

**Features for artisans :**

**1) Browsing through innovations :**
There will be list of innovative items which are uploaded by artisans. Users can see the details and place order accordingly.

![image](https://github.com/saiabhiramjaini/ReSculpt-Market/assets/115941546/9ce46995-cf0f-4d86-8697-06a2fd2c4027)


**2) Cart provision and profile :**
Usrs can also use cart option **(still not completely developed)** to order mumtiple items. Ther is a profile screen to check their details.

![image](https://github.com/saiabhiramjaini/ReSculpt-Market/assets/115941546/5dbbb37c-7d8c-42f7-8d6c-d5d7b5af71c7)

## Backend

**Firebase Authentication :**

- Sign-in method used : email/password.
- With the help of firebase authentication user will be registered and user's email is visible at backend.
- A verification email will be sent to user when the user registers through which user gets verified.
![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/e3193248-f8fa-4d01-99aa-6d88e23feae4)

**Firebase Firestore :**

- This is our database.
- It has 3 collections 'users', 'products' and 'innovations'.
- users : it is used to store user related data.
- products : it is used to store uploaded requirements by an artisan.
- innovations : it is used to store artisan's innovative products which will be used to display in market app.
![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/77160ed2-015d-4cf0-bbf6-9c0d72f6719c)

![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/6a3234fa-ebee-4f09-8184-0890a38f6766)

![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/5ff48563-3076-4d47-8e07-72f9616b1990)


**Firebase Storage :**

- To store images.
- 'wasteImages' bucket contains all the images related to the requirement of artisan.
- 'innovationImages' bucket contains all the images related to innovative products uploaded by an artisan.
![image](https://github.com/saiabhiramjaini/Resculpt-For_Artisans/assets/115941546/93d71ad5-56ff-4cb6-8af7-7e00642493f3)

## Author

- [@saiabhiramjaini](https://github.com/saiabhiramjaini)
- **Repositories :**
https://github.com/saiabhiramjaini/Resculpt-For_Artisans

## Feedback 

If you have any feedback, please reach out me at abhiramjaini28@gmail.com

