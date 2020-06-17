--- gamera plugin for STI
-- @author Sean Leffler
-- @copyright 2020
-- @license MIT/X11

local lg = require((...):gsub('plugins.gamera', 'graphics'))

return {
    gamera_LICENSE     = "MIT/X11",
	gamera_URL         = "https://github.com/karai17/Simple-Tiled-Implementation",
	gamera_VERSION     = "1.0.1",
	gamera_DESCRIPTION = "gamera hooks for STI.",

    --- Draw an STI map using a gamera camera instance's coordinate transform.
    -- @param camera The camera instance to use as a coordinate transform.
    -- This implementation is a work in progress! It may have graphical artifacts.
	gamera_draw = function(map, camera)
        local current_canvas = lg.getCanvas()
        lg.setCanvas(map.canvas)
        lg.clear()
        lg.push()
        lg.origin()

        -- Currently, we won't bother with gamera's visibility AABB.
        -- l, t, w, and h describe this bounding box; a potential
        -- optimization in the future might be to cull Tiled objects/tiles
        -- outside of it?
        -- TODO: Is tearing a problem with this implementation? Maybe fix similarly to `Map:draw`
        -- TODO: Scale post-draw similarly to `Map:draw`.
        camera:draw(function(l, t, w, h)
            -- This code comes directly from `Map:draw`.
            for _, layer in ipairs(map.layers) do
                if layer.visible and layer.opacity > 0 then
                    map:drawLayer(layer)
                end
            end
        end)

        lg.setCanvas(current_canvas)
        lg.draw(map.canvas)
        lg.pop()
    end
}