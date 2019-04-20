//
//  ChangeBorderVC.swift
//  Collage
//


import UIKit
import RangeSeekSlider

@objc protocol ChangeBorderVCDelegate {
    func changeBorderWidth(width: CGFloat)
}
class ChangeBorderVC: UIViewController {
    @IBOutlet fileprivate weak var changeBorderSlider: RangeSeekSlider!
    weak var changeBorderVCDelegate: ChangeBorderVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBorderSlider.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true) {
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChangeBorderVC: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === changeBorderSlider {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            self.changeBorderVCDelegate?.changeBorderWidth(width: minValue)
        }
      
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
