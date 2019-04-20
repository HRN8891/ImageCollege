//
//  CollageViewController.swift
//  Collage
//
//  .
//  
//

import UIKit

class CollageViewController: UIViewController, UIScrollViewDelegate, CollageViewDelegate {

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var cromaColorPickerVC: CromaColorPickerVC?
    var changeBorderVC: ChangeBorderVC?

    @IBOutlet weak var collageScrollView: UIScrollView! {
        didSet {
            collageScrollView.delegate = self
            collageScrollView.isPagingEnabled = true
            collageScrollView.alwaysBounceVertical = false
            collageScrollView.alwaysBounceHorizontal = true
            collageScrollView.showsVerticalScrollIndicator = false
            collageScrollView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
    lazy var collageViews: [CollageView] = {
        return [
            CollageView.instanceFromNib(nibName: "CollageType1") as! CollageView,
            CollageView.instanceFromNib(nibName: "CollageType2") as! CollageView,
            CollageView.instanceFromNib(nibName: "CollageType3") as! CollageView,
            CollageView.instanceFromNib(nibName: "CollageType4") as! CollageView,
            CollageView.instanceFromNib(nibName: "CollageType5") as! CollageView
        ]
    }()
    var selectedCollagePhotoCount = 0
    var selectedCollageType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = UIColor.black
        title = "Choose your style"
    
        configurePageControl()
        setupScrollView()

        let rightBarButtonItem = UIBarButtonItem(title: "Color", style: .plain, target: self, action: #selector(saveCollage))
        
        let changeBorderrButtonItem = UIBarButtonItem(title: "Border", style: .plain, target: self, action: #selector(changeBorder))

        navigationItem.rightBarButtonItems = [rightBarButtonItem]
        
        navigationItem.leftBarButtonItems = [changeBorderrButtonItem]

        // Do any additional setup after loading the view.
    }
    
    func saveCollage() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"CromaColorPickerVC") as? CromaColorPickerVC {
            cromaColorPickerVC = vc
            cromaColorPickerVC?.cromaColorPickerVCDelegate = self
            vc.modalTransitionStyle   = .crossDissolve;
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func changeBorder() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"ChangeBorderVC") as? ChangeBorderVC {
            changeBorderVC = vc
            changeBorderVC?.changeBorderVCDelegate = self
            vc.modalTransitionStyle   = .crossDissolve;
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupScrollView() {
        var frame: CGRect = CGRect.zero
        let y = (UIApplication.shared.statusBarFrame.size.height + navigationController!.navigationBar.frame.size.height)
        collageScrollView.frame = CGRect(x: 0, y: y, width: view.frame.size.width, height: (view.frame.size.height - y))
        
        for (index, collageView) in collageViews.enumerated() {
            frame.origin.x = collageScrollView.frame.size.width * CGFloat(index)
            frame.origin.y = 0
            frame.size = collageScrollView.frame.size
            collageView.frame = frame
            collageView.delegate = self
            
            print(frame)
            collageScrollView.addSubview(collageView)
        }
        collageScrollView.contentSize = CGSize(width: collageScrollView.frame.size.width * CGFloat(collageViews.count), height: collageScrollView.frame.size.height)
        print(collageScrollView.contentSize)
    }
    private func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl.numberOfPages = collageViews.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
    }
    func changePage(_ sender: UIPageControl) {
        let x = CGFloat(pageControl.currentPage) * collageScrollView.frame.size.width
        collageScrollView.setContentOffset(CGPoint(x: x, y: 0.0), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PhotoCollectionSegue" {
            let destination = segue.destination as! CollageCollectionViewController
            destination.photoCount = self.selectedCollagePhotoCount
            destination.selectedCollageType = self.selectedCollageType
        }
    }
    
    // MARK: - CollageView Delegate
    func onClickCollage(_ view: CollageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            view.blurView.isHidden = true
            
            if view.photoCount != nil {
                self.selectedCollagePhotoCount = view.photoCount!.rawValue
                self.selectedCollageType = view.collageType
            }
            self.performSegue(withIdentifier: "PhotoCollectionSegue", sender: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                view.blurView.isHidden = true
            })
        }
        
    }
    
    func changeBorderColor(view: UIView) {
        for subview in view.subviews {
            if subview.subviews.count > 0 {
                changeBorderColor(view: subview)
            } else {
                if subview is UIImageView {
                    subview.layer.borderWidth = appDelegate.collegeBorderWidth
                    subview.layer.borderColor = appDelegate.collegeBorderColor
                }
            }
        }
    }

    

}

extension CollageViewController: CromaColorPickerVCDelegate, ChangeBorderVCDelegate {
    func changeBorderColorWithColor(color: UIColor) {
        appDelegate.collegeBorderColor = color.cgColor
        changeBorderColor(view: collageViews[pageControl.currentPage])
    }
    func changeBorderWidth(width: CGFloat) {
        appDelegate.collegeBorderWidth = width
        changeBorderColor(view: collageViews[pageControl.currentPage])
    }


}
