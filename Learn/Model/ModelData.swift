//
//  VideoData.swift
//  Learn
//
//  Created by Teema Khawjit on 7/30/23.
//

import Foundation

class ModelData: ObservableObject {
    @Published var drafts = [Draft]()

    init() {
        loadData()
    }

    private func loadData() {
        // Load data from the JSON file
        if let data = loadJSONData() {
            drafts = data
        }
    }

    private func loadJSONData() -> [Draft]? {
        guard let fileURL = Bundle.main.url(forResource: "contentData", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let contents = try JSONDecoder().decode([Draft].self, from: data)
            return contents
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    private func saveData() {
        guard let fileURL = Bundle.main.url(forResource: "contentData", withExtension: "json") else {
            return
        }

        do {
            let data = try JSONEncoder().encode(drafts)
            try data.write(to: fileURL)
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }

    // CRUD Operations

    func addContent(_ draft: Draft) {
        drafts.append(draft)
        saveData()
    }

    func updateContent(_ draft: Draft) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            drafts[index] = draft
            saveData()
        }
    }

    func deleteContent(_ draft: Draft) {
        drafts.removeAll { $0.id == draft.id }
        saveData()
    }
    
    // CRUD Operations for decision
    
    func addDecision(_ draft: Draft, _ decision: Node) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            drafts[index].nodes.append(decision)
            saveData()
        }
    }
    
    func updateDecision(_ draft: Draft, _ decision: Node) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            if let decisionIndex = drafts[index].nodes.firstIndex(where: { $0.id == decision.id }) {
                drafts[index].nodes[decisionIndex] = decision
                saveData()
            }
        }
    }
    
    func deleteDecision(_ draft: Draft, _ decision: Node) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            if let decisionIndex = drafts[index].nodes.firstIndex(where: { $0.id == decision.id }) {
                drafts[index].nodes.remove(at: decisionIndex)
                saveData()
            }
        }
    }
    
    // CRUD Operations for option
    
    func addOption(_ draft: Draft, _ decision: Node, _ option: Branch) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            if let decisionIndex = drafts[index].nodes.firstIndex(where: { $0.id == decision.id }) {
                drafts[index].nodes[decisionIndex].branchs.append(option)
                saveData()
            }
        }
    }
    
    func updateOption(_ draft: Draft, _ decision: Node, _ option: Branch) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            if let decisionIndex = drafts[index].nodes.firstIndex(where: { $0.id == decision.id }) {
                if let optionIndex = drafts[index].nodes[decisionIndex].branchs.firstIndex(where: { $0.id == option.id }) {
                    drafts[index].nodes[decisionIndex].branchs[optionIndex] = option
                    saveData()
                }
            }
        }
    }
    
    func deleteOption(_ draft: Draft, _ decision: Node, _ option: Branch) {
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            if let decisionIndex = drafts[index].nodes.firstIndex(where: { $0.id == decision.id }) {
                if let optionIndex = drafts[index].nodes.firstIndex(where: { $0.id == decision.id }) {
                    drafts[index].nodes[decisionIndex].branchs.remove(at: optionIndex)
                    saveData()
                }
            }
        }
    }
    
}

