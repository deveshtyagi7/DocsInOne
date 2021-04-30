//
//  AppUtil.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 25/04/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI
import CoreLocation


//MARK: - Constants
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let ratingNotificationTime = 2 // after 2 sec
let checkoutNotificationTime =  5 * 60 //1 hour
//MARK: - global functions
//load mainview
/*func loadMainView()   {
    guard let mainView = UIStoryboard(name: Screens.SideMenu.rawValue, bundle: nil).instantiateInitialViewController() as? CustomSideMenuViewController
        else{
            return
    }
//    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//      let sceneDelegate = windowScene.delegate as? SceneDelegate
//    else {
//      return
//    }
    
    if let keyWindow = UIWindow.key {
        // Do something
        keyWindow.rootViewController = mainView
    }
   // appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
   // sceneDelegate.window?.rootViewController = mainView
}*/



func userLogout(){
    removeIsServiceProvider()
    removeIsMinorityOwned()
    removeIsWomenOwned()
    removwAccessToken()
    removeUserID()
    removeReferralCode()
    removeReferralCount()
    
   //
    
//    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//        let sceneDelegate = windowScene.delegate as? SceneDelegate
//        else {
//            return
//    }
    removeAuroSignIn()//remove
  //  deleteImageToDocumentDirectory(name: KeyChain_ProfileImageKey)
   
//    removeAppliedFilter()
//    if let keyWindow = UIWindow.key {
//        // Do something
//      //  keyWindow.rootViewController  = loginTVC
//    }
  //  sceneDelegate.window?.rootViewController = loginVC
    UIApplication.shared.applicationIconBadgeNumber = 0
}
enum AppTabMenu {
    case hotspots,dailydeals,home,events,favorite
}

var selectedTabMenu:AppTabMenu = .home
//MARK: - OTP Generation
func generateOTP() -> String {
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }
    return fourDigitNumber
}

//MARK: - Date formatter's metthod

func getGreetingsByTime()->String{
    let dateComponents = Calendar.current.dateComponents([.hour], from: Date())
    if let hour = dateComponents.hour {
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return  "Good afternoon"
        default:
            return  "Good evening"
        }
    }
    return ""
}

func getStringFromDateString(dateString: String, dateFormat:String, desireDateFormat:String) -> String? {
    guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat) else { return nil }
    guard let desireDateString = getStringFromDate(date: date, dateFormat: desireDateFormat, useTimeZone: false) else { return nil }
    return desireDateString
}

func getDateFromString(dateString: String, dateFormat:String) -> Date? {
    let formater = DateFormatter()
    formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
    guard let date = formater.date(from: dateString) else{
        return nil
    }
    return date
}

func getStringFromDate(date: Date, dateFormat:String, useTimeZone:Bool) -> String? {
    let formater = DateFormatter()
    if useTimeZone{
    formater.timeZone = TimeZone(identifier: "Asia/Dubai")
    }
    formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
    let date1 = formater.string(from: date)
    return date1
}

func getDateFromTimeStamp(unixTimeStamp: Double, dateFormat:String) ->String?{
    let date = Date(timeIntervalSince1970: unixTimeStamp/1000)
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    //dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = dateFormat //Specify your format that you want
    let strdate = dateFormatter.string(from: date)
    return strdate
}

func getTimestampFromString(dateString: String, dateFormat:String)-> Double?{
    guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat)
        else{
            return nil
    }
    let dateStamp:TimeInterval = date.timeIntervalSince1970
    return (dateStamp)
}

func getDurationFromLastMsg(messageTime : String)-> String{
    let date = getTimestampFromString(dateString: messageTime, dateFormat:  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    let lastMsgtime = Date(timeIntervalSince1970: date!)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.second,.minute,.hour, .day]
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .full
    let now = Date()
    return formatter.string(from: lastMsgtime , to: now) ?? "2m"
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64(self.timeIntervalSince1970 * 1000.0)
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
//MARK : - Compostion
extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return NSAttributedString()
        }
    }
    
    // MARK: Remove Special character from string.
    var removeSpecialCharsFromString: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}

/// MARK: Regular Expression

extension String {
    func isValidPin() -> Bool {
        let regularExpression = "^(?!.*?(?:0(?:12|98)|123|234|3(?:45|21)|4(?:56|32)|5(?:67|43)|6(?:78|54)|7(?:89|65)|876|987))(?!.*?(.)\\1{2})[0-9]{5}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        
        return passwordValidation.evaluate(with: self)
    }
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!-/:-@\\[-`{-~]).{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func convertStringToLink() -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self, attributes: nil)
        let linkRange = NSRange(location: 0, length: self.count) // for the word "link" in the string above
        
        let linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.05, green: 0.4, blue: 0.65, alpha: 1.0),
            NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
        ]
        attributedString.setAttributes(linkAttributes, range: linkRange)
        return attributedString
    }
}

// MARK: UIButton Extension
extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}

////////// 971564804596

//json response keys
/////////////
//MARK: - API Methods
public enum APIMethods: String{
    case Login = "Login"
    case Logout = "Logout"
    
}


//MARK: - Side Menu Options
//enum SideMenuOptions: String {
//    case showHome = "showHome"
//    case containSideMenu = "containSideMenu"
//    case showContactUs = "showContactUs"
//    case showAboutUs = "showAboutUs"
//    case showShare = "showShare"
//    case showTermsAndCondition = "showTermsAndCondition"
//    case showSettings = "showSettings"
//    case showHelp = "showHelp"
//    case showMyProfile = "showMyProfile"
//}

//MARK: - Storyboards
enum Screens: String {
    case LaunchScreen = "LaunchScreen"
    case Welcome = "Welcome"
    case Login = "Login"
    case Dashboard = "Dashboard"
    case SideMenu = "SideMenu"
}

//MAR: - welcome from
enum ServiceType {
    case education, card, food, moneytransfer, goverment, bills, none
}

///show alert message
//MARK: - For Alert Message
enum AlertTitleType:String {
    case Oops = "Oops!"
   // case Warning = "Warning"
    case Message = "Message"
   // case Information = "Information"
    case none = ""
}


extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
func showAlertMessage(vc: UIViewController, title:AlertTitleType , message:String,actionTitle: String? = "Ok", handler:((UIAlertAction)->())? = nil) -> Void {

    let alertCtrl = UIAlertController(title: title.rawValue, message: message, preferredStyle: UIAlertController.Style.alert)

  let alertCancel = UIAlertAction(title: actionTitle, style: .cancel, handler: handler)
  alertCtrl.addAction(alertCancel)

//    let imageView = UIImageView(frame: CGRect(x: 115, y: -10, width: 40, height: 40))
//    imageView.image = UIImage(named: "danger")
//
//    alertCtrl.view.addSubview(imageView)

  vc.present(alertCtrl, animated: true, completion: nil)
}

func showConfirmMessage(vc: UIViewController, title:String, message:String,actionTitle: String?, imageName:String = "Alert_Caution", handler:((UIAlertAction)->())?) -> Void {
    
      
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
    let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertCtrl.addAction(alertCancel)
    alertCtrl.addAction(alertAction)
    vc.present(alertCtrl, animated: true, completion: nil)
}


func showMultipleActionMessage(vc: UIViewController, title:String, message:String,actionTitle1: String?,actionTitle2: String?, handler1:((UIAlertAction)->Void)?, handler2:((UIAlertAction)->Void)?) -> Void {
    
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let alertAction1 = UIAlertAction(title: actionTitle1, style: .default, handler: handler1)
    let alertAction2 = UIAlertAction(title: actionTitle2, style: .default, handler: handler2)
    alertCtrl.addAction(alertAction1)
    alertCtrl.addAction(alertAction2)
    vc.present(alertCtrl, animated: true, completion: nil)
}


//func showErrorMessage( vc: UIViewController,message:String, focusTextField:UITextField)  {
//    showAlertMessage(vc: vc, title: .Oops, message: message, actionTitle: "Ok".localized) { (action) in
//        DispatchQueue.main.async {
//            focusTextField.becomeFirstResponder()
//        }
//    }
//}
//validation
extension String{
    
//    var isValidContact: Bool {
//        let phoneNumberRegex = "^[6-9]\\d{9}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
//        let isValidPhone = phoneTest.evaluate(with: self)
//        return isValidPhone
//    }
//
    var isValidPhone: Bool {
        let phoneRegex = "^((0091)|(\\+91)|(\\+91)|0?)[6789]{1}\\d{9}$"
        //let mobileRegEx = "^[1{1}]\\s\\d{3}-\\d{3}-\\d{4}$"//"1 555-555-5555"
        //let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        //let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidEmail = emailTest.evaluate(with: self)
        return isValidEmail
    }
}


func getAccessToken( ) -> String? {
      return  UserDefaults.standard.string(forKey: KeyChain_AuthToken)
}

func setAccessToken( accessToken:String ) {
    
    UserDefaults.standard.set(accessToken, forKey: KeyChain_AuthToken)
}
func removwAccessToken() {
    UserDefaults.standard.removeObject(forKey: KeyChain_AuthToken)
}

func setReferralCode(referralCode: String){
    UserDefaults.standard.set(referralCode, forKey: KeyChain_ReferralCode)
}

func getReferralCode() -> String?{
    return UserDefaults.standard.string(forKey: KeyChain_ReferralCode)
}

func removeReferralCode(){
    UserDefaults.standard.removeObject(forKey: KeyChain_ReferralCode)
}

func setReferralCount(referralCount: Int){
    UserDefaults.standard.set(referralCount, forKey: KeyChain_ReferralCount)
}

func getReferralCount() -> String?{
    UserDefaults.standard.string(forKey: KeyChain_ReferralCount)
}

func removeReferralCount() {
    UserDefaults.standard.removeObject(forKey: KeyChain_ReferralCount)
}

func getCheckedInVenueID( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_CheckedInVenueID)
}

func setCheckedInVenueID(venueId : String ) {
    UserDefaults.standard.set(venueId, forKey: KeyChain_CheckedInVenueID)
}

func removeCheckedInVenueID() {
    UserDefaults.standard.removeObject(forKey: KeyChain_CheckedInVenueID)
}

func getCheckedInTime( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_CheckedInTime)
}

func setCheckedInTime(time : String ) {
    UserDefaults.standard.set(time, forKey: KeyChain_CheckedInTime)
}

func removeCheckedInTime() {
    UserDefaults.standard.removeObject(forKey: KeyChain_CheckedInTime)
}
func getUserID( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_UserID)
}

func setUserID( userid:String ) {
    UserDefaults.standard.set(userid, forKey: KeyChain_UserID)
}

func removeUserID() {
    UserDefaults.standard.removeObject(forKey: KeyChain_UserID)
}

var isWomenOwned = false
func setIsWomenOwned( status:Bool ) {
    UserDefaults.standard.set(status, forKey: KeyChain_isWomenOwned)
}
func getIsWomenOwned( ) -> Bool? {
    return UserDefaults.standard.bool(forKey: KeyChain_isWomenOwned)
}
func removeIsWomenOwned( ){
    UserDefaults.standard.removeObject(forKey: KeyChain_isWomenOwned)
}
func setIsMinorityOwned( status:Bool ) {
    UserDefaults.standard.set(status, forKey: KeyChain_isMinorityOwned)
}
func getIsMinorityOwned( ) -> Bool? {
    return UserDefaults.standard.bool(forKey: KeyChain_isMinorityOwned)
}
func removeIsMinorityOwned( ){
    UserDefaults.standard.removeObject(forKey: KeyChain_isMinorityOwned)
}
func setIsServiceProvider( status:Bool ) {
    UserDefaults.standard.set(status, forKey: KeyChain_setIsServiceProvider)
}
func getIsServiceProvider( ) -> Bool? {
    return UserDefaults.standard.bool(forKey: KeyChain_setIsServiceProvider)
}
func removeIsServiceProvider( ){
    UserDefaults.standard.removeObject(forKey: KeyChain_setIsServiceProvider)
}

func deleteAccessToken()  {
     UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    UserDefaults.standard.removeObject(forKey: KeyChain_AuthToken)
}


func getDistanceInMile (_ location1:CLLocation , location2:CLLocation ) -> String {
    let distanceInMeters = location1.distance(from: location2)
    let distanceInMiles = distanceInMeters/1609.344
    let distanceMiles =   String(format: "%.2f", distanceInMiles)
    return distanceMiles
}

func getDistanceInMeters (_ location1:CLLocation , location2:CLLocation ) -> Int {
    let distanceInMeters = location1.distance(from: location2)
    print("getDistanceInMeters === > \(distanceInMeters)")
    return Int(distanceInMeters)
}

/*func setCurrentLocation( currentlocation:CLLocation ) {
    UserDefaults.standard.set(currentlocation, forKey: KeyChain_CurrentLocation)
}

func getCurrentLocation( ) -> CLLocation? {
    return UserDefaults.standard.string(forKey: KeyChain_CurrentLocation)
}*/

//Getting top ost view for Rating and Connect with us screens
func topMostController() -> UIViewController {
    guard var topController: UIViewController = (UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) else {
        return UIViewController()
    }
    //let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController!
    }
    return topController
}
//Filters

//USER Default
func setUserName( userName:String ) {
    UserDefaults.standard.set(userName, forKey: KeyChain_UserName)
}
func getUserName( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_UserName)
}

func setUserLastName( userLastName:String ) {
    UserDefaults.standard.set(userLastName, forKey: KeyChain_UserLastName)
}

func getUserLastName( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_UserLastName)
}

func setUserProfession(profession:String ) {
    UserDefaults.standard.set(profession, forKey: KeyChain_Profession)
}
func getUserProfession( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_Profession)
}
func setUserPassword( password:String ) {
    UserDefaults.standard.set(password, forKey: KeyChain_UserPassword)
}
func getUserPassword( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_UserPassword)
}

func setFCMToken( token:String ) {
    UserDefaults.standard.set(token, forKey: KeyChain_FCMDeviceToken)
}
func getFCMToken( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_FCMDeviceToken)
}

func setAuroSignIn( status:String ) {
    UserDefaults.standard.set(status, forKey: KeyChain_AutoSignIn)
}
func getAuroSignIn( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_AutoSignIn)
}
func removeAuroSignIn( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_AutoSignIn)
}


func setProfileUserName(_ username:String ) {
    UserDefaults.standard.set(username, forKey: KeyChain_ProfileUserName)
}
func getProfileUserName( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_ProfileUserName)
}
func removeProfileUserName( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_ProfileUserName)
}


func setProfileEmail(_ email:String ) {
    UserDefaults.standard.set(email, forKey: KeyChain_ProfileUserEmail)
}
func getProfileEmail( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_ProfileUserEmail)
}
func removeProfileEmail( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_ProfileUserEmail)
}


func setIsCheckedIn(_ isCheckedIn:Bool ) {
    UserDefaults.standard.set(isCheckedIn, forKey:KeyChain_IsCheckedIn )
}
func getIsCheckedIn( ) -> Bool {
    return UserDefaults.standard.bool(forKey: KeyChain_IsCheckedIn)
}

func removeIsCheckedIn( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_IsCheckedIn)
}

func setFeedbackVenueName(_ venueName:String ) {
    UserDefaults.standard.set(venueName, forKey: KeyChain_FeedbackVenueName)
}
func getFeedbackVenueName( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_FeedbackVenueName)
}
func removeFeedbackVenueName( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_FeedbackVenueName)
}

//UserDefault for Filters
func getProfessionFilter() -> [String]? {
    return UserDefaults.standard.object(forKey: "2678387t3b387t3t383") as? [String]
    
}

func setProfessionFilter(_ arr : [String]) {
    UserDefaults.standard.set(arr, forKey: "2678387t3b387t3t383")
}

func setIndustryFilter(_ arr : [String]){
    UserDefaults.standard.set(arr, forKey:KeyChain_Industry)
}
func getIndustryFilter( ) -> [String]? {
    return UserDefaults.standard.object(forKey: KeyChain_Industry)as? [String]
}
func setAffFilter(_ arr : [String]){
    UserDefaults.standard.set(arr, forKey:KeyChain_Affiliation )
}
func getAffFilter( ) -> [String]? {
    return UserDefaults.standard.object(forKey: KeyChain_Affiliation) as? [String]
}
func setInterestFilter(_ arr : [String]){
    UserDefaults.standard.set(arr, forKey:KeyChain_Interest )
}
func getInterestFilter( ) -> [String]? {
    return UserDefaults.standard.object(forKey: KeyChain_Interest) as? [String]
}
func setCityFilter(_ arr : [String]){
    UserDefaults.standard.set(arr, forKey:KeyChain_City)
}
func getCityFilter( ) -> [String]? {
    return UserDefaults.standard.object(forKey: KeyChain_City) as? [String]
}
func setAppliedFilterByUser(_ filterArray:[String:Any] ) {
    UserDefaults.standard.set(filterArray, forKey:KeyChain_FilterArrayByUser )
}
func getAppliedFilterByUser( ) -> [String:Any]? {
    return UserDefaults.standard.object(forKey: KeyChain_FilterArrayByUser) as? [String : Any]
}
func setUserProfileData(data : [String: Any]){
    UserDefaults.standard.set(data, forKey:KeyChain_setUserProfileData )
}
func getUserProfileData() -> [String:Any]?{
    let profileDetail = UserDefaults.standard.object(forKey: KeyChain_setUserProfileData) as! [String:Any]

    let profession : String  = profileDetail["Profession"] as! String
    let country : String = profileDetail["Country"] as! String
    let serviceProvider : String = profileDetail["Service Provider"] as! String
    let state : String = profileDetail["State"] as! String
    let industry : Array<String> = profileDetail["Industry"] as! Array<String>
    let minorityOwned : String = profileDetail["Minority owned bussiness"] as! String
    let womenOwnedBussiness : String = profileDetail["Women owned bussiness"] as! String

    let properties =  ["Profession" : profession, "Country" : country,"State": state, "Industry":industry,"Women owned bussiness": womenOwnedBussiness,"Minority owned bussiness":minorityOwned ,"Service Provider": serviceProvider] as [String : Any]
    return properties
}
func removeUserProfileData( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_setUserProfileData)
}


func removeAppliedFilterByUser( ){
    removeIsServiceProvider()
    removeIsMinorityOwned()
    removeIsWomenOwned()
     UserDefaults.standard.removeObject(forKey: KeyChain_FilterArrayByUser)
}

func setAppliedFilter(_ filterArray:[[String:Any]] ) {
    UserDefaults.standard.set(filterArray, forKey:KeyChain_FilterArray )
}
func getAppliedFilter( ) -> [[String:Any]]? {
    return UserDefaults.standard.object(forKey: KeyChain_FilterArray) as? [[String : Any]]
}

func removeAppliedFilter( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_FilterArray)
}

func setFilterAppliedBy(viewName : String){
    UserDefaults.standard.set(viewName, forKey: KeyChain_FilterAppliedBy )
}
func getFilterAppliedBy( ) -> String? {
    return UserDefaults.standard.string(forKey: KeyChain_FilterAppliedBy)
}
func removeFilterAppliedBy() {
    UserDefaults.standard.removeObject(forKey: KeyChain_FilterAppliedBy)
}

//UserDefault for Settings And priferences
func setSettingsAndPreferences(_ settingsAndPreferencesArray:[String:Any]) {
    removeSettingsAndPreferences()
    UserDefaults.standard.set(settingsAndPreferencesArray, forKey:KeyChain_SettingsAndPreferences )
}
func getSettingsAndPreferences( ) -> [String:Any]? {
    return UserDefaults.standard.object(forKey: KeyChain_SettingsAndPreferences) as? [String:Any]
}

func removeSettingsAndPreferences( ){
     UserDefaults.standard.removeObject(forKey: KeyChain_SettingsAndPreferences)
}




func setTabBarImage() {
    if let profileImage = getImageFromLocal(filename :KeyChain_ProfileImageKey){
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let tabBarController =  appDelegate?.self.window!.rootViewController as? UITabBarController {

            tabBarController.tabBar.items![0].title = ""
            tabBarController.tabBar.items![1].title = ""
            tabBarController.tabBar.items![2].title = ""
            
            tabBarController.addSubviewToFirstTabItem(profileImage)
            
        }
        
    }
}

func deleteImageToDocumentDirectory( name:String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
    
    do {
        try fileManager.removeItem(atPath: paths)
    } catch {
        print("Could not clear temp folder: \(error)")
    }
    
}


func createDirectory(){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("images")
    if !fileManager.fileExists(atPath: paths){
        do {
            try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Couldn't create document directory")
        }
    }else{
        print("Already directory created.")
    }
}

func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getImageFromLocal(filename:String)->UIImage? {
    
    let fileManager = FileManager.default
    let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(filename)
    if fileManager.fileExists(atPath: imagePath){
        if let image = UIImage(contentsOfFile: imagePath){
            return image
        } else {
            return #imageLiteral(resourceName: "placeholderImg")
        }
       
    }else{
        print("No Image available")
        return nil
    }
}

func requestForContactAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
    let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    let addressBookStore = CNContactStore()
    switch authorizationStatus {
    case .authorized:
        completionHandler(true)
    case .denied, .notDetermined:
        addressBookStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
            if access {
                completionHandler(access)
            } else {
                if authorizationStatus == CNAuthorizationStatus.denied {
                    completionHandler(false)
                }
            }
        })
    default:
        completionHandler(false)
    }
}

func setHMACKey(input:String)  {
    UserDefaults.standard.set(input, forKey: KeyChain_SetHMAC)
}

func getHMACKey() ->String? {
    guard let output = UserDefaults.standard.string(forKey: KeyChain_SetHMAC) else{
        return nil
    }
    return output
}

func setAESKey(input:String)  {
    UserDefaults.standard.set(input, forKey: KeyChain_SetAESKey)
}

func getAESKey() ->String? {
    guard let output = UserDefaults.standard.string(forKey: KeyChain_SetAESKey) else{
        return nil
    }
    return output
}

func setAESNonce(input:String)  {
    UserDefaults.standard.set(input, forKey: KeyChain_SetAESNonce)
}

func getAESNonce() ->String? {
    guard let output = UserDefaults.standard.string(forKey: KeyChain_SetAESNonce) else{
        return nil
    }
    return output
}

func getDeviceUniqueID()-> String{
    #if targetEnvironment(simulator)
        return "abcdef123456"
    #else
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    #endif
   
 }

//App killed after launch saved userinfo
func setuserinfo(_ userinfo:[AnyHashable : Any] ) {
    UserDefaults.standard.set(userinfo, forKey:KeyChain_UserInfo )
}
func getUserInfo() -> [AnyHashable : Any]? {
    return UserDefaults.standard.object(forKey: KeyChain_UserInfo) as? [String:Any]
}

func removeUserInfo(){
     UserDefaults.standard.removeObject(forKey: KeyChain_UserInfo)
}

public func simpleAddNotification(minute: Double, identifier: String, title: String, subtitle: String,  body: String, userInfo:[String:String]) {
    // Initialize User Notification Center Object
    let center = UNUserNotificationCenter.current()
    // The content of the Notification
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.body = body
    content.sound = .default
    content.userInfo = userInfo
    
    // 2
    /*let imageName = "AppIcon"
    guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
    
    let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
    print(attachment)
    
    content.attachments = [attachment]*/
    
    // The selected time to notify the user
    /*var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = second*/
    // The time/repeat trigger
   // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (minute), repeats: false)
    // Initializing the Notification Request object to add to the Notification Center
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    // Adding the notification to the center
    center.add(request) { (error) in
        if (error) != nil {
            print(error!.localizedDescription)
        }
    }
}










////
extension UIView {
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: -5, height: 5)
        self.layer.shadowRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension UINavigationController{
    
    func setBackButton()  {
        let yourBackImage = UIImage(named: "back_btn")
        navigationBar.backIndicatorImage = yourBackImage
        navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
}


func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
    let decoder = JSONDecoder()
    print("Decoding ==> \(type)")
    guard let data = from else { return nil }
    do {
        
        let response = try decoder.decode(type.self, from: data)
        return response
    } catch let error {
        print("DEBUG :Error while decoding type ==> \(type)")
        print(error.localizedDescription)
        return nil
    }
    
}

func encodeJSON<T: Encodable>(type: T) -> Data? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let data = try? encoder.encode(type) else { return nil }
    return data
}

func getPlistValue( from file:String, for key:String) -> String?{
    
    guard let file = Bundle.main.path(forResource: file, ofType: "plist"),
        let dictionary = NSDictionary(contentsOfFile: file),
        let value = dictionary[key] as? String
        else {
            return nil
    }
    return value
}




////////

func getAmountWithCurrencyCode(amount:String) -> String {
    guard let damount = Double(amount) else {return ""}
    return "\(String(format: " %.2f AED", damount) )"
}


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}


extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}


func isDeviceJailBroken() ->Bool{
    if TARGET_IPHONE_SIMULATOR != 1
    {
        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") || FileManager.default.fileExists(atPath: "/bin/bash") || FileManager.default.fileExists(atPath: "/usr/sbin/sshd") || FileManager.default.fileExists(atPath: "/etc/apt") ||
            FileManager.default.fileExists(atPath: "/private/var/lib/apt/") || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!)  {
                return true
        }
        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do
        {
            try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: .utf8)
            //Device is jailbroken
            return true
        }catch
        {
            return false
        }
    }else
    {
        return false
    }
}

extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(target, action: action, for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

public extension Optional {

    var isNil: Bool {

        guard case Optional.none = self else {
            return false
        }

        return true

    }

    var isSome: Bool {

        return !self.isNil

    }

}

extension NSObject {
    //https://stackoverflow.com/questions/24130026/swift-how-to-sort-array-of-custom-objects-by-property-value
//    func sortForVenuDistance(item1:VenueModelElement, item2:VenueModelElement) -> Bool {
//
//       let appDelegate = UIApplication.shared.delegate as! AppDelegate
//       guard let latAsString1 = item1.lattitude, let lat1 = Double(latAsString1) else { return false}
//       guard let lngAsString1 = item1.longititude, let lng1 = Double(lngAsString1) else { return false}
//       let location1 = CLLocation(latitude: lat1, longitude: lng1)
//       let distance1 =  getDistanceInMile(appDelegate.currentLocation, location2: location1)
//
//       guard let latAsString2 = item2.lattitude, let lat2 = Double(latAsString2) else { return false}
//       guard let lngAsString2 = item2.longititude, let lng2 = Double(lngAsString2) else { return false}
//       let location2 = CLLocation(latitude: lat2, longitude: lng2)
//       let distance2 =  getDistanceInMile(appDelegate.currentLocation, location2: location2)
//
//     return distance1 < distance2
//   }
}


extension UIApplication {

  
    @discardableResult
    static func openAppSettings() -> Bool {
        guard
            let settingsURL = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsURL)
            else {
                return false
        }

        UIApplication.shared.open(settingsURL)
        return true
    }
}
func addingCustomButton(buttonTitle : String, buttonFontSize: CGFloat) -> UIButton
{
    let ownButton = UIButton()

    ownButton.setTitle(buttonTitle, for: UIControl.State.normal)


    ownButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: buttonFontSize)

    ownButton.setTitleColor(.black, for: .normal)
    let buttonTitleSize = (buttonTitle as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: buttonFontSize + 10)])
    
    ownButton.widthAnchor.constraint(equalToConstant: buttonTitleSize.width).isActive = true
    ownButton.frame.size.height = buttonTitleSize.height * 2
    ownButton.frame.origin.x = 30


    ownButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    ownButton.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9647058824, alpha: 1)
    ownButton.layer.cornerRadius = 15
    
    ownButton.layer.borderWidth = 2
    ownButton.layer.borderColor = #colorLiteral(red: 0.6117647059, green: 0.768627451, blue: 0.7843137255, alpha: 1)



//        ownButton.setTitleColor(UIColor.darkGray, for: UIControl.State.highlighted)
    return ownButton
}

extension UIView {
    func rotate() {
            let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = NSNumber(value: 180)
        rotation.duration = 0.25
            rotation.isCumulative = true
            rotation.repeatCount = 0
            self.layer.add(rotation, forKey: "rotationAnimation")
        }
    
    
}
extension UIImage{
    func resize(targetSize: CGSize) -> UIImage {
           return UIGraphicsImageRenderer(size:targetSize).image { _ in
               self.draw(in: CGRect(origin: .zero, size: targetSize))
           }
       }
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func resizeImage( newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext( CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
        var roundedImage: UIImage {
            let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
            UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
            UIBezierPath(
                roundedRect: rect,
                cornerRadius: self.size.height
                ).addClip()
            self.draw(in: rect)
            return UIGraphicsGetImageFromCurrentImageContext()!
        }
    
}

extension NSAttributedString {
    static func makeHyperLink(for path :String , in string : String, as substring : String) -> NSAttributedString {
        let nsString  = NSString(string: string)
        let substring = nsString.range(of: substring)
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(.link, value: path, range: substring)
        return attributeString
    }
}
public extension UIImage {

    /**
    Returns the flat colorized version of the image, or self when something was wrong

    - Parameters:
        - color: The colors to user. By defaut, uses the ``UIColor.white`

    - Returns: the flat colorized version of the image, or the self if something was wrong
    */
    func colorized(with color: UIColor = .white) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }


        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: rect, mask: cgImage)
        context.fill(rect)

        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }

        return colored
    }

    /**
    Returns the stroked version of the fransparent image with the given stroke color and the thickness.

    - Parameters:
        - color: The colors to user. By defaut, uses the ``UIColor.white`
        - thickness: the thickness of the border. Default to `2`
        - quality: The number of degrees (out of 360): the smaller the best, but the slower. Defaults to `10`.

    - Returns: the stroked version of the image, or self if something was wrong
    */

    func stroked(with color: UIColor = .white, thickness: CGFloat = 2, quality: CGFloat = 10) -> UIImage {

        guard let cgImage = cgImage else { return self }

        // Colorize the stroke image to reflect border color
        let strokeImage = colorized(with: color)

        guard let strokeCGImage = strokeImage.cgImage else { return self }

        /// Rendering quality of the stroke
        let step = quality == 0 ? 10 : abs(quality)

        let oldRect = CGRect(x: thickness, y: thickness, width: size.width, height: size.height).integral
        let newSize = CGSize(width: size.width + 2 * thickness, height: size.height + 2 * thickness)
        let translationVector = CGPoint(x: thickness, y: 0)


        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)

        guard let context = UIGraphicsGetCurrentContext() else { return self }

        defer {
            UIGraphicsEndImageContext()
        }
        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.interpolationQuality = .high

        for angle: CGFloat in stride(from: 0, to: 360, by: step) {
            let vector = translationVector.rotated(around: .zero, byDegrees: angle)
            let transform = CGAffineTransform(translationX: vector.x, y: vector.y)

            context.concatenate(transform)

            context.draw(strokeCGImage, in: oldRect)

            let resetTransform = CGAffineTransform(translationX: -vector.x, y: -vector.y)
            context.concatenate(resetTransform)
        }

        context.draw(cgImage, in: oldRect)

        guard let stroked = UIGraphicsGetImageFromCurrentImageContext() else { return self }

        return stroked
    }
}


extension CGPoint {
    /**
    Rotates the point from the center `origin` by `byDegrees` degrees along the Z axis.

    - Parameters:
        - origin: The center of he rotation;
        - byDegrees: Amount of degrees to rotate around the Z axis.

    - Returns: The rotated point.
    */
    func rotated(around origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = x - origin.x
        let dy = y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + byDegrees * .pi / 180.0 // to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return "Now"
    }
    
    func dateToTime() ->  String{
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "hh:mm a"
        formatter3.timeZone = .current
        return formatter3.string(from: self)
    }
    func dateToDateString() -> String{
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MM/dd/yyyy"
        formatter3.timeZone = .current
        return formatter3.string(from: self)
    }
}

extension Data {

    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }

    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
}

class FileDownloader {
    
    static func checkDownloaded(url: URL, completion: @escaping(Bool, String) -> Void){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
    
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(true, destinationUrl.path)
        } else {
            completion(false, destinationUrl.path)
        }
    }
    static func downlaoadFile(url: URL, completion: @escaping (String?, Error?) -> Void)
        {
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let destinationUrl = documentsUrl.appendingPathComponent("\(url.lastPathComponent).pdf")
        
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let task = session.dataTask(with: request, completionHandler:
                {
                    data, response, error in
                    if error == nil
                    {
                        if let response = response as? HTTPURLResponse
                        {
                            if response.statusCode == 200
                            {
                                if let data = data
                                {
                                    if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                    {
                                        completion(destinationUrl.path, error)
                                    }
                                    else
                                    {
                                        completion(destinationUrl.path, error)
                                    }
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                        }
                    }
                    else
                    {
                        completion(destinationUrl.path, error)
                    }
                })
                task.resume()
            
    }
    }


let countryCodeDict = ["AF":"93", "AL":"355", "DZ":"213","AS":"1", "AD":"376", "AO":"244","AI":"1","AG":"1","AR":"54","AM":"374","AW":"297","AU":"61","AT":"43","AZ":"994","BS":"1","BH":"973","BD":"880","BB":"1","BY":"375","BE":"32","BZ":"501","BJ":"229","BM":"1","BT":"975","BA":"387","BW":"267","BR":"55","IO":"246","BG":"359","BF":"226","BI":"257","KH":"855","CM":"237","CA":"1","CV":"238","KY":"345","CF":"236","TD":"235","CL":"56","CN":"86","CX":"61","CO":"57","KM":"269","CG":"242","CK":"682","CR":"506","HR":"385","CU":"53","CY":"537","CZ":"420","DK":"45","DJ":"253","DM":"1","DO":"1","EC":"593","EG":"20","SV":"503","GQ":"240","ER":"291","EE":"372","ET":"251","FO":"298","FJ":"679","FI":"358","FR":"33","GF":"594","PF":"689","GA":"241","GM":"220","GE":"995","DE":"49","GH":"233","GI":"350","GR":"30","GL":"299","GD":"1","GP":"590","GU":"1","GT":"502","GN":"224","GW":"245","GY":"595","HT":"509","HN":"504","HU":"36","IS":"354","IN":"91","ID":"62","IQ":"964","IE":"353","IL":"972","IT":"39","JM":"1","JP":"81","JO":"962","KZ":"77","KE":"254","KI":"686","KW":"965","KG":"996","LV":"371","LB":"961","LS":"266","LR":"231","LI":"423","LT":"370","LU":"352","MG":"261","MW":"265","MY":"60","MV":"960","ML":"223","MT":"356","MH":"692","MQ":"596","MR":"222","MU":"230","YT":"262","MX":"52","MC":"377","MN":"976","ME":"382","MS":"1","MA":"212","MM":"95","NA":"264","NR":"674","NP":"977","NL":"31","AN":"599","NC":"687","NZ":"64","NI":"505","NE":"227","NG":"234","NU":"683","NF":"672","MP":"1","NO":"47","OM":"968","PK":"92","PW":"680","PA":"507","PG":"675","PY":"595","PE":"51","PH":"63","PL":"48","PT":"351","PR":"1","QA":"974","RO":"40","RW":"250","WS":"685","SM":"378","SA":"966","SN":"221","RS":"381","SC":"248","SL":"232","SG":"65","SK":"421","SI":"386","SB":"677","ZA":"27","GS":"500","ES":"34","LK":"94","SD":"249","SR":"597","SZ":"268","SE":"46","CH":"41","TJ":"992","TH":"66","TG":"228","TK":"690","TO":"676","TT":"1","TN":"216","TR":"90","TM":"993","TC":"1","TV":"688","UG":"256","UA":"380","AE":"971","GB":"44","US":"1", "UY":"598","UZ":"998", "VU":"678", "WF":"681","YE":"967","ZM":"260","ZW":"263","BO":"591","BN":"673","CC":"61","CD":"243","CI":"225","FK":"500","GG":"44","VA":"379","HK":"852","IR":"98","IM":"44","JE":"44","KP":"850","KR":"82","LA":"856","LY":"218","MO":"853","MK":"389","FM":"691","MD":"373","MZ":"258","PS":"970","PN":"872","RE":"262","RU":"7","BL":"590","SH":"290","KN":"1","LC":"1","MF":"590","PM":"508","VC":"1","ST":"239","SO":"252","SJ":"47","SY":"963","TW":"886","TZ":"255","TL":"670","VE":"58","VN":"84","VG":"284","VI":"340"]

extension UITabBarController {
    
    func addSubviewToFirstTabItem(_ imageName: UIImage) {
        if let firstTabBarButton = self.tabBar.subviews.first, let tabItemImageView = firstTabBarButton.subviews.first {
            if let accountTabBarItem = self.tabBar.items?.first {
                accountTabBarItem.selectedImage = nil
                accountTabBarItem.image = nil
            }
            let imgView = UIImageView()
            imgView.frame = tabItemImageView.frame
            imgView.layer.cornerRadius = 19
            imgView.setDimensions(width: 38, height: 38)
            
            imgView.layer.masksToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.image = imageName
            
            
            self.tabBar.subviews.first?.addSubview(imgView)
          
            imgView.anchor(top: self.tabBar.topAnchor, left : view.leftAnchor,paddingTop: 7  ,paddingLeft: 40)
            
        }
    }
}

import Foundation


// Key Chain Keys
let KeyChain_CheckedInVenueID = "KeyChain_CheckedInVenueID"
let KeyChain_CheckedInTime = "KeyChain_CheckedInTime"
let KeyChain_UserID = "KeyChain_UserID_TheSuites"
let KeyChain_AuthToken = "KeyChain_AuthToken"
let User_QRCode = "titan_qrcode.jpg"
let User_ProfileImage = "titan_UserProfileImage.jpg"

let KeyChain_ShopAddCartDetail = "titan_KeyChain_ShopAddCartDetail"

let KeyChain_SetLanguage = "titan_KeyChain_SetLanguage"
let KeyChain_SetMobileNo = "titan_KeyChain_SetMobileNo"
let KeyChain_SetNotificationCount = "titan_KeyChain_SetNotificationCount"
let KeyChain_BalanceData = "User_Balance"
let KeyChain_ReferralCode = "Referral_Code"
let KeyChain_ReferralCount = "Referral_Count"

///
let KeyChain_SetHMAC = "titan_KeyChain_SetHMAC"
let KeyChain_SetAESKey = "titan_KeyChain_SetAESKey"
let KeyChain_SetAESNonce = "titan_KeyChain_SetAESNonce"

//UserDefaulr
let KeyChain_Profession = "KeyChain_UserProffession"
let KeyChain_UserName = "KeyChain_UserName"
let KeyChain_UserPassword = "KeyChain_UserPassword"
let KeyChain_FCMDeviceToken = "KeyChain_FCMDeviceToken"
let KeyChain_AutoSignIn = "KeyChain_AutoSignIn"
let KeyChain_UserLastName = "KeyChain_UserLastName"
let KeyChain_ProfileUserName = "KeyChain_ProfileUserName"
let KeyChain_ProfileUserEmail = "KeyChain_ProfileUserEmail"
let KeyChain_ProfileImageKey = "KeyChain_ProfileImageKey_The_Suites"
let KeyChain_IsCheckedIn = "KeyChain_IsCheckedIn"

let KeyChain_CurrentLocation = "KeyChain_CurrentLocation"
let KeyChain_FilterArray = "KeyChain_FilterArray"
let KeyChain_FilterAppliedBy = "KeyChain_FilterAppliedBy"
let KeyChain_SettingsAndPreferences = "KeyChain_SettingsAndPreferences"
let KeyChain_UserInfo = "KeyChain_UserInfo"
let KeyChain_FeedbackVenueName = "KeyChain_FeedbackVenueName"

//Alert message
let noEventDataAvaialbe = "No Event data available"
let noFavoritesDataAvaialbe = "No Favorites data available"
let noNotificationDataAvaialbe = "No Notification data"
let noDailyDealDataAvaialbe = "No Daily Deals data"
let noHotSpotDataAvaialbe = "No Hot Spots data"


//Filters
let KeyChain_City = "KeyChain_Cityyyyyyyy"
let KeyChain_Interest = "KeyChain_Interesddsssst"
let KeyChain_Industry = "KeyChain_Indusssstry"
let KeyChain_Affiliation = "KeyChain_Affilisssation"
let KeyChain_Prof = "KeyChain_Proesssssionf"
let KeyChain_FilterArrayByUser = "KeyChain_FilterArrayByUser"

let KeyChain_setUserProfileData = "KeyChain_setUserProfileData"


let KeyChain_setIsServiceProvider = "KeyChain_setIsServiceProvider"
let KeyChain_isWomenOwned = "isWomenOwned"

let KeyChain_isMinorityOwned = "isMinorityOwned"


protocol CommonViewControllerMethods {
    static func getStoryboardInstanceForNC() -> UINavigationController?
    static func getStoryboardInstanceForVC() -> UIViewController?
    static func getStoryboardInstanceForTabVC() -> UITabBarController?
}
extension UIViewController:CommonViewControllerMethods{
    static func getStoryboardInstanceForTabVC() -> UITabBarController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let tabBarViewController = storyboard.instantiateInitialViewController() as? UITabBarController else { return nil }
        return tabBarViewController
    }
    
    static func getStoryboardInstanceForNC() -> UINavigationController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else { return nil }
        return navController
    }
    
    static func getStoryboardInstanceForVC() -> UIViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return nil }
        
        return viewController
    }
    
}


extension UIViewController {
    func hideKeyboardOnTap(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func addSwipeRight(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                navigationController?.popViewController(animated: true)
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}



protocol ReusableView {
    static var identifier:String{
        get
    }
    static var nib:UINib{
        get
    }
}
extension UITableViewCell:ReusableView{
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
/*extension UICollectionViewCell:ReusableView{
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}*/

extension UITableViewHeaderFooterView:ReusableView{
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView:ReusableView{
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
//
//  UIView+Extension.swift
 
//
//  Created by Amit Panton 14/03/19.
 

import UIKit
import SafariServices

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 0
    @IBInspectable var shadowRadius : CGFloat = 5
    @IBInspectable var shadowWidth : Int = 2
    @IBInspectable var shadowHeight : Int = 2
    @IBInspectable var shadowColor : UIColor = UIColor.gray
    @IBInspectable var shadowOpacity : Float = 0.8
    @IBInspectable var fillColor : UIColor = .white
    @IBInspectable var borderColor : UIColor?
    @IBInspectable var borderWidth : CGFloat = 0
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        if shadowLayer == nil {
            if(cornerRadius == 0) {
                cornerRadius = ( self.bounds.size.height / 2 )
                
            }
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            if let borderColor = borderColor{
                shadowLayer.borderColor = borderColor.cgColor
            }
            if  borderWidth > 0{
                shadowLayer.borderWidth = borderWidth
            }
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0, delay: 0, options: [.beginFromCurrentState],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    
    
    //self.myView.addShadow(shadowColor: .black, offSet: CGSize(width: 2.6, height: 2.6), opacity: 0.8, shadowRadius: 5.0, cornerRadius: 20.0, corners: [.topRight, .topLeft], fillColor: .red)

    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
    
    func addErrorImage(_ image:UIImage?  ,yAxis:CGFloat) {
        guard let img = image  else {
            return
        }
        
        let imageView = UIImageView()
        imageView.tag = 30003
        imageView.image = img
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -yAxis),
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width),
        imageView.heightAnchor.constraint(equalToConstant: 250)])
        
        /*
         newView.translatesAutoresizingMaskIntoConstraints = false
         let horizontalConstraint = newView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
         let verticalConstraint = newView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
         */
    }
    
    
    
    func addErrorLabel(_ title:String , textColor:UIColor, fontData:UIFont ,yAxis:CGFloat){
        removeErrorLabel()
        let label = UILabel()
        label.tag = 20002
        label.font = fontData
        label.textColor = textColor
        label.text = title
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -yAxis),
            label.widthAnchor.constraint(equalToConstant: self.frame.size.width),
            label.heightAnchor.constraint(equalToConstant: 135)])
       // return label
    }
    
    func removeErrorLabel(){
        if let foundView = self.viewWithTag(20002) {
            foundView.removeFromSuperview()
        }
        if let imageView = self.viewWithTag(30003) {
            imageView.removeFromSuperview()
        }
        
        //let label:UILabel = self.viewWithTag(20002) as! UILabel
        //label.removeFromSuperview()
    }
    
    
}

