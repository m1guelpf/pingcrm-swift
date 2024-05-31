import Vapor

extension HTTPResponseStatus {
	var isSuccess: Bool {
		return code >= 200 && code < 300
	}
}

extension Response {
	func withStatus(_ status: HTTPResponseStatus) -> Response {
		self.status = status
		return self
	}
}

extension Response.Body {
	var isEmpty: Bool {
		count == 0
	}
}
