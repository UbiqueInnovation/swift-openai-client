//
//  File 2.swift
//
//
//  Created by Nicolas Märki on 30.06.2024.
//

import Foundation

public struct Chat {

    let client: Client
    let model: Components.Schemas.CreateChatCompletionRequest.modelPayload

    public init(gptModel model: Components.Schemas.CreateChatCompletionRequest.modelPayload.Value2Payload = .gpt_hyphen_4o, using client: Client) {
        self.client = client
        self.model = .init(value2: model)
    }

    public init(model: String, using client: Client) {
        self.client = client
        self.model = .init(value1: model)
    }

    public func completion(_ messages: ChatPayload...) async throws -> Message {
        try await completion(messages)
    }

    public func completion(_ messages: [ChatPayload]) async throws -> Message {
        let requestMessages = messages.map { $0.chatCompletionRequestMessage }
        let completion = try await client.createChatCompletion(body: .json(.init(messages: requestMessages, model: model))).ok.body.json

        return Message(raw: completion.choices[0].message)
    }

}

public protocol ChatPayload {
    var chatCompletionRequestMessage: Components.Schemas.ChatCompletionRequestMessage { get }
}

public protocol ChatPayloadPart {
    var chatCompletionRequestMessageContentPart: Components.Schemas.ChatCompletionRequestMessageContentPart { get }
}

extension String: ChatPayload, ChatPayloadPart {
    public var chatCompletionRequestMessageContentPart: Components.Schemas.ChatCompletionRequestMessageContentPart {
        .ChatCompletionRequestMessageContentPartText(.init(_type: .text, text: self))

    }
    public var chatCompletionRequestMessage: Components.Schemas.ChatCompletionRequestMessage {
        Components.Schemas.ChatCompletionRequestMessage.ChatCompletionRequestUserMessage(.init(content: .case2([self.chatCompletionRequestMessageContentPart]), role: .user))
    }
}

extension Message.Part {
    public var chatCompletionRequestMessageContentPart: Components.Schemas.ChatCompletionRequestMessageContentPart {
        switch self {
        case .text(let text):
            return .ChatCompletionRequestMessageContentPartText(.init(_type: .text, text: text))
            case .file(_): fatalError("Not implemented")
        case .image_url(let url):
                return .ChatCompletionRequestMessageContentPartImage(.init(_type: .image_url, image_url: .init(url: url)))
        }
    }
}

extension Message: ChatPayload {
    public var chatCompletionRequestMessage: Components.Schemas.ChatCompletionRequestMessage {
        let parts = self.parts.map { $0.chatCompletionRequestMessageContentPart }
        switch self.role {
            case .user:
                return .ChatCompletionRequestUserMessage(.init(content: .case2(parts), role: .user))
            case .assistant:
                let content = try! self.text
                return .ChatCompletionRequestAssistantMessage(.init(content: content, role: .assistant))
        }

    }
}
