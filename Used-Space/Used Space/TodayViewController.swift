//
//  TodayViewController.swift
//  Used Space
//
//  Created by Hayley Guillou on 2014-11-21.
//  Copyright (c) 2014 hayleyguillou. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var barView: UIProgressView!
    
    let RATE_KEY = "kUDRateUsed"
    
    var fileSystemSize: UInt64 = 0
    var freeSize: UInt64 = 0
    var usedSize: UInt64 = 0
    //var usedRate: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
        percentLabel.text = "ran"
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateInterface() {
        var rate: Double = self.usedRate; // retrieve the cached value
        self.percentLabel.text = String(format: "%.1d%%", (rate*100))
        self.barView.progress = Float(rate);
    }
    
    func updateSizes() {
        // Retrieve the attributes from NSFileManager
        var dict: NSDictionary = NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory(), error: nil)!
        
        // Set the values
        fileSystemSize = UInt64(dict.valueForKey(NSFileSystemSize) as Int)
        freeSize       = UInt64(dict.valueForKey(NSFileSystemFreeSize) as Int)
        usedSize       = self.fileSystemSize - self.freeSize;
    }
    
    var usedRate() -> (Double) {
    return NSUserDefaults.standardUserDefaults().valueForKey(RATE_KEY) as Double
    }
    
    func setUsedRate(usedRate: Double)
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(usedRate, forKey: RATE_KEY)
        defaults.synchronize()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        updateSizes()
        var newRate = Double(self.usedSize) / Double(self.fileSystemSize)
        if (newRate - usedRate()) < 0.0001 {
            completionHandler(NCUpdateResult.NoData)
        } else {
            setUsedRate(newRate)
            updateInterface()
            completionHandler(NCUpdateResult.NewData)
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var margins: UIEdgeInsets = defaultMarginInsets
        margins.bottom = 10.0
        return margins
    }
    
}
