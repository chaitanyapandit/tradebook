//
//  API.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Foundation
import Combine
import Starscream

public class API<T: Decodable & Requestable> {
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

    public var publisher: PassthroughSubject<T, Never> = .init()
    
    public func disconnect() {
        socket = nil
    }
    
    public func connect() throws {
        let request = try T.request()
        let socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        self.socket = socket
    }
    
    public func decode(_ text: String) throws -> T {
        guard let data = text.data(using: .utf8) else {
            throw APIError.badData
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension API: WebSocketDelegate {
    public func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
            case .text(let string):
            print("<<<< : \(string)")
            do {
                let val = try self.decode(string)
                self.publisher.send(val)
            } catch let err {
                print("<<<< ERROR: \(err)")
            }
            
            case .connected(let headers):
                self.state = .connected
            
            case .disconnected(let reason, let code):
                self.socket = nil
                self.state = .disconnected
            
            case .error(let error):
                self.socket = nil
                self.state = .disconnected
            
        default:
            print("<<<< TODO: event: \(event)")
            break
        }
    }
}
