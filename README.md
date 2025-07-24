# PostHub

A dynamic SwiftUI application that enables users to view, like, and interact with posts. This project demonstrates fetching posts from a remote server with robust error handling and fallback mock data.

- Built a dynamic SwiftUI application that enables users to view, like, and interact with posts.
- Integrated features for fetching posts from a remote server with error handling and fallback mock data.
- Implemented like/unlike functionality with real-time updates using state management and asynchronous image loading for enhanced performance.

## Features

- Fetches and decodes post data from a remote JSON API.
- Displays posts in a clean, scrollable list.
- Asynchronously loads and displays images.
- Allows users to like and unlike individual posts, with immediate UI feedback.
- Implements a fallback to mock data if the network request fails or returns no data.

## Technology

- **UI Framework:** SwiftUI
- **Language:** Swift
- **Concurrency:** URLSession for asynchronous data fetching.

## How to Run

1.  Clone this repository.
2.  Open the `learn.xcodeproj` file in Xcode.
3.  Select a simulator or a physical device.
4.  Build and run the project (Cmd+R).
