//
//  LoginViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/23/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

enum LoginResult {
    case loggedIn
    case error(message: String)
}

struct LoginViewModel {
    
    weak var delegate: ViewModelDidComplete?
    
    private let networking = BaseNetworking.newNetworking()
    let keys = AppKeys.instance
    
    init() {

    }
    
    func login(email: String?, password: String?, completionBlock: @escaping (LoginResult) -> Void) {
        guard let email = email, let password = password else {return}
        
        networking.request(CoreApiClient.authenticateUser(email: email, password: password)) {
            completion in
            
            switch completion {
            case let .success(moyaResponse):
                do {
                    let authHeader = try moyaResponse.filterSuccessfulStatusCodes().mapAuthHeader()
                    
                    try self.keys.save(token: authHeader)
                    completionBlock(.loggedIn)
                }catch {
                    completionBlock(.error(message: "Unsuccessful \(moyaResponse.statusCode)"))
                }
                
            case .failure:
                completionBlock(.error(message: "Could Not Login"))
            }
        }
    }
}
