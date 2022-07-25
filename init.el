(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;; 防止反复调用 package-refresh-contents 会影响加载速度
(when (not package-archive-contents)
  (package-refresh-contents))

;; modeline上显示我的所有的按键和执行的命令
; (package-install 'keycast)
; (keycast-mode t)

;; set key
(setq w32-apps-modifier 'super)

;; global key set, not work yet
(global-set-key (kbd "s-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-v") 'yank) ;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-z") 'undo) ;对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "s-x") 'kill-region) ;对应Windows上面的Ctrol-x 剪切

;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode -1)

;; 关闭文件滑动控件
(scroll-bar-mode -1)

;; 显示行号
(global-linum-mode 1)

;; 更改光标的样式（不能生效，解决方案见第二集）
(setq-default cursor-type 'bar)
(show-paren-mode t)


(icomplete-mode 1)


;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)


; 开启全局 Company 补全
(global-company-mode 1)

;; company mode 默认选择上一条和下一条候选项命令 M-n M-p
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)


;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
;; (set-face-attribute 'default nil :height 160);;

;; 让鼠标滚动更好用
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; 增强 minibuffer 补全
(package-install 'vertico)
(vertico-mode t)

(package-install 'orderless)
(setq completion-styles '(orderless))

;; 配置 Marginalia 增强 minubuffer 的 annotation
(package-install 'marginalia)
(marginalia-mode t)

;; minibuffer action 和自适应的 context menu：Embark
(package-install 'embark)
(global-set-key (kbd "C-;") 'embark-act)
(setq prefix-help-command 'embark-prefix-help-command)

;; 增强文件内搜索和跳转函数定义：Consult
(package-install 'consult)
;; replace swiper
(global-set-key (kbd "C-s") 'consult-line)
;; consult-imen

;; 禁用自动生成备份文件
(setq make-backup-files nil)

;; 最近打开文件列表
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

;; 这个快捷键绑定可以用之后的插件 counsel 代替
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; 输入替换选中
(delete-selection-mode 1)

;; 使用 emacs 打开文件管理器
(shell-command-to-string "explorer.exe C:\\")

(shell-command-to-string "explorer.exe ~/.emacs.d")

(shell-command-to-string
 (encode-coding-string
  (replace-regexp-in-string "/" "\\\\"
		(format "explorer.exe %s" (expand-file-name "~/.emacs.d")))
  'gbk))

(defun consult-directory-externally (file)
  "Open FILE externally using the default application of the system."
  (interactive "fOpen externally: ")
  (if (and (eq system-type 'windows-nt)
	   (fboundp 'w32-shell-execute))
      (shell-command-to-string (encode-coding-string (replace-regexp-in-string "/" "\\\\"
	    (format "explorer.exe %s" (file-name-directory (expand-file-name file)))) 'gbk))
    (call-process (pcase system-type
		    ('darwin "open")
		    ('cygwin "cygstart")
		    (_ "xdg-open"))
		  nil 0 nil
		  (file-name-directory (expand-file-name file)))))

 (define-key embark-file-map (kbd "E") #'consult-directory-externally)
;; 打开当前文件的目录
(defun my-open-current-directory ()
  (interactive)
  (consult-directory-externally default-directory))

;; ----------------------------------------------------------------------
;; this is for auto generate, do not edit manually
;; ----------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(consult vertico orderless marginalia embark company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
