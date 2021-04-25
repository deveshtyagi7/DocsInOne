//
//  Api.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 30/08/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import Foundation
import ProgressHUD
struct Api {
    static var Upload = UploadApi()
    
}

struct Config {
    static var STORAGE_ROOT_REF = "gs://docsinone-154f5.appspot.com"
}
