import SwiftUI  // Importing the SwiftUI framework to build the user interface

// Data Model
struct Post: Identifiable, Codable {
    // 'Post' struct conforms to 'Identifiable' for unique identification and 'Codable' for easy encoding/decoding

    let id = UUID().uuidString
    // The 'id' is a unique identifier for each post, generated using UUID and converted to a string

    let text: String
    // 'text' holds the content of the post

    let image: URL?
    // 'image' is an optional URL that may point to an image related to the post

    var isLiked: Bool = false
    // 'isLiked' keeps track of whether the post is liked or not, defaulting to false

    enum CodingKeys: String, CodingKey {
        // 'CodingKeys' is used to map JSON keys to Swift property names
        case text = "content"
        // Maps the 'content' key in JSON to the 'text' property in Swift
        case image = "image_url"
        // Maps the 'image_url' key in JSON to the 'image' property in Swift
    }
}

// ViewModel
class PostViewModel: ObservableObject {
    // The ViewModel is an ObservableObject, which means it can be observed for changes in the UI

    @Published var posts: [Post] = []
    // 'posts' is a published property, so any change to it will update the UI

    let url = URL(string: "https://storage.googleapis.com/carousell-interview-assets/ios/ios-se-1a.json")!
    // A constant URL pointing to the JSON file from which posts will be fetched

    func fetchPosts() {
        // Fetching posts from the server using URLSession

        URLSession.shared.dataTask(with: url) { data, _, error in
            // A data task is created with the URL to fetch the posts

            if let error = error {
                // If there is an error during the request
                print("Error Fetching data \(error.localizedDescription)")
                self.useMockData() // If an error occurs, use mock data instead
                return
            }

            guard let data else {
                // If no data is returned
                print("No Data")
                self.useMockData() // Use mock data when there is no data
                return
            }

            do {
                // Try to decode the fetched data into an array of Post objects
                let decodePost = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    // Ensure the UI updates on the main thread
                    self.posts = decodePost
                }
            } catch {
                // If decoding fails
                print("Error decoding JSON: \(error.localizedDescription)")
                self.useMockData() // Use mock data if decoding fails
            }
        }.resume() // Start the data task
    }

    private func useMockData() {
        // This method provides mock data if real data is unavailable

        DispatchQueue.main.async {
            // Ensure UI updates on the main thread
            self.posts = [
                Post(
                    text: "Short text with an image.",
                    image: URL(string: "https://via.placeholder.com/150"),
                    isLiked: false
                ),
                Post(
                    text: "Long text with an image. This text explains more details about the post and continues for several lines to simulate a longer description.",
                    image: URL(string: "https://via.placeholder.com/150"),
                    isLiked: false
                ),
                Post(
                    text: "This is a post without an image.",
                    image: nil,
                    isLiked: false
                )
            ]
            print("Using mock data.") // Logs when mock data is being used
        }
    }
}

// Main View
struct ContentView: View {
    @StateObject private var viewModel = PostViewModel()
    // Creates and manages an instance of the PostViewModel

    var body: some View {
        ZStack {
            
            
            
            NavigationView {
                // Embedding the UI inside a NavigationView for navigation functionality
                
                List {
                    // A List view to display posts
                    
                    ForEach($viewModel.posts) { post in
                        // Iterates over each post, binding to each post object for updating the UI
                        
                        PostCell(post: post)
                        // Displays a PostCell for each post in the list
                    }
                }
                .navigationTitle("Posts")
                // Sets the navigation bar title to "Posts"
                .onAppear {
                    // Fetch posts when the view appears
                    viewModel.fetchPosts()
                }
            }
        }
    }
}

// PostCell
struct PostCell: View {
    @Binding var post: Post
    // Binding to the post allows changes to the post to reflect in the parent view

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // A vertical stack to arrange the post content

            HStack {
                // A horizontal stack to arrange the image and text horizontally

                if let imageUrl = post.image {
                    // Checks if the post has an image

                    AsyncImage(url: imageUrl) { image in
                        // Fetches and displays the image asynchronously

                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                        // Configures the image's size and clipping
                    } placeholder: {
                        // Displays a progress view while the image is loading
                        ProgressView()
                    }
                }

                Text(post.text)
                    .font(.body)
                    // Displays the post's text with the body font style
            }

            Button(action: {
                post.isLiked.toggle()
                // Toggles the 'isLiked' state when the button is tapped
            }) {
                HStack {
                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(post.isLiked ? .red : .gray)
                    // Displays a filled heart icon if liked, otherwise an empty one, with corresponding colors

                    Text(post.isLiked ? "Liked" : "Like")
                        // Changes the text to "Liked" or "Like" based on the 'isLiked' state
                }
            }
        }
        .padding()
        // Adds padding around the content
    }
}

// Preview
#Preview {
    ContentView()
    // Previews the ContentView for UI development
}

