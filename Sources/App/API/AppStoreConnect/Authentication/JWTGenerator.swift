//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/01.
//

import Foundation
import Vapor
import JWT

class JWTGenrator {
    let app: Application

    init(app: Application) {
        self.app = app
    }

    func generateJWT() -> String {
        let ecdsaPrivateKey = ""
        do {
            let key = try ECDSAKey.private(pem: ecdsaPrivateKey)
            app.jwt.signers.use(.es256(key: key))
        } catch {

        }
    }
}
