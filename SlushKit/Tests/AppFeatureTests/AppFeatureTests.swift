// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import ComposableArchitecture
import CustomDump
import Dependencies
import DependenciesTestSupport
import Foundation
import SQLiteData
import Testing

@testable import AppFeature

@Suite(.serialized)
struct AppFeatureTests {
  @Test
  @MainActor
  func inputChangedUpdatesInputText() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }

    await store.send(.inputChanged("Buy coffee")) {
      $0.inputText = "Buy coffee"
    }
  }

  @Test
  @MainActor
  func submitTappedWithEmptyTextDoesNothing() async {
    let store = TestStore(initialState: AppFeature.State(inputText: "   \n\t  ")) {
      AppFeature()
    } withDependencies: {
      $0.databaseClient.insert = { _ in
        Issue.record("Empty input should not insert a thought.")
      }
    }

    await store.send(.submitTapped)
  }

  @Test
  @MainActor
  func submitTappedWithNonEmptyTextInsertsThoughtAndClearsInput() async {
    let now = Date(timeIntervalSince1970: 1_778_400_000)
    let recorder = ThoughtRecorder()
    let store = TestStore(initialState: AppFeature.State(inputText: "  Buy coffee  ")) {
      AppFeature()
    } withDependencies: {
      $0.date.now = now
      $0.databaseClient.insert = { thought in
        await recorder.insert(thought)
      }
      $0.uuid = .incrementing
    }

    await store.send(.submitTapped) {
      $0.inputText = ""
    }
    await store.finish()

    let thoughts = await recorder.thoughts()
    expectNoDifference(
      thoughts,
      [
        Thought(
          id: UUID(0),
          text: "Buy coffee",
          createdAt: now
        )
      ]
    )
  }

  @Test(
    .dependencies {
      try $0.bootstrapDatabase(path: ":memory:")
      let database = $0.defaultDatabase
      $0.databaseClient.insert = { thought in
        try await database.write { db in
          try Thought.insert { thought }
            .execute(db)
        }
      }
    }
  )
  func databaseInsertPersistsThoughtsNewestFirst() async throws {
    @Dependency(\.databaseClient)
    var databaseClient
    @Dependency(\.defaultDatabase)
    var database

    let older = Thought(
      id: UUID(1),
      text: "Older thought",
      createdAt: Date(timeIntervalSince1970: 1_000)
    )
    let newer = Thought(
      id: UUID(2),
      text: "Newer thought",
      createdAt: Date(timeIntervalSince1970: 2_000)
    )

    try await databaseClient.insert(older)
    try await databaseClient.insert(newer)

    let thoughts = try await database.read { db in
      try Thought.all.fetchAll(db)
    }

    expectNoDifference(thoughts, [newer, older])
  }
}

private actor ThoughtRecorder {
  private var recordedThoughts: [Thought] = []

  func thoughts() -> [Thought] {
    recordedThoughts
  }

  func insert(_ thought: Thought) {
    recordedThoughts.append(thought)
  }
}
