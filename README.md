# Photos App

The Photos App is a photo collection (iOS application) created using UIKit, that helps users to explore and interact with a collection of photos. 
The app offers several features, enhancing the user experience while navigating and enjoying their photo collection.

<img width="519" alt="ss1" src="https://github.com/ananyajoshi/PhotosApp/assets/40498665/cd6117a0-de8c-4ebd-904c-47d1b39c7829"> <img width="582" alt="ss2" src="https://github.com/ananyajoshi/PhotosApp/assets/40498665/2c94b520-3fe2-4a78-8f29-c54765bec038">

## Features

### Full-screen Viewing
- Tapping on a photo in the collection view opens a full-screen view for a more immersive experience.

### Asynchronous Image Prefetching
- The app prefetches images for upcoming items in the collection view to improve the user experience during scrolling.
- Images are downloaded in the background to ensure a smooth and responsive interface.

### Strong Caching
- It checks if the image is already in the cache, It uses the image directly. it saves the time of the application, and improves, the user-friendliness.

### Date-based Scrolling
- The app dynamically updates the date label based on the user's scrolling behavior.
- Incrementing or decrementing the date label enhances the user's understanding of the chronological order of photos.
