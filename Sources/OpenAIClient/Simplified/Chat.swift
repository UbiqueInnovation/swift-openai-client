//
//  File 2.swift
//  
//
//  Created by Nicolas Märki on 30.06.2024.
//

import Foundation

public struct Chat {

    let client: Client
    let model: Components.Schemas.CreateChatCompletionRequest.modelPayload.Value2Payload

    public init(model: Components.Schemas.CreateChatCompletionRequest.modelPayload.Value2Payload = .gpt_hyphen_4o, using client: Client) {
        self.client = client
        self.model = model
    }

    public func completion(_ messages: ChatContentPayload...) async throws -> Message {
        return try await completion(messages)
    }
    
    public func completion(_ messages: [ChatContentPayload]) async throws -> Message {
        let requestMessages = messages.map { Components.Schemas.ChatCompletionRequestMessage.ChatCompletionRequestUserMessage(.init(content: .case2([$0.chatCompletionContentPayload]), role: .user)) }
        let completion = try await client.createChatCompletion(body: .json(.init(messages: requestMessages, model: .init(value2: model)))).ok.body.json

        return Message(raw: completion.choices[0].message)
    }

}
