//
//  FavoritesViewModel.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 30/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FavoritesViewModel: BaseViewModel {
    
    
    
    
    
    private var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    private var context: NSManagedObjectContext { return appDelegate.persistentContainer.viewContext }
    
   
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //didChange.send()
    }
    
}


