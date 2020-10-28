# SeatGeek
This is a sample application using the events API from Seat API 

Problem Statement :

Write a type ahead against the Seat Geek API. The type ahead should update a list of results as the search query changes. Results can be tapped to view them on a details screen.

Solution and Design

1. This is an iOS application which uses Seat Geek events API, query API for home screen and event id API for the Details Screen.
2. It uses MVVM Design pattern.
3. It uses concept of throttling and chaining required for type ahead search, If the use is looking for a specific word we don't need to fetch each character.
4. Network Layer uses URL Session to fetch json data from the API, It uses Codable protocol to process the data.
5. It uses Managers - ImageDownload and CacheManagers. ImageDownload Manager can use the cache as well but for simplicty of the application, its being fetched everytime right now. CacheManager caches the identifiers of the Events and shows a heart icon / fav icon for the indexes those has been favorited in the previous session.

Improvements -

1. Cache the Event Data and show it on application launch
2. Use any third party API to cache images. Kingfisher / SDWebImage are some of them
3. Generic Network Layer to be used for all the configurations
4. Optimization for pagination and prefetching API 
5. Make the cache manager more Generic so that it can be used to save any data type rather than Data, as of now it deals on String as Key and Data as value
6. Tweak the UI little better as per the specifications. 

Documentation of the API is available at http://platform.seatgeek.com/#events

![Home Screen](https://github.com/irahuldubey/SeatGeek/blob/main/1st.png)

![Detail Screen](https://github.com/irahuldubey/SeatGeek/blob/main/2nd.png)
