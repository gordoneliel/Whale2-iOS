//
//  AppKeys.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/23/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import KeychainAccess

public class AppKeys {
    public enum WhaleKeyIdentifier: String {
        case token
    }
    
    static let instance = AppKeys()
    let keychain = Keychain()
    
    var hasToken: Bool {
        do {
            let str = try keychain.get(WhaleKeyIdentifier.token.rawValue) ?? ""
            return !str.isEmpty
        }catch {
            return false
        }
    }
    
    
    var token: String {
        do {
         return try keychain.get(WhaleKeyIdentifier.token.rawValue) ?? ""
        }catch {
            return ""
        }
    }
    
    init() {
        
    }
    
    func save(token: String) throws {
        return try keychain.set(token, key: WhaleKeyIdentifier.token.rawValue)
    }
    
    func erase() throws {
        return try keychain.removeAll()
    }
}
