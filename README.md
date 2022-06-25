# swift-fetch

## A simple utility for performing http(s) json requests in Swift

### The simplest example:

```swift
import Fetch

struct Query: Codable {
	var id: String
}

struct Response: Codable {
	var id: String
	var name: String
	var email: String
}

func someFunc() throws async {
	let query = Query(
		id: "1dab17eb-4789-484b-9ac7-a8df16ac1553",
	)
	let data: Response = try await fetch(
		url: "https://api.website.com/user",
		query: query
	)
	print(data)
}
```

### Intermediate example:

```swift
import Fetch

struct Response: Codable {
	var id: String
	var name: String
	var email: String
}

struct Request: Codable {
	var name: String
	var email: String
}

func someFunc() throws async {
	let body = Request(
		name: "Joe Black",
		email: "joe@black.com"
	)
	let data: Response = try await fetch(
		url: "https://api.website.com/user",
		method: .POST,
		body: body
	)
	print(data)
}
```

### Advanced example:

```swift
import Fetch

struct Response: Codable {
	var id: String
	var name: String
	var email: String
}

struct Request: Codable {
	var name: String
	var email: String
}

// adds headers to all fetch requests
func defaultFetchHeaders() -> [Header] {
	return [Header(key: "Authorization", value: "Bearer \(accessToken)")]
}
assignDefaultFetchHeaders(headerFunc: defaultFetchHeaders)

func someFunc() throws async {
	let body = Request(
		name: "Joe Black",
		email: "joe@black.com"
	)
	let data: Response = try await fetch(
		url: "https://api.website.com/user",
		method: .POST,
		body: body,
		headers: [Header(key: "X-Header", value: "Value")]
	)
	print(data)
}
```
