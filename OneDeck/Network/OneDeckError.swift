//
//  OneDeckError.swift
//  OneDeck
//
//  Created by Antigravity on 2026/10/16.
//

import Foundation

public enum OneDeckError: LocalizedError, Sendable {
    case invalidURL
    case networkError(String)
    case serverError(code: Int, message: String)
    case unauthorized
    case decodingError(String)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "服务器地址无效，请检查配置"
        case .networkError(let detail):
            return "网络连接失败: \(detail)"
        case .serverError(let code, let message):
            return "服务器错误 [\(code)]: \(message)"
        case .unauthorized:
            return "登录凭证已失效或无权访问，请重新登录"
        case .decodingError(let detail):
            return "数据解析错误: \(detail)"
        case .unknown:
            return "未知异常"
        }
    }
}
