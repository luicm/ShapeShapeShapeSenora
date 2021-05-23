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
  var selectedShape: SenoraShape? = nil
}

struct SenoraShape: Equatable, Identifiable {

  enum ShapeType: CaseIterable {
    case oval
    case rectangle
  }

  let id = UUID()
  var size: SenoraSize
  var position: SenoraPosition
  var color: Color
  let type: ShapeType
  var isSelected: Bool = false

  struct SenoraSize: Equatable {
    var height: Double
    var width: Double

    init(
      height: Double = .random(in: 20..<300),
      width: Double = .random(in: 20..<300)
    ) {
      self.height = height
      self.width = width
    }
  }

  struct SenoraPosition: Equatable {
    var x: Double
    var y: Double

    var cgPosition: CGPoint {
      return CGPoint(x: self.x, y: self.y)
    }

    var xStringValue: String {
      return "\(x)"
    }

    var yStringValue: String {
      return "\(y)"
    }
  }

/*
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
  }*/
}

extension SenoraShape {
  init(
    position: CGPoint,
    size: SenoraShape.SenoraSize = .init(),
    color: Color = Color.random,
    type: ShapeType = ShapeType.allCases.randomElement()!
  ) {
    self.position = SenoraPosition(x: Double(position.x), y: Double(position.y))
    self.size = size
    self.color = color
    self.type = type
  }
    
}

extension SenoraShape {
  mutating func setPosition(position: SenoraPosition) {
    self.position = position
  }
}

struct AppState: Equatable {
  var document: SenoraDocument
}

enum AppAction: Equatable {
  case createShapeAt(CGPoint)
  case didChangeColor(Color)
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

  case .didChangeColor(let color):
    guard
      var selectedShape = state.document.selectedShape,
      let index = state.document.shapes.firstIndex(of: selectedShape)
    else {
      return .none
    }
    selectedShape.color = color
    state.document.shapes[index] = selectedShape
    state.document.selectedShape = selectedShape
    
    return .none

  case .didChangeSize(let size):
    guard
      var selectedShape = state.document.selectedShape,
      let index = state.document.shapes.firstIndex(of: selectedShape)
    else {
      return .none
    }
    selectedShape.size.width = size.width
    selectedShape.size.height = size.height
    state.document.shapes[index] = selectedShape
    state.document.selectedShape = selectedShape
    
    return .none

  case .didDrag(let position):
    guard
      var selectedShape = state.document.selectedShape,
      let index = state.document.shapes.firstIndex(of: selectedShape)
    else {
      return .none
    }
    selectedShape.position.x = Double(position.x)
    selectedShape.position.y = Double(position.y)
    state.document.shapes[index] = selectedShape
    state.document.selectedShape = selectedShape

    // state.document.shapes
    //     .first(where: { $0.id == id })?
    //     .setPosition(position: position)

    return .none

  case .didSelect(let leshape):
    state.document.selectedShape = leshape
    return .none

  }
}
.debug()
