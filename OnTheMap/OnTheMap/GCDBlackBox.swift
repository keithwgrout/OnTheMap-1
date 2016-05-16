//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Aaron Phillips on 5/16/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}