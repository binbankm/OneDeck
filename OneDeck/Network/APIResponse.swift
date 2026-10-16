//
//  APIResponse.swift
//  OneDeck
//
//  Created by Antigravity on 2026/10/16.
//

import Foundation

/// 1Panel 统一响应外层包装
public struct APIResponse<T: Codable & Sendable>: Codable, Sendable {
    public let code: Int
    public let message: String?
    public let data: T?
    
    public nonisolated var isSuccess: Bool {
        return code == 200
    }
    
    public nonisolated init(code: Int, message: String? = nil, data: T? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// 通用空数据响应
public struct EmptyData: Codable, Sendable, Hashable {
    public nonisolated init() {}
}
