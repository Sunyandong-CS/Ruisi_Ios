//
//  ForumsController.swift
//  Ruisi
//
//  Created by yang on 2017/4/17.
//  Copyright © 2017年 yang. All rights reserved.
//

import UIKit

// 首页 - 板块列表
class ForumsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var datas: [Forums] = []
    let logoDir = "assets/forumlogo/"
    let jsonPath = "assets/forums"
    var loginState: Bool = false
    private var colCount = 6 //collectionView列数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginState = App.isLogin
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.clearsSelectionOnViewWillAppear = true
        loadData(loginState: loginState)
        colCount = Int(UIScreen.main.bounds.width / 75)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if App.isLogin != loginState { //第一次
            loginState = App.isLogin
            loadData(loginState: loginState)
        }
    }
    
    
    func loadData(loginState: Bool) {
        print("load forums login state:\(loginState)")
        let filePath = Bundle.main.path(forResource: "assets/forums", ofType: "json")!
        //let jsonData = jsonString.data(encoding: .utf8)!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath, isDirectory: false))
        let decoder = JSONDecoder()
        datas = try! decoder.decode([Forums].self, from: data).filter({ (f) -> Bool in
            f.forums = f.forums?.filter({ (ff) -> Bool in
                return loginState || !ff.login
            })
            return loginState || !f.login
        })
        
        collectionView?.reloadData()
    }
    
    // 点击头像
    @objc func tapHandler(sender: UITapGestureRecognizer) {
        if App.isLogin && App.uid != nil {
            self.performSegue(withIdentifier: "myProvileSegue", sender: nil)
        } else {
            //login
            let dest = self.storyboard?.instantiateViewController(withIdentifier: "loginViewNavigtion")
            self.present(dest!, animated: true, completion: nil)
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    //单元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.width - CGFloat((colCount - 1) * 8) - CGFloat(24)) / CGFloat(colCount)
        return CGSize(width: cellSize, height: cellSize + UIFont.systemFont(ofSize: 13).lineHeight - 3)
    }
    
    // collectionView的上下左右间距    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
    }
    
    
    // 单元的行间距    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    // 每个小单元的列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    // section 头或者尾部
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head", for: indexPath)
            let label = head.viewWithTag(1) as! UILabel
            label.text = datas[indexPath.section].name
            label.textColor = ThemeManager.currentPrimaryColor
            head.backgroundColor = UIColor(white: 0.96, alpha: 1)
            return head
        }
        
        return UICollectionReusableView(frame: CGRect.zero)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].getSize()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        let fileName = datas[indexPath.section].forums![indexPath.row].fid
        if let path = Bundle.main.path(forResource: "common_\(fileName)_icon", ofType: "gif", inDirectory: logoDir) {
            imageView.image = UIImage(contentsOfFile: path)
        }
        
        label.text = datas[indexPath.section].forums![indexPath.row].name
        return cell
    }
    
    var selectedIndexPath: IndexPath?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let type = Urls.getPostsType(fid: datas[indexPath.section].forums![indexPath.row].fid, isSchoolNet: App.isSchoolNet)
        switch type {
        case .imageGrid:
            self.performSegue(withIdentifier: "forumToImagePosts", sender: self)
        default:
            self.performSegue(withIdentifier: "forumToNormalPosts", sender: self)
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    func showLoginAlert() {
        let alert = UIAlertController(title: "需要登陆", message: "你需要登陆才能执行此操作", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "登陆", style: .default, handler: { (alert) in
            let dest = self.storyboard?.instantiateViewController(withIdentifier: "loginViewNavigtion")
            self.present(dest!, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "formToSearchSegue" {
            if !App.isLogin {
                showLoginAlert()
                return false
            }
        }
        return true
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = selectedIndexPath {
            let fid = datas[index.section].forums?[index.row].fid
            let title = datas[index.section].forums?[index.row].name
            
            if let dest = (segue.destination as? PostsViewController) {
                dest.title = title
                dest.fid = fid
            } else if let dest = (segue.destination as? ImageGridPostsViewController) {
                dest.title = title
                dest.fid = fid
            }
        }
    }
    
}
