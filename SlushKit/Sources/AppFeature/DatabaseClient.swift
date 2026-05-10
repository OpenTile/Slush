// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import Dependencies
import SQLiteData

/// Performs the persistence writes needed by the app feature.
public struct DatabaseClient: Sendable {
  /// Inserts a captured thought into the local store.
  public var insert: @Sendable (_ thought: Thought) async throws -> Void

  public init(insert: @escaping @Sendable (_ thought: Thought) async throws -> Void = { _ in }) {
    self.insert = insert
  }
}

extension DatabaseClient: DependencyKey {
  public static var liveValue: Self {
    @Dependency(\.defaultDatabase)
    var database

    return Self { thought in
      try await database.write { db in
        try Thought.insert { thought }
          .execute(db)
      }
    }
  }

  public static var testValue: Self {
    Self()
  }
}

extension DependencyValues {
  /// Database writes for the typed thought capture flow.
  public var databaseClient: DatabaseClient {
    get { self[DatabaseClient.self] }
    set { self[DatabaseClient.self] = newValue }
  }
}
