// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import Dependencies
import SQLiteData

extension DependencyValues {
  /// Opens the app database and migrates the typed thought capture schema.
  public mutating func bootstrapDatabase(path: String? = nil) throws {
    let database = try SQLiteData.defaultDatabase(path: path)
    var migrator = DatabaseMigrator()

    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif

    migrator.registerMigration("Create thoughts table") { db in
      try #sql(
        """
        CREATE TABLE "thoughts" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE,
          "text" TEXT NOT NULL DEFAULT '',
          "created_at" INTEGER NOT NULL
        ) STRICT
        """
      )
      .execute(db)
    }

    try migrator.migrate(database)
    defaultDatabase = database
  }
}
