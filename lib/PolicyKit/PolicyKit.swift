import Vapor
import Fluent

/// A resource that can perform actions on another resource.
public protocol Authorizable: Model {}

/// A policy that defines what actions can be performed the resource.
public protocol ModelPolicy: Model {
	/// The supported actions for the policy.
	associatedtype Action

	/// The resource that can perform the actions.
	associatedtype Agent: Authorizable

	/// Determines if the agent can perform the action on the model.
	///
	/// - Parameters:
	///   - agent: The agent that is trying to perform the action.
	///   - action: The action that is being attempted.
	func can(authenticated agent: Agent, do action: Self.Action) -> Bool
}

struct InvalidAgent: DebuggableError {
	var identifier: String {
		"InvalidAgent"
	}

	var reason: String {
		"Could not perform authorization on resource."
	}

	var possibleCauses: [String] {
		["You tried to authorize a model with a different agent than the one defined in the policy."]
	}
}

public extension Authorizable {
	/// Determines if this agent is authorized to perform the action on the model.
	///
	/// - Parameters:
	///   - action: The action that is being attempted.
	///   - model: The model that the action is being attempted on.
	func can<M: ModelPolicy>(_ action: M.Action, for model: M) throws -> Bool {
		guard let agent = self as? M.Agent else {
			throw InvalidAgent()
		}

		return model.can(authenticated: agent, do: action)
	}

	/// Ensures that this agent is authorized to perform an action on the provided model.
	/// If the agent is not authorized, the request will be aborted with a 401 Unauthorized error.
	///
	/// - Parameters:
	///   - action: The action that is being attempted.
	///   - model: The model that the action is being attempted on.
	func authorize<M: ModelPolicy>(_ action: M.Action, for model: M) throws {
		guard try can(action, for: model) else {
			throw Abort(.unauthorized)
		}
	}
}
