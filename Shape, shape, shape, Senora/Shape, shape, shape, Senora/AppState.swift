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
  var shapes: [SenoraShape]
}

struct SenoraShape: Equatable, Identifiable {

  enum ShapeType: CaseIterable {
    case oval
    case rectangle
  }

  let id = UUID()
  let size: SenoraSize
  let postion: SenoraPosition
  let color: SenoraColor
  let type: ShapeType

  struct SenoraSize: Equatable {
    let height: Double
    let width: Double

    init(
      height: Double = .random(in: 20..<300),
      width: Double = .random(in: 20..<300)
    ) {
      self.height = height
      self.width = height
    }
  }

  struct SenoraPosition: Equatable {
    let x: Double
    let y: Double

    var cgPosition: CGPoint {
      return CGPoint(x: self.x, y: self.y)
    }
  }

  struct SenoraColor: Equatable {
    let hue: Double
    let saturation: Double
    let brightness: Double
    let opacity: Double

    var swiftColor: Color {
      return Color(
        hue: self.hue,
        saturation: self.saturation,
        brightness: self.brightness,
        opacity: self.opacity)
    }

    init(
      hue: Double = .random(in: 0..<1),
      saturation: Double = 0.85,
      brightness: Double = 1,
      opacity: Double = 1
    ) {
      self.hue = hue
      self.saturation = saturation
      self.brightness = brightness
      self.opacity = opacity
    }
  }
}

extension SenoraShape {
  init(
    position: CGPoint,
    size: SenoraShape.SenoraSize = .init(),
    color: SenoraShape.SenoraColor = .init(),
    type: ShapeType = ShapeType.allCases.randomElement()!
  ) {
    self.postion = SenoraPosition(x: Double(position.x), y: Double(position.y))
    self.size = size
    self.color = color
    self.type = type
  }
}

struct AppState: Equatable {
  var document: SenoraDocument
}

enum AppAction: Equatable {
  case createShapeAt(CGPoint)
  case didChangeColor(SenoraShape.SenoraColor)
  case didChangeSize(SenoraShape.SenoraSize)
  case didDrag(SenoraShape.SenoraPosition)
  case didSelect(SenoraShape)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in

  switch action {
  case .createShapeAt(let point):
    let newShape = SenoraShape(position: point)
    state.document.shapes.append(newShape)

    return .none

  case .didChangeColor(_):
    return .none

  case .didChangeSize(_):
    return .none

  case .didDrag(_):
    return .none

  case .didSelect(_):
    return .none

  }
}.debug()
