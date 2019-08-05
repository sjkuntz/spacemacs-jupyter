;;; packages.el --- jupyter layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Steven Kuntz <stevenjkuntz@gmail.com>
;; URL: https://github.com/sjkuntz/spacemacs-jupyter
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:
;; See the README for package information.

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `jupyter-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `jupyter/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `jupyter/pre-init-PACKAGE' and/or
;;   `jupyter/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst jupyter-packages
  '(
    company
    (ox-ipynb :location (recipe
                         :fetcher github
                         :repo "jkitchin/ox-ipynb"))
    jupyter
    )
  )

(defun jupyter/post-init-company ()
  ;; Enable company-capf backend in the REPL.
  (spacemacs|add-company-hook jupyter-repl-mode)
  (push 'company-capf company-backends-jupyter-repl-mode)
  ;; (spacemacs|add-company-backends
  ;;  :backends company-capf
  ;;  :modes jupyter-repl-mode)
  )

;; (defun jupyter/init-company-capf ()
;;   (use-package company-capf
;;     :defer t
;;     :init (push 'company-capf company-backends-jupyter-repl-mode)
;;     )
;;   )

(defun jupyter/init-ox-ipynb ()
  (use-package ox-ipynb)
  )

(defun jupyter/post-init-ox-ipynb ()
  ;; jupyter-LANG needs to point to LANG's kernelspecs.
  ;; TODO: Pull version info from a dynamic source.
  (add-to-list 'ox-ipynb-kernelspecs
               '(jupyter-python . (kernelspec . ((display_name . "Python 3")
                                                 (language . "python")
                                                 (name . "python3"))))
               )
  (add-to-list 'ox-ipynb-kernelspecs
               '(jupyter-julia . (kernelspec . ((display_name . "Julia 0.6.0")
                                                (language . "julia")
                                                (name . "julia-0.6"))))
               )

  ;; jupyter-LANG needs to point to LANG's metadata.
  ;; TODO: Pull version info from a dynamic source.
  (add-to-list 'ox-ipynb-language-infos
               '(jupyter-python . (language_info . ((codemirror_mode . ((name . ipython)
                                                                        (version . 3)))
                                                    (file_extension . ".py")
                                                    (mimetype . "text/x-python")
                                                    (name . "python")
                                                    (nbconvert_exporter . "python")
                                                    (pygments_lexer . "ipython3")
                                                    (version . "3.5.2"))))
               )
  (add-to-list 'ox-ipynb-language-infos
               '(jupyter-julia . (language_info . ((codemirror_mode . "julia")
                                                   (file_extension . ".jl")
                                                   (mimetype . "text/x-julia")
                                                   (name . "julia")
                                                   (pygments_lexer . "julia")
                                                   (version . "0.6.0"))))
               )
  )

(defun jupyter/init-jupyter ()
  (if (executable-find "jupyter")
      (use-package jupyter
        :defer t
        :init
        (progn
          (spacemacs/set-leader-keys
            "ajj" 'jupyter-run-repl
            "ajr" 'jupyter-run-repl
            "ajc" 'jupyter-connect-repl)
          ;; (spacemacs|add-company-backends :backends company :modes jupyter-repl-mode)
          )
        ;; :config
        ;; (progn
        ;;   (evilified-state-evilify-map 'jupyter-repl-mode-map
        ;;     :mode jupyter-repl-mode)

        ;;   (spacemacs/declare-prefix-for-mode 'jupyter-repl-mode
        ;;     "mf" "file")
        ;;   (spacemacs/declare-prefix-for-mode 'jupyter-repl-mode
        ;;     "me" "eval")
        ;;   (spacemacs/declare-prefix-for-mode 'jupyter-repl-mode
        ;;     "mh" "history")
        ;;   ;; TODO not working
        ;;   (spacemacs/set-leader-keys-for-major-mode 'jupyter-repl-mode
        ;;     ;; "," 'jupyter-eval-line-or-region ;; probably these functions should be called from source code
        ;;     ;; "ee" 'jupyter-eval-line-or-region
        ;;     "ed" 'jupyter-eval-defun
        ;;     "eb" 'jupyter-eval-buffer
        ;;     "fl" 'jupyter-load-file
        ;;     "fs" 'jupyter-repl-scratch-buffer
        ;;     "fb" 'jupyter-repl-pop-to-buffer
        ;;     "kr" 'jupyter-repl-restart-kernel
        ;;     "hn"  'jupyter-repl-history-next
        ;;     "hN"  'jupyter-repl-history-previous
        ;;     "i" 'jupyter-inspect-at-point
        ;;     "sb" 'jupyter-repl-pop-to-buffer)
        ;;   )
        )
    (message "jupyter was not found in your path, jupyter is not loaded")
    )
  )

;;; packages.el ends here
