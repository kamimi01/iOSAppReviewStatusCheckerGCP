//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/02.
//

import Foundation
import JWT

struct Payload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case issue = "iss"
        case issuedAtClaim = "isa"
        case expiration = "exp"
        case audience = "aud"
    }

    var issue: IssuerClaim
    var issuedAtClaim: IssuedAtClaim
    var expiration: ExpirationClaim
    var audience: AudienceClaim

    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.audience.verifyIntendedAudience(includes: "appstoreconnect-v1")
    }
}
