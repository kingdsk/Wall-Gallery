//
//  ProfileVC.swift
//  ImageViewer
//
//  Created by hyperlink on 05/05/26.
//

import UIKit

class ProfileVC: UIViewController {

    //------------------------------------------------------
    //MARK: - Outlet -
    //------------------------------------------------------
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    @IBOutlet weak var lblNameTitle:    UILabel!
    @IBOutlet weak var vwName:          UIView!
    @IBOutlet weak var txtName:         UITextField!
    @IBOutlet weak var lblEmailTitle:   UILabel!
    @IBOutlet weak var vwEmail:         UIView!
    @IBOutlet weak var txtEmail:        ThemeTextField!
    @IBOutlet weak var btnLogout:       ThemeBlueButton!

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
        navigationItem.hidesBackButton = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfilePhoto.setRound()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //------------------------------------------------------
    //MARK: - Setup -
    //------------------------------------------------------
    private func setUpView() {
        self.setupViewModelObserver()
        self.applyStyle()
        self.setupUserData()
        self.loadProfileImage()
    }

    private func applyStyle() {
        self.lblNameTitle.font(name: .medium, size: 16.0).text  = AppStrings.nameTitle.localized
        self.lblEmailTitle.font(name: .medium, size: 16.0).text = AppStrings.emailTitle.localized
        self.btnLogout.setTitle(AppStrings.logoutTitle.localized, for: .normal)
    }

    //------------------------------------------------------
    //MARK: - User Data -
    //------------------------------------------------------
    private func setupUserData() {
        self.txtName.text  = UserDefaultsConfig.userName
        self.txtEmail.text = UserDefaultsConfig.userEmail
    }

    //------------------------------------------------------
    //MARK: - Profile Image -
    //------------------------------------------------------
    private func loadProfileImage() {
        let urlString = UserDefaultsConfig.profilePhoto
        guard let url = URL(string: urlString) else { return }
        imgProfilePhoto.sd_setImage(
            with: url,
            placeholderImage: UIImage(resource: .profileIcon)
        )
    }

    //------------------------------------------------------
    //MARK: - Logout -
    //------------------------------------------------------
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: AppStrings.logoutTitle.localized,
            message: AppStrings.logoutMesasge.localized,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: AppStrings.cancelTitle.localized, style: .cancel))

        alert.addAction(UIAlertAction(title: AppStrings.logoutTitle.localized, style: .destructive) { [weak self] _ in
            UserDefaultsConfig.isAuthorization = false
            UserDefaultsConfig.isReturningFromLogout = true
            CoreDataManager.shared.clearAllCache()
            UIApplication.shared.logoutAppUser()
            UIApplication.shared.manageLogin()
        })

        present(alert, animated: true)
    }

    //------------------------------------------------------
    //MARK: - ViewModel Observer Setup -
    //------------------------------------------------------
    private func setupViewModelObserver() { }

    //------------------------------------------------------
    //MARK: - Action Methods -
    //------------------------------------------------------
    @IBAction func btnLogOutTapped(_ sender: UIButton) {
        self.showLogoutAlert()
    }

    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
