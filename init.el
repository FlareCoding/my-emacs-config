;; Melpa and Packages
(require 'package)
(package-initialize)
(add-to-list 'package-archives
           '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(setq inhibit-startup-message t)   ; Don't show the splash screen
(setq visible-bell t)              ; Flash when the bell rings
(setq initial-scratch-message "")  ; Empty the *scratch* buffer

;; Ensure that each tab is 4 spaces wide
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(company dashboard helm kaolin-themes use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

;; Move backups to a dedicated directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Load the theme
(use-package kaolin-themes
   :config
   (load-theme 'kaolin-aurora t)
   (kaolin-treemacs-theme))

;; Dashboard splash screen
(use-package dashboard
    :ensure t
    :diminish dashboard-mode
    :config
    (setq dashboard-banner-logo-title "Welcome to Systems Hacking!")
    (setq dashboard-startup-banner "~/.config/emacs/imgs/splash.txt")
    (setq dashboard-items '((recents  . 10)
                            (bookmarks . 10)))
    (dashboard-setup-startup-hook))

;; Helm
(use-package helm
  :ensure t
  :config
  (setq helm-split-window-inside-p t)
  (setq helm-use-frame-when-more-than-two-windows nil)
  (helm-autoresize-mode 1))

(use-package helm-mode
    :config (helm-mode 1))

(use-package helm-command
    :bind (("M-x" . helm-M-x)))

(use-package helm-files
    :bind (("C-x C-f" . helm-find-files)))

(use-package helm-buffers
    :bind (("C-x C-b" . helm-buffers-list)
           ("M-s m" . helm-mini))
    :config (setq helm-buffer-max-length nil))

(use-package helm-occur
    :bind (("M-s o" . helm-occur)))

(use-package helm-imenu
    :bind (("M-s i" . helm-imenu))
    :config (setq imenu-max-item-length 120))

(use-package helm-bookmarks
    :bind (("M-s b" . helm-bookmarks)))

;; Company (autocomplete)
(add-hook 'after-init-hook 'global-company-mode)

;; -------- Custom functions + keybinds --------

;; Open split shell window
(defun open-split-shell ()
  "Split the current window and open a shell in the new window."
  (interactive)
  (split-window-below)       ;; Adjust to split-window-right if you prefer a vertical split
  (other-window 1)           ;; Move to the new window
  (shell))                   ;; Open a shell in the new window

(global-set-key (kbd "C-c m") 'open-split-shell)

;; Kill current buffer and close window
(defun kill-buffer-and-window ()
  "Kill the current buffer and close the current window."
  (interactive)
  (let ((kill-buffer-query-functions nil))
    (kill-buffer))
  (unless (one-window-p) ; Check if there's more than one window open
    (delete-window)))   ; Close the current window if more than one is open

(global-set-key (kbd "C-c n") 'kill-buffer-and-window)

;; Open split horizontal or vertical window with helm open-file menu
(defun open-new-window-and-find-file (direction)
  "Split the current window horizontally or vertically and open a new file dialog in the new window."
  (interactive)
  (cond
   ((eq direction ?r) (split-window-right))
   ((eq direction ?b) (split-window-below))
   (t (message "Invalid direction")))
  (other-window 1)
  (call-interactively 'helm-find-files))

(global-set-key (kbd "C-c k") (lambda () (interactive) (open-new-window-and-find-file ?r)))
(global-set-key (kbd "C-c <down>") (lambda () (interactive) (open-new-window-and-find-file ?b)))
(global-set-key (kbd "C-c <right>") (lambda () (interactive) (open-new-window-and-find-file ?r)))

;; Close current window
(global-set-key (kbd "C-c l") 'delete-window)

;; Run compile line
(setq compile-command "make -k ")
(global-set-key (kbd "C-c c") 'compile)

;; SSH remote connection
(defun connect-to-vm ()
  (interactive)
  (dired "/sshx:sym:/home/sym/Symbi-OS/"))

