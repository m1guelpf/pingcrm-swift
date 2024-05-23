import Vapor

func routes(_ app: Application) throws {
	app.group(User.ensureGuest()) { guestRoutes in
		guestRoutes.get("login", use: LoginController.index).name("login")
		guestRoutes.post("login", use: LoginController.store).name("login.store")
	}

	app.group(User.requireAuth()) { authRoutes in
		authRoutes.post("logout", use: LoginController.destroy).name("logout")

		// Dashboard
		authRoutes.get(use: DashboardController.index).name("dashboard")

		// Users
		authRoutes.group("users") { userRoutes in
			userRoutes.get(use: UsersController.index).name("users")
			userRoutes.get("create", use: UsersController.create).name("users.create")
			userRoutes.post(use: UsersController.store).name("users.store")
			userRoutes.get(":id", "edit", use: UsersController.edit).name("users.edit")
			userRoutes.put(":id", use: UsersController.update).name("users.update")
			userRoutes.delete(":id", use: UsersController.destroy).name("users.destroy")
			userRoutes.post(":id", "restore", use: UsersController.restore).name("users.restore")
		}

		// Organizations
		authRoutes.group("organizations") { organizationRoutes in
			organizationRoutes.get(use: OrganizationsController.index).name("organizations")
			organizationRoutes.get("create", use: OrganizationsController.create).name("organizations.create")
			organizationRoutes.post(use: OrganizationsController.store).name("organizations.store")
			organizationRoutes.get(":id", "edit", use: OrganizationsController.edit).name("organizations.edit")
			organizationRoutes.put(":id", use: OrganizationsController.update).name("organizations.update")
			organizationRoutes.delete(":id", use: OrganizationsController.destroy).name("organizations.destroy")
			organizationRoutes.post(":id", "restore", use: OrganizationsController.restore).name("organizations.restore")
		}

		// Contacts
		authRoutes.group("contacts") { contactRoutes in
			contactRoutes.get(use: ContactsController.index).name("contacts")
			contactRoutes.get("create", use: ContactsController.create).name("contacts.create")
			contactRoutes.post(use: ContactsController.store).name("contacts.store")
			contactRoutes.get(":id", "edit", use: ContactsController.edit).name("contacts.edit")
			contactRoutes.put(":id", use: ContactsController.update).name("contacts.update")
			contactRoutes.delete(":id", use: ContactsController.destroy).name("contacts.destroy")
			contactRoutes.post(":id", "restore", use: ContactsController.restore).name("contacts.restore")
		}

		// Reports
		authRoutes.get("reports", use: ReportsController.index).name("reports")
	}
}
