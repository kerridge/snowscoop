# SnowScoop
![alt text](https://github.com/kerridge/snowscoop/blob/master/images/icon-2.png)

A Web Scraping app written in Flutter/Dart.

The goal of this application was to learn more about Flutter and to explore some new packages. 

I have written a [web scraper in Python 3.7](https://www.github.com/kerridge/pythonsheets) which is responsible for scraping values from a weather website, and then uploading them to Google Sheets using their API.

I am using Google Sheets as a backend because it's unique, and a lot of people are utilising it to design easy visualized backends for small to medium businesses. Plus, honestly this applcation has a simple data structure so there is no need for a fancy solution.


- This was the initial mockup for the end look


![alt text](https://github.com/kerridge/snowscoop/blob/master/images/phonr.png) 


![alt text](https://github.com/kerridge/snowscoop/blob/master/images/current.jpg)
- This is the current state of the UI
---
# MVVM Architecture
**This is the architecture used across the entire application.**

The idea is that there are 3 main parts, much like MVC. Our main goal is to move as much of the _state_ and the _logic_ as possible into a separate class called the **View-Model**. This **View-Model** class contains the business logic and serves as the _mediator_ between the **View**, and **Model** classes.

* Firstly we have **Model** - Model is the data objects we create to store our data across the app. These are things like the User object, which stores all the details required for login and the user's name so we can personalize the application. I will go into more detail on this below in the **data classes** section.

* Secondly, we have the **View** - View is the front-end. The view is the UI components that are displayed to the user, and the components the user interacts with. The view has two main jobs: to listen to streams of data sent from the **view-model** and update the user interface accordingly (e.g. updating a text field), and to listen to user input and inform the **view-model** of the interaction (e.g. clicking a button and incrementing a counter).

* Lastly, we have the **View-Model** - The view-model is the bridge between the **model** and **view-model**. The view-model has two main jobs: to listen for user input and react accordingly, and to grab data from the model that the view can subscribe to (e.g. network requests, push navigation, etc).

In Flutter, we achieve this using 3 different files. The view is represented as widgets, the model is data classes, and the view-model is an abstract class that extends the view. Theoretically, if we separated all logic properly, the view-model could be reused in a web application, as it has no dependencies to Flutter. You can read more about our implementation [here.](https://medium.com/flutter-community/easily-navigate-through-your-flutter-code-by-separating-view-and-view-model-240026191106)

---
