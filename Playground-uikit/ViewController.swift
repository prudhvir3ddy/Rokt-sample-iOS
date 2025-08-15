import UIKit
import mParticle_Apple_SDK
import Rokt_Widget
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Status label to show Rokt initialization state
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rokt Status: Not Initialized"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let roktEmbedView: MPRoktEmbeddedView = {
        let view = MPRoktEmbeddedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = true
        return view
    }()
        
    // Button to call Rokt
    let roktButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call Rokt", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        return button
    }()
    
    // Location manager for handling location permissions
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupRoktEvents()
        
        // Add UI elements
        view.addSubview(statusLabel)
        view.addSubview(roktButton)
        view.addSubview(roktEmbedView)

        // Set up constraints
        NSLayoutConstraint.activate([
            // Constraints for the status label
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Constraints for the Rokt button
            roktButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roktButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            roktEmbedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            roktEmbedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            roktEmbedView.topAnchor.constraint(equalTo: roktButton.bottomAnchor, constant: 16)
            
        ])
        
        // Add target action for the button
        roktButton.addTarget(self, action: #selector(callRokt), for: .touchUpInside)
        
        // Setup location manager
        setupLocationManager()
        
        // Request location permission immediately when view loads
        requestLocationPermission()
    }
    
    func setupRoktEvents() {
        MParticle.sharedInstance().rokt.events("RoktLayout", onEvent: { roktEvent in
                if let event = roktEvent as? MPRoktEvent.MPRoktInitComplete {
                    print("Rokt init completed with status: \(event.success)")
                    self.updateRoktStatus("Rokt Status: Initialized ✅", color: .systemGreen)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktShowLoadingIndicator {
                    print("Rokt show loading")
                    self.updateRoktStatus("Rokt Status: Loading...", color: .systemOrange)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktHideLoadingIndicator {
                    print("Rokt hide loading")
                    self.updateRoktStatus("Rokt Status: Ready", color: .systemBlue)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktPlacementInteractive {
                    print("Rokt interactive placement")
                    self.updateRoktStatus("Rokt Status: Interactive", color: .systemPurple)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktPlacementReady {
                    print("Rokt placement ready")
                    self.updateRoktStatus("Rokt Status: Placement Ready", color: .systemGreen)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktOfferEngagement {
                    print("Rokt offer engagement")
                    self.updateRoktStatus("Rokt Status: Offer Engaged", color: .systemTeal)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktOpenUrl {
                    print("Rokt open url")
                    self.updateRoktStatus("Rokt Status: URL Opened", color: .systemIndigo)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktPositiveEngagement {
                    print("Rokt MPRoktPositiveEngagement")
                    self.updateRoktStatus("Rokt Status: Positive Engagement ⭐", color: .systemYellow)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktPlacementClosed {
                    print("Rokt MPRoktPlacementClosed")
                    self.updateRoktStatus("Rokt Status: Placement Closed", color: .systemGray)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktPlacementCompleted {
                    print("Rokt MPRoktPlacementCompleted")
                    self.updateRoktStatus("Rokt Status: Completed ✅", color: .systemGreen)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktPlacementFailure {
                    print("Rokt MPRoktPlacementFailure")
                    self.updateRoktStatus("Rokt Status: Failed ❌", color: .systemRed)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktFirstPositiveEngagement {
                    print("Rokt MPRoktFirstPositiveEngagement")
                    self.updateRoktStatus("Rokt Status: First Engagement 🎉", color: .systemMint)
                } else if let _ = roktEvent as? MPRoktEvent.MPRoktCartItemInstantPurchase {
                    print("Rokt MPRoktCartItemInstantPurchase")
                    self.updateRoktStatus("Rokt Status: Instant Purchase 🛒", color: .systemCyan)
                }
        })
    }
    
    // Helper method to update UI status
    func updateRoktStatus(_ text: String, color: UIColor) {
        statusLabel.text = text
        statusLabel.textColor = color
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        let status = locationManager.authorizationStatus
        print("Current authorization status: \(status.rawValue)")
        
        switch status {
        case .notDetermined:
            print("Requesting location permission...")
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location permission denied or restricted")
            showLocationPermissionAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission already granted")
            startLocationUpdates()
        @unknown default:
            print("Unknown authorization status")
            break
        }
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Permission Required",
            message: "This app needs location access to provide better services. Please enable location access in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        present(alert, animated: true)
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted")
            startLocationUpdates()
        case .denied, .restricted:
            print("Location permission denied")
        case .notDetermined:
            print("Location permission not determined")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        // Stop updating location after getting the first update
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    @objc func callRokt() {
        print("Call Rokt button tapped")
        
        // Update UI to show Rokt is being called
        updateRoktStatus("Rokt Status: Calling Rokt...", color: .systemOrange)
        
        // Create Rokt view with dynamic height (only set width, height will be determined by content)
        let attributes = [
            "email": "prudhvi@gmail.com",
            "firstname": "Jenny",
            "lastname": "Smith",
            "billingzipcode": "07762",
            "confirmationref": "54321",
            "country": "uk"
        ]
        
        let callbacks = MPRoktEventCallback()
        callbacks.onLoad = {
            // Optional callback for when the Rokt placement loads
            print("Rokt onLoad")
        }
        callbacks.onUnLoad = {
            // Optional callback for when the Rokt placement unloads
            print("Rokt onUnLoad")
        }
        callbacks.onShouldShowLoadingIndicator = {
            // Optional callback to show a loading indicator
            print("Rokt onShouldShowLoadingIndicator")
        }
        callbacks.onShouldHideLoadingIndicator = {
            // Optional callback to hide a loading indicator
            print("Rokt onShouldHideLoadingIndicator")
        }
        callbacks.onEmbeddedSizeChange = { (placement: String, size: CGFloat) in
            // Optional callback to get selectedPlacement and height required by the placement every time the height of the placement changes
            print("Rokt onEmbeddedSizeChange - Placement: \(placement), Height: \(size)")
            // Here you can update the view's height dynamically based on the content
            DispatchQueue.main.async {
                var newFrame = self.roktEmbedView.frame
                newFrame.size.height = size
                self.roktEmbedView.frame = newFrame
            }
        }
        let embeddedViews = ["RoktEmbedded1": roktEmbedView]
        let roktConfig = MPRoktConfig()
        roktConfig.colorMode = .system
        MParticle.sharedInstance().rokt.selectPlacements("helperstage", attributes: attributes, embeddedViews: embeddedViews, config: roktConfig, callbacks: callbacks)
    }

}
 
