//
//  StatisticsViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/25/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

    //MARK: *** UI Variables
    var database: OpaquePointer?
    let day = ["Sun", "Mon", "Tues", "Weds", "Thurs", "Fri", "Satur"]
    var thisWeek = [String]()
    var income = ""
    //MARK: *** Data model
    var Bills = [Bill]()
    //MARK: ***UI Elements
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var statistic: LineChartView!
    @IBOutlet weak var saleLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        database = DB.openDatabase()
        thisWeek = formattedDaysInThisWeek()
        print(thisWeek)
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        Bills = DBBill.loadBill(database: database)
        var total = 0
        var entries = [ChartDataEntry]()
        for i in 0..<thisWeek.count{
            var currentday = 0
            for j in 0..<Bills.count
            {
                if thisWeek[i] == Bills[j].dateCheckIn!
                {
                    currentday += Bills[j].totalPrice!
                }
            }
            let entry = ChartDataEntry(x: Double(i), y: Double(currentday))
            entries.append(entry)
            currentday = 0
        }
        for i in 0..<Bills.count{
            total += Bills[i].totalPrice!
        }
        saleLabel.text = total.toCurrency()
        let dataSet = LineChartDataSet(values: entries, label: income)
        dataSet.colors = [UIColor.red]
        dataSet.circleColors = [UIColor.red]
        
        let data = LineChartData(dataSets: [dataSet])
        statistic.data = data
        
        // *** Định dạng lại cho biểu đồ
        statistic.chartDescription?.text = ""
        statistic.xAxis.drawLabelsEnabled = true
        statistic.leftAxis.granularity = 10000
        statistic.rightAxis.granularity = 10000
        statistic.xAxis.valueFormatter = IndexAxisValueFormatter(values: day)
        statistic.xAxis.granularity = 1
        statistic.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

    func formattedDaysInThisWeek() -> [String] {
        // create calendar
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // today's date
        let today = NSDate()
        let todayComponent = calendar.components([.day, .month, .year], from: today as Date)
        
        // range of dates in this week
        let thisWeekDateRange = calendar.range(of: .day, in:.weekOfMonth, for:today as Date)
        
        // date interval from today to beginning of week
        let dayInterval = thisWeekDateRange.location - todayComponent.day!
        
        // date for beginning day of this week, ie. this week's Sunday's date
        let beginningOfWeek = calendar.date(byAdding: .day, value: dayInterval, to: today as Date, options: .matchNextTime)
        
        var formattedDays: [String] = []
        
        for i in 0 ..< thisWeekDateRange.length {
            let date = calendar.date(byAdding: .day, value: i, to: beginningOfWeek!, options: .matchNextTime)!
            formattedDays.append(formatDate(date: date as NSDate))
        }
        
        return formattedDays
    }
    
    func formatDate(date: NSDate) -> String {
        let format = "dd-MM-yyyy"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    
    func configureViewFromLocalisation() {
        self.navigation.topItem?.title = Localization("StatisticWeek")
        self.backButton.title = Localization("Back")
        revenueLabel.text = Localization("Revenue")
        income = Localization("Income")
    }
}
