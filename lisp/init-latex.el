;;; init-latex.el --- LaTeX authoring with preview -*- lexical-binding: t; -*-

;;; Commentary:
;; For paper writing (done together with Claude), so preview matters more
;; than fast typing: AUCTeX for editing, latexmk for building, and pdf-tools
;; for an in-Emacs PDF view with two-way SyncTeX (jump source<->PDF).
;;
;;   C-c C-c       build (defaults to LatexMk; handles reruns + bib)
;;   C-c C-v       view the PDF (pdf-tools)
;;   C-c C-p C-p   preview math/figures inline (AUCTeX preview-latex)
;;   C-c =         reftex TOC; \ref and \cite get completion via reftex
;;
;; Engine is left to the document, so Japanese papers work either way:
;; choose lualatex/xelatex or (u)platex+dvipdfmx via a `.latexmkrc', a
;; `%!TEX program = ...' line, or a file-local `(setq TeX-engine 'luatex)'.
;;
;; pdf-tools builds a small helper (epdfinfo) on first use; install its
;; build deps with scripts/install-pdf-tools-deps.sh (Linux/WSL).  Where it
;; can't build (e.g. native Windows) AUCTeX falls back to the system viewer.

;;; Code:

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook ((LaTeX-mode . turn-on-reftex)         ; \ref / \cite management
         (LaTeX-mode . TeX-source-correlate-mode) ; SyncTeX source<->PDF
         (LaTeX-mode . prettify-symbols-mode)  ; show \alpha as α, etc.
         (LaTeX-mode . visual-line-mode))      ; soft-wrap prose
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)                             ; ask for master in multi-file docs
  (TeX-PDF-mode t)
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-start-server t)
  (reftex-plug-into-AUCTeX t)
  :config
  ;; Reload the PDF in pdf-tools automatically after a successful build.
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  ;; Prefer pdf-tools for viewing (the entry is built into AUCTeX); SyncTeX
  ;; forward search lands at point, C-mouse-1 in the PDF jumps back.
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")
                                     (output-dvi "xdg-open")
                                     (output-html "xdg-open"))))

;; Build with latexmk (reruns, bibtex/biber, engine via .latexmkrc).
(use-package auctex-latexmk
  :ensure t
  :after tex
  :config
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  (auctex-latexmk-setup)
  (setq-default TeX-command-default "LatexMk"))

;; In-Emacs PDF viewer with SyncTeX.  pdf-loader-install defers building the
;; epdfinfo helper until the first PDF is opened, keeping startup light.
(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-loader-install :no-query))

;; Fast math/environment input (less typing for formula-heavy papers).
(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex))

(provide 'init-latex)
;;; init-latex.el ends here
