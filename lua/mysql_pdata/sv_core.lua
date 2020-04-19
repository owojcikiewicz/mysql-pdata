if !SERVER then return end

require("mysqloo")

MySQLData.CONN = MySQLData.CONN || nil

local PLAYER = FindMetaTable("Player")

function MySQLData:InitializeDatabase()
    if !self.CONN then 
        if MySQLData.Config.Debug then 
            print("[MySQL Data] Connection doesn't exist!") 
        end

        return 
    end

    local query = self.CONN:query([[CREATE TABLE IF NOT EXISTS data (
        key_id LONGTEXT NOT NULL,
        value LONGTEXT NULL
    );]])

    function query:onSuccess()
        if MySQLData.Config.Debug then
            print("[MySQL Data] Successfully created SQL table!")
        end
    end

    function query:onError(strError)
        if MySQLData.Config.Debug then 
            for i = 1, 5 do 
                print("[MySQL Data] Unsuccessfully created SQL table, error: "..strError)
            end
        end
    end

    query:start()
end

function MySQLData:ConnectDatabase()
    if self.CONN then 
        if MySQLData.Config.Debug then 
            print("[MySQL Data] Connection already exists!") 
        end

        self.CONN:ping() 
        return 
    end

    local db = mysqloo.connect(self.Config.Database.ip, self.Config.Database.user, self.Config.Database.password, self.Config.Database.db, self.Config.Database.port)

    function db:onConnected()
        if MySQLData.Config.Debug then
            print("[MySQL Data] Successfully connected to Database!")
        end

        MySQLData.CONN = db
        MySQLData:InitializeDatabase()
    end

    function db:onConnectionFailed(strError)
        if MySQLData.Config.Debug then
            for i = 1, 5 do 
                print("[MySQL Data] Unsuccessfully connected to database, error: "..strError)
            end
        end
    end

    db:connect()
end

function PLAYER:SetData(strKey, strData)
    local strSave = string.format("%s [%s]", self:SteamID64(), string.lower(tostring(strKey)))
    local strNick = self:Nick()

    self:GetData(strKey, function(strResult)
        if strResult == nil then 
            local query = MySQLData.CONN:query(string.format("INSERT INTO data (key_id, value) VALUES ('%s', '%s')", strSave, strData))

            function query:onSuccess()
                if MySQLData.Config.Debug then
                    print(string.format("[MySQL Data] Successfully set data %s for player %s!", strKey, strNick))
                end
            end

            function query:onError(strError)
                if MySQLData.Config.Debug then
                    for i = 1, 5 do 
                        print(string.format("[MySQL Data] Unsuccessfully set data %s for player %s, error: %s", strKey, strNick, strError))
                    end
                end
            end

            query:start()
        else
            local query = MySQLData.CONN:query(string.format("UPDATE data SET value = '%s' WHERE key_id = '%s'", strData, strSave))

            function query:onSuccess()
                if MySQLData.Config.Debug then
                    print(string.format("[MySQL Data] Successfully set data %s for player %s!", strKey, strNick))
                end
            end

            function query:onError(strError)
                if MySQLData.Config.Debug then
                    for i = 1, 5 do 
                        print(string.format("[MySQL Data] Unsuccessfully set data %s for player %s, error: %s", strKey, strNick, strError))
                    end
                end
            end

            query:start()
        end
    end)
end

function PLAYER:GetData(strKey, funcCallback)
    local strSave = string.format("%s [%s]", self:SteamID64(), string.lower(tostring(strKey)))
    local strNick = self:Nick()

    local query = MySQLData.CONN:query(string.format("SELECT value FROM data WHERE key_id = '%s'", strSave))

    function query:onSuccess(tblData)
        if MySQLData.Config.Debug then
            print(string.format("[MySQL Data] Successfully received data %s for player %s!", strKey, strNick))
        end

        if #tblData == 0 then 
            funcCallback(nil)
        else
            funcCallback(tblData[1].value)
        end
    end

    function query:onError(strError)
        if MySQLData.Config.Debug then
            for i = 1, 5 do 
                print(string.format("[MySQL Data] Unsuccessfully received data %s for player %s, error: %s", strKey, strNick, strError))
            end
        end
    end

    query:start()
end

MySQLData:ConnectDatabase()