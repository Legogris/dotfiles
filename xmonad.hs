import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad
import System.IO
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.NoBorders
import XMonad.Util.WorkspaceCompare
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS

import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as W
import qualified Data.Map as M

myWorkspaces = ["一","二","三","四","五","六","七","八","九"]
-- myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
modm = mod1Mask

legoKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((mod4Mask, xK_t), spawn myTerminal)
    , ((mod4Mask, xK_r), spawn "dmenu_run")
    , ((mod4Mask, xK_p), spawn "passmenu")
    , ((mod4Mask, xK_i), spawn "urxvt -name urxvtq -e sudo wifi-menu")
    , ((mod4Mask, xK_b), spawn "urxvt -name urxvtq -e bluetoothctl")
    , ((mod4Mask, xK_w), spawn "firefox")
    , ((mod4Mask, xK_l), spawn "slock")

    -- close focused window
    , ((mod1Mask, xK_F4), kill)

    , ((mod1Mask, xK_grave), scratchPad)
    , ((mod1Mask, xK_Escape), scratchPad)

     -- Rotate through the available layout algorithms
    , ((modm, xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
     , ((modm .|. shiftMask, xK_space ), sendMessage NextLayout)
     , ((mod4Mask, xK_Tab), moveTo Next HiddenNonEmptyWS)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
   -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

  -- Focus an urgent window
    , ((modm              , xK_u     ), focusUrgent)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
     , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    , ((mod4Mask           , xK_Right), spawn "playerctl next")
    , ((mod4Mask           , xK_Left), spawn "playerctl previous")
    , ((mod4Mask           , xK_Up), spawn "playerctl volume +")
    , ((mod4Mask           , xK_space), spawn "playerctl play-pause")
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    [((m .|. mod4Mask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    -- TODO: FIX COMPILE ERROR
    -- [((m .|. modm, key), f sc)
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(viewScreen, 0), (sendToScreen, shiftMask)]]

    where
      scratchPad = scratchpadSpawnActionTerminal "urxvt"
------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = smartBorders $ avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

main = do
  -- trayerproc <- spawnPipe "trayer --edge top --align right --widthtype pixel --width 150 --expand true --SetDockType true --SetPartialStrut true --height 16 --tint 0xFF181032 --alpha 127 --transparent true --monitor 2"
  -- xmonad =<< statusBar myPP toggleStrutsKey myConfig
  xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myTerminal = "urxvt"
-- myManageHook = (manageSpawn <+> manageDocks <+> manageHook def) <+> manageScratchPad
myManageHook = composeAll
  [ --manageSpawn
  className =? "Pinentry" --> doFloat
  ,appName =? "slack" --> doF (W.shift (myWorkspaces !! 8))
  ,appName =? "urxvtq" --> doFloat
  ,className =? "Spotify" --> doF (W.shift (myWorkspaces !! 7)) -- y u no work
  , manageSpawn
  , manageDocks
  , manageHook def
  , manageScratchPad
  ]


-- myBar = "xmobar -x 0"
myBar = "xmobar -d ~/.config/xmobarrc"

myPPLayout "Tall" = "高"
myPPLayout "Mirror Tall" = "広"
myPPLayout "Full" = "全"
myPPLayout s = s
-- Hide NSP (scratchpad)
myPPHidden "NSP" = ""
myPPHidden s = s
myPP = xmobarPP { ppTitle = xmobarColor "#888888" "" . shorten 70
                , ppUrgent = xmobarColor "yellow" "red"
                , ppCurrent = \s -> xmobarColor "#eeeeee" "#552777" (s)
                , ppHidden = myPPHidden
                , ppLayout = myPPLayout
                -- TODO: FIX COMPILE ERROR
                -- , ppSort = fmap (.scratchpadFilterOutWorkspace) $ getSortByXineramaPhysicalRule
                }

toggleStrutsKey XConfig { XMonad.modMask = modMask} = (modMask, xK_b)

myStartupHook = setWMName "LG3D"
  >> spawnOn "九" "slack"

myConfig = def 
    { manageHook = myManageHook
    , startupHook = myStartupHook
    , layoutHook = myLayout --toggleLayouts (noBorders Full) $ smartBorders $ layoutHook def
    -- , logHook = dynamicLogWithPP defaultPP { ppSort = fmap (.scratchpadFilterOutWorkspace) $ ppSort defaultPP }
    -- , logHook = dynamicLogWithPP defaultPP { ppSort = fmap (.scratchpadFilterOutWorkspace) $ ppSort defaultPP }
    , terminal  =myTerminal
    , modMask   = modm
    , borderWidth = 1
    , focusedBorderColor = "#7700bb"
    , normalBorderColor = "#332255"
    , keys = legoKeys
    , workspaces = myWorkspaces
    }

-- trayerHook h = dynamicLogWithPP . xmobarPP
--                 { ppOutput = hPutStrLn h }
{-
myLogHook = dynamicLogWithPP $ xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "#33ee22" "" . shorten 70
                , ppUrgent = xmobarColor "yellow" "red"
                , ppCurrent = \s -> xmobarColor "#ee9a00" "" ("[" ++ s ++ "]")
                , ppSort = fmap (.scratchpadFilterOutWorkspace) $ getSortByXineramaPhysicalRule
                }
-}

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.25
    w = 1
    t = 1 - h
    l = 1 - w
