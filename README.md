# SeatGeek
This is a sample application using the events API from Seat API 

Problem Statement :

Write a type ahead against the Seat Geek API. The type ahead should update a list of results as the search query changes. Results can be tapped to view them on a details screen.

Solution and Design

1. This is an iOS application which uses Seat Geek events API, query API for home screen and event id API for the Details Screen.
2. It uses MVVM Design pattern.
3. It uses concept of throttling and chaining required for type ahead search, If the use is looking for a specific word we don't need to fetch each character.
4. Network Layer uses URL Session to fetch json data from the API, It uses Codable protocol to process the data.

Documentation of the API is available at http://platform.seatgeek.com/#events

![Home Screen](https://github.com/irahuldubey/SeatGeek/blob/main/1st.png)

![Detail Screen](https://github.com/irahuldubey/SeatGeek/blob/main/2nd.png)
