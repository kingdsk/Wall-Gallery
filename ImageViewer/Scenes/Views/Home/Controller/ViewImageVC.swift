//
//  ViewImageVC.swift
//  ImageViewer
//
//  Created by hyperlink on 05/05/26.
//

import UIKit
import SDWebImage

class ViewImageVC: UIViewController {

    //------------------------------------------------------
    //MARK: - Outlet -
    //------------------------------------------------------
    @IBOutlet weak var vwBackArrow:          UIView!
    @IBOutlet weak var imgBackArrow:         UIImageView!
    @IBOutlet weak var imgContent:           UIImageView!
    @IBOutlet weak var vwPhotoInfoBlur:      UIView!
    @IBOutlet weak var lblPhotoGrapherTitle: UILabel!
    @IBOutlet weak var lblPhotoGrapherName:  UILabel!
    @IBOutlet weak var btnCross:             UIButton!

    //------------------------------------------------------
    //MARK: - Class Variable -
    //------------------------------------------------------
    var imageURL:         String = ""
    var photographerName: String = ""

    private var scrollView:    UIScrollView!
    private var zoomableImage: UIImageView!

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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if zoomableImage.frame != scrollView.bounds {
            zoomableImage.frame    = scrollView.bounds
            scrollView.contentSize = scrollView.bounds.size
        }
        addBlur(to: vwBackArrow,
                style: .systemUltraThinMaterialDark,
                cornerRadius: vwBackArrow.bounds.height / 2)
        addBlur(to: vwPhotoInfoBlur,
                style: .systemUltraThinMaterialDark,
                cornerRadius: 16.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //------------------------------------------------------
    //MARK: - Setup -
    //------------------------------------------------------
    private func setUpView() {
        self.applyStyle()
        self.setupZoomableScrollView()
        self.loadImage()
        self.setupGestures()
        self.animateInfoViewIn()
    }

    private func applyStyle() {
        view.backgroundColor = .black
        self.lblPhotoGrapherTitle.font(name: .medium, size: 18.0)
            .textColor(color: .splash)
            .text = AppStrings.photographerTitle.localized
        self.lblPhotoGrapherName.font(name: .medium, size: 15.0)
            .textColor(color: .splash)
            .text = photographerName
        imgContent.isHidden = true
    }

    //------------------------------------------------------
    //MARK: - Zoomable ScrollView -
    //------------------------------------------------------
    private func setupZoomableScrollView() {
        scrollView                                = UIScrollView()
        scrollView.delegate                       = self
        scrollView.minimumZoomScale               = 1.0
        scrollView.maximumZoomScale               = 5.0
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor                = .black
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(scrollView, at: 0)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        zoomableImage                 = UIImageView()
        zoomableImage.contentMode     = .scaleAspectFit
        zoomableImage.backgroundColor = .black
        scrollView.addSubview(zoomableImage)
    }

    //------------------------------------------------------
    //MARK: - Load Image -
    //------------------------------------------------------
    private func loadImage() {
        guard let url = URL(string: imageURL) else { return }
        zoomableImage.sd_setImage(
            with: url,
            placeholderImage: UIImage(systemName: "photo")
        )
    }

    //------------------------------------------------------
    //MARK: - Gestures -
    //------------------------------------------------------
    private func setupGestures() {
        vwBackArrow.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        let doubleTap                  = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }

    //------------------------------------------------------
    //MARK: - Double Tap Zoom -
    //------------------------------------------------------
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let point  = gesture.location(in: zoomableImage)
            let size   = CGSize(
                width:  zoomableImage.bounds.width  / scrollView.maximumZoomScale,
                height: zoomableImage.bounds.height / scrollView.maximumZoomScale
            )
            let origin = CGPoint(
                x: point.x - size.width  / 2,
                y: point.y - size.height / 2
            )
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }

    //------------------------------------------------------
    //MARK: - Blur -
    //------------------------------------------------------
    private func addBlur(to view: UIView,
                         style: UIBlurEffect.Style = .systemThinMaterialDark,
                         cornerRadius: CGFloat) {
        view.subviews
            .compactMap { $0 as? UIVisualEffectView }
            .forEach { $0.removeFromSuperview() }

        let blurEffect              = UIBlurEffect(style: style)
        let blurView                = UIVisualEffectView(effect: blurEffect)
        blurView.frame              = view.bounds
        blurView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
        blurView.alpha              = 0.75
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds      = true

        let vibrancyEffect            = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        let vibrancyView              = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame            = blurView.bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.contentView.addSubview(vibrancyView)

        view.insertSubview(blurView, at: 0)
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds      = true
        view.backgroundColor    = UIColor.white.withAlphaComponent(0.05)
    }

    //------------------------------------------------------
    //MARK: - Info View Animation -
    //------------------------------------------------------
    private func animateInfoViewIn() {
        vwPhotoInfoBlur.isHidden  = false
        vwPhotoInfoBlur.alpha     = 0
        vwPhotoInfoBlur.transform = CGAffineTransform(translationX: 0, y: 80)

        UIView.animate(withDuration: 0.45,
                       delay: 0.1,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            self.vwPhotoInfoBlur.alpha     = 1.0
            self.vwPhotoInfoBlur.transform = .identity
        }
    }

    private func animateInfoViewOut() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn) {
            self.vwPhotoInfoBlur.alpha     = 0
            self.vwPhotoInfoBlur.transform = CGAffineTransform(translationX: 0, y: 80)
        } completion: { _ in
            self.vwPhotoInfoBlur.isHidden  = true
            self.vwPhotoInfoBlur.transform = .identity
        }
    }

    //------------------------------------------------------
    //MARK: - ViewModel Observer Setup -
    //------------------------------------------------------
    private func setupViewModelObserver() { }

    //------------------------------------------------------
    //MARK: - Action Methods -
    //------------------------------------------------------
    @IBAction func btnCrossTapped(_ sender: UIButton) {
        self.btnCross.isHidden = true
        animateInfoViewOut()
    }
}

//=================================================================================================
//MARK: - UIScrollViewDelegate
//=================================================================================================
extension ViewImageVC: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomableImage
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width  - scrollView.contentSize.width)  * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(
            top: offsetY, left: offsetX,
            bottom: offsetY, right: offsetX
        )
    }
}
