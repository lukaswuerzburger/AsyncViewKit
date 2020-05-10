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
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel!.text = "🎉 Success Push"
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "🎉 Success Modal"
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "⚠️ Failure Push"
        } else if indexPath.row == 3 {
            cell.textLabel!.text = "⚠️ Failure Modal"
        } else if indexPath.row == 4 {
            cell.textLabel!.text = "⚠️ Failure Push (Auto Dismiss + Alert)"
        } else if indexPath.row == 5 {
            cell.textLabel!.text = "⚠️ Failure Modal (Auto Dismiss + Alert)"
        } else if indexPath.row == 6 {
            cell.textLabel!.text = "🌈 Custom Loading Animation"
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
        } else if indexPath.row == 6 {
            presentCustomAnimation()
        }
    }
    
    // MARK: - Helper
    
    func successViewController() -> UIViewController {
        let viewController = AsyncViewController(load: { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                callback(.success("It worked 🎉"))
            }
        }, success: { string -> UIViewController in
            return self.viewController(title: string)
        }) { error -> AsyncViewController<UIViewController, String, Error>.FailureResolution in
            return .showViewController(self.errorViewController(error: error))
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
    
    func customAnimationViewController() -> UIViewController {
        let viewController = AsyncViewController(load: { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                callback(.success("It worked 🎉"))
            }
        }, success: { string -> UIViewController in
            return self.viewController(title: string)
        }) { error -> AsyncViewController<UIViewController, String, Error>.FailureResolution in
            return .showViewController(self.errorViewController(error: error))
        }
        viewController.loadingViewController = CustomLoadingViewController()
        return viewController
    }
    
    func viewController(title: String) -> UIViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        viewController.title = title
        return viewController
    }
    
    func errorViewController(error: Error) -> UIViewController {
        return viewController(title: "⚠️ Something went wrong:\n\n" + error.localizedDescription)
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
                return .custom({ asyncViewController in
                    asyncViewController.navigationController?.popToRootViewController(animated: true)
                    self.presentErrorAlert(error)
                })
            } else {
                return .showViewController(self.errorViewController(error: error))
            }
        })
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentFailureModal(autoDismiss: Bool = false) {
        let vc = failureViewController({ error in
            if autoDismiss {
                return .custom({ asyncViewController in
                    asyncViewController.dismiss(animated: true)
                    self.presentErrorAlert(error)
                })
            } else {
                return .showViewController(self.errorViewController(error: error))
            }
        })
        presentModalViewController(viewController: vc)
    }
    
    func presentCustomAnimation() {
        navigationController?.pushViewController(customAnimationViewController(), animated: true)
    }
    
    func presentModalViewController(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        present(navigationController, animated: true)
    }
    
    @objc func dismissViewController() {
        presentedViewController?.dismiss(animated: true)
    }
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "⚠️ Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

enum MyResponseError: Error {
    case notFound
}
