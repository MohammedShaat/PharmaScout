//
//  GenericDrug+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

extension GenericDrug {
    static let samples: [GenericDrug] = [
       
        GenericDrug(
            id: .init(uuidString: "b1494acf-88eb-44a4-925d-b266839b7471")!,
            genericName: "Amoxicillin + Clavulanic Acid"
        ),

        GenericDrug(
            id: .init(uuidString: "8a89a93a-ac39-4562-ab7f-bb5c383c5bc3")!,
            genericName: "Paracetamol"
        ),


        GenericDrug(
            id: .init(uuidString: "b864e0e3-7e65-401c-bad0-585e776a129a")!,
            genericName: "Ibuprofen"
        ),


        GenericDrug(
            id: .init(uuidString: "ad652256-8e4f-4325-8221-3254dc7b87ed")!,
            genericName: "Amoxicillin"
        ),


        GenericDrug(
            id: .init(uuidString: "99714fc0-1b3f-4252-9176-715947ca187c")!,
            genericName: "Diclofenac"
        ),

    ]
}
