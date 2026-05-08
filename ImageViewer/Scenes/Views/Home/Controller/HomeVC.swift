//
//  HomeVC.swift
//  ImageViewer
//
//  Created by hyperlink on 04/05/26.
//

import UIKit
import SDWebImage

//=================================================================================================
//MARK: - ImageCell
//=================================================================================================
class ImageCell: UICollectionViewCell {

    //------------------------------------------------------
    //MARK: - Outlet -
    //------------------------------------------------------
    @IBOutlet weak var contentImg:           UIImageView!
    @IBOutlet weak var vwBlur:               UIView!
    @IBOutlet weak var lblPhotoGrapherTitle: UILabel!
    @IBOutlet weak var lblPhotoGrapherName:  UILabel!

    //------------------------------------------------------
    //MARK: - Class Variable -
    //------------------------------------------------------
    private var blurEffectView: UIVisualEffectView?

    //------------------------------------------------------
    //MARK: - Life Cycle -
    //------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView?.frame = vwBlur.bounds
    }

    //------------------------------------------------------
    //MARK: - Setup -
    //------------------------------------------------------
    private func applyStyle() {
        addBlurToVwBlur()
        self.lblPhotoGrapherTitle.font(name: .medium, size: 14.0).textColor(color: .splash).text = AppStrings.photographerTitle.localized
        self.lblPhotoGrapherName.font(name: .medium, size: 13.0).textColor(color: .splash)
        DispatchQueue.main.async {
            self.contentImg.cornerRadius(cornerRadius: 10.0)
            self.vwBlur.cornerRadius(cornerRadius: 10.0)
        }
    }

    //------------------------------------------------------
    //MARK: - Blur -
    //------------------------------------------------------
    private func addBlurToVwBlur() {
        blurEffectView?.removeFromSuperview()
        let blurView              = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame            = vwBlur.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha            = 0.5
        vwBlur.backgroundColor    = .clear
        vwBlur.insertSubview(blurView, at: 0)
        self.blurEffectView       = blurView
    }

    //------------------------------------------------------
    //MARK: - Configure -
    //------------------------------------------------------
    func configure(photo: UnsplashPhotoModel) {
        lblPhotoGrapherName.text = photo.user.name
        contentImg.sd_setImage(
            with: URL(string: photo.urls.regular ?? ""),
            placeholderImage: UIImage(systemName: "photo")
        )
    }

    func configure(cached: CachedPhoto) {
        lblPhotoGrapherName.text = cached.photographerName ?? ""
        contentImg.sd_setImage(
            with: URL(string: cached.imageURL ?? ""),
            placeholderImage: UIImage(systemName: "photo")
        )
    }
}

//=================================================================================================
//MARK: - HomeVC
//=================================================================================================
class HomeVC: UIViewController {

    //------------------------------------------------------
    //MARK: - Outlet -
    //------------------------------------------------------
    @IBOutlet weak var lblDiscover:      UILabel!
    @IBOutlet weak var lblhighResImages: UILabel!
    @IBOutlet weak var vwLiveFeed:       UIView!
    @IBOutlet weak var lblLiveFeed:      UILabel!
    @IBOutlet weak var colImagesData:    UICollectionView!
    @IBOutlet weak var btnProfile:       UIBarButtonItem!

    //------------------------------------------------------
    //MARK: - Class Variable -
    //------------------------------------------------------
    private let viewModel                   = HomeViewModel()
    private var isOfflineMode: Bool         = false
    private var cachedPhotos: [CachedPhoto] = []

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
        startNetworkMonitoring()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let isOnline = NetworkReachability.shared.isConnected
            self.updateFeedBadge(isOnline: isOnline)
            self.viewModel.fetchPhotos(page: 1)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
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
        self.colImagesData.delegate   = self
        self.colImagesData.dataSource = self
    }

    private func applyStyle() {
        self.lblDiscover.font(name: .medium, size: 18.0)
            .textColor(color: .black)
            .text = AppStrings.discoverTitle.localized
        self.lblhighResImages.font(name: .medium, size: 16.0)
            .textColor(color: .colorDarkGray)
            .text = AppStrings.highResolutionTitle.localized
    }

    //------------------------------------------------------
    //MARK: - Network Monitor -
    //------------------------------------------------------
    private func startNetworkMonitoring() {
        NetworkReachability.shared.onStatusChange = { [weak self] isConnected in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateFeedBadge(isOnline: isConnected)

                if isConnected && self.isOfflineMode {
                    self.isOfflineMode = false
                    self.cachedPhotos  = []
                    self.colImagesData.reloadData()
                    self.colImagesData.setContentOffset(.zero, animated: false)
                    self.viewModel.resetPagination()
                    self.viewModel.fetchPhotos(page: 1)
                    self.showSnackbar(message: AppStrings.backOnlineMessage.localized,
                                      emoji: "✅")

                } else if !isConnected && !self.isOfflineMode {
                    self.isOfflineMode = true
                    let cached = CoreDataManager.shared.fetchAllPhotos()
                    if cached.isEmpty {
                        self.showEmptyState(message: AppStrings.noInternetNoCacheMessage.localized)
                    } else {
                        self.cachedPhotos = cached
                        self.hideEmptyState()
                        self.colImagesData.reloadData()
                        self.showSnackbar(message: AppStrings.offlineSnackMessage.localized,
                                          emoji: "📡")
                    }
                }
            }
        }
    }

    //------------------------------------------------------
    //MARK: - Feed Badge -
    //------------------------------------------------------
    private func updateFeedBadge(isOnline: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.vwLiveFeed.alpha = 0.0
        } completion: { _ in
            if isOnline {
                self.vwLiveFeed
                    .cornerRadius(cornerRadius: 25.0)
                    .borderColor(color: .textCompletedOrder, borderWidth: 1.0)
                    .backGroundColor(color: .completedOrder)
                self.lblLiveFeed
                    .font(name: .medium, size: 12.0)
                    .textColor(color: .textCompletedOrder)
                    .text = AppStrings.liveFeedTitle.localized
            } else {
                self.vwLiveFeed
                    .cornerRadius(cornerRadius: 25.0)
                    .borderColor(color: .systemYellow, borderWidth: 1.0)
                    .backGroundColor(color: UIColor.systemYellow.withAlphaComponent(0.15))
                self.lblLiveFeed
                    .font(name: .medium, size: 12.0)
                    .textColor(color: .color1)
                    .text = AppStrings.offlineTitle.localized
            }
            UIView.animate(withDuration: 0.3) {
                self.vwLiveFeed.alpha = 1.0
            }
        }
    }

    //------------------------------------------------------
    //MARK: - ViewModel Observer -
    //------------------------------------------------------
    private func setupViewModelObserver() {

        viewModel.onPhotosLoaded = { [weak self] _ in
            guard let self = self else { return }
            guard !self.isOfflineMode else { return }
            self.hideEmptyState()
            self.colImagesData.reloadData()
        }

        viewModel.onCachedPhotosLoaded = { [weak self] cached in
            guard let self = self else { return }
            guard self.isOfflineMode else { return }
            self.cachedPhotos = cached
            self.hideEmptyState()
            self.colImagesData.reloadData()
        }

        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            self.showEmptyState(message: message)
        }

        viewModel.onLoadingStateChanged = { _ in }
    }

    //------------------------------------------------------
    //MARK: - Empty State -
    //------------------------------------------------------
    private func showEmptyState(message: String) {
        let emptyView = UIView(frame: colImagesData.bounds)

        let imgView              = UIImageView()
        imgView.image            = UIImage(systemName: "photo.on.rectangle.angled")
        imgView.tintColor        = .lightGray
        imgView.contentMode      = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false

        let label                = UILabel()
        label.text               = message
        label.textColor          = .lightGray
        label.numberOfLines      = 0
        label.textAlignment      = .center
        label.font               = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        let retryBtn                    = UIButton(type: .system)
        retryBtn.setTitle(AppStrings.retryTitle.localized, for: .normal)
        retryBtn.setTitleColor(.white, for: .normal)
        retryBtn.backgroundColor        = .systemBlue
        retryBtn.layer.cornerRadius     = 10
        retryBtn.translatesAutoresizingMaskIntoConstraints = false
        retryBtn.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        emptyView.addSubview(imgView)
        emptyView.addSubview(label)
        emptyView.addSubview(retryBtn)

        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -80),
            imgView.widthAnchor.constraint(equalToConstant: 80),
            imgView.heightAnchor.constraint(equalToConstant: 80),

            label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -32),

            retryBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            retryBtn.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            retryBtn.widthAnchor.constraint(equalToConstant: 120),
            retryBtn.heightAnchor.constraint(equalToConstant: 44)
        ])

        colImagesData.backgroundView = emptyView
    }

    private func hideEmptyState() {
        colImagesData.backgroundView = nil
    }

    @objc private func retryTapped() {
        guard NetworkReachability.shared.isConnected else {
            showEmptyState(message: AppStrings.stillNoInternetMessage.localized)
            return
        }
        hideEmptyState()
        viewModel.resetPagination()
        viewModel.fetchPhotos(page: 1)
    }

    //------------------------------------------------------
    //MARK: - Action Methods -
    //------------------------------------------------------
    @IBAction func btnProfileTapped(_ sender: UIBarButtonItem) {
        let profileVC = ProfileVC.instantiate(fromAppStoryboard: .home)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}

//=================================================================================================
//MARK: - UICollectionView
//=================================================================================================
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return isOfflineMode ? cachedPhotos.count : viewModel.allPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colImagesData.dequeueReusableCell(withClass: ImageCell.self, for: indexPath)
        if isOfflineMode {
            cell.configure(cached: cachedPhotos[indexPath.row])
        } else {
            cell.configure(photo: viewModel.allPhotos[indexPath.row])
        }
        return cell
    }

    //------------------------------------------------------
    //MARK: - Pagination -
    //------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard !isOfflineMode else {
            if indexPath.row == cachedPhotos.count - 3 {
                showSnackbar(message: AppStrings.offlineSnackMessage.localized)
            }
            return
        }
        if indexPath.row == viewModel.allPhotos.count - 3 {
            viewModel.fetchPhotos()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let viewImageVC = ViewImageVC.instantiate(fromAppStoryboard: .home)
        if isOfflineMode {
            let cached               = cachedPhotos[indexPath.row]
            viewImageVC.imageURL         = cached.imageURL ?? ""
            viewImageVC.photographerName = cached.photographerName ?? ""
        } else {
            let photo                    = viewModel.allPhotos[indexPath.row]
            viewImageVC.imageURL         = photo.urls.regular ?? ""
            viewImageVC.photographerName = photo.user.name
        }
        navigationController?.pushViewController(viewImageVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (colImagesData.frame.width - 10) / 2
        let height = (221 * ScreenSize.width) / 375
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20.0)
    }
}
