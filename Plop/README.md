# Plop

Plop is an iOS app designed to help people find and review bathrooms based on their current location. 


# Implementation

1. **MapViewController** is the initial view controller where users can browse nearby restaurants with the intention of using their restrooms. 

2. In **YelpBusinessDetailController**, users can view Plop and Yelp reviews in addition to basic information about the restaurant. Selecting an image in a plop review launches ImagesViewController, where enlarged versions of the images can be viewed. Selecting the plus on the top right launches StarRatingViewController.

3. In **StarRatingViewController**, users provide ratings out of five on the restaurant bathroom’s cleanliness, privacy, bathroom essentials, smell, and overall aesthetic. Pressing “done” leads to the AddReviewViewController.

4. In the **AddReviewViewController**, users can write their own review and have the option to attach photos. Pressing “Post Review” adds data to the Firebase database.


# How to build

The main project file is [Plop.xcworkspace](https://github.com/jmg764/iOS-Projects/tree/master/Plop/Plop.xcodeproj).

To install Firebase frameworks, while in the main directory for this project, run the ```pod install``` command in Terminal.

Install [OAuth2](https://github.com/p2/OAuth2), [Locksmith](https://github.com/matthewpalmer/Locksmith), and [Cosmos](https://github.com/evgenyneu/Cosmos) using Carthage. For more information on installing Carthage and the necessary frameworks, follow the instructions given [here](https://github.com/Carthage/Carthage).


# Requirements

Xcode 9.2

Swift 4.0


