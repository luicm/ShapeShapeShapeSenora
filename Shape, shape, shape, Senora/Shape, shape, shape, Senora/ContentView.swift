//
//  ContentView.swift
//  Shape, shape, shape, Senora
//
//  Created by Luisa Cruz Molina on 21.05.21.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    ZStack {
      WithViewStore(self.store) { viewStore in
        ForEach(viewStore.document.shapes) { shape in
          Group {
            
            switch shape.type {
            case .oval:
              Circle()
            case .rectangle:
              Rectangle()
            }
            
          }
          .foregroundColor(shape.color)
          .frame(width: shape.size.width, height: shape.size.height)
          .position(shape.postion)

        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store:
        Store(
          initialState: AppState(
            document: .init(shapes: [
              SenoraShape.init(
                size: CGSize(width: 100, height: 50),
                postion: CGPoint(x: 100, y: 100),
                color: .red, type: .rectangle)
            ]
            )
          ),
          reducer: appReducer,
          environment: AppEnvironment(mainQueue: .immediate)))
  }
}
