(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)
(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(electric-pair-mode 1)

(set-face-attribute
 'default nil
:font "Ubuntu Mono derivative Powerline"
)

(setq-default custom-file null-device)

(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes
  '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode treemacs-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green"
  )

(defun display-line-numbers--turn-on ()
  "turn on line numbers but exempting certain major modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)

(save-place-mode t)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa"))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package diminish)

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode 1)
  )

(use-package dashboard
  :init
  (setq dashboard-startup-banner 'logo
	dashboard-set-heading-icons t
	dashboard-set-file-icons t)
  :config
  (dashboard-setup-startup-hook)
  )

(use-package doom-modeline
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-window-width-limit fill-column)
  )

(use-package solaire-mode
  :hook (
	 (after-init . solaire-global-mode)
	 )
  )

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-acario-dark t)
  (doom-themes-visual-bell-config)
  )

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode)
  )

(use-package ace-window
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  )

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t
	unto-tree-visualizer-diff t
	)
  )

(use-package helm
  :diminish helm-mode
  :bind (
	 ("C-c h" . helm-command-prefix)
	 ("M-x" . helm-M-x)
	 ("C-x b" . helm-mini)
	 ("C-x C-f" . helm-find-files)
	 ("C-x r b" . helm-filtered-bookmarks)
	 ("C-x c o" . helm-occur)
	 ("C-x c SPC" . helm-all-mark-rings)
	 ("M-y" . helm-show-kill-ring)
	 )
  :config
  (global-unset-key (kbd "C-x c"))
  (setq helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-matching t
	helm-apropos-fuzzy-match t
	helm-M-x-fuzzy-match t)
  (helm-mode 1)
  )

(use-package helm-projectile
  :diminish projectile-mode
  :config
  (projectile-global-mode)
  (helm-projectile-on)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-completion-system 'helm
	projectile-project-search-path '(
					 "~/projects/"
					 )
	projectile-switch-project-action 'helm-projectile)
  )

(use-package magit
  :diminish magit-mode
  :bind (
	 ("C-c g" . magit-file-dispatch)
	 )
  )

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode)
  )

(use-package helpful
  :bind (
	 ("C-h f" . helpful-callable)
	 ("C-h v" . helpful-variable)
	 ("C-h k" . helpful-key)
	 ("C-c C-d" . helpful-at-point)
	 )
  )

(use-package crux
  :bind(
	;; First kill to end of line, then kill line
	("C-k" . crux-smart-kill-line)

	;; Kill line backwards
	("C-<Backspace>" . crux-kill-line-backwards)

	;; Insert and properly indent line above current
	("C-S-RET" . crux-smart-open-line-above)

	;; Insert empty line and indent properly
	("S-RET" . crux-smart-open-line)

	;; Fix indentation in buffer and strip whitespace
	("C-c n" . crux-cleanup-buffer-or-region)

	;; Open recently visited file
	("C-c f" . crux-recentf-find-file)

	;; Delete current file and buffer
	("C-c D" . crux-delete-file-and-buffer)

	;; Rename current buffer and its visiting file if any
	("C-c r" . crux-rename-file-and-buffer)

	;; Kill all other open buffers
	("C-c k" . crux-kill-other-buffers)

	;; Select other window or most recent buffer
	;; ("M-o" . crux-other-window-or-switch-buffer)
	("C-c o" . crux-other-window-or-switch-buffer)
	)
  )

;; The following is required by the steroids version
(use-package visual-regexp)

(use-package visual-regexp-steroids
  :config
  (define-key global-map (kbd "C-c q") 'vr/query-replace)
  (define-key global-map (kbd "C-r") 'vr/isearch-backward)
  (define-key global-map (kbd "C-s") 'vr/isearch-forward)
  )

(use-package company
  :config
  (add-hook 'prog-mode-hook 'company-mode)
  )

(use-package yasnippet
  :diminish yas-minor-mode
  :init
  (yas-global-mode)
  )

(use-package yasnippet-snippets)

(use-package emmet-mode
  :diminish emmet-mode
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode)
  )

(use-package flycheck
  :config
  (global-flycheck-mode)
  )

(use-package lsp-mode
  :commands
  (lsp lsp-deferred)

  :hook
  (prog-mode . lsp)

  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols)
	)

  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-auto-configure t)
  (lsp-headerline-breadcrumb-mode)
  (global-set-key (kbd "C-c l") lsp-command-map)
  )

(use-package lsp-ui
  :hook
  (lsp-mode . lsp-ui-mode)

  :custom
  (lsp-ui-doc-position 'bottom)
  )

(use-package helm-lsp)

(use-package company-lsp
  :config
  (setq company-lsp-cache-candidates 'auto
	company-lsp-async t
	company-lsp-enable-recompletion t
	)
  )

(use-package typescript-mode)

(use-package rjsx-mode
  :mode (
	 "\\.js\\'"
	 "\\.jsx\\'"
	 )

  :config
  (setq js2-mode-show-parse-errors nil
	js2-mode-show-strict-warnings nil
	js2-basic-offset 2
	js-indent-level 2
	)
  )

(use-package add-node-modules-path
  :hook (
	 ((js2-mode rjsx-mode) . add-node-modules-path)
	 )
  )

(use-package indium)

(use-package prettier-js
  :hook (
	 ((js2-mode rjsx-mode) . prettier-js-mode)
	 )
  )

(use-package anaconda-mode
  :hook (
	 (python-mode-hook . anaconda-mode-hook)
	 (python-mode-hook . anaconda-eldoc-mode)
	 )
  )

(use-package company-anaconda
  :config
  (eval-after-load "company"
    '(add-to-list 'company-backends 'company-anaconda)
    )

  :hook (
	 (python-mode-hook . anaconda-mode)
	 )
  )

(use-package sly
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  )

(use-package org
  :custom
  (org-src-tab-acts-natively t)
  )

(use-package treemacs
  :defer t
  :bind
  (:map global-map
	("M-0" . treemacs-select-window)
	("C-x t 1" . treemacs-delete-other-windows)
	("C-x t t" . treemacs)
	("C-x t B" . treemacs-bookmark)
	("C-x t C-t" . treemacs-find-file)
	("C-x t M-t" . treemacs-find-tag))
  )

(use-package treemacs-projectile
  :after treemacs projectile
  )

(use-package treemacs-icons-dired
  :after treemacs dired
  :config
  (treemacs-icons-dired-mode)
  )

(use-package treemacs-magit
  :after treemacs magit
  )
