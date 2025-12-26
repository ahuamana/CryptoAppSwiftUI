//
//  PorfolioDataService.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import Foundation
import CoreData

class PorfolioDataService {
    private let container: NSPersistentContainer
    private let containerName:String = "PorfolioContainer" // ⚠️ MUST match your file name exactly!
    private let entityName:String = "PorfolioEntity" // ⚠️ MUST match the Entity Name in the editor
    
    @Published var savedEntities: [PorfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: PUBLIC
    func updatePorfolio(coin:CoinPresentationModel, amount:Double) {
        // Check if coin is already in portolio
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity:entity)
            }
            
        } else {
            add(coin: coin, amount: amount)
        }
        //getPortfolio()
    }
    
    //MARK: PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PorfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
            
        } catch let error {
            print("Error fetching Porfolio entities. \(error)")
        }
        
    }
    
    private func add(coin:CoinPresentationModel, amount: Double) {
        let entity = PorfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applychanges()
    }
    
    private func update(entity:PorfolioEntity, amount:Double) {
        entity.amount = amount
        applychanges()
    }
    
    private func delete(entity:PorfolioEntity) {
        container.viewContext.delete(entity)
        applychanges()
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Date. \(error)")
        }
    }
    
    private func applychanges() {
        save()
        getPortfolio()
    }
    
}
