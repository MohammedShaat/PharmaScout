//
//  DeleteAccountPayload.swift
//  PharmaScout
//
//  Created by Mohammed on 11/3/26.
//


import Foundation

struct DeleteAccountPayload: Encodable {
    let reauth: ReauthCredential
}