--- === RandomBackground ===
---
--- Use Unsplash API to set a random background image for your desktop
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/BingDaily.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/BingDaily.spoon.zip)
--- Download: [TODO](TODO)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "RandomBackground"
obj.version = "0.1"
obj.author = "Rodrigo Medina <rodrigo.medina.neri@gmail.com>"
obj.homepage = "https://github.com/roeeyn/RandomBackground.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"


local logger = hs.logger.new(obj.name, "debug")

local function curl_download_callback(exitCode, stdOut, stdErr)
    if exitCode == 0 then
        obj.task = nil
        hs.screen.mainScreen():desktopImageURL("file://" .. obj.localpath)
        logger.d("New background set successfully")
    else
        logger.d("Error downloading image from parsed JSON API response")
        logger.d(stdOut, stdErr)
    end
end

local function get_download_link(response_body)
    local ok, decoded_data = pcall(hs.json.decode, response_body)
    if ok then
        return decoded_data.links.download
    else
        return nil
    end
end

local function download_img_request(image_url)
    -- cancel any pending request
    if obj.task then
        obj.task:terminate()
        obj.task = nil
    end

    logger.d("Downloading image: " .. image_url)

    local temp_img_name = hs.hash.SHA1(hs.timer.absoluteTime())

    -- set as download path the Trash folder, as we only want to set the wallpaper once
    obj.localpath = os.getenv("HOME") .. "/.Trash/" .. temp_img_name .. "_background.jpg"
    obj.task = hs.task.new("/usr/bin/curl", curl_download_callback, { "-L", image_url, "-o", obj.localpath })
    obj.task:start()
end

local function set_new_background()
    logger.d("Setting new background papirrin")

    hs.http.asyncGet(obj.unsplash_api_url, {}, function(stat, body, header)
        logger.d("Received response from unsplash")
        logger.d("Remaining Rate Limit: ", header["X-Ratelimit-Remaining"])

        if stat ~= 200 then
            logger.d("Unsplash API get random image failed")
            return false
        end

        logger.d("Successful response status. Processing download link")

        local download_link = get_download_link(body)
        if download_link == nil then
            logger.d("Unsplash API response JSON parsing failed")
            return false
        end

        logger.d("Successful download link parsing.")

        return pcall(download_img_request, download_link)
    end)
end

function obj:start()
    -- https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#how-do-i-create-a-spoon
    -- From the docs...
    -- If your Spoon provides some kind of background activity, e.g. timers, watchers, spotlight searches, etc. you should generally activate them in a :start() method, and de-activate them in a :stop() method

    if obj.unsplash_api_key == nil or obj.unsplash_api_key == "" then
        error("There's no Unsplash API key or it is empty.")
    end

    logger.d("Received API Key: ", obj.unsplash_api_key)

    local UNSPLASH_API_URL = "https://api.unsplash.com/photos/random/?orientation=landscape&client_id="
    obj.unsplash_api_url = UNSPLASH_API_URL .. obj.unsplash_api_key

    logger.d("Started the cosa")
    if obj.timer == nil then
        obj.timer = hs.timer.doEvery(3 * 60 * 60, set_new_background)
        obj.timer:setNextTrigger(5)
    else
        obj.timer:start()
    end
end

function obj:stop()
    logger.d("Stopped the RandomBackground spoon")
    if obj.timer ~= nil then
        obj.timer:stop()
    end
end


function obj:init()
    -- https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#how-do-i-create-a-spoon
    -- From the docs...
    -- If the object you return has an :init() method, Hammerspoon will call it automatically (although users can override this behaviour, so be sure to document your :init() method).
    -- In the :init() method, you should do any work that is necessary to prepare resources for later use, although generally you should not be starting any timers/watchers/etc. or mapping any hotkeys here.
    -- In this case it won't work as the api key is received from the config table and would be accessible until the setup is done. i.e. start()
    logger.d("Init the RandomBackground spoon")
end

return obj
