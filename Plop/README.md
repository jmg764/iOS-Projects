# Plop

Plop is an iOS app designed to help people find and review bathrooms based on their current location. 


# Implementation

1. **MapViewController** is the initial view controller where users can browse nearby restaurants with the intention of using their restrooms. 

2. In **YelpBusinessDetailController**, users can view Plop and Yelp reviews in addition to basic information about the restaurant. Selecting an image in a plop review launches ImagesViewController, where enlarged versions of the images can be viewed. Selecting the plus on the top right launches StarRatingViewController.

3. In **StarRatingViewController**, users provide ratings out of five on the restaurant bathroom’s cleanliness, privacy, bathroom essentials, smell, and overall aesthetic. Pressing “done” leads to the AddReviewViewController.

4. In the **AddReviewViewController**, users can write their own review and have the option to attach photos. Pressing “Post Review” adds data to the Firebase database.


# How to build

Plop can be built and run using Xcode, and accessed through the Plop.xcworkspace file.

To add frameworks using Carthage follow the instructions in this link: https://github.com/Carthage/Carthage
	Create new Cartfile: touch Cartfile
	Open Cartfile with Xcode: open Cartfile -a Xcode
	Build frameworks with Carthage: carthage update --platform iOS --no-use-binaries
	Enable latest Swift compiler: sudo xcode-select -switch *path to Xcode*
	Open current directory: open .
	Add to Run Script Phase: /usr/local/bin/carthage copy-frameworks
	Path to Framework: $(SRCROOT)/Carthage/Build/iOS/OAuth2.framework


# Requirements

Xcode 9.2

Swift 4.0


