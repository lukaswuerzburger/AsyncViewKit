//
//  MasterViewController.swift
//  AsyncViewController-Demo
//
//  Created by Lukas Würzburger on 08.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel!.text = "Success Push"
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "Success Modal"
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "Failure Push"
        } else if indexPath.row == 3 {
            cell.textLabel!.text = "Failure Modal"
        } else if indexPath.row == 4 {
            cell.textLabel!.text = "Failure Push (Auto Dismiss)"
        } else if indexPath.row == 5 {
            cell.textLabel!.text = "Failure Modal (Auto Dismiss)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presentSuccessPush()
        } else if indexPath.row == 1 {
            presentSuccessModal()
        } else if indexPath.row == 2 {
            presentFailurePush()
        } else if indexPath.row == 3 {
            presentFailureModal()
        } else if indexPath.row == 4 {
            presentFailurePush(autoDismiss: true)
        } else if indexPath.row == 5 {
            presentFailureModal(autoDismiss: true)
        }
    }
    
    // MARK: - Helper
    
    func successViewController() -> UIViewController {
        let viewController = AsyncViewController(load: { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                callback(.success("It worked"))
            }
        }, success: { string -> UIViewController in
            return self.viewController(title: string)
        }) { error -> AsyncViewController<UIViewController, String, Error>.FailureResolution in
            return .showViewController(self.viewController(title: "Something went wrong."))
        }
        return viewController
    }
    
    func failureViewController(_ failureBlock: @escaping (Error) -> AsyncViewController<UIViewController, String, Error>.FailureResolution) -> UIViewController {
        let viewController = AsyncViewController(load: { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                callback(.failure(MyResponseError.notFound))
            }
        }, success: { string -> UIViewController in
            return self.viewController(title: string)
        }) { error -> AsyncViewController<UIViewController, String, Error>.FailureResolution in
            return failureBlock(error)
        }
        return viewController
    }
    
    func viewController(title: String) -> UIViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        viewController.title = title
        return viewController
    }
    
    func errorViewController(error: Error) -> UIViewController {
        return UIViewController()
    }
    
    func presentSuccessPush() {
        navigationController?.pushViewController(successViewController(), animated: true)
    }
    
    func presentSuccessModal() {
        presentModalViewController(viewController: successViewController())
    }
    
    func presentFailurePush(autoDismiss: Bool = false) {
        let vc = failureViewController({ error in
            if autoDismiss {
                return .custom({ asyncViewController in asyncViewController.navigationController?.popToRootViewController(animated: true) })
            } else {
                return .showViewController(self.viewController(title: "Something went wrong."))
            }
        })
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentFailureModal(autoDismiss: Bool = false) {
        let vc = failureViewController({ viewController in
            if autoDismiss {
                return .custom({ asyncViewController in asyncViewController.dismiss(animated: true) })
            } else {
                return .showViewController(self.viewController(title: "Something went wrong."))
            }
        })
        presentModalViewController(viewController: vc)
    }
    
    func presentModalViewController(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        present(navigationController, animated: true)
    }
    
    @objc func dismissViewController() {
        presentedViewController?.dismiss(animated: true)
    }
}

enum MyResponseError: Error {
    case notFound
}
