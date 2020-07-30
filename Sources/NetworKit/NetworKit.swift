import Network
import UIKit


public class NetworKit: NSObject {
    static let shared = NetworKit()
    
    private var _monitor:AnyObject! // NWPathMonitor(requiredInterfaceType: .cellular)
    @available(iOS 12, *)
    fileprivate var monitor:NWPathMonitor! {
        if self._monitor == nil {
            self._monitor = NWPathMonitor()
        }
        return (self._monitor as! NWPathMonitor)
    }
    
    private static var _path: NWPath!
}

// MARK: - public
extension NetworKit {
    // MARK: - properties
    public static var connectionExists: Bool! {
        if NetworKit._path.status == .satisfied {
            return true
        } else {
            return false
        }
    }
    
    public static var isExpensive: Bool! {
        return NetworKit._path.isExpensive
    }
    
    public static var path: NWPath! {
        return NetworKit._path
    }
    
    public static var status: NWPath.Status! {
        return NetworKit._path.status
    }
    
    // MARK: - methods
    public final class func initNetworkStatus(callback: ((_ status:NWPath.Status) -> ())? = nil) {
        NetworKit.shared.monitor.pathUpdateHandler = { path in
            NetworKit._path = path
            callback?(path.status)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        NetworKit.shared.monitor.start(queue: queue)
    }
    
    public class func canProceedWithRequest(displayWarning: Bool = false) -> Bool {
        if !(NetworKit.connectionExists) {
            if displayWarning {
                let viewController: UIViewController? = NetworKitUtils.topMostWindowController()
                let alertViewController = UIAlertController(title: "Warning", message: "No internet connection available", preferredStyle: .alert)
                
                alertViewController.addAction(UIAlertAction(title: "okay", style: .cancel) { action in
                    alertViewController.dismiss(animated: true, completion: nil)
                })
                
                viewController?.present(alertViewController, animated: true, completion: nil)
            }
            
            return false
        }
        
        return true
    }
}
