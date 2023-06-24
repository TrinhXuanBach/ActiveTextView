//
//  ActiveComponentVM.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import Foundation

class ActiveComponentVM {
    private (set) var activeComponentParser   = ActiveComponentParser()
    private (set) var registerActiveTypes     = [ActiveComponentType]()
    private (set) var components              = [ActiveComponentType: [ActiveComponent]]()
    
    func registerActiveTypeComponents(registerActiveType: [ActiveComponentType]) {
        self.registerActiveTypes = registerActiveType
    }
    
    func registerActiveTypeComponent(registedActiveType: ActiveComponentType) {
        guard !isContainActiveType(activeType: registedActiveType) else { return }
        self.registerActiveTypes.append(registedActiveType)
    }
    
    func unregisterActiveTypeComponent(registedActiveType: ActiveComponentType) {
        self.registerActiveTypes.removeAll(
            where: { $0.getSchema() == registedActiveType.getSchema() })
        self.components.removeValue(forKey: registedActiveType)
    }
    
    func parserComponents(text: String) {
        for type in registerActiveTypes {
            guard isNeedParserType(activeType: type) else {
                continue
            }
            
            components[type] = activeComponentParser.createElements(type: type,
                                                                    from: text)
        }
    }
    
    func parserMoreComponent(text: String) {
        guard let moreActiveType = findActiveComponent(by: Constant.Schema.moreSchema) else {
            return
        }
        
        components[moreActiveType] = activeComponentParser.createMoreElement(
            type: moreActiveType, from: text)
    }
    
    func isHasMoreActiveType() -> Bool {
        return registerActiveTypes.contains(
            where: { $0.getSchema() == Constant.Schema.moreSchema})
    }
    
    func findActiveComponent(by schema: String) -> ActiveComponentType? {
        return registerActiveTypes.first(where: { $0.getSchema() == schema })
    }
    
    private func isNeedParserType(activeType: ActiveComponentType) -> Bool {
        return activeType.getSchema() != Constant.Schema.mentionsSchema && activeType.getSchema() != Constant.Schema.moreSchema
    }
    
    private func isContainActiveType(activeType: ActiveComponentType) -> Bool {
        return registerActiveTypes.contains(where: { $0.getSchema() == activeType.getSchema() })
    }
}
