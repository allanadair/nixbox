;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; debug on error
(setq debug-on-error t)

;; use-package for bootstrapping emacs environment
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'use-package)
(setq use-package-always-ensure t)

;; theme and appearance
(load-theme 'deeper-blue)
(setq column-number-mode t)
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq default-directory "~")

;; default major mode
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message nil)

;; spelling (hunspell must be on system path)
(setq ispell-program-name "hunspell")
(setenv "DICTIONARY" "en_US")
(setq flyspell-prog-mode 1)

;; show matching parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)
(require 'paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;; melpa
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; elpy for Python development
(use-package elpy
  :config
  (elpy-enable)
  )

;; magit for git
(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
  )

;; org-mode
(use-package org
  :config
  (add-to-list 'org-agenda-files (expand-file-name "/vagrant/org/"))
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (setq org-log-done t)
  )

;; helm
(use-package helm)
(use-package helm-pydoc)


;; yaml
(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  )

;; docker
(use-package docker)

;; dockerfile
(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
  )

;; markdown
(use-package markdown-mode)

;; restclient
(use-package restclient)

;; editorconfig
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; nix
(use-package nix-mode)

;; undo-tree
(use-package undo-tree
  :config
  (global-undo-tree-mode))

;; kubernetes
(use-package kubernetes)
