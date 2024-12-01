;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Michael Lavin"
       user-mail-address "michaelllavin@gmail.com")


(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "|" "DONE")))

(setq org-agenda-custom-commands
        '(("1" "Level 1 Overview"
           ((tags-todo  "LEVEL=1+TODO=\"NEXT\""
                        ((org-agenda-overriding-header "Level 1 Next:")))
            (tags-todo  "LEVEL=1+TODO=\"TODO\""
                        ((org-agenda-overriding-header "Level 1 Todos:")))
            ))

	  ("2" "Level 2 Overview"
           ((tags-todo  "LEVEL=2+TODO=\"NEXT\""
                        ((org-agenda-overriding-header "Level 2 Next:")))
            (tags-todo  "LEVEL=2+TODO=\"TODO\""
                        ((org-agenda-overriding-header "Level 2 Todos:")))
            ))))


  (setq org-startup-folded t)

  ;;ORG ROAM

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org-roam")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))



;; thanks to zzamboni.org for this: disable completion of words in or
(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))


;; Set Mouse 3 for flyspell corrections
(after! flyspell
  (define-key flyspell-mode-map [down-mouse-3] 'flyspell-correct-word) )



;; Display whitespace characters
;; adapted from a solution by adamroyjones
;; https://github.com/doomemacs/doomemacs/issues/2673
(use-package! whitespace
  :config
  (setq
    whitespace-style '(face tabs tab-mark spaces space-mark trailing newline newline-mark)
    whitespace-display-mappings '(
      (space-mark   ?\     [?\u00B7]     [?.])
      (space-mark   ?\xA0  [?\u00A4]     [?_])
      (newline-mark ?\n    [182 ?\n])
      (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t])))
  (global-whitespace-mode +1))



;; Yes, I really want to quit.
(setq confirm-kill-emacs nil)


(defun tb/leaving-countdown ()
  "Counts down to leaving date"
  (interactive)
    (let ((leaving-date (encode-time (parse-time-string "19 Jul 2025 13:10:00" ))))
    (setq diff (time-subtract leaving-date (current-time)))
    (print(format-seconds "%D %H %M %S" diff))))


(defun tb/clean-up()
  (interactive)
  (whitespace-mode)
  (goto-char (point-min))
  (flush-lines "^\\s-+$")
  (goto-char (point-min))
;; get rid of extra spaces after bullet  point
  (while (re-search-forward "-   " nil t)
    (replace-match "- ")))
