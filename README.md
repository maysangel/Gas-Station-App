# Gas Station App

This is my first Flutter application that allows its users to **find nearby gas stations, displays their prices, as well as permitting a unique admin to add, modify or even delete stations.**

## The Idea Executed 

### Signing In 

We first start with a *"Sign In"* page as displayed, with features such as **"Forgot Password ?"** , plus the option to **create new account** for new users.

![sign ij](https://user-images.githubusercontent.com/106128760/179071146-782e6e1b-0bdc-4690-8a0c-aa0f7c3eb6d7.jpeg)

### Users Map
After logging in with the correct credentials, *the map* used through a *google maps package* and *API keys* , is displayed after accessing the user's location, with all the markers existing in the Firebase Database, for each one its own name and price.
We can also order them by different gas prices, ascending or descending order.
The user chooses the station he wants, and an itinerary option (provided by the package) shows so he would follow those directions to reach his destinations.

![perms](https://user-images.githubusercontent.com/106128760/179071361-bc6c7618-9aef-4013-9c35-ce61f0987511.jpeg)

![map](https://user-images.githubusercontent.com/106128760/179071327-cd2117f4-469e-41d6-88a0-fe2cf9857225.jpeg)

![trier](https://user-images.githubusercontent.com/106128760/179071343-27a8f617-435b-4936-ab5a-b6eb5565d898.jpeg)


### Admin

A unique admin can add stations, which are added directly to the database and displayed on the map automatically.
He can either do that manually by typing the coordinates and the prices, or with an even simpler method just by tapping the desired location on map hence showing an
alert box to type in other informations of the station.

  ![admin int](https://user-images.githubusercontent.com/106128760/179071429-0e9afc38-1153-4677-9cef-2f9effc86b43.jpeg)
  
  This admin can also modify or delete the already existing stations.
  
![modify](https://user-images.githubusercontent.com/106128760/179071461-60cc123d-e2cf-4f55-98b0-6d7e044f05f4.jpeg)


For an even **user-like experience**, the same map displayed to the user can be visualized by the admin too.

## Conclusion
This application mainly relied on Flutter, Dart, Firebase, APIs, SDK, and many other technologies for the developpment of a mobile app for Android and IOS .
