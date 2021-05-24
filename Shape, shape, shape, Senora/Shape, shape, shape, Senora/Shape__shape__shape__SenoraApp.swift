//
//  Shape__shape__shape__SenoraApp.swift
//  Shape, shape, shape, Senora
//
//  Created by Luisa Cruz Molina on 21.05.21.
//

import ComposableArchitecture
import SwiftUI

@main
struct Shape__shape__shape__SenoraApp: App {
  var body: some Scene {
    DocumentGroup(newDocument: SenoraDocument()) { configuration in
      ContentView(
        store: Store(
          initialState: AppState(
            document: configuration.document
          ),
          reducer: appReducer,
          environment: AppEnvironment(
            fileClient: .live,
            mainQueue: .main
          )
        ),
        document: configuration.$document
      )
    }
  }
}
