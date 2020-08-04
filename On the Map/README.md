# On The Map

On The Map allows students to share their location along with a URL with fellow students. This is represented by a map with pins containing the posted URL. 


# Implementation
1. **LoginViewController** allows the user to login using Udacity or Facebook credentials.
2. **MapViewController** displays a map with pins specifying the last 100 locations posted by students. When the user taps a pin, the URL posted by the student who posted it is presented. Tapping on the URL launches Safari, and the user is directed to the link with the associated pin.
3. **AddPinViewController** allows the user to add a pin to the map indicating their current location.
4. **AddLinkViewController** allows the user to associate a URL with the pin dropped in AddPinViewController.
5. **ListViewController** displays the most recent posts by students in a table. Tapping on a URL launches the link in Safari.


# Requirements

Xcode 9.2
Swift 4.0
