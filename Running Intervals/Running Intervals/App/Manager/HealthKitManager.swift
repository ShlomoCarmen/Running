//
//  HealthKitManager.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 03/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class HealthKitManager {
    
    let healthStore = HKHealthStore()
    
    static private var manager: HealthKitManager?
    
    class var shared: HealthKitManager {
        if self.manager == nil {
            self.manager = HealthKitManager()
        }
        return self.manager!
    }
    
    func authorizeHealthKit() -> Bool {
        var isEnabled = false
        if HKHealthStore.isHealthDataAvailable() {
            isEnabled = true
        }
        
        return isEnabled
    }
    
    func getUserAuthorization(completion: @escaping (Bool, Error?) -> Swift.Void)  {
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)
            else { return }
        
        let healthKitTypesToWrite: Set<HKSampleType> = []

        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, biologicalSex, height, bodyMass]

        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }

    }
    
    func getAgeAndGender() throws -> (age: Int, biologicalSex: HKBiologicalSex) {
      let healthKitStore = HKHealthStore()
        
      do {
        
        let birthdayComponents = try healthKitStore.dateOfBirthComponents()
        let biologicalSex = try healthKitStore.biologicalSex()

        let today = Date()
        let calendar = Calendar.current
        let todayDateComponents = calendar.dateComponents([.year], from: today)
        let thisYear = todayDateComponents.year!
        let age = thisYear - birthdayComponents.year!
        
        let unwrappedBiologicalSex = biologicalSex.biologicalSex
          
        return (age, unwrappedBiologicalSex)
      }
        
    }
    
    func getHeight(completion: @escaping ([HKSample], Error?) -> Swift.Void) {
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let results = results {
                completion(results, error)
            }
        }
        self.healthStore.execute(query)
    }
    
    func getWeight(completion: @escaping ([HKSample], Error?) -> Swift.Void) {
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let results = results {
                completion(results, error)
                
            }
        }
        self.healthStore.execute(query)
    }
}
