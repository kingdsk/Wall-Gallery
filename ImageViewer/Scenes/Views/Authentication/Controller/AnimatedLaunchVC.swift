//
//  AnimatedLaunchVC.swift
//  ImageViewer
//
//  Created by hyperlink on 04/05/26.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class AnimatedLaunchVC: UIViewController {

    //------------------------------------------------------
    //MARK: - Outlet -
    //------------------------------------------------------
    @IBOutlet weak var imgRotatingImages:   UIImageView!
    @IBOutlet weak var lblAppNameTitle:     UILabel!
    @IBOutlet weak var lblDescription:      UILabel!
    @IBOutlet weak var vwGoogleLogin:       UIView!
    @IBOutlet weak var lblSigninWithGoogle: UILabel!

    //------------------------------------------------------
    //MARK: - Class Variable -
    //------------------------------------------------------
    var isReturningFromLogout: Bool = false

    var arrRotatingImages = [UIImage(resource: .launchScreenOne),
                             UIImage(resource: .launchScreenTwo),
                             UIImage(resource: .launchScreenThree),
                             UIImage(resource: .launchScreenFour),
                             UIImage(resource: .launchScreenFive)]

    //------------------------------------------------------
    //MARK: - Memory Management -
    //------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit { }

    //------------------------------------------------------
    //MARK: - Life Cycle -
    //------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //------------------------------------------------------
    //MARK: - Setup
    //------------------------------------------------------
    private func setUpView() {
        self.setupViewModelObserver()
        self.applyStyle()
        self.startImageRotation()
        self.showGoogleLoginButton()
        self.setupGoogleLoginTap()
    }

    private func applyStyle() {
        self.lblAppNameTitle.font(name: .bold, size: 20.0).text = AppStrings.wallGalleryTitle.localized
        self.lblDescription.font(name: .medium, size: 16.0).textColor(color: .textGray).text = AppStrings.wallgalleryDescription.localized
        self.lblSigninWithGoogle.font(name: .medium, size: 15.0).text = AppStrings.signInWithGoogle.localized
        self.imgRotatingImages.cornerRadius(cornerRadius: 10.0)
        self.vwGoogleLogin.borderColor(color: .colorDarkGray, borderWidth: 1.0).cornerRadius(cornerRadius: 15.0)
        self.vwGoogleLogin.alpha    = 0
        self.vwGoogleLogin.isHidden = true
    }

    //------------------------------------------------------
    //MARK: - Image Rotation
    //------------------------------------------------------
    private func startImageRotation() {
        var currentIndex = 0

        func showNext() {
            let nextIndex = (currentIndex + 1) % arrRotatingImages.count
            UIView.transition(with: imgRotatingImages,
                              duration: 0.6,
                              options: .transitionFlipFromRight) {
                self.imgRotatingImages.image = self.arrRotatingImages[nextIndex]
            } completion: { _ in
                currentIndex = nextIndex
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showNext()
                }
            }
        }

        imgRotatingImages.image = arrRotatingImages[0]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showNext()
        }
    }

    //------------------------------------------------------
    //MARK: - Show Google Login Button
    //------------------------------------------------------
    private func showGoogleLoginButton() {
        let delay: Double = isReturningFromLogout ? 0.0 : 4.0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }

            if UserDefaultsConfig.isAuthorization {
                self.navigateToHome(withMessage: false)
            } else {
                self.vwGoogleLogin.isHidden = false
                UIView.animate(withDuration: 0.6,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut) {
                    self.vwGoogleLogin.alpha     = 1
                    self.vwGoogleLogin.transform = .identity
                }
            }
        }
    }

    //------------------------------------------------------
    //MARK: - Google Login
    //------------------------------------------------------
    private func googleLoginTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil,
                  let user    = result?.user,
                  let idToken = user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self  = self,
                      error     == nil,
                      let firebaseUser = authResult?.user else { return }

                UserDefaultsConfig.userName     = firebaseUser.displayName ?? ""
                UserDefaultsConfig.userEmail    = firebaseUser.email ?? ""
                UserDefaultsConfig.profilePhoto = firebaseUser.photoURL?.description ?? ""

                DispatchQueue.main.async {
                    self.navigateToHome()
                }
            }
        }
    }

    //------------------------------------------------------
    //MARK: - Setup Gestures
    //------------------------------------------------------
    private func setupGoogleLoginTap() {
        self.vwGoogleLogin.addTapGestureRecognizer { [weak self] in
            self?.googleLoginTapped()
        }
    }

    //------------------------------------------------------
    //MARK: - Navigation
    //------------------------------------------------------
    func navigateToHome(withMessage: Bool = true) {
        if withMessage {
            Alert.shared.showSnackBar("Login successful")
        }
        let homeVC = HomeVC.instantiate(fromAppStoryboard: .home)
        UserDefaultsConfig.isAuthorization = true
        self.navigationController?.pushViewController(homeVC, animated: true)
    }

    //------------------------------------------------------
    //MARK: - ViewModel Observer Setup
    //------------------------------------------------------
    private func setupViewModelObserver() { }

    //------------------------------------------------------
    //MARK: - Action Methods
    //------------------------------------------------------
}
