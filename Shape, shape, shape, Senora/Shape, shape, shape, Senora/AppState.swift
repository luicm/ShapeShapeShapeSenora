//
//  AppState.swift
//  Shape, shape, shape, Senora
//
//  Created by Luisa Cruz Molina on 21.05.21.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct SenoraDocument: Equatable {
  var shapes: [SenoraShape] = []
  var selectedShape: SenoraShape? = nil
}

extension UTType {
  static var senora: UTType {
    UTType(exportedAs: "com.senora.content")
  }
}

extension SenoraDocument: FileDocument {
  static var readableContentTypes: [UTType] {
    return [.senora]
  }

  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else {
      throw CocoaError(.fileReadCorruptFile)
    }
    let decoder = JSONDecoder()
    self.shapes = try decoder.decode([SenoraShape].self, from: data)
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let encoder = JSONEncoder()
    let data = try encoder.encode(self.shapes)
    return FileWrapper(regularFileWithContents: data)
  }
}

struct SenoraShape: Equatable, Identifiable, Codable {

  enum ShapeType: Int, CaseIterable, Codable {
    case oval
    case rectangle
  }

  let id = UUID()
  var size: SenoraSize
  var position: SenoraPosition
  var color: Color
  let type: ShapeType
  var isSelected: Bool = false

  struct SenoraSize: Equatable, Codable {
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

  struct SenoraPosition: Equatable, Codable {
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

//MARK: -

struct AppState: Equatable {
  var document: SenoraDocument
  var isExportingPresented: Bool = false
  var isImportingPresented: Bool = false
}

enum AppAction: Equatable {
  case createShapeAt(CGPoint)
  case didChangeColor(Color)
  case didChangeSize(SenoraShape.SenoraSize)
  case didDrag(SenoraShape.SenoraPosition)
  case didSelect(SenoraShape)
  case didImporDocument([SenoraShape])
  case setExporting(isPresented: Bool)
  case setImporting(isPresented: Bool)
}

struct AppEnvironment {
  var fileClient: FileClient
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

  case .didImporDocument(let shapes):
    state.document.shapes = shapes
    return .none

  case .setExporting(isPresented: let presented):
    state.isExportingPresented = presented
    return .none

  case .setImporting(isPresented: let presented):
    state.isImportingPresented = presented
    return .none
  }
}
.debug()

//MARK: -

struct FileClient {
  var load: (String) -> Effect<Data, Error>
  var save: (String, Data) -> Effect<Never, Error>
}

extension FileClient {
  static var live: Self {
    return Self(
      load: { fileName in
        .catching {
          //TODO:
          Data()
        }
      },
      save: { fileName, data in
        .fireAndForget {
          //TODO:
        }
      }
    )
  }
}
