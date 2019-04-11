;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; (package-initialize)

;; init the straight package manager
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

;; watch for repo modifications if we have python3 and watchexec
;; otherwise just use a save hook
(setq straight-check-for-modifications
      (if (and (executable-find "python3")
               (executable-find "watchexec"))
          '(watch-files find-when-checking)
        '(check-on-save find-when-checking)))

(straight-use-package 'use-package)

;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

(defvar nd/conf-dir "~/.emacs.d/"
  "The absolute path to the EMACS configuration directory.")

(defvar nd/conf-main (expand-file-name "conf.org" nd/conf-dir)
  "The absolute path the main EMACS configuration file.")

(org-babel-load-file nd/conf-main)
