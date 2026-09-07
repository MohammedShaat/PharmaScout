//
//  DrugService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

protocol DrugService {
    func autoComplete(for text: String) async throws -> [GenericDrug]
}
