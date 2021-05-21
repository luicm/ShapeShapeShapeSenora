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
    WithViewStore(self.store, removeDuplicates: ==) { viewStore in
      Rectangle()
        .frame(minWidth: 500, minHeight: 300)
        .gesture(
          DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { state in
                viewStore.send(.createShapeAt(state.startLocation), animation: .easeInOut(duration: 0.2))
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
              .frame(width: CGFloat(shape.size.width), height: CGFloat(shape.size.height))
              .overlay(Text("x: \(shape.position.x) y: \(shape.position.y)").font(.caption))
              .draggableSenoraShape(shape: shape, viewStore: viewStore)
              .position(x: CGFloat(shape.position.x), y: CGFloat(shape.position.y))
              // .offset(x: CGFloat(shape.position.x), y: CGFloat(shape.position.y))
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

// Handle dragging
struct DraggableSenoraShapeView: ViewModifier {
  let shape: SenoraShape
  // let store: Store<AppState, AppAction>
  let viewStore: ViewStore<AppState, AppAction>
  var offset: SenoraShape.SenoraPosition { shape.position }

  func body(content: Content) -> some View {
    // WithViewStore(self.store.stateless) { viewStore in
    content
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            viewStore.send(.didSelect(shape))
            var newOffset = offset
            newOffset.x += Double(value.location.x - value.startLocation.x)
            newOffset.y += Double(value.location.y - value.startLocation.y)
            viewStore.send(
              .didDrag(
                .init(
                  x: Double(newOffset.x),
                  y: Double(newOffset.y)
                )

              )
            )
          }
      )
    // }
  }
}

// Wrap `draggable()` in a View extension to have a clean call site
extension View {
  func draggableSenoraShape(shape: SenoraShape, viewStore: ViewStore<AppState, AppAction>)
    -> some View
  {
    return modifier(DraggableSenoraShapeView(shape: shape, viewStore: viewStore))
    // return modifier(DraggableSenoraShapeView(shape: shape, store: store))
  }
}
