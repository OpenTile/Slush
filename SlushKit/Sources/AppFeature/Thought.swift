// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import Foundation
import SQLiteData

/// A locally stored brain-dump entry captured from typed input.
@Table("thoughts")
public struct Thought: Equatable, Identifiable, Sendable {
  public let id: UUID

  /// The exact text the user submitted.
  public var text: String

  /// The time the thought was captured, stored as Unix time in SQLite.
  @Column("created_at", as: Date.UnixTimeRepresentation.self)
  public var createdAt: Date

  public init(id: UUID, text: String, createdAt: Date) {
    self.id = id
    self.text = text
    self.createdAt = createdAt
  }
}

extension Thought {
  /// Thoughts ordered newest-first for the main capture list.
  public static var all: some SelectStatementOf<Self> {
    Self.order { $0.createdAt.desc() }
  }
}
