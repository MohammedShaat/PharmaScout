//
//  SupabaseManager.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

struct SupabaseManager {
    static let shared = SupabaseManager()
    
    private let urlStr = "https://lwrpmlmfeyhglsniponn.supabase.co"
    private let key = "sb_publishable_q-LZxtCJa-lOCYk5CBm4tQ_zXKRNXZ-"
    
    let client: SupabaseClient
    
    private init() {
        let options = SupabaseClientOptions(
            auth: .init(emitLocalSessionAsInitialSession: true)
        )
        client = SupabaseClient(
            supabaseURL: URL(string: urlStr)!,
            supabaseKey: key,
            options: options
        )
    }
}
