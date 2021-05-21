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
    WithViewStore(self.store) { viewStore in
      Rectangle()
        .frame(minWidth: 500, minHeight: 300)
        .gesture(
          DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { state in
              viewStore.send(.createShapeAt(state.startLocation))
            }
        )
        .overlay(
          ZStack {
            ForEach(viewStore.document.shapes) { shape in
              Group {

                switch shape.type {
                case .oval:
                  Circle()
                case .rectangle:
                  Rectangle()
                }

              }
              .foregroundColor(shape.color.swiftColor)
              .frame(width: CGFloat(shape.size.height), height: CGFloat(shape.size.height))
              .position(shape.postion.cgPosition)
            }
          }
        )

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
              SenoraShape.init(position: CGPoint(x: 100, y: 100))
            ]
            )
          ),
          reducer: appReducer,
          environment: AppEnvironment(mainQueue: .immediate)))
  }
}
