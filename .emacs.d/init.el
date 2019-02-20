(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; (defun my/choice (menu)
;;   "Allows the user to choose one item from a list"
;;   (avy-menu "*test-menu*" (list "Title" (cons "Pane" (mapcar (lambda (item)
;;                                        (cons (if (consp item)
;;                                                  (car item)
;;                                                item)
;;                                              item))
;;                                      menu)))))

;; (my/choice '("a" "b" "c" "d" "e"))

(server-start)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'spacemacs-theme)
  (package-refresh-contents)
  (package-install 'spacemacs-theme))

;; Coding
(prefer-coding-system 'utf-8-unix)

;; Preferences
(setq make-backup-file nil)
(setq auto-save-default nil)

(setq display-time-24hr-format t)
(setq calendar-week-start-day 1)

(setq delete-trailing-lines nil)

(defvar my/term-shell "/bin/bash")
(defvar my/pdf-reader "zathura")
(defvar my/html-previewer "surf")
(defvar my/notes-directory (expand-file-name "~/.notes"))
(defvar my/notes-dir-create-if-not-exist t)
(defvar html-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil)
            (setq-local electric-pair-pairs '(
                                              (?\( . ?\))
                                              (?\[ . ?\])
                                              ))
            (electric-pair-local-mode t)))

(add-hook 'conf-space-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil)
            (setq-local tab-width 4)))

(add-hook 'conf-unix-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil)
            (setq-local tab-width 8)))

(defun my/exit ()
  "Prompt before closing."
  (interactive)
  (if (y-or-n-p (format "Really quit Emacs? "))
      (save-buffers-kill-emacs)
    (message "Canceled exit")))

(when window-system
  (global-set-key (kbd "C-x C-c") 'my/exit))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq-default show-trailing-whitespace t)

(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(setq scroll-conservatively 100)

(setq ring-bell-function 'ignore)

(when window-system (global-hl-line-mode t))

(when window-system (global-prettify-symbols-mode t))

(defun my/buffer-extension-in (exts)
  "Return non-nil if current buffer's file extension is in EXTS."
  (if (null (buffer-file-name)) nil
    (member (file-name-extension (buffer-file-name)) exts)))

(add-hook 'markdown-mode-hook
          (lambda () (progn
                  (when (my/buffer-extension-in '("Rmd" "md"))
                    (setq-local indent-tabs-mode nil)
                    (add-hook 'after-save-hook 'my/doc-compile nil t))
                  (visual-line-mode))))

;(add-hook 'multi-web-mode-hook
;          (lambda () (progn
;                  (when (my/buffer-extension-in html-extensions)
;                    (add-hook 'after-save-hook 'my/html-preview-update nil t)))))

(require 'ido)
(setq ido-enable-flex-matching nil)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode)

(require 'ispell)
(setq ispell-program-name "/usr/bin/tmispell")
(add-to-list 'ispell-dictionary-alist
             '("finnish"
               "[A-Za-z\345\344\366\305\304\326]"
               "[^A-Za-z\345\344\366\305\304\326]"
               "[:]" nil ("-d finnish" "-C")
               "~list" utf-8))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/evil/")
(require 'evil)
(setq evil-prompt-quit '(y-or-n-p (format "Really quit Emacs? ")))
(evil-mode 1)

(define-key evil-motion-state-map (kbd "ö") 'evil-first-non-blank)
(define-key evil-motion-state-map (kbd "ä") 'evil-end-of-line)
(define-key evil-motion-state-map (kbd ",") 'evil-repeat-find-char)
(define-key evil-motion-state-map (kbd ";") 'evil-repeat-find-char-reverse)

(define-key evil-motion-state-map (kbd "SPC") nil)
(define-key evil-motion-state-map (kbd "RET") nil)

(define-key evil-normal-state-map (kbd "RET") 'ido-switch-buffer)
(define-key evil-normal-state-map (kbd "<C-return>") 'ibuffer)

;(evil-ex-define-cmd "q[uit]" (lambda () (kill-buffer (current-buffer))))

(use-package php-mode
  :ensure t)

(use-package web-mode
  :ensure t)

;(use-package multi-web-mode
;  :ensure t
;  :init
;  (setq mweb-default-major-mode 'html-mode)
;  (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;                    (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;                    ;; (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")
;                    ))
;  (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;  (multi-web-global-mode 1))

(use-package avy
  :ensure t
  :init
  (define-key evil-normal-state-map (kbd "SPC") 'avy-goto-char))

(use-package avy-menu
  :ensure t)

(defun my/choice (menu &optional title)
  "Allow the user to choose one item from MENU.  TITLE overrides the generic 'Title'."
  (avy-menu "*choice-menu*"
            (list (if title title "Title")
                  (cons "Pane"
                        (mapcar (lambda (item)
                                  (if (consp item) item (cons item item))
                                  ;; (cons (if (consp item)
                                  ;;           (car item)
                                  ;;         item)
                                  ;;       item)
                                  )
                                menu)))))

(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package projectile
  :ensure t
  :init
  (projectile-mode t))

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
    (setq eclimd-default-workspace "~/eclipse-workspace")
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
  (add-hook 'after-init-hook (lambda () (let (i) (dotimes (i 3 nil) (elscreen-create))) (elscreen-goto 0))))

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

(defun my/dired-in-new-tab ()
  "Open dired in new tab."
  (interactive)
  (elscreen-create)
  (dired "~/"))

(global-set-key (kbd "C-c k") 'my/jump-or-prev-tab)          ;previous tab
(global-set-key (kbd "C-c j") 'my/jump-or-next-tab)          ;next tab
(global-set-key (kbd "C-c f") 'my/dired-in-new-tab)          ;find file in tab
(global-set-key (kbd "C-c t") 'elscreen-create)              ;create tab
(global-set-key (kbd "C-c x") 'elscreen-kill)                ;kill tab
(define-key evil-normal-state-map "gT" 'my/jump-or-prev-tab) ;previous tab
(define-key evil-normal-state-map "gt" 'my/jump-or-next-tab) ;next tab

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

(use-package csharp-mode
  :ensure t
  :mode "\\.cs$")

(use-package markdown-mode
  :ensure t
  :mode "\\.Rmd$")

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
  :config
  (setq racer-rust-src-path "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")
  :init
  (require 'rust-mode)
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook (lambda ()
                               (setq company-idle-delay nil)
                               (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
                               (setq company-tooltip-align-annotations t))))

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
  (add-hook 'prog-mode-hook
            (lambda ()
              (linum-relative-mode))))

(use-package wcheck-mode
  :ensure t
  :pin melpa
  :init
  (defvar my/finnish-syntax-table
    (copy-syntax-table text-mode-syntax-table))
  (modify-syntax-entry ?- "w" my/finnish-syntax-table)
  (setq wcheck-language-data
        '(("Finnish"
           (program . "/usr/bin/enchant-2")
           (args "-l" "-d" "fi")
           (syntax . my/finnish-syntax-table)
           (action-program . "/usr/bin/enchant-2")
           (action-args "-a" "-d" "fi")
           (action-parser . wcheck-parser-ispell-suggestions)))))


(add-hook 'java-mode-hook
          (lambda ()
            (setq-local company-idle-delay 2)
            (setq-local company-minimum-prefix-length 1)))

(add-to-list 'write-file-functions
             (lambda ()
               (when (derived-mode-p 'prog-mode)
                 (delete-trailing-whitespace))))

(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local tab-width 4)
            (setq-local indent-tabs-mode nil)
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

(defun my/open-rss-urls ()
    "Open newsboat RSS urls file."
    (interactive)
    (find-file "~/.config/newsboat/urls"))

(defun my/open-i3blocks-config ()
    "Open i3blocks config."
    (interactive)
    (find-file "~/.config/i3blocks/config"))

(defun my/kill-curr-buffer ()
    "Kill current buffer."
    (interactive)
    (kill-buffer (current-buffer)))

(defun my/note-name (&optional name)
  "Create name for note, with optional NAME."
  (concat
   (format-time-string "%Y-%m-%d_%H.%M.%S")
   (when name (concat "-" name))))

(defun my/note-create ()
  "Create a new note."
  (interactive)
  (if (progn
          (if (not (file-exists-p my/notes-directory))
            (if my/notes-dir-create-if-not-exist
                (progn (mkdir my/notes-directory) t)
              nil)
            t))
      (progn
        (let ((note-name (my/note-name (read-string "Enter note name: "))))
          (message "Create note: %s" note-name)
          (find-file
           (concat my/notes-directory "/" note-name ".txt")))
        (message "Buffer file name: %s" buffer-file-name))
    (progn (message "Unable to create note"))))

(defun my/note-filename-to-name (filename)
  "Convert FILENAME into a readable name."
  (file-name-base
   (replace-regexp-in-string
    "^.*_[0-9\.-]*" "" filename)))

(defun my/note-list-item (filename)
  "Create a list item from FILENAME."
  (cons (my/note-filename-to-name filename) filename))

(defun my/note-open ()
  "Open a previously created note."
  (interactive)
  (let ((notes (mapcar 'my/note-list-item
                       (cddr (directory-files my/notes-directory)))))
    (find-file (concat
                my/notes-directory "/" (my/choice notes "Select note to open")))))

;; (defun my/index-of (list element &optional curr)
;;   "Find the index of ELEMENT in LIST.  CURR is used internally."
;;   (if (= (length list) 0) nil
;;     (if (equal (car list) element)
;;         (if curr curr 0)
;;       (my/index-of (cdr list) element (if curr (1+ curr) 1)))))

; TODO: Check if current file is a document file, check if the file has been saved, check the file type, check for a Makefile, run the appropriate compile command.
(defun my/doc-compile ()
  "Compile document being edited (if any)."
  (interactive)
  (when
      (and
       (my/buffer-extension-in '("Rmd"))
       (file-exists-p (concat default-directory "Makefile")))
    (start-process "make knit" nil "make" "knit"))
  (when
      (my/buffer-extension-in '("md"))
    (start-process "pandoc" nil "pandoc" "-s" (concat (file-name-base) ".md") "-o" (concat (file-name-base) ".pdf")))
  nil)

(defun my/doc-preview ()
  "Launch preview of the document being edited (if any)."
  (interactive)
  (when (and (my/buffer-extension-in '("Rmd"))
             (file-exists-p (concat default-directory "Makefile")))
    (start-process "make preview" nil "make" "preview"))
  (when (my/buffer-extension-in '("md"))
    (progn
      (my/doc-compile)
      (start-process my/pdf-reader nil my/pdf-reader (concat (file-name-base) ".pdf"))))
  (when (my/buffer-extension-in html-extensions)
    (my/html-preview))
  nil)

(defvar my/html-preview-proc nil)

(defun my/html-preview ()
  "Launch a preview of the webpage in suckless surf."
  (interactive)
  (when (my/buffer-extension-in html-extensions)
    (unless (and my/html-preview-proc (equal 'run (process-status my/html-preview-proc)))
        ;; (signal-process my/html-preview-proc 'SIGHUP)
      (setq my/html-preview-proc (start-process my/html-previewer nil my/html-previewer (buffer-file-name)))
      )))

(defun my/html-preview-update ()
  "Update the preview of the webpage in suckless surf."
  (interactive)
  (when (my/buffer-extension-in html-extensions)
    (when (and my/html-preview-proc (equal 'run (process-status my/html-preview-proc)))
        (signal-process my/html-preview-proc 'SIGHUP))))

(global-set-key (kbd "C-c c e") 'my/open-emacs-config)
(global-set-key (kbd "C-c c i") 'my/open-i3-config)
(global-set-key (kbd "C-c c p") 'my/open-polybar-config)
(global-set-key (kbd "C-c c v") 'my/open-vim-config)
(global-set-key (kbd "C-c c b") 'my/open-bash-config)
(global-set-key (kbd "C-c c l") 'my/open-i3blocks-config)
(global-set-key (kbd "C-c c r") 'my/open-rss-urls)

(global-set-key (kbd "C-c n n") 'my/note-create)
(global-set-key (kbd "C-c n o") 'my/note-open)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x k")   'my/kill-curr-buffer)
(global-set-key (kbd "C-x b")   'ido-switch-buffer)
(global-set-key (kbd "C-c w")   'whitespace-mode)
(global-set-key (kbd "C-c p")   'my/doc-compile)
(global-set-key (kbd "C-c o")   'my/doc-preview)

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
    (avy-menu php-mode wcheck-mode markdown-mode csharp-mode projectile avy company-emacs-eclim eclim lsp-rust rust-mode company-lsp flycheck elscreen company-irony evil-matchit evil-args evil-commentary linum-relative evil-surround diminish company spaceline rainbow-delimiters rainbow-delimeters dashboard rainbow-mode spacemacs-theme which-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "SRC" :family "Hack"))))
 '(elscreen-tab-background-face ((t (:background "#2A2A31"))))
 '(elscreen-tab-control-face ((t (:background "#5A4F76" :foreground "black"))))
 '(elscreen-tab-current-screen-face ((t (:background "#CAAFFF" :foreground "black"))))
 '(elscreen-tab-other-screen-face ((t (:background "#7A6F9F" :foreground "black")))))
(put 'narrow-to-region 'disabled nil)
