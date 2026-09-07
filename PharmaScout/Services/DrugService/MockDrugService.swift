//
//  MockDrugService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

struct MockDrugService: DrugService {
    func autoComplete(for text: String) async throws -> [GenericDrug] {
        GenericDrug.samples.filter {
            $0.genericName.localizedCaseInsensitiveContains(text)
        }
    }
}
