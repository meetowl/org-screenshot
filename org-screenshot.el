(require 'org)
;; org-screenshot
(defvar org-screenshot-command
  "xfce4-screenshooter -r -s %s"
  "Format string which will be used to take screenshot")

(defvar org-screenshot-directory
  "./img"
  "(Possibly relative) directory to save the screenshots in")

(defvar org-screenshot-filename-digits
  4
  "How many digits the screenhsot filename will have")

(defvar org-screenshot-file-extension
  "png"
  "Screenshot file extension")

(defun org-screenshot-valid-filename-p (filename)
  "Checks whether a filename corresponds to the format of a org-screenshot file."
  (let ((file-regexp (format "^[0-9]\\{%d\\}\\.%s$" org-screenshot-filename-digits org-screenshot-file-extension)))
    (string-match-p file-regexp filename)))

(defun shell-string-to-process-args (argstr infile destination display)
  "Converts a shell command into list of tokens for use with `call-process'
Equivalent to splitting string by delimited with spaces,
inserting infile, destination, display after the first element."
  (let ((arg-list (split-string argstr)))
    (cons (car arg-list) (cons infile (cons destination (cons display (cdr arg-list)))))))

(defun org-insert-screenshot ()
  "Insert a link to screenshot after cursor and call `org-display-inline-images'.
The screenshot command is defined by `org-screenshot-command'.
The directory to save screenshots is `org-screenshot-directory'.

You can change the amount of digits the screenshot file has as
a name with `org-screenshot-filename-digits'.
The extension is specified with `org-screenshot-file-extension'."
  (interactive)
  (unless (file-accessible-directory-p org-screenshot-directory)
    (make-directory org-screenshot-directory))
  (let ((filtered-directory-ls (cl-remove-if-not 'org-screenshot-valid-filename-p
                                              (directory-files org-screenshot-directory)))
        (new-file-format-str (format "%%0%dd.%%s" org-screenshot-filename-digits))
        (new-file-number)
        (new-file-name)
        (new-file-path))

    (if filtered-directory-ls ; Empty if there are no files which follow our format
        (setq new-file-number
                    (+ 1 (string-to-number (substring (car (last filtered-directory-ls))
                                                      0 org-screenshot-filename-digits))))
      (setq new-file-number '1))

    (setq new-file-name (format new-file-format-str new-file-number org-screenshot-file-extension))
    (setq new-file-path  (concat org-screenshot-directory "/" new-file-name))

    (apply 'call-process
           (shell-string-to-process-args (format org-screenshot-command new-file-path)
                                         nil "Output" nil))
    (if (file-exists-p new-file-path)
        (progn
          (insert (concat "[[" new-file-path "]]"))
          (org-display-inline-images))
      (message "Screenshot cancelled (no file created)"))))
