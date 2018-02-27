//
//  CYCycleScrollView.swift
//  SwiftCYCycleScrollView
//
//  Created by cyan on 2018/2/27.
//  Copyright © 2018年 cyan. All rights reserved.
//

import UIKit
//属性代理
@objc protocol CycleScrollViewDelegate : NSObjectProtocol{
    // MARK: - 点击图片回调
    //optional 修饰可以不必实现
    @objc optional  func cycleScrollViewDidSelectionItemAtIndex(cycleScrollView:CYCycleScrollView , index:Int)
    // MARK: - 图片滚动回调
    @objc optional func
        cycleScrollViewDidScrollToIndex(index:Int)
   
}

class CYCycleScrollView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    weak var delegate: CycleScrollViewDelegate?
   
    //属性参数
    //图片名
    var imageNames = Array<Any>(){
        didSet{
            if imageNames.count != 0{
                let finalArr = NSMutableArray(array: imageNames)
                finalArr.add(imageNames[0])
                self.imagePathsGroup = NSArray(array: finalArr)
                self.totalItemsCount = self.imagePathsGroup.count
                //开启定时器
                setupTimer()
            }
            
        }
    }
    //是否无限循环，默认true
    var infinitedLoop:Bool = true
    //自动滚动时间间隔，默认2s
    var autoScrollTimeInterval:CGFloat = 2
    //是否自动滚动，默认true
    var isAutoScroll:Bool = true
    //是否显示分页控件
    var showPageControl:Bool = true
    //分页控件小圆标大小
    var pageControlDotSize: CGSize!
    //当前分页控件小圆标颜色
    var currentPageDotColor:UIColor!
    //其他分页控件小圆标的颜色
    var pageDotColor :UIColor!
    //当前分页控件小圆标图片
    var cunrrentPageDotImage:NSString!
    //其他分页控件小圆标图片
    var pageDotImage:NSString!
    
    var scroller: UIScrollView!
    var pageControl:UIPageControl!
    //显示图片的collectionview
    private var mainView:UICollectionView!
    var flowLayout:UICollectionViewFlowLayout!
    var totalItemsCount:Int!
    var imagePathsGroup:NSArray!
    var timer:Timer!
    //图片数
    private var imageCount:Int = 0
    
    
    //获取屏幕尺寸
    let main = UIScreen.main.bounds.size
 

    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景为灰色
        self.frame = frame
        openFunction()
        creatUI()
    }
    
    override func layoutSubviews() {
        self.flowLayout.itemSize = self.frame.size
        self.mainView.frame = self.bounds
        self.pageControl.frame = CGRect(x: 0, y: self.bounds.height - 20, width: self.bounds.width, height: 20)
        if self.imageNames.count == 1 {
            self.pageControl.numberOfPages = 0
        }else{
            self.pageControl.numberOfPages = self.imageNames.count
        }
      
    }
//
    //功能设置
    func openFunction(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.infinitedLoop = true
        self.isAutoScroll = true
        self.backgroundColor = UIColor.cyan
    }
    //UI界面
    func creatUI(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.flowLayout = flowLayout;
        
        let mainView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.delegate  = self
        mainView.dataSource = self
        mainView.register(CYCollectionViewCell.classForCoder(), forCellWithReuseIdentifier:"CYCollectionViewCell")
        self.addSubview(mainView)
        self.mainView = mainView
        initializePageControl()
        
    }

    //组件二 ：UIPageControl 的初始化
    func initializePageControl(){
        self.pageControl = UIPageControl()
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.pageControl.numberOfPages = self.imageCount
        self.addSubview(pageControl)
    }
    
// MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagePathsGroup.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CYCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CYCollectionViewCell", for: indexPath) as! CYCollectionViewCell
        
        let imagePath = self.imagePathsGroup[indexPath.row]
        if ((imagePath as? NSString) != nil) {
            let imagePathUrl:NSString = imagePath as! NSString
            if imagePathUrl.hasPrefix("http"){
                ///用sd加载图片
                cell.imageView.sd_setImage(with: URL.init(string: imagePathUrl as String), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
            }else{
                cell.imageView.image = UIImage(named:imagePathUrl as String)
            }
        }else if  ((imagePath as? UIImage) != nil){
            let image:UIImage = imagePath as! UIImage
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    // MARK: - scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemIndex:Int = Int((scrollView.contentOffset.x + self.mainView.bounds.width * 0.5)/self.mainView.bounds.width)
        self.pageControl.currentPage = itemIndex
        if itemIndex == self.totalItemsCount - 1{
            self.pageControl.currentPage = 0
        }
        if scrollView.contentOffset.x < 0 {
           self.mainView.contentOffset = CGPoint(x: CGFloat(self.imagePathsGroup.count - 1) *  self.bounds.width , y: 0)
            
        }
        if scrollView.contentOffset.x > (CGFloat(imagePathsGroup.count - 1) * self.bounds.width) {
            mainView.scrollToItem(at: NSIndexPath.init(row: 0, section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
            
        }
        
        
    }
    //手指将要滑动的时候 停止定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if self.isAutoScroll {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    //手指滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll {
            setupTimer()
        }
    }
    
    //开启定时器
    func setupTimer(){
        self.timer =  Timer.scheduledTimer(timeInterval:2, target: self, selector: #selector(self.automaticScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        
        
    }
    
    
    //滚动效果设计
    @objc func automaticScroll(){
        if self.totalItemsCount == 0 {
            return
        }
        
        let currentIndex:Int = Int(self.mainView.contentOffset.x / self.flowLayout.itemSize.width)
        let targetIndex:Int = currentIndex + 1;
        
        if targetIndex == self.totalItemsCount {
            
            self.mainView.scrollToItem(at:NSIndexPath.init(row: 0, section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
            self.mainView.scrollToItem(at: NSIndexPath.init(row: 1, section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            return
        }
        self.mainView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
     
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


