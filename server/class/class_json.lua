JsonDB = {};
JsonDB.__index = JsonDB;

function JsonDB.new(resourceName, beautify, timedSave, saveInterval, debug)
  local self = setmetatable({}, JsonDB);
  self.resourceName = resourceName;
  self.timedSave = timedSave;
  self.saveInterval = saveInterval or 60000;
  self.debug = debug;
  self.collections = {};
  self.path = _JSON.Path;
  self.beautify = beautify;
  Console.Success(("[DATABASE] path: %s"):format(_JSON.Path));
  return self;
end
local function detectCircularReferences(tbl, visited)
  visited = visited or {}
  if visited[tbl] then
      return true
  end
  visited[tbl] = true
  for _, v in pairs(tbl) do
      if type(v) == "table" then
          if detectCircularReferences(v, visited) then
              return true
          end
      end
  end
  visited[tbl] = nil
  return false
end

function JsonDB.save(self, collection)
  function saveCollection(collection)

    local collectionFile = ("%s%s.json"):format(self.path, collection);
    SaveResourceFile(self.resourceName, collectionFile, json.encode(self.collections[collection], self.beautify and { indent = true, level = 2 } or nil), -1);
    Console.Success(("[DATABASE] Saved collection %s"):format(collection));
  end

  if collection then
    saveCollection(collection);
  else
    for collection, _ in pairs(self.collections) do
      saveCollection(collection);
    end
  end

  return self;
end

function JsonDB.init(self, collections)
  for idx, collection in ipairs(collections) do
    local collectionFile = ("%s%s.json"):format(self.path, collection);
    local collectionData = LoadResourceFile(self.resourceName, collectionFile);
    if collectionData then
      self.collections[collection] = json.decode(collectionData);
      Console.Success(("[DATABASE] Loaded collection %s"):format(collection));
    else
      self.collections[collection] = {};
      Console.Success(("[DATABASE] Created collection %s"):format(collection));
    end
  end

  if self.timedSave then
    Console.Success(("[DATABASE] Saving json every %s seconds"):format(self.saveInterval / 1000));
    self.saveTimer = function()
      self:save();
      SetTimeout(self.saveInterval, self.saveTimer);
    end
    self.saveTimer();
  end

  Console.Success(("[DATABASE] initialized"));

  return self;
end

function JsonDB.update(self, collection, key, value)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end

  self.collections[collection][key] = value;
  Console.Success(("[DATABASE] Updated %s in %s"):format(key, collection));

  if not self.timedSave then
    self:save(collection);
  end
end

function JsonDB.delete(self, collection, key)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end

  self.collections[collection][key] = nil;
  Console.Success(("[DATABASE] Deleted %s from %s"):format(key, collection));

  if not self.timedSave then
    self:save(collection);
  end
end

function JsonDB.get(self, collection, key)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end

  return self.collections[collection][key];
end

function JsonDB.getAll(self, collection)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end

  return self.collections[collection];
end

function JsonDB.insert(self, collection, key, value)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end

  if self.collections[collection][key] then
    Console.Error(("[DATABASE] Key %s already exists in %s"):format(key, collection));
    return false;
  end

  self.collections[collection][key] = value;
  Console.Success(("[DATABASE] Inserted %s into %s"):format(key, collection));
  if not self.timedSave then
    self:save(collection);
  end
end

function JsonDB.insertAll(self, collection, data)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end

  for key, value in pairs(data) do
    if self.collections[collection][key] then
      Console.Error(("[DATABASE] Key %s already exists in %s"):format(key, collection));
      return false;
    end

    self.collections[collection][key] = value;
  end

  Console.Success(("[DATABASE] Inserted %s keys into %s"):format(#data, collection));

  if not self.timedSave then
    self:save(collection);
  end
end

function JsonDB.search(self, collection, key, value)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end
  
  for k, v in pairs(self.collections[collection]) do
    if v[key] == value then
      return v;
    end
  end
end

function JsonDB.searchAll(self, collection, key, value)
  if not self.collections[collection] then
    Console.Error(("[DATABASE] Collection %s does not exist"):format(collection));
    return false;
  end
  
  local results = {};
  for k, v in pairs(self.collections[collection]) do
    if v[key] == value then
      table.insert(results, v);
    end
  end
  
  return results;
end