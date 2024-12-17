import UIKit
import SnapKit

extension UIView {
    func makeToast(_ message: String, duration: TimeInterval = 2.0) {
        // 移除现有的 toast
        self.viewWithTag(999)?.removeFromSuperview()
        
        // 创建容器视图
        let containerView = UIView()
        containerView.tag = 999
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.alpha = 0
        
        // 创建消息标签
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // 添加视图层级
        self.addSubview(containerView)
        containerView.addSubview(messageLabel)
        
        // 设置约束
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
            make.height.greaterThanOrEqualTo(20)
        }
        
        // 添加动画
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            containerView.alpha = 1
            // 添加轻微的上移效果
            containerView.transform = CGAffineTransform(translationX: 0, y: -10)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: duration, options: .curveEaseIn, animations: {
                containerView.alpha = 0
                // 恢复位置并稍微下移
                containerView.transform = CGAffineTransform(translationX: 0, y: 10)
            }) { _ in
                containerView.removeFromSuperview()
            }
        }
    }
} 
