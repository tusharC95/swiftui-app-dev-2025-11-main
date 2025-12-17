
## An exercise to demonstrate a SwiftUI app



Getting Started With the Server Backend (/server)
-----------------------------------------------
For this exercise a simple pre-built server application is provided. The
application runs by default on `localhost:4000` and has the following endpoints:

 - `http://localhost:4000/videos` - returns a JSON-encoded array of videos.

### Running the Server

The provided API server is needed as a data source for your project. To run the
server you will need Node.js.

You can quickly install the requirements using [Homebrew](https://brew.sh/) with:
```sh
brew install node
```

With dependencies installed, you can run the server with:
```sh
cd server
npm install
npm start
```

You can verify the API is working by visiting http://localhost:4000/videos in
your browser, or another HTTP client.
