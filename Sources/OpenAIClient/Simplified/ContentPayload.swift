//
//  File.swift
//  
//
//  Created by Nicolas Märki on 27.06.2024.
//

import Foundation



//public protocol ContentPart {
//    var chatCompletionRequestMessageContentPart: Components.Schemas.ChatCompletionRequestMessageContentPart { get }
//}
//
//public protocol ContentPayload {
//    var createMessageRequestContentPayload2: Components.Schemas.CreateMessageRequest.contentPayload.Case2PayloadPayload { get }
//    var chatCompletionRequestMessage: Components.Schemas.ChatCompletionRequestMessage { get }
//}
//
//extension String: ContentPart {
//    public var chatCompletionRequestMessageContentPart: Components.Schemas.ChatCompletionRequestMessageContentPart {
//        .ChatCompletionRequestMessageContentPartText(.init(_type: .text, text: self))
//    }
//}
//
//extension String: ContentPayload {
//    public var createMessageRequestContentPayload2: Components.Schemas.CreateMessageRequest.contentPayload.Case2PayloadPayload {
//        .MessageRequestContentTextObject(.init(_type: .text, text: self))
//    }
//
//    public var chatCompletionRequestMessage: Components.Schemas.ChatCompletionRequestMessage {
//        Components.Schemas.ChatCompletionRequestMessage.ChatCompletionRequestUserMessage(.init(content: .case2([self.chatCompletionRequestMessageContentPart]), role: .user))
//    }
//
//}


