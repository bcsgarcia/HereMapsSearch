//
//  FavoritesViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 30/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "favoriteCell"
    var fetchedResultController: NSFetchedResultsController<Favorite>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchFavorites()
        setupMap()
    }
    
    func setupMap() {
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Map.mapView.frame = mapContainer.bounds
        Map.mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapContainer.addSubview(Map.mapView)
    }
    
    func fetchFavorites() {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Favorite.locationId, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func closeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (fetchedResultController?.fetchedObjects?.count ?? 0 ) > 0 {
            tableView.hideEmpty()
            return fetchedResultController?.fetchedObjects?.count ?? 0
        } else {
            tableView.showEmpty(message: "No Favorites")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        guard let favorite = fetchedResultController?.object(at: indexPath) else { return cell }
        cell.prepare(with: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favorite = fetchedResultController?.object(at: indexPath) else { return }
        Map.setPosition(for: .destination, with: Position(with: favorite))
        //performSegue(withIdentifier: segueDetail, sender: cat)
    }
    
}
