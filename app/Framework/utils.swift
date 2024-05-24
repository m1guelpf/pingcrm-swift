import Vapor

public extension Request {
	enum RedirectBack {
		case back
	}

	func redirect(_: RedirectBack, redirectType: Redirect = .normal) -> Response {
		return redirect(to: url.string, redirectType: redirectType)
	}
}

extension DirectoryConfiguration {
	mutating func reconfigure() {
		publicDirectory = workingDirectory + "public/"
		resourcesDirectory = workingDirectory + "resources/"
		viewsDirectory = resourcesDirectory + "views/"
	}
}
