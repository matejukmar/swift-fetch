import Foundation

public enum Error: Swift.Error {
	case invalidStatusCode(Int, Any?)
	case encodingError
}

public enum Method: String {
	case GET
	case POST
	case PUT
	case PATCH
	case DELETE
}

public struct Header {
	public var key: String
	public var value: String
}

var defaultFetchHeaderFunc: (() -> [Header])? = nil

public func fetch<A: QueryStringEncodable, B: Codable, C: Codable>(
	url: String, query: A?, method: Method? = nil, body: B? = nil, headers: [Header]? = nil
) async throws -> C {
	var urlStr = url
	if let query = query {
		urlStr += query.queryString
	}
	var request = URLRequest(url: URL(string: urlStr)!)
	request.httpMethod = method?.rawValue ?? "GET"
	let encoder = JSONEncoder()
	let bodyData: Data? = body != nil ? try encoder.encode(body) : nil
	request.httpBody = bodyData
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	if let hf = defaultFetchHeaderFunc {
		let defHeaders = hf()
		defHeaders.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	if let hs = headers {
		hs.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	let (data, res) = try await URLSession.shared.data(for: request)
	let response = res as! HTTPURLResponse
	if response.statusCode < 200 || response.statusCode >= 300 {
		throw Error.invalidStatusCode(response.statusCode, data)
	}
	let decoder = JSONDecoder()
	return try decoder.decode(C.self, from: data)
}

public func fetch<A: Codable, B: Codable>(
	url: String, method: Method? = nil, body: A? = nil, headers: [Header]? = nil
) async throws -> B {
	var request = URLRequest(url: URL(string: url)!)
	request.httpMethod = method?.rawValue ?? "GET"
	let encoder = JSONEncoder()
	let bodyData: Data? = body != nil ? try encoder.encode(body) : nil
	request.httpBody = bodyData
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	if let hf = defaultFetchHeaderFunc {
		let defHeaders = hf()
		defHeaders.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	if let hs = headers {
		hs.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	let (data, res) = try await URLSession.shared.data(for: request)
	let response = res as! HTTPURLResponse
	if response.statusCode < 200 || response.statusCode >= 300 {
		throw Error.invalidStatusCode(response.statusCode, data)
	}
	let decoder = JSONDecoder()
	return try decoder.decode(B.self, from: data)
}

public func fetch<A: Codable>(
	url: String, method: Method? = nil, headers: [Header]? = nil
) async throws -> A {
	var request = URLRequest(url: URL(string: url)!)
	request.httpMethod = method?.rawValue ?? "GET"
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	if let hf = defaultFetchHeaderFunc {
		let defHeaders = hf()
		defHeaders.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	if let hs = headers {
		hs.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	let (data, res) = try await URLSession.shared.data(for: request)
	let response = res as! HTTPURLResponse
	if response.statusCode < 200 || response.statusCode >= 300 {
		throw Error.invalidStatusCode(response.statusCode, data)
	}
	let decoder = JSONDecoder()
	return try decoder.decode(A.self, from: data)
}

public func fetch<A: QueryStringEncodable, B: Codable>(
	url: String, query: A, method: Method? = nil, headers: [Header]? = nil
) async throws -> B {
	var request = URLRequest(url: URL(string: url + query.queryString)!)
	request.httpMethod = method?.rawValue ?? "GET"
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	if let hf = defaultFetchHeaderFunc {
		let defHeaders = hf()
		defHeaders.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	if let hs = headers {
		hs.forEach { h in
			request.setValue(h.value, forHTTPHeaderField: h.key)
		}
	}
	let (data, res) = try await URLSession.shared.data(for: request)
	let response = res as! HTTPURLResponse
	if response.statusCode < 200 || response.statusCode >= 300 {
		throw Error.invalidStatusCode(response.statusCode, data)
	}
	let decoder = JSONDecoder()
	return try decoder.decode(B.self, from: data)
}

public func assignDefaultFetchHeaders(headerFunc: @escaping () -> [Header]) {
	defaultFetchHeaderFunc = headerFunc
}

struct TestThing: Codable {
	var test: String
}

public func test(request: URLRequest) async throws {
	struct Query: QueryStringEncodable {
		var id: String
	}
	let thing: String = try await fetch(
		url: "http://preview.art",
		query: Query(id: "ababababab"),
		headers: [Header(key: "Bearer", value: "Test")]
	)
	print(thing)
}
