//
//  SGDetailsViewController.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import UIKit

protocol SGDetailViewControllerDelegate: AnyObject {
    func updateFavoriteEvent(withIdentifier id: String, isFavorite: Bool)
}

final public class SGDetailsViewController: UIViewController {
    
    private var eventModel: SGEventModel?
    private var selectedEventId: String?
    private var detailsViewModel: SGDetailsViewModel?
    private var sbService: SGServiceAPI?
    weak var detailDelegate: SGDetailViewControllerDelegate?
    
    @IBOutlet weak var activitiyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sgImageView: UIImageView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        loadData()
        updateViews()
    }
    
    public func setUpDetailView(identifier: String) {
        self.selectedEventId = identifier
    }
    
    private func initialize() {
        self.detailsViewModel = SGDetailsViewModel(delegate: self)
        self.sbService = SGService()
    }
    
    private func loadData() {
        guard let eventId = self.selectedEventId else { return }
        self.detailsViewModel?.fetchEventDetails(with: eventId)
    }
    
    // check the favorite status and update it in the navigation bar
    private func updateViews() {
        self.activitiyIndicator.startAnimating()
        self.sgImageView.layer.cornerRadius = 7
        self.sgImageView.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    private func downloadImage(with imageURL: String) {
        ImageDownloadManager.sharedInstance.downloadImage(with: imageURL) { [weak self] (image) in
            guard let strongSelf = self else { return }
            strongSelf.sgImageView.image = image
        }
    }
}

//MARK: Favorite Action

extension SGDetailsViewController {
    
    @IBAction func toogleFavoriteEvent() {

        guard let detailsViewModel = detailsViewModel,
            let eventSelected = self.selectedEventId
            else { return }
        
        detailsViewModel.toggleFavorite(eventWith: eventSelected) { (isFavorited) in
            if isFavorited {
                navigationItem.rightBarButtonItem?.tintColor = .red
                detailDelegate?.updateFavoriteEvent(withIdentifier: eventSelected, isFavorite: true)
            } else {
                navigationItem.rightBarButtonItem?.tintColor = .gray
                detailDelegate?.updateFavoriteEvent(withIdentifier: eventSelected, isFavorite: false)
            }
        }
    }
}


// MARK: DetailsViewModelDelegate

extension SGDetailsViewController: SGAlertAction, SGDetailsViewModelDelegate {
    
    func onFetchSuccess(with event: SGEventModel) {
        self.activitiyIndicator.stopAnimating()
        title = event.shortTitle
        location.text = event.location
        timeLabel.text = Date.formatDateDisplayValueFrom(string: event.date)?.formatInDayMonthYearValue()
        navigationItem.rightBarButtonItem?.tintColor = event.isFavorite ? .red : .gray
        self.downloadImage(with: event.imageUrl)
    }
    
    func onFetchFailure(with error: String) {
        self.activitiyIndicator.stopAnimating()
        let action = UIAlertAction(title: Message.ok, style: .default)
        self.displayAlert(with: Message.detailsAlert , message: error, actions: [action])
    }
}
