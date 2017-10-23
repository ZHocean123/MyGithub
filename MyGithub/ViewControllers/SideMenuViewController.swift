//
//  SideMenuViewController.swift
//  MyGithub
//
//  Created by yang on 23/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return super.numberOfSections(in: tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {

        })
        let rootViewController = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                let controller = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "RepositoriesViewController") as! RepositoriesViewController
                controller.type = .owner
                rootViewController.setViewControllers([controller], animated: false)
            case 1:
                let controller = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "RepositoriesViewController") as! RepositoriesViewController
                controller.type = .member
                rootViewController.setViewControllers([controller], animated: false)
            case 3:
                rootViewController.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepositorySearchViewController")], animated: false)
            default:
                break
            }
        default:
            break
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
