import Foundation

public protocol QueryStringEncodable {
	var queryString: String { get }
}

extension QueryStringEncodable {
	public var queryString: String {
		var result: String = ""
		var i = 0
		let mirror = Mirror(reflecting: self)
		// Optional check to make sure we're iterating over a struct or class
		// guard let style = mirror.displayStyle, style == .struct || style == .class else {
		// 	throw Error.encodingError
		// }

		for (property, value) in mirror.children {
			guard
				let property = property,
				let value = value as? String,
				let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			else {
				continue
			}
			if i == 0 {
				result += "?"
			} else {
				result += "&"
			}
			result += "\(property)=\(encodedValue)"
			i += 1
		}
		return result
	}
}
