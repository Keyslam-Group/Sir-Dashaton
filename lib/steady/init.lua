--MIT License
--Copyright (c) 2018 Arvid Gerstmann, Jake Besworth, Max, Pablo Mayobre, LÖVE Developers

--Original author: https://github.com/Leandros
--Max frame skip: https://github.com/jakebesworth
--Manual garbage collection: https://github.com/Geti
--Put it all together: https://github.com/Positive07
--Original love.run: LÖVE Developers

local conf = {
   --------- Update and Fixed update --------
   update_time = math.huge, --Max time spent updating the game
 
   ------ Fixed timestep configuration ------
   tick_rate = 1/120, --Fixed tick rate
   max_frame_skip = 25, --Max number of frames that can be skipped by fixed update
 
   ------------ GC configuration ------------
   gc_time = 1/600, --Max time dedicated to Garbage Collection per frame
   gc_steps = 1000, --Max number of Garbage Collection steps
   gc_safe_margin = 64, --When Garbage exceeds this number of MB, triggers a hard collection
 }
 
 if not love.event then
   require "love.event"
   love.createhandlers() --luacheck:ignore
 end
 
 if not love.timer then
   require "love.timer"
 end
 
 function love.run()
   if love.load then
     love.load(love.arg.parseGameArguments(arg), arg) --luacheck:ignore
   end
 
   -- We don't want the first frame's dt to include time taken by love.load.
   love.timer.step()
 
   local delta, lag = 0.0, 0.0
   local time = love.timer.getTime
 
   -- Main loop
   return function()
     love.event.pump() --Event handling
     for name, a,b,c,d,e,f in love.event.poll() do
       if name == "quit" then
         if not love.quit or not love.quit() then
           return a or 0
         end
       end
       love.handlers[name](a,b,c,d,e,f) --luacheck:ignore
     end
 
     do --Update and Fixed Update
       local startUpdate = time()
       delta = love.timer.step()
 
       --Lag can't exceed the frame skip margin
       lag = math.min(lag + delta, conf.tick_rate * conf.max_frame_skip)
 
       --Number of fixed time frames based on the lag and tick rate
       local frames = math.floor(lag/conf.tick_rate)
       --Remaining lag is taken into account in the next frame
       lag = lag % conf.tick_rate
 
       --Update
       if love.postUpdate then love.postUpdate(delta) end
 
       if love.update then
         for _=1, frames do
           --Don't exceed the allocated ammount of time for the update
           if startUpdate - time() > conf.update_time then break end
 
           --Fixed update
           love.update(conf.tick_rate)
         end
       end
     end
 
     if love.graphics.isActive() then --Rendering
       love.graphics.origin()
       love.graphics.clear(love.graphics.getBackgroundColor())
 
       local w, h = love.graphics.getDimensions()
       if love.draw then love.draw(w, h, lag) end
 
       love.graphics.present()
     end
 
     do --Garbage collection
       local start = time()
 
       --Respect the max number of collection steps
       for _=1, conf.gc_steps do
         --Don't exceed the allocated time
         if time() - start > conf.gc_time then break end
 
         --Small step each time, prevents some big spikes during collection
         --Still may cause some spikes with big sets
         collectgarbage("step", 1)
       end
 
       --Safety net, hard collect when the safety margin is reached
       if collectgarbage("count")/1024 > conf.gc_safe_margin then
         collectgarbage("collect")
       end
 
       --Don't garbage collect outside of this
       collectgarbage("stop")
     end
 
     love.timer.sleep(0.001)
   end
 end
 
 return conf
