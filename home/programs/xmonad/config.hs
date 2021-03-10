import XMonad
import XMonad.Util.EZConfig
main = xmonad $ gnomeConfig
        { terminal = "alacritty"
        , modMask = mod4Mask -- set the mod key to the windows key
        }
        `additionalKeysP` 
                 [ ("M-m", spawn "echo 'Hi, mom!' | dzen2 -p 4")
                 ]
