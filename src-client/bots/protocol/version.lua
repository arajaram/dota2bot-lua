--
-- version message
--
local pack = require(GetScriptDirectory() .. "/utils/pack")

-- returned module
local version = {}

-- public
version.sent = false

local PROTOCOL_VERSION = "0.1.0"

-- public
function version.get()
  local ver = {}
  ver["protocol"] = PROTOCOL_VERSION
  -- return version
  return pack.pack(ver, "version");
end

return version
