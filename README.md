# org-screenshot
Easily create screenshots and insert them into an Org file in Emacs.

## Usage
Make sure to load `org-screenshot` on start:
```elisp
(require 'org-srceenshot)
```

Place marker where you would like to insert a screenshot, then use `org-insert-screenshot`.

## Configuration
### Screenshot Utility
This has been written with `xfce4-screenshooter`.
You can change this by modifying `org-screenshot-command` by placing the following in your init file:
```elisp
(setq org-screenshot-command "xfce4-screenshooter -r -s %s")
```
where `%s` is the filename and path that `org-screenshot` will request it to be saved as.

### Everything else
You can find the configuration variables in [org-screenshot.el](org-screenshot.el).

I think its self explanatory but if you would like more clarification please submit an issue :)
