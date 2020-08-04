# Virtual Tourist

Virtual Tourist downloads and stores images from Flickr. It allows users to drop pins on a map, as if they were stops on a tour. Users are then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.


# Implementation

1. **MapViewController** displays the map and allows users to drop a pin anywhere in the world. Once the pin is dropped, image data is obtained from Flickr for that particular location. 
2. **PhotoAlbumViewController** displays the images downloaded from Flickr for the location where the pin was dropped in MapViewController. The user can press the "New Collection" button in order to obtain a new batch of images. 


# Requirements

Xcode 9.2
Swift 4.0
