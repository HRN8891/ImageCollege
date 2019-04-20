//
//  CromaColorPickerVC.swift
//  Collage
import UIKit


@objc protocol CromaColorPickerVCDelegate {
    func changeBorderColorWithColor(color: UIColor)
}
class CromaColorPickerVC: UIViewController {
    
    weak var cromaColorPickerVCDelegate: CromaColorPickerVCDelegate?

    @IBOutlet weak var colorDisplayView: UIView!
    var colorPicker: ChromaColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Calculate relative size and origin in bounds */
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.midY - pickerSize.height/2)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
        //colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor] // You can also override gradient colors
        
        
        colorPicker.hexLabel.textColor = UIColor.white
        
        /* Don't want an element like the shade slider? Just hide it: */
        //colorPicker.shadeSlider.hidden = true
        
        self.view.addSubview(colorPicker)
    }
     @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true) {
        }
    }
}

extension CromaColorPickerVC: ChromaColorPickerDelegate{
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        //Set color for the display view
       self.cromaColorPickerVCDelegate?.changeBorderColorWithColor(color: color)
    }
}
