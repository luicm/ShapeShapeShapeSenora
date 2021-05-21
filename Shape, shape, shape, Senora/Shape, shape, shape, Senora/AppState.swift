//
//  AppState.swift
//  Shape, shape, shape, Senora
//
//  Created by Luisa Cruz Molina on 21.05.21.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct SenoraDocument: Equatable {
  let shapes: [SenoraShape]

}

struct SenoraShape: Equatable, Identifiable {
  enum ShapeType {
    case oval
    case rectangle
  }

  let id = UUID()
  let size: CGSize
  let postion: CGPoint
  let color: Color
  let type: ShapeType

}

struct AppState: Equatable {
  var document: SenoraDocument
}

enum AppAction: Equatable {
  case didChangeColor(Color)
  case didChangeSize(CGSize)
  case didDrag(CGPoint)
  case didSelect(SenoraShape)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in

  switch action {
  case .didChangeColor(_):
    return .none

  case .didChangeSize(_):
    return .none

  case .didDrag(_):
    return .none

  case .didSelect(_):
    return .none

  }
}
