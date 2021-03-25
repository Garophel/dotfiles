--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Operations (sendMessage)
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig

import XMonad.Actions.CycleWS (toggleWS, nextWS, prevWS)
import qualified XMonad.Actions.FlexibleResize as Flex

import XMonad.Layout.Grid
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Renamed
--import XMonad.Layout.Spacing
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ServerMode
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)

import qualified Graphics.X11.ExtraTypes.XF86 as XF

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- *** Utility functions *** --
myfSpacewrap :: [Char] -> [Char]
myfSpacewrap s = " " ++ s ++ " "

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "termite"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = fmap myfSpacewrap ["dev","term","text","web","5","6","7","8","9","mpd"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#ff0000"

myToggleFloat w = windows (\s -> if M.member w (W.floating s)
    then W.sink w s
    else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys = \conf -> mkKeymap conf $
    [ ("M-<Return>", spawn $ XMonad.terminal conf) -- Open terminal
    , ("M-<Tab>", toggleWS) -- Back and forth between the last two workspaces
    , ("M-<XF86Forward>", nextWS)
    , ("M-<XF86Back>", prevWS)
    , ("M-<Print>", spawn "spectacle -r")
    , ("<Print>", spawn "scrot --silent '%Y.%m.%d_%H.%M.%S.png' -e 'mv $f ~/pics/screenshots/'")
    , ("S-<Print>", spawn "scrot --silent --select '%Y.%m.%d_%H.%M.%S.png' -e 'mv $f ~/pics/screenshots/'")
    , ("M-S-<Tab>", sendMessage NextLayout)
    , ("M-S-f", sendMessage (T.Toggle "Full"))
    , ("M-S-<Space>", withFocused myToggleFloat)
    , ("M-s", spawn "~/scripts/screensave.sh")
    , ("M-S-s", spawn "~/scripts/bin/dmenu_screenlayout.sh")
    , ("M-i", spawn "qutebrowser")
    , ("M-f", spawn "firefox")
    , ("M-a", spawn "pavucontrol")
    , ("M-S-a", spawn "arandr")
    , ("M-q", kill) -- Close the focused window
    , ("M-d", spawn "dmenu_run") -- Open dmenu
    , ("M-m", windows W.focusMaster) -- Focus the master window
    , ("M-j", windows W.focusDown) -- Focus the previous window in desc order
    , ("M-k", windows W.focusUp) -- Focus the next window in desc order
    , ("M-S-m", windows W.swapMaster) -- Swap with the master window
    , ("M-S-j", windows W.swapDown) -- Swap with the previous window in desc order
    , ("M-S-k", windows W.swapUp) -- Swap with the next window in desc order
    , ("M-S-e", io $ exitWith ExitSuccess)
    , ("M-S-r", spawn "xmonad --recompile; xmonad --restart")
    , ("<XF86AudioPlay>", spawn "~/scripts/util/player-ctrl.sh toggle")
    , ("<XF86AudioPrev>", spawn "~/scripts/util/player-ctrl.sh prev")
    , ("<XF86AudioNext>", spawn "~/scripts/util/player-ctrl.sh next")
    , ("<XF86AudioStop>", spawn "~/scripts/util/player-ctrl.sh stop")
    , ("<XF86AudioLowerVolume>", spawn "~/scripts/util/volume-ctrl.sh down")
    , ("<XF86AudioRaiseVolume>", spawn "~/scripts/util/volume-ctrl.sh up")
    , ("<XF86AudioMute>", spawn "~/scripts/util/volume-ctrl.sh mute")

    ]
    ++
    [("M-" ++ m ++ (show n), windows $ f i)
        | (i, n) <- zip (XMonad.workspaces conf) ([1..9] ++ [0])
        , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [

    -- mod-button1, Set the window to floating mode and move by dragging
    ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                     >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> Flex.mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.

--floats = renamed [Replace "floats"] simplestFloat
--full = Full

tall = Tall nmaster delta ratio
  where
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

--myLayout = avoidStruts (tall ||| Mirror tall ||| Full)
myLayout = avoidStruts $ T.toggleLayouts Full myDefaultLayout
    where myDefaultLayout = tall
                        ||| Grid
                        ||| Full
                        -- ||| floats

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return () -- >> checkKeymap myConfig myKeys

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
    xmonad $ ewmh def
        { terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , clickJustFocuses   = myClickJustFocuses
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

      -- key bindings
        , keys               = myKeys
        , mouseBindings      = myMouseBindings

      -- hooks, layouts
        , layoutHook         = myLayout
        , manageHook         = (isFullscreen --> doFullFloat) <+> myManageHook <+> manageDocks
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
        , logHook            = myLogHook <+> dynamicLogWithPP xmobarPP
                                  { ppOutput = \x -> hPutStrLn xmproc x
                                  , ppCurrent = xmobarColor "#88FF88" "" . wrap "[" "]"
                                  , ppHidden = xmobarColor "#88FF88" ""
                                  , ppHiddenNoWindows = xmobarColor "#88FF88" ""
                                  } 
        , startupHook        = myStartupHook
    }

-- Horribly out-of-date
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
