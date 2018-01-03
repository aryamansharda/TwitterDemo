# TwitterDemo
Playing around with the Twitter API. Loads trending topics and allows infinite scrolling of images pertaining to a search query. 

Once you build and run the application, the list of currently trending topics will load. Alternatively, you can enter a custom search query. The app will then use Twitter's API to find all images relating to that search query. The Twitter API does not remvoe duplicates, so if duplicates appear in the collection view, it's expected behavior. 

In order to reuse table view cells, the images are cached once the async load request is done. The cache is emptied when a new query is executed. 

Infinite scrolling is implemented as well. As the user scrolls towards the bottom of the list, an async request to load more images with a certain offset is called. 
