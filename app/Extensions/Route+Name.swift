import Vapor

public extension Route {
    @discardableResult
    func name(_ string: String) -> Route {
        userInfo["name"] = string
        return self
    }
}
