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

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil)
            (setq-local electric-pair-pairs '(
                                              (?\( . ?\))
                                              (?\[ . ?\])
                                              ))
            (electric-pair-local-mode t)))

(defalias 'yes-or-no-p 'y-or-n-p)

(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(setq scroll-conservatively 100)

(setq ring-bell-function 'ignore)

(when window-system (global-hl-line-mode t))

(when window-system (global-prettify-symbols-mode t))

(require 'ido)
(setq ido-enable-flex-matching nil)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/evil/")
(require 'evil)
(evil-mode 1)

(define-key evil-motion-state-map (kbd "ö") 'evil-first-non-blank)
(define-key evil-motion-state-map (kbd "ä") 'evil-end-of-line)
(define-key evil-motion-state-map (kbd ",") 'evil-repeat-find-char)
(define-key evil-motion-state-map (kbd ";") 'evil-repeat-find-char-reverse)

(define-key evil-motion-state-map (kbd "SPC") nil)
(define-key evil-motion-state-map (kbd "RET") nil)

(define-key evil-normal-state-map (kbd "RET") 'ido-switch-buffer)
(define-key evil-normal-state-map (kbd "<C-return>") 'ibuffer)

(use-package avy
  :ensure t
  :init
  (define-key evil-normal-state-map (kbd "SPC") 'avy-goto-char))

(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package yasnippet
  :ensure t
  :pin melpa)

;; Eclim has dropped Windows support.
(when (eq system-type 'gnu/linux)
  (use-package eclim
    :ensure t
    :after yasnippet
    :config
    (setq eclim-eclipse-dirs '("~/eclipse"))
    (setq eclim-executable "~/eclipse/eclim")
    :init
    (setq eclimd-autostart t)
    (add-hook 'java-mode-hook (lambda () (eclim-mode t))))

  (use-package company-emacs-eclim
    :ensure t
    :after (company eclim)
    :init
    (company-emacs-eclim-setup)))

;; "vim-like" tabs
(use-package elscreen
  :ensure t
  :init
  (elscreen-start)
  (define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;create tab
  (define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill)   ;kill tab
  )

(require 'elscreen)
(defun my/jump-or-prev-tab (arg)
  "Jump to elscreen specified by ARG or previous if none."
  (interactive "P")
  (if (null arg)
      (elscreen-previous)
    (elscreen-goto arg)))

(defun my/jump-or-next-tab (arg)
  "Jump to elscreen specified by ARG or next if none."
  (interactive "P")
  (if (null arg)
      (elscreen-next)
    (elscreen-goto arg)))

(global-set-key (kbd "C-c p") 'my/jump-or-prev-tab) ;previous tab
(global-set-key (kbd "C-c n") 'my/jump-or-next-tab) ;next tab
(define-key evil-normal-state-map "gT" 'my/jump-or-prev-tab)        ;previous tab
(define-key evil-normal-state-map "gt" 'my/jump-or-next-tab)        ;next tab

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
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 10)))
  (setq dashboard-startup-banner "~/.emacs.d/dashboard_icon.png")
  (setq dashboard-banner-logo-title
        (let ((hour (string-to-number (format-time-string "%H"))))
          (concat (cond ((< hour 5) "Peaceful night")
                        ((< hour 12) "Good morning")
                        ((< hour 13) "Good noon")
                        ((< hour 18) "Good afternoon")
                        ((< hour 22) "Good evening")
                        (t "Peaceful night"))
                  ", "
                  (user-login-name))))
  :init
  (add-hook 'dashboard-mode-hook (lambda () (evil-emacs-state nil))))

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

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(use-package linum-relative
  :ensure t
  :init
  (setq linum-relative-current-symbol "")
  (add-hook 'prog-mode-hook (lambda () (linum-relative-mode))))

(add-hook 'java-mode-hook
          (lambda ()
            (setq-local company-idle-delay 2)
            (setq-local company-minimum-prefix-length 1)))

(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local tab-width 4)
            (setq-local indent-tabs-mode t)
            (setq-local c-basic-offset 4)))

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(setq inhibit-startup-message t)

(defun my/open-emacs-config ()
    "Open Emacs config."
    (interactive)
    (find-file "~/.emacs.d/init.el"))

(defun my/open-i3-config ()
    "Open i3 config."
    (interactive)
    (find-file "~/.config/i3/config"))

(defun my/open-polybar-config ()
    "Open Polybar config."
    (interactive)
    (find-file "~/.config/polybar/config"))

(defun my/open-vim-config ()
    "Open Vim config."
    (interactive)
    (find-file "~/.vimrc"))

(defun my/open-bash-config ()
    "Open Bash config."
    (interactive)
    (find-file "~/.bashrc"))

(defun my/kill-curr-buffer ()
    "Kill current buffer."
    (interactive)
    (kill-buffer (current-buffer)))

(global-set-key (kbd "C-c c e") 'my/open-emacs-config)
(global-set-key (kbd "C-c c i") 'my/open-i3-config)
(global-set-key (kbd "C-c c p") 'my/open-polybar-config)
(global-set-key (kbd "C-c c v") 'my/open-vim-config)
(global-set-key (kbd "C-c c b") 'my/open-bash-config)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x k") 'my/kill-curr-buffer)
(global-set-key (kbd "C-x b") 'ido-switch-buffer)
(global-set-key (kbd "C-c w") 'whitespace-mode)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(elscreen-display-screen-number t)
 '(elscreen-display-tab t)
 '(elscreen-tab-display-control nil)
 '(elscreen-tab-display-kill-screen nil)
 '(linum-relative-format "%3s ")
 '(package-selected-packages
   (quote
    (avy company-emacs-eclim eclim lsp-rust rust-mode company-lsp flycheck elscreen company-irony evil-matchit evil-args evil-commentary linum-relative evil-surround diminish company spaceline rainbow-delimiters rainbow-delimeters dashboard rainbow-mode spacemacs-theme which-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "SRC" :family "Hack"))))
 '(elscreen-tab-background-face ((t (:background "#2A2A31"))))
 '(elscreen-tab-control-face ((t (:background "#5A4F76" :foreground "black"))))
 '(elscreen-tab-current-screen-face ((t (:background "#CAAFFF" :foreground "black"))))
 '(elscreen-tab-other-screen-face ((t (:background "#7A6F9F" :foreground "black")))))
