//
//  File.swift
//
//
//  Created by Nicolas Märki on 27.06.2024.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public struct Message {
    public enum Part {
        case text(String)
        case image_url(String)
        case file(String)

        init(raw: String) {
            self = .text(raw)
        }
        init(raw: Components.Schemas.MessageObject.contentPayloadPayload) {
            switch raw {
                case .MessageContentTextObject(let text):
                    self = .text(text.text.value)
                case .MessageContentImageUrlObject(let url):
                    self = .image_url(url.image_url.url)
                case .MessageContentImageFileObject(let file):
                    self = .file(file.image_file.file_id)
            }
        }
    }
    public enum Role {
        case user
        case assistant
    }
    let parts: [Part]
    let role: Role

    init(raw: Components.Schemas.MessageObject) {
        self.parts = raw.content.map { Part(raw: $0) }
        switch raw.role {
            case .assistant: self.role = .assistant
            case .user: self.role = .user
        }
    }
    init(raw: Components.Schemas.ChatCompletionResponseMessage) {
        if let text = raw.content {
            self.parts = [.text(text)]
        }
        else {
            self.parts = []
        }
        switch raw.role {
            case .assistant: self.role = .assistant
        }
    }
    public init(_ parts: [MessagePartContent], role: Role = .user) {
        self.parts = parts.map { $0.part }
        self.role = role
    }
    public init(_ parts: MessagePartContent..., role: Role = .user) {
        self.parts = parts.map { $0.part }
        self.role = role
    }

    public var text: String {

        get throws {
            switch parts.first {
                case .none: throw OpenAIError(errorDescription: "No parts")
                case .text(let text): return text
                default: throw OpenAIError(errorDescription: "No text part")
            }
        }

        
    }

    public func decoded<T: Decodable>(as type: T.Type = T.self) throws -> T {
        return try JSONDecoder().decode(T.self, from: self.text.data(using: .utf8)!)
    }
}

public protocol MessagePartContent {
    var part: Message.Part { get }
}

extension String: MessagePartContent {
     public var part: Message.Part {
        .text(self)
    }
}

extension URL: MessagePartContent {
    public var part: Message.Part {
        .image_url(self.absoluteString)
    }
}

#if canImport(UIKit)
extension UIImage: MessagePartContent {
    public var part: Message.Part {
        let encoded = self.pngData()!.base64EncodedString()
        let url = "data:image/png;base64,\(encoded)"
        return .image_url(url)
    }
}
#endif
