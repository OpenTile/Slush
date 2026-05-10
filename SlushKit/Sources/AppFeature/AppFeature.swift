// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import ComposableArchitecture
import Foundation

/// Coordinates typed thought input and persistence.
@Reducer
public struct AppFeature {
  @ObservableState
  public struct State: Equatable, Sendable {
    public var inputText: String

    public init(inputText: String = "") {
      self.inputText = inputText
    }
  }

  public enum Action: Sendable {
    case inputChanged(String)
    case submitTapped
  }

  @Dependency(\.databaseClient)
  var databaseClient
  @Dependency(\.date.now)
  var now
  @Dependency(\.uuid)
  var uuid

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .inputChanged(text):
        state.inputText = text
        return .none

      case .submitTapped:
        let text = state.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
          return .none
        }

        state.inputText = ""
        let insert = databaseClient.insert
        let thought = Thought(id: uuid(), text: text, createdAt: now)
        return .run { _ in
          try await insert(thought)
        }
      }
    }
  }
}
