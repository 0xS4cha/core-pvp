Console = {};

---@param ... string
function Console.Error(...)
  local args = {...} 
  local output = table.concat(args, ", ") 

  print('^1[ERROR]:^0 ' .. output .. '^0');
end

---@param ... string
function Console.Debug(...)
  if not _CONFIG.Debug  then
    return;
  end

  local line = debug.getinfo(2, 'l').currentline;
  local file = debug.getinfo(2, 'S').source:sub(2);
  local args = {...} 
  local output = table.concat(args, ", ") 
  print('^4[DEBUG]:^0 (' .. file .. ':' .. line .. ')^3 ' .. output .. '^0');
end

---@param ... string
function Console.Log(...)
  local args = {...} 
  local output = table.concat(args, ", ") 
  print('^5[INFO]:^0 ' .. output .. '^0');
end

function Console.debugPrint(data)
  local function cpy(t)
      local seen = {}
      local function _cpy(t)
          if type(t) ~= "table" then
              return tostring(t)
          elseif seen[t] then
              return seen[t]
          end
          local s = {}
          seen[t] = s
          for k, v in pairs(t) do
              s[_cpy(k)] = _cpy(v)
          end
          return setmetatable(s, getmetatable(t))
      end
      return _cpy(t)
  end
  print(json.encode(cpy(data), { indent = true }))
end
---@param ... string
function Console.Warn(...)
  local args = {...} 
  local output = table.concat(args, ", ") 
  print('^3[WARN]:^0 ' .. output .. '^0');
end

---@param ... string
function Console.Success(...)
  local args = {...} 
  local output = table.concat(args, ", ") 
  print('^2[SUCCESS]:^0 ' .. output .. '^0');
end



---@param ... string
function Console.Version(...)
  local args = {...} 
  local output = table.concat(args, ", ") 
  print('^1[VERSION]:^0 ' .. output .. '^0');
end


