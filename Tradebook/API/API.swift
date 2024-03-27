//
//  API.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Foundation
import Combine
import Starscream
import AnyCodable

public class API {
    static let shared = API()
    
    enum State {
        case idle
        case connecting
        case connected
        case disconnected
    }
    
    private var state: State = .idle
    private var socket: WebSocket? = nil {
        willSet {
            socket?.delegate = nil
            socket?.disconnect()
        }
    }
    private var pendingSubscriptions: [WSTopic] = []
    
    public var publisher: PassthroughSubject<WSMessage, Never> = .init()
    
    public func disconnect() {
        socket = nil
    }
    
    public func connect() throws {
        guard state != .connected else {
            return
        }
        
        let socket = try WebSocket(request: URL.request())
        socket.delegate = self
        socket.connect()
        self.socket = socket
    }
    
    public func subscribe(_ topics: [WSTopic]) {
        pendingSubscriptions.append(contentsOf: topics)
        guard state == .connected else {
            return
        }
    }

    public func handleMessage(_ text: String) {
        print("<<<< : \(text)")
        
        guard let data = text.data(using: .utf8) else {
            return
        }
        
        do {
            let message = try JSONDecoder.shared.decode(WSMessage.self, from: data)
            self.publisher.send(message)
        } catch let error {
            handleError(error)
        }
    }
    
    private func subscribe() {
        do {
            let command = WSCommand(op: WSOperation.subscribe.rawValue, args: self.pendingSubscriptions.map{$0.rawValue})
            self.pendingSubscriptions.removeAll()
            try send(command)
        } catch let error {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error?) {
        print("!!!! Error: \(error?.localizedDescription ?? "Unknown")")
    }
}

extension API: WebSocketDelegate {
    public func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
            case .text(let string):
                handleMessage(string)

            case .connected(_):
                state = .connected
                subscribe()
            
            case .disconnected(let reason, let code):
                socket = nil
                state = .disconnected
            
            case .error(let error):
                socket = nil
                state = .disconnected
                handleError(error)

        default:
            print("<<<< TODO: event: \(event)")
            break
        }
    }
}

extension API {
    private func send(_ command: WSCommand) throws {
        let data = try JSONEncoder().encode(command)
        self.socket?.write(stringData: data, completion: {
            print(">>>> \(String(data: data, encoding: .utf8) ?? "")")
        })
    }
}
