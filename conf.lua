function love.conf(t)
   t.identity              = "Dashaton"
   t.appendidentity        = false
   t.version               = "11.1"
   t.console               = true
   t.accelerometerjoystick = false
   t.externalstorage       = false
   t.gammacorrect          = true

   t.audio.mixwithsystem = true

   t.window.title          = "Dashaton LD 42"
   t.window.icon           = nil
   t.window.width          = 1280
   t.window.height         = 720
   t.window.borderless     = false
   t.window.resizable      = false
   t.window.minwidth       = 1
   t.window.minheight      = 1
   t.window.fullscreen     = false
   t.window.fullscreentype = "desktop"
   t.window.vsync          = 0
   t.window.msaa           = 0
   t.window.display        = 1
   t.window.highdpi        = false
   t.window.x              = nil
   t.window.y              = nil

   t.modules.audio    = true
   t.modules.data     = false
   t.modules.event    = true
   t.modules.font     = true
   t.modules.graphics = true
   t.modules.image    = true
   t.modules.joystick = true
   t.modules.keyboard = true
   t.modules.math     = true
   t.modules.mouse    = true
   t.modules.physics  = false
   t.modules.sound    = true
   t.modules.system   = true
   t.modules.thread   = false
   t.modules.timer    = true
   t.modules.touch    = false
   t.modules.video    = false
   t.modules.window   = true
end
