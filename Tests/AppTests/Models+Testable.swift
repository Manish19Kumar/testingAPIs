@testable import App
import Crypto
import FluentPostgreSQL

extension User {
    // 1. Make the username parameter an optional string that defaults to nil.
    static func create(name: String = "Luke", username: String? = nil, on connection: PostgreSQLConnection) throws -> User {
        var createUsername: String
        // 2. If a username is supplied, use it.
        if let suppliedUsername = username {
            createUsername = suppliedUsername
            // 3. If a username isn’t supplied, create a new, random one using UUID. This ensures the username is unique as required by the migration.

        } else {
            createUsername = UUID().uuidString
        }
        let password = try BCrypt.hash("password")
        // 4. Create a user.
        let user = User(
            name: name,
            username: createUsername,
            password: password)
        return try user.save(on: connection).wait()
    }
}

extension Acronym {
    static func create(short: String = "TIL", long: String = "Today I Learned", user: User? = nil, on connection: PostgreSQLConnection) throws -> Acronym {
        var acronymsUser = user
        
        if acronymsUser == nil {
            acronymsUser = try User.create(on: connection)
        }
        
        let acronym = Acronym(short: short, long: long, userID: acronymsUser!.id!)
        return try acronym.save(on: connection).wait()
    }
}

extension App.Category {
    static func create(name: String = "Random", on connection: PostgreSQLConnection) throws -> App.Category {
        let category = Category(name: name)
        return try category.save(on: connection).wait()
    }
}

