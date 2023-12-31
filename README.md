# RandomBackground.spoon

`RandomBackground.spoon` is a Spoon package for Hammerspoon, that sets a random desktop background for your Mac, using the Unsplash API.

## Features

- Automatically changes your Mac desktop background at regular intervals.
- Uses high-quality, random images from Unsplash.

## Prerequisites

- [Hammerspoon](http://www.hammerspoon.org/): A powerful automation tool for OS X.
- Unsplash API key: Required for fetching images from Unsplash.

## Getting the Unsplash API Key

1. Go to [Unsplash Developers](https://unsplash.com/developers).
2. Register as a developer.
3. Create a new app and accept the API/developer terms. (`Demo` type has been enough for me)
4. Your **Access Key** (`NOT Secret Key`) is your Unsplash API key, and it should keep private always.

## Usage

After downloading the ZIP of the project, and uncompressing it as `~/.hammerspoon/Spoons/RandomBackground.spoon/`:

### Saving the API Key in a File (Recommended)

For convenience and security, you may choose to store your Unsplash API key in a dedicated file named `.unsplash_api_key` located in your home directory.

To create this file, first copy your API key to your clipboard, then execute the following command in your terminal: `pbpaste > ~/.unsplash_api_key`. This command pastes your copied key into the newly created file.

Once this step is complete, you can read the API key from this file within your `init.lua` script and use it to configure the `RandomBackground` spoon. The following snippet provides an example of how this can be achieved:

```lua
local function read_api_key(file_path)
    local file = io.open(file_path, 'r') -- open in read mode
    if not file then
        return nil
    end

    local content = file:read '*a' -- *a or *all reads the entire file
    file:close()

    return content:gsub('%s+$', '') -- remove trailing spaces
end

-- Assumes that the API Key is stored in ~/.unsplash_api_key
local api_key = read_api_key(os.getenv("HOME") .. "/.unsplash_api_key")

-- After installing the spoon
hs.spoons.use('RandomBackground', {
    -- OPTIONAL: Uncomment this line to enable printing of debug messages to the console.
    -- loglevel = 'debug',
    config = {
        -- REQUIRED: Your Unsplash API KEY
        unsplash_api_key = api_key
    },
    -- REQUIRED: To start the task that will download and set the desktop image.
    start = true,
}, true)
```

### Directly Setting the API Key

You can directly set the API key in your Hammerspoon configuration:

```lua
-- After installing the spoon
hs.spoons.use('RandomBackground', {
    -- OPTIONAL: Uncomment this line if you want to print debugging messages in the console.
    -- loglevel = 'debug',
    config = {
        -- REQUIRED: Your Unsplash API KEY
        unsplash_api_key = 'replace_this_with_your_unsplash_api_key'
    },
    -- REQUIRED: to start the task that will download and set the desktop image.
    start = true,
}, true)
```

### With Environment Variable

Using environment variables for storing sensitive data like API keys is an important and recommended practice in software development. It keeps your sensitive data out of your codebase and thus out of version control systems like git, which can be crucial for security, especially in open-source projects.

To set an environment variable, you need to define it in your shell's configuration file. For Zsh, which is the default shell in macOS Catalina and later, you should add the export line to your `~/.zprofile` file.

Open `~/.zprofile` in a text editor (create the file if it doesn't exist), and add the following line:

```sh
export UNSPLASH_API_KEY=replace_this_with_your_unsplash_api_key
```

Save and close the file, then restart your terminal or run `source ~/.zprofile` to make the changes take effect.

After setting the environment variable, you can access it in your Hammerspoon configuration as shown:

```lua
-- After installing the spoon
hs.spoons.use('RandomBackground', {
    -- OPTIONAL: Uncomment this line if you want to print debugging messages in the console.
    -- loglevel = 'debug',
    config = {
        -- REQUIRED: Your Unsplash API KEY
        unsplash_api_key = os.getenv('UNSPLASH_API_KEY')
    },
    -- REQUIRED: to start the task that will download and set the desktop image.
    start = true,
}, true)
```

## Contributing

All suggestions and feedback are welcome!

1. Fork the Project
1. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
1. Setup pre-commit (`pre-commit install`)
1. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
1. Push to the Branch (`git push origin feature/AmazingFeature`)
1. Open a Pull Request

## License

Distributed under the MIT License. See LICENSE for more information.
