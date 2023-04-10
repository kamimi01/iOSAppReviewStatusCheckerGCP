//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Foundation

struct PostMessageResponse: Decodable {
    let ok: Bool
    let error: String?

    init(ok: Int, error: String?) {
        print(ok)
        self.ok = (ok == 1) ? true : false
        self.error = error
    }
}
