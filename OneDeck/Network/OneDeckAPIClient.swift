//
//  OneDeckAPIClient.swift
//  OneDeck
//
//  Created by Antigravity on 2026/10/16.
//

import Foundation

public final class OneDeckAPIClient: NSObject, URLSessionDelegate, Sendable {
    public static let shared = OneDeckAPIClient()
    
    // 当前连接的服务器配置
    public struct ServerConfig: Sendable, Codable {
        public var baseURL: String // e.g. "https://192.168.1.100:9999"
        public var token: String? // "1Panel-Token"
        public var entranceCode: String? // 安全入口，例如 "myentrance"
        public var allowInsecureSSL: Bool // 是否允许内网自签名 SSL 证书
        
        public init(
            baseURL: String = "",
            token: String? = nil,
            entranceCode: String? = nil,
            allowInsecureSSL: Bool = true
        ) {
            self.baseURL = baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            self.token = token
            self.entranceCode = entranceCode
            self.allowInsecureSSL = allowInsecureSSL
        }
    }
    
    private let configLock = NSLock()
    private var _config: ServerConfig = ServerConfig()
    
    public var config: ServerConfig {
        get {
            configLock.lock()
            defer { configLock.unlock() }
            return _config
        }
        set {
            configLock.lock()
            _config = newValue
            configLock.unlock()
        }
    }
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    public override init() {
        super.init()
    }
    
    /// 发起请求并解包标准 APIResponse<T>
    public func request<T: Codable & Sendable>(
        path: String,
        method: String = "GET",
        queryItems: [URLQueryItem]? = nil,
        body: (any Encodable)? = nil,
        customHeaders: [String: String]? = nil
    ) async throws -> T {
        let currentConfig = self.config
        guard !currentConfig.baseURL.isEmpty else {
            throw OneDeckError.invalidURL
        }
        
        // 拼接完整 URL（1Panel 统一路由前缀 /api/v2）
        let normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
        let fullPathString = "\(currentConfig.baseURL)\(normalizedPath)"
        
        guard var components = URLComponents(string: fullPathString) else {
            throw OneDeckError.invalidURL
        }
        
        if let queryItems = queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw OneDeckError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 自动注入 1Panel 鉴权 Header
        if let token = currentConfig.token, !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "1Panel-Token")
        }
        
        // 自动注入安全入口 Header
        if let entrance = currentConfig.entranceCode, !entrance.isEmpty {
            let base64Entrance = Data(entrance.utf8).base64EncodedString()
            request.setValue(base64Entrance, forHTTPHeaderField: "EntranceCode")
        }
        
        // 自定义 Header
        customHeaders?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        // 编码 Request Body
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw OneDeckError.networkError(error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OneDeckError.unknown
        }
        
        if httpResponse.statusCode == 401 {
            throw OneDeckError.unauthorized
        }
        
        // 解码外层包装结构 APIResponse<T>
        let decoder = JSONDecoder()
        do {
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
            if apiResponse.isSuccess {
                if let unwrapped = apiResponse.data {
                    return unwrapped
                }
                if let empty = EmptyData() as? T {
                    return empty
                }
                throw OneDeckError.decodingError("返回成功但数据字段为空")
            } else {
                throw OneDeckError.serverError(code: apiResponse.code, message: apiResponse.message ?? "未知错误")
            }
        } catch let error as OneDeckError {
            throw error
        } catch {
            // 如果接口返回未包装的裸数据，尝试兜底直接解码
            if let direct = try? decoder.decode(T.self, from: data) {
                return direct
            }
            throw OneDeckError.decodingError("解析失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - URLSessionDelegate (支持内网自签名证书)
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if config.allowInsecureSSL,
           challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
