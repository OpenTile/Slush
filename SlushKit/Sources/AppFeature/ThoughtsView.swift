// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import ComposableArchitecture
import Dependencies
import Foundation
import SQLiteData
import SwiftUI

/// The main typed capture surface and persisted thought list.
public struct ThoughtsView: View {
  @Bindable
  public var store: StoreOf<AppFeature>
  @FetchAll(Thought.all, animation: .default)
  private var thoughts

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      VStack(spacing: 16) {
        HStack(alignment: .top, spacing: 8) {
          TextField(
            "Capture a thought",
            text: $store.inputText.sending(\.inputChanged),
            axis: .vertical
          )
          .lineLimit(1...4)
          .onSubmit { store.send(.submitTapped) }
          .textFieldStyle(.roundedBorder)

          Button {
            store.send(.submitTapped)
          } label: {
            Image(systemName: "plus")
          }
          .buttonStyle(.borderedProminent)
          .disabled(isSubmitDisabled)
        }
        .padding([.horizontal, .top])

        List {
          if thoughts.isEmpty {
            ContentUnavailableView("No thoughts yet", systemImage: "text.bubble")
          } else {
            ForEach(thoughts) { thought in
              VStack(alignment: .leading, spacing: 4) {
                Text(thought.text)
                  .font(.body)

                Text(thought.createdAt, format: .dateTime.month().day().hour().minute())
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
              .padding(.vertical, 4)
            }
          }
        }
      }
      .navigationTitle("Slush")
    }
  }

  private var isSubmitDisabled: Bool {
    store.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}

#Preview {
  let _ = prepareDependencies {
    try! $0.bootstrapDatabase(path: ":memory:")
    try! $0.defaultDatabase.write { db in
      try db.seed {
        Thought(
          id: UUID(1),
          text: "Sketch the typed thought capture slice",
          createdAt: Date(timeIntervalSince1970: 1_778_400_000)
        )
      }
    }
  }

  ThoughtsView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}
