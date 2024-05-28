import Vapor

extension HTTPResponseStatus {
	var isSuccess: Bool {
		return code >= 200 && code < 300
	}
}

extension Response.Body {
	var isEmpty: Bool {
		count == 0
	}
}
