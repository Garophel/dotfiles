(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'spacemacs-theme)
  (package-refresh-contents)
  (package-install 'spacemacs-theme))

(setq make-backup-file nil)
(setq auto-save-default nil)

(setq display-time-24hr-format t)
(setq calendar-week-start-day 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(setq scroll-conservatively 100)

(setq ring-bell-function 'ignore)

(when window-system (global-hl-line-mode t))

(when window-system (global-prettify-symbols-mode t))

(add-to-list 'load-path "~/.emacs.d/evil/")
(require 'evil)
(evil-mode 1)

(define-key evil-motion-state-map (kbd "ö") 'evil-first-non-blank)
(define-key evil-motion-state-map (kbd "ä") 'evil-end-of-line)

(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

(require 'flycheck)
(add-to-list 'load-path "~/.emacs.d/flycheck-java/")
;; (require 'flycheck-java)
(add-hook 'java-mode-hook
		  (lambda () (setq flycheck-java-ecj-jar-path "/usr/share/java/ecj.jar")))

; "vim-like" tabs
(use-package elscreen
  :ensure t
  :init
  (elscreen-start)
  (define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;create tab
  (define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill)   ;kill tab
  (define-key evil-normal-state-map "gT" 'elscreen-previous)        ;previous tab
  (define-key evil-normal-state-map "gt" 'elscreen-next)            ;next tab
  )

(use-package evil-surround
  :ensure t
  :init
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :ensure t
  :init
  (evil-commentary-mode))

(use-package evil-args
  :ensure t
  :config
  ;; bind evil-args text objects
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

  ;; bind evil-forward/backward-args
  ;;(define-key evil-normal-state-map "L" 'evil-forward-arg)
  ;;(define-key evil-normal-state-map "H" 'evil-backward-arg)
  ;;(define-key evil-motion-state-map "L" 'evil-forward-arg)
  ;;(define-key evil-motion-state-map "H" 'evil-backward-arg)

  ;; bind evil-jump-out-args
  ;;(define-key evil-normal-state-map "K" 'evil-jump-out-args)
  )

(use-package evil-matchit
  :ensure t
  :init
  (global-evil-matchit-mode 1))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package rainbow-mode
  :ensure t
  :init
  (rainbow-mode 1))

(use-package rainbow-delimiters
  :ensure t
  :init
  (rainbow-delimiters-mode 1)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'rust-mode-hook 'rainbow-delimiters-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 10)))
  (setq dashboard-banner-logo-title "Hello!"))

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

;; (use-package lsp-mode
;;   :ensure t
;;   :init
;;   (add-hook 'prog-mode-hook 'lsp-mode))

;; (use-package lsp-rust
;;   :ensure t
;;   :after lsp-mode
;;   :init
;;   (add-hook 'rust-mode-hook #'lsp-rust-enable))

;; (with-eval-after-load 'lsp-mode
;;   (setq lsp-rust-rls-command '("rustup" "run" "stable" "rls"))
;;   (require 'lsp-rust))

(use-package racer
  :ensure t
  :init
  (require 'rust-mode)
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

(use-package company-irony
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-irony))

;; (use-package company-lsp
;;   :ensure t
;;   :config
;;   (require 'company)
;;   (add-to-list 'company-backends 'company-lsp)
;;   )

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package spaceline
  :ensure t
  :config
  (require 'spaceline-config)
  (setq powerline-default-separator (quote arrow))
  (spaceline-spacemacs-theme))

(use-package diminish
  :ensure t
  :init
  (diminish 'which-key-mode)
  (diminish 'rainbow-mode)
  (diminish 'undo-tree-mode)
  (diminish 'linum-relative-mode)
  (diminish 'evil-commentary-mode)
  (diminish 'linum-relative-mode)
  )

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(use-package linum-relative
  :ensure t
  :init
  (setq linum-relative-current-symbol "")
  (linum-relative-global-mode))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(add-hook 'prog-mode-hook
	  (lambda ()
	    (setq-local tab-width 4)
	    (setq-local indent-tabs-mode t)
	    (setq-local c-basic-offset 4)))

(set-frame-parameter (selected-frame) 'alpha '(85 . 85))
(add-to-list 'default-frame-alist '(alpha . (85 . 85)))

(setq inhibit-startup-message t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages
   (quote
    (lsp-rust rust-mode company-lsp flycheck elscreen company-irony evil-matchit evil-args evil-commentary linum-relative evil-surround diminish company spaceline rainbow-delimiters rainbow-delimeters dashboard rainbow-mode spacemacs-theme which-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "SRC" :family "Hack")))))
