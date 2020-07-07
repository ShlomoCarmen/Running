//
//  TrainingRepository.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 06/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation

class TrainingRepository {
    
    private static var repository: TrainingRepository?
    
    class var shared: TrainingRepository {
        if self.repository == nil {
            self.repository = TrainingRepository()
        }
        return self.repository!
    }
    
    func getAllTraining() -> [Training] {
        guard let traningData: Data = self.getResource(resourceName: "training_information", extensionName: "json") else { return [] }
        guard let traningJson = Utils.convertDataToJSONObject(traningData) as? [[String:Any]] else { return [] }
        let training = traningJson.compactMap{Training(values: $0)}
        return training
    }
    
    func getResource(resourceName: String, extensionName: String) -> Data? {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: extensionName) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return data
        }
        catch {
            return nil
        }
    }
   
}
