
(setq inhibit-startup-screen t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(set-default 'truncate-lines t)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq pop-up-windows nil) ; no popups (eg ediff)

;; (global-linum-mode t)
(line-number-mode 1)
(column-number-mode 1)

(setq-default tab-width 4)

(setq scroll-conservatively 100)

(when window-system (global-prettify-symbols-mode t))

(when window-system (global-hl-line-mode t))

(defalias 'yes-or-no-p 'y-or-n-p) ; eliminate yes or no prompt on killing procs

(defvar my:theme 'spacemacs-dark)
(defvar my:theme-window-loaded nil)
(defvar my:theme-terminal-loaded nil)
(if (daemonp)
    (add-hook 'after-make-frame-functions(lambda (frame)
                                           (select-frame frame)
                                           (if (window-system frame)
                                               (unless my:theme-window-loaded
                                                 (if my:theme-terminal-loaded
                                                     (enable-theme my:theme)
                                                   (load-theme my:theme t))
                                                 (setq my:theme-window-loaded t))
                                             (unless my:theme-terminal-loaded
                                               (if my:theme-window-loaded
                                                   (enable-theme my:theme)
                                                 (load-theme my:theme t))
                                               (setq my:theme-terminal-loaded t)))))
  (progn
    (load-theme my:theme t)
    (if (display-graphic-p)
        (setq my:theme-window-loaded t)
      (setq my:theme-terminal-loaded t))))

(use-package spaceline
  :ensure t
  :config
    (require 'spaceline-config)
    (setq powerline-default-separator (quote arrow))
    (spaceline-spacemacs-theme)
    (setq spaceline-buffer-size-p nil))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
   (setq dashboard-banner-logo-title "Emacs"))
   ;; (setq dashboard-items '((recents . 10))))

(global-set-key (kbd "C-h a") 'apropos)

(global-set-key (kbd "<f1>") 'org-agenda)
(global-set-key (kbd "<f2>") 'org-capture)
(global-set-key (kbd "<f3>") 'org-iswitchb)

(use-package delight
  :ensure t)

(use-package beacon
  :ensure t
  :delight
  :init
  (beacon-mode 1))

(use-package which-key
  :ensure t
  :delight
  :init
  (which-key-mode))

(use-package ido
  :ensure t
  :bind
  ("C-x C-b" . 'ido-switch-buffer)
  ("C-x b" . 'ibuffer)
  :config
  (ido-mode 1)
  (setq ido-everywhere t)
  (setq ido-enable-flex-matching t)
  (setq ido-max-directory-size 100000)
  (setq ido-default-file-method 'selected-window)
  (setq ido-default-buffer-method 'selected-window)
  (use-package ido-vertical-mode
    :ensure t
    :init
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)))


  ;; (setq ido-file-extensions-order '(".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))

(use-package smex
  :ensure t
  :init
  (smex-initialize)
  :bind
  ("M-x" . 'smex)
  ("M-X" . 'smex-major-mode-commands))

(use-package rainbow-delimiters
  :ensure t
  :delight
  :init
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
    (add-hook 'ess-mode-hook #'rainbow-delimiters-mode))

(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config (setq aw-background nil))

(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char)
  :config (setq avy-background t))

(use-package sudo-edit
  :ensure t
  :bind ("C-c s" . sudo-edit))

(use-package typit
  :init
  :ensure t)

(use-package calfw
  :init
  :ensure t)

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (use-package evil-org
    :ensure t
    :after org
    :delight
    :config
    (add-hook 'org-mode-hook 'evil-org-mode)
    (add-hook 'evil-org-mode-hook
              (lambda ()
                (evil-org-set-key-theme)))
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys)))

(use-package undo-tree
  :ensure t
  :delight
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-diff t))

(defun split-and-follow-horizontally ()
    (interactive)
    (split-window-below)
    (balance-windows)
    (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
    (interactive)
    (split-window-right)
    (balance-windows)
    (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defun config-visit ()
(interactive)
(find-file "~/.emacs.d/conf.org"))
(global-set-key (kbd "C-c e") 'config-visit)

(defun config-reload ()
"Reloads ~/.emacs.d/conf.org at runtime"
(interactive)
(org-babel-load-file (expand-file-name "~/.emacs.d/conf.org")))
(global-set-key (kbd "C-c r") 'config-reload)

(global-set-key (kbd "C-S-w") 'fc/delete-whole-line)
(defun fc/delete-whole-line ()
"Delete the whole line without flooding the kill ring"
(interactive)
(delete-region (progn (forward-line 0) (point))
                (progn (forward-line 1) (point))))

(global-set-key (kbd "M-d") 'fc/delete-word-forward)
(defun fc/delete-word-forward (arg)
"Delete word forward without flooding the kill ring"
(interactive "p")
(delete-region (point) (progn (forward-word arg) (point))))

(global-set-key (kbd "<M-backspace>") 'fc/delete-word-backward)
(defun fc/delete-word-backward (arg)
"Delete word backward without flooding the kill ring"
(interactive "p")
(delete-region (point) (progn (backward-word arg) (point))))

(global-set-key (kbd "C-c C-d") 'fc/duplicate-current-line-or-region)
(defun fc/duplicate-current-line-or-region (arg)
    "Duplicates the current line or region ARG times."
    (interactive "p")
    (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
        (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point))))))

(setq inferior-R-args "--quiet --no-save")
(load "ess-site")
(setq ess-history-file "session.Rhistory")
(setq ess-history-directory
      (substitute-in-file-name "${XDG_CONFIG_HOME}/r/"))

(setq org-log-done t)
(setq org-src-window-setup 'current-window)
(setq org-startup-indented t)
(delight 'org-indent-mode)
(setq org-directory "~/Org")

(use-package org-bullets
  :ensure t
  :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(defun nd/org-ui-heading-same-font-height ()
  (let ((heading-height 1.15))
    (set-face-attribute 'org-level-1 nil :weight 'bold :height heading-height)
    (set-face-attribute 'org-level-2 nil :weight 'semi-bold :height heading-height)
    (set-face-attribute 'org-level-3 nil :weight 'normal :height heading-height)
    (set-face-attribute 'org-level-4 nil :weight 'normal :height heading-height)
    (set-face-attribute 'org-level-5 nil :weight 'normal :height heading-height)))

(add-hook 'org-mode-hook 'nd/org-ui-heading-same-font-height)

;;(add-hook 'org-capture-mode-hook 'evil-append)

(add-to-list 'org-structure-template-alist
             '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))

(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)
(setq org-yank-adjusted-subtrees t)

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-x x") 'nd/mark-subtree-done)
            (local-set-key (kbd "C-c C-x c") 'nd/org-clone-subtree-with-time-shift-reset)))

(evil-define-key 'motion org-agenda-mode-map
  "t" 'nd/toggle-project-toplevel-display
  "D" 'org-agenda-day-view
  "W" 'org-agenda-week-view
  "M" 'org-agenda-month-view
  "Y" 'org-agenda-year-view
  "ct" nil
  "e" 'org-agenda-set-effort
  "ce" nil)

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-c") '(message org-tags-alist))))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAIT(w@/!)" "HOLD(h@/!)" "|" "CANC(c@/!)")))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "light coral" :weight bold)
              ("NEXT" :foreground "khaki" :weight bold)
              ("DONE" :foreground "light green" :weight bold)
              ("WAIT" :foreground "orange" :weight bold)
              ("HOLD" :foreground "violet" :weight bold)
              ("CANC" :foreground "deep sky blue" :weight bold))))

(defun nd/filter-tags-prefix (prefix tags-list)
  "Return a subset of tags-list whose first character matches prefix.'
tags-list defaults to org-tag-alist if not given"
  (seq-filter (lambda (tag)
                (and (stringp tag)
                     (string-prefix-p prefix tag)))
              tags-list))

(defun nd/add-tag-face (fg-name prefix)
  "Adds list of cons cells to org-tag-faces with foreground set to fg-name.
Start and end specify the positions in org-tag-alist which define the tags
to which the faces are applied"
  (dolist (tag (nd/filter-tags-prefix prefix (mapcar #'car org-tag-alist)))
    (push `(,tag . (:foreground ,fg-name)) org-tag-faces)))

;; for some reason, org-mode doesn't like it if the org-tags-alist
;; has special chars before it is loaded (overrides keybindings)
;; this somewhat convoluted hook works tho...
(defun nd/set-org-tag-alist-and-faces ()
  (progn
    ;; dirty hack to keep org agenda happy
;;    (setq org-tag-alist '((:newline)))
    (setq org-tag-alist
          '((:startgroup)
            ("@errand" . ?e)
            ("@home" . ?h)
            ("@work" . ?w)
            ("@travel" . ?t)
            (:endgroup)
            
            ("#laptop" . ?L)
            ("#tcult" . ?T)
            ("#phone" . ?O)
            
            ("$note" . ?n)
            ("$inc" . ?i)
            ("$subdiv" . ?s)
            
            (:startgroup)
            ("_env" . ?E)
            ("_fin" . ?F)
            ("_int" . ?I)
            ("_met" . ?M)
            ("_phy" . ?H)
            ("_pro" . ?P)
            ("_rec" . ?R)
            ("_soc" . ?S)
            (:endgroup)))
    
    (setq org-tag-faces '())
    
    (nd/add-tag-face "PaleGreen" "@")
    (nd/add-tag-face "SkyBlue" "#")
    (nd/add-tag-face "PaleGoldenrod" "$")
    (nd/add-tag-face "violet" "_")))

(add-hook 'org-mode-hook 'nd/set-org-tag-alist-and-faces)

(add-to-list 'org-default-properties "PARENT_TYPE")
(add-to-list 'org-default-properties "OWNER")
(setq org-global-properties
      '(("PARENT_TYPE_ALL" . "periodical iterator")
        ("Effort_ALL" . "0:05 0:15 0:30 1:00 1:30 2:00 3:00 4:00 5:00 6:00")))

;; TODO this may not be needed
(setq org-use-property-inheritance '("PARENT_TYPE"))

(setq org-capture-templates
      '(("t" "todo" entry (file "~/Org/capture.org") "* TODO %?\ndeliverable: \n%U\n")
        ("n" "note" entry (file "~/Org/capture.org") "* %? :\\%note:\n%U\n" )
        ("a" "appointment" entry (file "~/Org/capture.org") "* %?\n%U\n%^t\n" )
        ("m" "multi-day" entry (file "~/Org/capture.org") "* TODO %?\n%U\n%^t--%^t\n" )
        ("d" "deadline" entry (file "~/Org/capture.org") "* TODO %?\nDEADLINE: %^t\ndeliverable:\n%U\n" )
        
        ("j" "journal" entry (file+datetree "~/Org/diary.org") "* %?\n%U\n")
        ("p" "org-protocol" entry (file+headline ,(concat org-directory "~/Org/capture.org") "Inbox")
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
        ("L" "org-protocol" entry (file+headline ,(concat org-directory "~/Org/capture.org") "Inbox")
         "* %? [[%:link][%:description]] \nCaptured On: %U")            
        ("h" "habit" entry (file "~/Org/capture.org")
         "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 ("~/Org/reference/idea.org" :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
(setq org-completion-use-ido t)

(setq org-refile-allow-creating-parent-nodes 'confirm)

(setq org-indirect-buffer-display 'current-window)

(defun nd/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'nd/verify-refile-target)

(setq org-agenda-files '("~/Org"
                      "~/Org/projects"
                      "~/Org/reference"))
;; (setq org-agenda-files '("~/Org/reference/agendatest.org"))
(setq org-agenda-dim-blocked-tasks nil)
(setq org-agenda-compact-blocks t)

(defun nd/get-date-property (date-property)
  "Helper function to get the date property and convert to a number.
If it does not have a date, it will return nil."
  (let ((timestamp (org-entry-get nil date-property)))
    (if timestamp (float-time (date-to-time timestamp)))))

(defun nd/heading-compare-timestamp (timestamp-fun &optional ref-time future)
  "helper function that returns the timestamp (returned by timestamp-fun on the
current header) if timestamp is futher back in time compared to a ref-time
 (default to 0 which is now, where negative is past an positive is future). 
If the future flag is set, returns timestamp if it is in the future
 compared to ref-time. Returns nil if no timestamp is found."
  (let* ((timestamp (funcall timestamp-fun))
        (ref-time (or ref-time 0)))
    (if (and timestamp
             (if future
                 (> (- timestamp (float-time)) ref-time)
               (<= (- timestamp (float-time)) ref-time)))
        timestamp)))

(defun nd/is-timestamped-heading-p ()
  (nd/get-date-property "TIMESTAMP"))

(defun nd/is-scheduled-heading-p ()
  (nd/get-date-property "SCHEDULED"))

(defun nd/is-deadlined-heading-p ()
  (nd/get-date-property "DEADLINE"))

(defun nd/is-closed-heading-p ()
  (nd/get-date-property "CLOSED"))

(defun nd/is-stale-heading-p ()
  (nd/heading-compare-timestamp 'nd/is-timestamped-heading-p))

(defun nd/is-fresh-heading-p ()
  (nd/heading-compare-timestamp 'nd/is-timestamped-heading-p nil t))

(defvar nd/archive-delay-days 30
  "the number of days to wait before tasks show up in the archive view")

(defun nd/is-archivable-heading-p ()
  (nd/heading-compare-timestamp
   'nd/is-closed-heading-p
    (- (* 60 60 24 nd/archive-delay-days))))

(defun nd/is-todoitem-p ()
  (let ((keyword (nth 2 (org-heading-components))))
    (if (member keyword org-todo-keywords-1)
        keyword)))

(defun nd/is-project-p ()
  (and (nd/heading-has-children 'nd/is-todoitem-p) (nd/is-todoitem-p)))

(defun nd/is-task-p ()
  (and (not (nd/heading-has-children 'nd/is-todoitem-p)) (nd/is-todoitem-p)))

(defun nd/is-project-task-p ()
  (and (nd/heading-has-parent 'nd/is-todoitem-p) (nd/is-task-p)))

(defun nd/is-atomic-task-p ()
  (and (not (nd/heading-has-parent 'nd/is-todoitem-p)) (nd/is-task-p)))

(defun nd/is-periodical-heading-p ()
  (equal "periodical" (org-entry-get nil "PARENT_TYPE" t)))

(defun nd/is-iterator-heading-p ()
  (equal "iterator" (org-entry-get nil "PARENT_TYPE" t)))

(defun nd/heading-has-effort-p ()
  (org-entry-get nil "Effort"))

(defun nd/heading-has-context-p ()
  (let ((tags (org-get-tags-at)))
    (or (> (length (nd/filter-tags-prefix "#" tags)) 0)
        (> (length (nd/filter-tags-prefix "@" tags)) 0))))

(defun nd/heading-has-children (heading-test)
  "returns t if heading has subheadings that return t when assessed with 
heading-test function"
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        has-children previous-point)
    (save-excursion
      (setq previous-point (point))
      (outline-next-heading)
      (while (and (not has-children)
                  (< previous-point (point) subtree-end))
        (when (funcall heading-test)
          (setq has-children t))
        (setq previous-point (point))
        (org-forward-heading-same-level 1 t)))
    has-children))

(defun nd/heading-has-parent (heading-test)
  "returns parent keyword if heading is in the immediate subtree of a heading 
that evaluated to t with heading-test function"
  (save-excursion (and (org-up-heading-safe) (funcall heading-test))))

(defun nd/has-discontinuous-parent ()
  "returns t if heading has a parent which is not a
todoitem which in turn has a parent which is a todoitem"
  (let ((has-todoitem-parent)
        (has-non-todoitem-parent))
    (save-excursion
      (while (and (org-up-heading-safe)
                  (not has-todoitem-parent))
        (if (nd/is-todoitem-p)
            (setq has-todoitem-parent t)
          (setq has-non-todoitem-parent t))))
    (and has-todoitem-parent has-non-todoitem-parent)))

(defconst nd/project-invalid-todostates
  '("WAIT" "NEXT")
  "projects cannot have these todostates") 

(defconst nd/project-statuscodes
  '(:archivable
    :complete
    :stuck
    :held
    :waiting
    :active
    :done-incomplete
    :undone-complete
    :invalid-todostate
    :scheduled-project)
  "list of statuscodes to be used in assessing projects
Note they are listed in order of priority (eg items further
down the list override higher items")

(defmacro nd/compare-statuscodes (operator statuscode-1 statuscode-2)
  "syntactic suger to compare statuscodes by position"
  `(,operator (position ,statuscode-1 nd/project-statuscodes)
     (position ,statuscode-2 nd/project-statuscodes)))
  
(defun nd/status< (statuscode-1 statuscode-2)
  "returns t is statuscode-1 is lesser priority than statuscode-2"
  (nd/compare-statuscodes < statuscode-1 statuscode-2))

(defun nd/status> (statuscode-1 statuscode-2)
  "returns t is statuscode-1 is greater priority than statuscode-2"
  (nd/compare-statuscodes > statuscode-1 statuscode-2))

(defun nd/status= (statuscode-1 statuscode-2)
  "returns t is statuscode-1 is equal priority than statuscode-2"
  (nd/compare-statuscodes = statuscode-1 statuscode-2))

(defun nd/descend-into-project ()
  "returns statuscode of project and recursively descends into subprojects"
  (let ((project-state :archivable)
        (previous-point))
    (save-excursion
      (setq previous-point (point))
      (outline-next-heading)
      ;; loop breaks if active or higher priority
      ;; note that all invalid statuscodes are higher
      ;; thus this function will only return the first
      ;; encountered error
      (while (and (nd/status< project-state :active)
                  (> (point) previous-point))
        (let ((keyword (nd/is-todoitem-p)))
          (if keyword
              (let ((cur-state
                     (if (nd/heading-has-children 'nd/is-todoitem-p)
                         (cond ((member keyword nd/project-invalid-todostates) :invalid-todostate)
                               ((nd/is-scheduled-heading-p) :scheduled-project)
                               ((equal keyword "CANC") (if (nd/is-archivable-heading-p)
                                                                :archivable
                                                              :complete))
                               ((equal keyword "HOLD") :held)
                               (t (let ((child-statuscode (nd/descend-into-project)))
                                    (cond ((equal keyword "TODO")
                                           (if (nd/status> child-statuscode :complete)
                                               child-statuscode
                                             :undone-complete))
                                          (t (case child-statuscode
                                               (:complete :complete)
                                               (:archivable (if (nd/is-archivable-heading-p)
                                                                :archivable
                                                              :complete))
                                               (t (if (nd/status= child-statuscode :complete)
                                                      :complete
                                                    :done-incomplete))))))))
                       (cond ((equal keyword "HOLD") :held)
                             ((equal keyword "WAIT") :waiting)
                             ((equal keyword "NEXT") :active)
                             ((and (equal keyword "TODO") (nd/is-scheduled-heading-p)) :active)
                             ((equal keyword "TODO") :stuck)
                             ((nd/is-archivable-heading-p) :archivable)
                             (t :complete)))))
                (if (nd/status> cur-state project-state)
                    (setq project-state cur-state)))))
        (setq previous-point (point))
        (org-forward-heading-same-level 1 t)))
    project-state))

(defmacro nd/is-project-keyword-status-p (test-keyword operator statuscode)
  "tests if a project has toplevel heading of top-keyword and
child status equal to status code and returns keyword if
both are true"
  `(and
    (equal ,keyword ,test-keyword)
    (nd/compare-statuscodes ,operator (nd/descend-into-project) ,statuscode)))

(defun nd/is-project-status-p (statuscode)
  "Returns t if project matches statuscode given. 
Note that this assumes the headline being tested is a valid project"
  (case statuscode
    ;; projects closed more than 30 days ago
    ;; note CANC overrides all subtasks/projects
    (:archivable
     (if (nd/is-archivable-heading-p)
         (or (equal keyword "CANC") 
             (nd/is-project-keyword-status-p "DONE" = :archivable))))
    
    ;; projects closed less than 30 days ago
    ;; note CANC overrides all subtasks/projects
    (:complete
     (if (not (nd/is-archivable-heading-p))
         (or (equal keyword "CANC")
             (nd/is-project-keyword-status-p "DONE" = :complete))))
    
    ;; projects with no waiting, held, or active components
    (:stuck
     (nd/is-project-keyword-status-p "TODO" = :stuck))
    
    ;; held projects
    ;; note toplevel HOLD overrides all subtasks/projects
    (:held
     (or (equal keyword "HOLD")
         (nd/is-project-keyword-status-p "TODO" = :held)))
    
    ;; projects with at least one waiting component
    (:waiting
     (nd/is-project-keyword-status-p "TODO" = :waiting))
    
    ;; projects with at least one active component
    (:active
     (nd/is-project-keyword-status-p "TODO" = :active))
    
    ;; projects marked DONE but still have undone subtasks
    (:done-incomplete
     (nd/is-project-keyword-status-p "DONE" > :complete))
    
    ;; projects marked TODO but all subtasks are done
    (:undone-complete
     (nd/is-project-keyword-status-p "TODO" < :stuck))
    
    ;; projects with invalid todo keywords
    (:invalid-todostate
     (member keyword nd/project-invalid-todostates))
    
    ;; projects with scheduled heading (only subtasks should be scheduled)
    (:scheduled-project
     (nd/is-scheduled-heading-p))

    ;; error if not known
    (t (if (not (member statuscode nd/project-statuscodes))
           (error "unknown statuscode")))))

(defun nd/skip-heading ()
  (save-excursion (or (outline-next-heading) (point-max))))

(defun nd/skip-subtree ()
  (save-excursion (or (org-end-of-subtree t) (point-max))))

(defconst nd/project-skip-todostates
  '("HOLD" "CANC")
  "These keywords override all contents within their subtrees.
Currently used to tell skip functions when they can hop over
entire subtrees to save time and ignore tasks")

(defmacro nd/skip-heading-with (heading-fun test-fun)
  "Skips headings accoring to certain characteristics. heading-fun
is a function that tests the heading and returns the todoitem keyword
on success. Test-fun is a function that further tests the identity of
the heading and may or may not use the keyword output supplied by
the heading-fun. This function will not skip if heading-fun and 
test-fun return true"
  `(save-restriction
     (widen)
     (let ((keyword (,heading-fun)))
       (message keyword)
       (if (not (and keyword ,test-fun))
           (nd/skip-heading)))))

(defun nd/skip-non-stale-headings ()
  (save-restriction
    (widen)
    (let ((keyword (nd/is-todoitem-p)))
      (if (not
           (and (nd/is-stale-heading-p)
                (not (member keyword org-done-keywords))
                (not (nd/heading-has-children 'nd/is-todoitem-p))
                (not (nd/heading-has-parent 'nd/is-todoitem-p))))
          (nd/skip-heading)))))

;; NOTE: this assumes that tags-todo will
;; filter out all done state tasks
(defun nd/skip-non-atomic-tasks ()
  (save-excursion
    (widen)
    (if (not (nd/is-atomic-task-p))
        (nd/skip-heading))))

(defun nd/skip-non-closed-atomic-tasks ()
  (nd/skip-heading-with
   nd/is-atomic-task-p
   (and (member keyword org-done-keywords)
        (not (nd/is-archivable-heading-p)))))

(defun nd/skip-non-archivable-atomic-tasks ()
  (nd/skip-heading-with
   nd/is-atomic-task-p
   (and (member keyword org-done-keywords)
        (nd/is-archivable-heading-p))))

(defun nd/skip-non-fresh-periodical-parent-headers ()
  (save-restriction
    (widen)
    (if (not (and (nd/is-periodical-heading-p)
                  (not (nd/heading-has-parent 'nd/is-periodical-heading-p))
                  (nd/heading-has-children 'nd/is-fresh-heading-p)))
        (nd/skip-heading))))

(defun nd/skip-non-stale-periodical-parent-headers ()
  (save-restriction
    (widen)
    (if (not (and (nd/is-periodical-heading-p)
                  (not (nd/heading-has-parent 'nd/is-periodical-heading-p))
                  (nd/heading-has-children 'nd/is-stale-heading-p)
                  (not (nd/heading-has-children 'nd/is-fresh-heading-p))))
        (nd/skip-heading))))

(defun nd/skip-non-empty-periodical-parent-headers ()
  (save-restriction
    (widen)
    (if (not (and (nd/is-periodical-heading-p)
                  (not (nd/heading-has-parent 'nd/is-periodical-heading-p))
                  (not (nd/heading-has-children 'nd/is-timestamped-heading-p))))
        (nd/skip-heading))))

(defun nd/skip-non-keyword-project-tasks (skip-keyword)
  (save-restriction
    (widen)
    (let ((keyword (nd/is-todoitem-p)))
      (if keyword
          (if (nd/heading-has-children 'nd/is-todoitem-p)
              (if (member keyword nd/project-skip-todostates)
                  (nd/skip-subtree)
                (nd/skip-heading))
            (if (not (and (nd/heading-has-parent 'nd/is-todoitem-p)
                          (not (nd/is-timestamped-heading-p))
                          (not (nd/is-scheduled-heading-p))
                          (not (nd/is-deadlined-heading-p))
                          (equal keyword skip-keyword)))
                (nd/skip-heading)))
        (nd/skip-heading)))))

(defun nd/skip-non-discontinuous-project-tasks ()
  (nd/skip-heading-with
   nd/is-todoitem-p
   (nd/has-discontinuous-parent)))

(defun nd/skip-non-done-unclosed-todoitems ()
  (nd/skip-heading-with
   nd/is-todoitem-p
   (and (member keyword org-done-keywords)
        (not (nd/is-closed-heading-p)))))

(defun nd/skip-non-undone-closed-todoitems ()
  (nd/skip-heading-with
   nd/is-todoitem-p
   (and (not (member keyword org-done-keywords))
        (nd/is-closed-heading-p))))

(defun nd/skip-non-iterator-atomic-tasks ()
  (nd/skip-heading-with
   nd/is-atomic-task-p
   (nd/is-iterator-heading-p)))

(defun nd/skip-atomic-tasks-with-context ()
  (nd/skip-heading-with
   nd/is-atomic-task-p
   (not (nd/heading-has-context-p))))

(defun nd/skip-project-tasks-with-context ()
  (nd/skip-heading-with
   nd/is-project-task-p
   (not (nd/heading-has-context-p))))

(defun nd/skip-projects-with-context ()
  (nd/skip-heading-with
   nd/is-project-p
   (not (nd/heading-has-context-p))))

(defun nd/skip-tasks-with-effort ()
  (nd/skip-heading-with
   nd/is-task-p
   (not (nd/heading-has-effort-p))))

(defun nd/skip-projects-without-statuscode (statuscode)
  (save-restriction
    (widen)
    (let ((keyword (nd/is-project-p)))
      (if keyword
          (if (and nd/agenda-limit-project-toplevel
                   (nd/heading-has-parent 'nd/is-todoitem-p))
              (nd/skip-subtree)
            (if (not (nd/is-project-status-p statuscode))
                (nd/skip-heading)))
        (nd/skip-heading)))))

(defvar nd/agenda-limit-project-toplevel t
  "used to filter projects by all levels or top-level only")

(defvar nd/agenda-hide-incubator-tags t
  "used to filter incubator headings")

(defun nd/toggle-project-toplevel-display ()
  (interactive)
  (setq nd/agenda-limit-project-toplevel (not nd/agenda-limit-project-toplevel))
  (when (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "Showing %s project view in agenda"
           (if nd/agenda-limit-project-toplevel "toplevel" "complete")))

(defun nd/toggle-agenda-var (var msg)
  (interactive)
  (set var (not (eval var)))
  (when (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message msg))

(setq org-agenda-tags-todo-honor-ignore-options t)

(setq org-agenda-prefix-format
      '((agenda . "  %-12:c%-7:e%?-12t% s")
        (timeline . "  % s")
        (todo . "  %-12:c")
        (tags . "  %-12:c%-7:e")
        (search . "  %-12:c")))

(defun nd/agenda-base-header-command (match header skip-fun)
  `(tags
    ,match
    ((org-agenda-overriding-header ,header)
     (org-agenda-skip-function ,skip-fun)
     (org-agenda-sorting-strategy '(category-keep)))))

(defun nd/agenda-base-task-command (match header skip-fun)
  `(tags-todo
    ,match
    ((org-agenda-overriding-header ,header)
     (org-agenda-skip-function ,skip-fun)
     (org-agenda-todo-ignore-with-date t)
     (org-agenda-sorting-strategy '(category-keep)))))

(defun nd/agenda-base-project-command (match header statuscode)
  `(tags
    ,match
    ((org-agenda-overriding-header
      (concat (and nd/agenda-limit-project-toplevel "Toplevel ") ,header))
     (org-agenda-skip-function '(nd/skip-projects-without-statuscode ,statuscode))
     (org-agenda-sorting-strategy '(category-keep)))))

(setq org-agenda-tag-filter-preset (list "-%inc"))

(let ((task-match "-NA-REFILE-PARENT_TYPE=\"periodical\"/")
      (project-match "-NA-REFILE-PARENT_TYPE=\"periodical\"-PARENT_TYPE=\"iterator\"/")
      (periodical-match "-NA-REFILE+PARENT_TYPE=\"periodical\"-PARENT_TYPE=\"iterator\"/")
      (iterator-match "-NA-REFILE-PARENT_TYPE=\"periodical\"+PARENT_TYPE=\"iterator\"/"))
  (setq org-agenda-custom-commands
        `(("t"
           "Task View"
           ((agenda "" nil)
            ,(nd/agenda-base-task-command task-match "Next Project Tasks" ''(nd/skip-non-keyword-project-tasks "NEXT"))
            ,(nd/agenda-base-task-command task-match "Waiting Project Tasks" ''(nd/skip-non-keyword-project-tasks "WAIT"))
            ,(nd/agenda-base-task-command project-match "Atomic Tasks" ''nd/skip-non-atomic-tasks)
            ,(nd/agenda-base-task-command task-match "Held Project Tasks" ''(nd/skip-non-keyword-project-tasks "HOLD"))))
          ("p"
           "Project View"
           (,(nd/agenda-base-project-command project-match "Stuck Projects" :stuck)
            ,(nd/agenda-base-project-command project-match "Waiting Projects" :waiting)
            ,(nd/agenda-base-project-command project-match "Active Projects" :active)
            ,(nd/agenda-base-project-command project-match "Held Projects" :held)))
          ("P"
           "Periodical View"
           (,(nd/agenda-base-header-command periodical-match "Empty Periodicals" ''nd/skip-non-empty-periodical-parent-headers)
            ,(nd/agenda-base-header-command periodical-match "Stale Periodicals" ''nd/skip-non-stale-periodical-parent-headers)
            ,(nd/agenda-base-header-command periodical-match "Fresh Periodicals" ''nd/skip-non-fresh-periodical-parent-headers)))
          ("i"
           "Iterator View"
           (,(nd/agenda-base-project-command iterator-match "Stuck Iterators (require NEXT or schedule)" :stuck)
            ,(nd/agenda-base-project-command iterator-match "Empty Iterators (require new tasks)" :undone-complete)
            ,(nd/agenda-base-task-command iterator-match "Uninitialized Iterators (no tasks added)" ''nd/skip-non-iterator-atomic-tasks)
            ,(nd/agenda-base-project-command iterator-match "Active Iterators" :active)
            ,(nd/agenda-base-project-command iterator-match "Waiting Iterators" :waiting)
            ,(nd/agenda-base-project-command iterator-match "Held Iterators" :held)))
          ("r"
           "Refile and Critical Errors"
           ((tags "REFILE"
                  ((org-agenda-overriding-header "Tasks to Refile"))
                  (org-tags-match-list-sublevels nil))
            ,(nd/agenda-base-task-command "-NA-REFILE/TODO|NEXT|WAIT" "Project Tasks Without Context" ''nd/skip-project-tasks-with-context)
            ,(nd/agenda-base-task-command "-NA-REFILE/!" "Atomic Tasks Without Context" ''nd/skip-atomic-tasks-with-context)
            ;; ,(nd/agenda-base-task-command "-NA-REFILE-%subdiv/TODO|NEXT|WAIT" "Tasks Without Effort" ''nd/skip-tasks-with-effort)
            ,(nd/agenda-base-task-command task-match "Discontinous Project" ''nd/skip-non-discontinuous-project-tasks)
            ,(nd/agenda-base-project-command project-match "Invalid Todostate" :invalid-todostate)))
          ("e"
           "Non-critical Errors"
           (,(nd/agenda-base-header-command task-match "Undone Closed" ''nd/skip-non-undone-closed-todoitems)
            ,(nd/agenda-base-header-command task-match "Done Unclosed" ''nd/skip-non-done-unclosed-todoitems)
            ,(nd/agenda-base-project-command project-match "Undone Completed" :undone-complete)
            ,(nd/agenda-base-project-command project-match "Done Incompleted" :done-incomplete)))
          ("A"
           "Archivable Tasks and Projects"
           (,(nd/agenda-base-header-command task-match "Archivable Atomic Tasks" ''nd/skip-non-archivable-atomic-tasks)
            ,(nd/agenda-base-header-command task-match "Stale Tasks" ''nd/skip-non-stale-headings)
            ,(nd/agenda-base-project-command iterator-match "Archivable Iterators" :archivable)
            ,(nd/agenda-base-project-command project-match "Archivable Projects" :archivable))))))

(setq org-agenda-start-on-weekday 1)
(setq org-agenda-span 'day)
(setq org-agenda-time-grid (quote ((daily today remove-match)
                                   #("----------------" 0 16 (org-heading t))
                                   (0900 1100 1300 1500 1700))))

(add-hook 'org-finalize-agenda-hook 'place-agenda-tags)
(defun place-agenda-tags ()
  "Put the agenda tags by the right border of the agenda window."
  (setq org-agenda-tags-column (- 4 (window-width)))
  (org-agenda-align-tags))

(defun nd/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
        ((string= tag "hold")
         t))
       (concat "-" tag)))

(setq org-agenda-auto-exclude-function 'nd/org-auto-exclude-function)

(setq org-columns-default-format
      "%25ITEM %4TODO %TAGS %5Effort{:} %OWNER(OWN)")

(set-face-attribute 'org-column nil :background "#1e2023")
;; org-columns-summary-types

(defun nd/mark-subtree-keyword (new-keyword &optional exclude)
  "marks all tasks in a subtree with keyword unless original keyword
is in the optional argument exclude"
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (not (listp exclude))
        (error "exlude must be a list if provided"))
    (save-excursion
      (while (< (point) subtree-end)
        (let ((keyword (nd/is-todoitem-p)))
          (if (and keyword (not (member keyword exclude)))
              (org-todo new-keyword)))
        (outline-next-heading)))))

(defun nd/mark-subtree-done ()
  "marks all tasks in subtree as DONE unless they are already canc"
  (interactive)
  (nd/mark-subtree-keyword "DONE" '("CANC")))

(defun nd/org-clone-subtree-with-time-shift-reset (n &optional shift)
  "Like `org-clone-subtree-with-time-shift' except it resets checkboxes
and reverts all todo keywords to TODO"
  (interactive "nNumber of clones to produce: ")
  (let ((shift (read-from-minibuffer
                "Date shift per clone (e.g. +1w, empty to copy unchanged): ")))
    (condition-case err
        (progn
          (org-clone-subtree-with-time-shift n shift)
          (save-excursion
            (dotimes (i n)
             (org-forward-heading-same-level 1 t)
             (org-reset-checkbox-state-subtree)
             (nd/mark-subtree-keyword "TODO")
             (org-cycle))))
      (error (message "%s" (error-message-string err))))))

(use-package calfw-org
  :init
  :ensure t
  :config (setq cfw:fchar-junction ?╋
                cfw:fchar-vertical-line ?┃
                cfw:fchar-horizontal-line ?━
                cfw:fchar-left-junction ?┣
                cfw:fchar-right-junction ?┫
                cfw:fchar-top-junction ?┯
                cfw:fchar-top-left-corner ?┏
                cfw:fchar-top-right-corner ?┓))

(defvar nd-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list nd-term-shell)))
(ad-activate 'ansi-term)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
