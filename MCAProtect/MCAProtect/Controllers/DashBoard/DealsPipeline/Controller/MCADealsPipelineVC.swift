//
//  MCADealsPipelineVC.swift
//  MCAProtect
//
//  Created by Manjunath on 07/02/17.
//  Copyright © 2017 Accionlabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class MCADealsPipelineVC: MCABaseViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MCAPickerViewDelegate,MCADatePickerViewDelegate,MCARefreshDelegate {

    @IBOutlet weak var pipeLineTableView: MCATableView!
    
    var dealsPipeline : MCADealsPipeLine!
    var dataSourceArray = [MCADealsPipeLine]()
    var pickerViewPopup : UIActionSheet!
    @IBOutlet weak var rangeSelectionLabel: UILabel!
    
    var rangePicker = UIPickerView()
    var blurView:UIVisualEffectView!
    
    var toolbar : UIToolbar?
    var doneButton : UIBarButtonItem?
    var pickerTitle : UIBarButtonItem?
    var rangeList = Array<String>()
    var fromDateString : String!
    var toDateString : String!
    
    var selectedRange :MCADealsPipelineRange!
    var customDatePicker : MCACustomDatePickerView!
    var customPicker : MCACustomPickerView!
    weak var parentController: MCADashboardTabbarVC!
    
    var colorsArray = ["00ddff","0099cc","33b5e5","99cc00","ffbb33","aa66cc","ff4444"]

    //MARK: - View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        pipeLineTableView.register(UINib(nibName: "MCADealsPipelineTVCell", bundle: nil), forCellReuseIdentifier: CellIdentifiers.MCADealsPipelineTVCell)
        pipeLineTableView.tableFooterView = UIView()
        
        rangeList.append("Custom")
        rangeList.append("Current Week")
        rangeList.append("Current Month")
        rangeList.append("Previous Month")
        rangeList.append("Current Quarter")
        rangeList.append("Previous Quarter")
        rangeList.append("Current Year")
        
        selectedRange = MCADealsPipelineRange.CurrentYear
        rangeSelectionLabel.text = rangeList[selectedRange.rawValue]

        getDealsPipelineList()

        pipeLineTableView.addRefreshController()
        pipeLineTableView.refreshDelegate = self

    }
    
    func refreshContents()
    {
        getDealsPipelineList()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table View Datasource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.MCADealsPipelineTVCell) as! MCADealsPipelineTVCell!
        cell?.selectionStyle = .none
        
        dealsPipeline = dataSourceArray[indexPath.row]
        cell?.setDealsPipeline(dealsPipeline: dealsPipeline)
        cell?.leftView.backgroundColor = MCAUtilities.hexStringToUIColor(hexaDecimalString: colorsArray[indexPath.row])
        
        return cell!
    }
    
    //MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let applicationVC  = UIStoryboard(name: StoryboardName.MCAMerchantApplication, bundle: nil).instantiateViewController(withIdentifier:VCIdentifiers.MCAMerchantApplicationListVC) as! MCAMerchantApplicationListVC
        
        dealsPipeline = dataSourceArray[indexPath.row]
        applicationVC.selectedDealsPipeline = dealsPipeline;
        applicationVC.fromDateString = fromDateString
        applicationVC.toDateString = toDateString
        
        if dealsPipeline.applicationCount != 0{
            parentController.navigationController?.pushViewController(applicationVC, animated: true);
            
        }
    }
    
    
    //MARK: - API for Getting deals pipeline -
    
    func getDealsPipelineList() {
        
            if self.checkNetworkConnection() == false {
        return
    }
    
    self.showActivityIndicator()

        
        var endPoint = String()
        endPoint.append(MCAAPIEndPoints.BrokerDashBoardAPIEndpoint);
        endPoint.append("\(MCASessionManager.sharedSessionManager.mcapUser.brokerID!)");
        
        
        //TODO: create date range according to the selection
        
        let currentDate = Date()
        
        let unitFlags = Set<Calendar.Component>([.month, .year, .day])
        let calendar = Calendar.current
        let components = calendar.dateComponents(unitFlags, from: currentDate)

        switch selectedRange!
        {
            case .Custom:
                
                endPoint.append("?from_date=2017-01-01&to_date=2017-12-31")
            case .CurrentWeek:
                
                var fromDateComponents = DateComponents()
                fromDateComponents.year = components.year
                fromDateComponents.month = components.month
                fromDateComponents.day = components.day! - 7
                
                let fromCalendar = Calendar.current // user calendar
                let fromDateTime = fromCalendar.date(from: fromDateComponents)
                fromDateString = MCAUtilities.FormattedStringFromDate(date: fromDateTime!)
                
                var toDateComponents = DateComponents()
                toDateComponents.year = components.year
                toDateComponents.month = components.month
                toDateComponents.day = components.day
                
                let toCalendar = Calendar.current // user calendar
                let toDateTime = toCalendar.date(from: toDateComponents)
                toDateString = MCAUtilities.FormattedStringFromDate(date: toDateTime!)
                
            case .CurrentMonth:
                var fromDateComponents = DateComponents()
                fromDateComponents.year = components.year
                fromDateComponents.month = components.month
                fromDateComponents.day = 1
                
                let fromCalendar = Calendar.current // user calendar
                let fromDateTime = fromCalendar.date(from: fromDateComponents)
                fromDateString = MCAUtilities.FormattedStringFromDate(date: fromDateTime!)
                
                var toDateComponents = DateComponents()
                toDateComponents.year = components.year
                toDateComponents.month = components.month
                toDateComponents.day = components.day
                
                let toCalendar = Calendar.current // user calendar
                let toDateTime = toCalendar.date(from: toDateComponents)
                toDateString = MCAUtilities.FormattedStringFromDate(date: toDateTime!)
                
            case .PreviousMonth:
                
                var fromDateComponents = DateComponents()
                fromDateComponents.year = components.year
                fromDateComponents.month = components.month! - 1
                fromDateComponents.day = 1
                
                let fromCalendar = Calendar.current // user calendar
                let fromDateTime = fromCalendar.date(from: fromDateComponents)
                fromDateString = MCAUtilities.FormattedStringFromDate(date: fromDateTime!)
                
                var toDateComponents = DateComponents()
                toDateComponents.year = components.year
                toDateComponents.month = components.month
                toDateComponents.day = components.day
                
                let toCalendar = Calendar.current // user calendar
                let toDateTime = toCalendar.date(from: toDateComponents)
                toDateString = MCAUtilities.FormattedStringFromDate(date: toDateTime!)
                
                
            case .CurrentQuarter:
                
                var fromDateComponents = DateComponents()
                fromDateComponents.year = components.year
                fromDateComponents.month = components.month
                fromDateComponents.day = 1
                
                let fromCalendar = Calendar.current // user calendar
                let fromDateTime = fromCalendar.date(from: fromDateComponents)
                fromDateString = MCAUtilities.FormattedStringFromDate(date: fromDateTime!)
                
                var toDateComponents = DateComponents()
                toDateComponents.year = components.year
                toDateComponents.month = components.month! + 3
                toDateComponents.day = components.day
                
                let toCalendar = Calendar.current // user calendar
                let toDateTime = toCalendar.date(from: toDateComponents)
                toDateString = MCAUtilities.FormattedStringFromDate(date: toDateTime!)
                
                
            case .PreviousQuarter:
                
                var fromDateComponents = DateComponents()
                fromDateComponents.year = components.year
                fromDateComponents.month = components.month! - 3
                fromDateComponents.day = 1
                
                let fromCalendar = Calendar.current // user calendar
                let fromDateTime = fromCalendar.date(from: fromDateComponents)
                fromDateString = MCAUtilities.FormattedStringFromDate(date: fromDateTime!)
                
                var toDateComponents = DateComponents()
                toDateComponents.year = components.year
                toDateComponents.month = components.month
                toDateComponents.day = components.day
                
                let toCalendar = Calendar.current // user calendar
                let toDateTime = toCalendar.date(from: toDateComponents)
                toDateString = MCAUtilities.FormattedStringFromDate(date: toDateTime!)
                
                
            case .CurrentYear:
                
                var fromDateComponents = DateComponents()
                fromDateComponents.year = components.year
                fromDateComponents.month = 1
                fromDateComponents.day = 1
                
                let fromCalendar = Calendar.current // user calendar
                let fromDateTime = fromCalendar.date(from: fromDateComponents)
                fromDateString = MCAUtilities.FormattedStringFromDate(date: fromDateTime!)
                
                var toDateComponents = DateComponents()
                toDateComponents.year = components.year
                toDateComponents.month = components.month
                toDateComponents.day = components.day
                
                let toCalendar = Calendar.current // user calendar
                let toDateTime = toCalendar.date(from: toDateComponents)
                toDateString = MCAUtilities.FormattedStringFromDate(date: toDateTime!)
            
            
        }

        endPoint.append("?from_date=\(fromDateString!)&to_date=\(toDateString!)")
        
        MCAWebServiceManager.sharedWebServiceManager.getRequest(requestParam:[:],
                                                                endPoint:endPoint
            , successCallBack:{ (response : JSON) in
                
                self.dataSourceArray.removeAll()
                self.stopActivityIndicator()
                print("Success \(response)")
                
                if let items = response["data"].array
                {
                    let sortedResults = items.sorted { $0["application_state_id"].doubleValue < $1["application_state_id"].doubleValue }
                    print("Sorted Data \(sortedResults)")

                    for item in sortedResults {
                        self.dealsPipeline = MCADealsPipeLine(dealsPipeLine:item)
                        self.dataSourceArray.append(self.dealsPipeline)
                    }
                    self.pipeLineTableView.reloadData()
                }
        },
              failureCallBack: { (error : Error) in
                
                self.stopActivityIndicator()
                print("Failure \(error)")
                let alertViewController = UIAlertController(title : "MCAP", message : "Dashboard update Failed", preferredStyle : .alert)
                alertViewController.addAction(UIAlertAction(title : "OK" , style : .default , handler : nil))
                self.present(alertViewController, animated: true , completion: nil)
        })
    }

    @IBAction func selectDateRange(_ sender: Any)
    {
//        
//        customDatePicker =  Bundle.main.loadNibNamed("MCACustomDatePickerView", owner: self, options: nil)?[0] as! MCACustomDatePickerView
//        
//
//        customDatePicker.frame = self.parentController.view.bounds
//        customDatePicker.layoutIfNeeded()
//        self.parentController.view.addSubview(customDatePicker)

        if(nil == customPicker)
        {
            customPicker =  Bundle.main.loadNibNamed("MCACustomPickerView", owner: self, options: nil)?[0] as! MCACustomPickerView
        }
        customPicker.selectedRange = selectedRange.rawValue
        customPicker.setDatasource(dataSource: rangeList)
        customPicker.pickerDelegate = self;
        customPicker.frame = self.parentController.view.bounds
        customPicker.layoutIfNeeded()
        self.parentController.view.addSubview(customPicker)
    }
    
    func pickerSelected(dealsPipelineRange : NSInteger){
        
        selectedRange = MCADealsPipelineRange(rawValue: dealsPipelineRange)!
        rangeSelectionLabel.text = rangeList[dealsPipelineRange]
        
        if(MCADealsPipelineRange.Custom != selectedRange) {
            getDealsPipelineList()
        }
    }
    
    func dateSelected(date: Date)
    {
        
    }
    

}
