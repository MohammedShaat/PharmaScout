//
//  DrugSelectionViewModelTests.swift
//  PharmaScoutTests
//
//  Created by Mohammed on 11/23/26.
//

import Testing
@testable import PharmaScout

class StubDrugService: DrugService {
    let genericDrugs: [GenericDrug] = [
        .init(id: "generic-1", genericName: "Aspirin"),
        .init(id: "generic-2", genericName: "Paracetamol"),
        .init(id: "generic-3", genericName: "Ibuprofen"),
        .init(id: "generic-4", genericName: "Diclofenac"),
    ]
    
    var formulations: [DrugFormulation] {
        [
            .init(id: "formulation-1", genericDrugId: genericDrugs[0].id, strength: "200 mg", route: "oral", form: "tablet"),
            .init(id: "formulation-2", genericDrugId: genericDrugs[0].id, strength: "400 mg", route: "oral", form: "tablet"),
            .init(id: "formulation-3", genericDrugId: genericDrugs[1].id, strength: "200 mg", route: "oral", form: "capsule"),
            .init(id: "formulation-4", genericDrugId: genericDrugs[1].id, strength: "500 mg", route: "oral", form: "capsule"),
        ]
    }
    
    private(set) var genericDrugCalls: Int = 0
    private(set) var formulationsCalls: Int = 0
    
    func searchGenericDrug(contains text: String, from: Int, to: Int) async throws -> [PharmaScout.GenericDrug] {
        genericDrugCalls += 1
        return genericDrugs.filter { $0.genericName.lowercased().contains(text.lowercased()) }
    }
    
    func searchDrugFormulations(of genericDrugId: String, contians searchText: String, from: Int, to: Int) async throws -> [PharmaScout.DrugFormulation] {
        formulationsCalls += 1
        return formulations.filter {
            $0.genericDrugId == genericDrugId &&
            (
                searchText.isEmpty
                || $0.strength.contains(searchText)
                || $0.form.contains(searchText)
                || $0.route.contains(searchText)
            )
        }
    }
}

extension DrugSelectionViewModel {
    func startSearch(for query: String) async {
        searchText = query
        await onSearchTextChanged()
    }
}

@MainActor
struct DrugSelectionViewModelTests {
    
    private let genericDrug = GenericDrug(id: "generic-1", genericName: "Aspirin")
    private let formulation = DrugFormulation(id: "formulation-1", genericDrugId: "generic-1", strength: "300 mg", route: "rectal", form: "suppository")

    private func makeVM(
        service: DrugService? = nil,
        editingSelectedDrug: SelectedDrug? = nil,
        selectedFormulationIds: [String] = []
    ) -> DrugSelectionViewModel {
        DrugSelectionViewModel(
            drugSerice: service ?? StubDrugService(),
            editingSelectedDrug: editingSelectedDrug,
            selectedFormulationIds: selectedFormulationIds
        )
    }
    
    @Test func `Search field change resets the pagination`() async throws {
        let vm = makeVM()
        vm.searchLoadingState.pagination.nextPage()
        #expect(vm.searchLoadingState.pagination.hasPreviousPage)
        
        await vm.startSearch(for: "new search")
        #expect(!vm.searchLoadingState.pagination.hasPreviousPage)
    }

    @Test func `Search doesn't start with short query`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        let minLength = AppConstants.Search.minimumQueryLength
        await vm.startSearch(for: String(repeating: "a", count: minLength - 1))
        
        #expect(service.genericDrugCalls == 0)
    }
    
    @Test func `Search starts with minimum query length`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        let minLength = AppConstants.Search.minimumQueryLength
        await vm.startSearch(for: String(repeating: "a", count: minLength))
        
        #expect(service.genericDrugCalls == 1)
    }
    
    @Test func `Search with valid query returns a list of generic drugs`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        await vm.startSearch(for: service.genericDrugs[0].genericName)
        
        #expect(service.genericDrugCalls == 1)
        #expect(vm.genericDrugs.isNotEmpty)
    }
    
    @Test func `Picking generic drug chooses it, clears search text, and loads first formulations`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        await vm.startSearch(for: service.genericDrugs[0].genericName)
        await vm.onGenericDrugClicked(genericDrug: vm.genericDrugs[0])
        await vm.startSearch(for: vm.searchText)
        
        #expect(vm.selectedGenericDrug == vm.genericDrugs[0])
        #expect(vm.searchText.isEmpty)
        #expect(vm.drugFormulations.isNotEmpty)
    }
    
    @Test func `Picking formulation chooses it`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        await vm.startSearch(for: service.genericDrugs[0].genericName)
        await vm.onGenericDrugClicked(genericDrug: vm.genericDrugs[0])
        await vm.startSearch(for: vm.searchText)
        await vm.onDrugFormulationClicked(drugFormulaion: vm.drugFormulations[0])
        
        #expect(vm.selectedGenericDrug == vm.genericDrugs[0])
        #expect(vm.selectedDrugFormulation == vm.drugFormulations[0])
    }
    
    @Test func `Canceling generic drug restores its name and clears all selections and formulation list`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        let genericDrug = service.genericDrugs[0]
        
        await vm.startSearch(for: genericDrug.genericName)
        await vm.onGenericDrugClicked(genericDrug: vm.genericDrugs[0])
        await vm.startSearch(for: vm.searchText)
        await vm.onDrugFormulationClicked(drugFormulaion: vm.drugFormulations[0])
        
        vm.onGenericDrugCanceled()
        await vm.startSearch(for: vm.searchText)
        
        #expect(vm.searchText == genericDrug.genericName)
        #expect(vm.selectedGenericDrug == nil)
        #expect(vm.selectedDrugFormulation == nil)
        #expect(vm.genericDrugs.isNotEmpty)
        #expect(vm.drugFormulations.isEmpty)
    }
    
    @Test func `Canceling formulation restores its name and clears formulation selection`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        await vm.startSearch(for: service.genericDrugs[0].genericName)
        await vm.onGenericDrugClicked(genericDrug: vm.genericDrugs[0])
        await vm.startSearch(for: vm.searchText)
        let formulation = vm.drugFormulations[0]
        await vm.onDrugFormulationClicked(drugFormulaion: formulation)
        
        vm.onDrugFormulationCanceled()
        await vm.startSearch(for: vm.searchText)
        
        #expect(vm.searchText == formulation.title)
        #expect(vm.selectedDrugFormulation == nil)
        #expect(vm.selectedGenericDrug == vm.genericDrugs[0])
    }
    
    @Test func `Load more appends new items`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        await vm.startSearch(for: service.genericDrugs[0].genericName)
        let initialSize = vm.genericDrugs.count
        await vm.loadMore()
        
        #expect(vm.genericDrugs.count > initialSize)
    }
    
    @Test func `Refresh fetches the data again from the first page`() async throws {
        let service = StubDrugService()
        let vm = makeVM(service: service)
        
        await vm.startSearch(for: service.genericDrugs[0].genericName)
        await vm.loadMore()
        let loadedItems = vm.genericDrugs
        #expect(vm.searchLoadingState.pagination.page - 1 == 1)
        
        await vm.refresh()
        
        #expect(vm.genericDrugs.count < loadedItems.count)
        #expect(vm.searchLoadingState.pagination.page - 1 == 0)
    }
}
