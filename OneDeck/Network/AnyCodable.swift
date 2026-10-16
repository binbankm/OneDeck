//
//  AnyCodable.swift
//  OneDeck
//
//  Created by Antigravity on 2026/10/16.
//

import Foundation

/// 支持任意 JSON 类型解码与编码的 Swift 容器
public struct AnyCodable: Codable, Sendable, Hashable {
    public let value: AnySendable
    
    public init(_ value: Any?) {
        self.value = AnySendable(value ?? ())
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = AnySendable(())
        } else if let bool = try? container.decode(Bool.self) {
            self.value = AnySendable(bool)
        } else if let int = try? container.decode(Int.self) {
            self.value = AnySendable(int)
        } else if let double = try? container.decode(Double.self) {
            self.value = AnySendable(double)
        } else if let string = try? container.decode(String.self) {
            self.value = AnySendable(string)
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = AnySendable(array.map { $0.value.base })
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            self.value = AnySendable(dict.mapValues { $0.value.base })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable unsupported value")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let base = value.base
        switch base {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            let codableArray = array.map { AnyCodable($0) }
            try container.encode(codableArray)
        case let dict as [String: Any]:
            let codableDict = dict.mapValues { AnyCodable($0) }
            try container.encode(codableDict)
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable unsupported value")
            throw EncodingError.invalidValue(base, context)
        }
    }
}

public struct AnySendable: @unchecked Sendable, Hashable {
    public let base: Any
    
    public init(_ base: Any) {
        self.base = base
    }
    
    public static func == (lhs: AnySendable, rhs: AnySendable) -> Bool {
        String(describing: lhs.base) == String(describing: rhs.base)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: base))
    }
}
