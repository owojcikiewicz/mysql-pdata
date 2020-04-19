if !SERVER then return end

MySQLData = MySQLData || {}
MySQLData.Config = MySQLData.Config || {}

-- Which database should be used? 
MySQLData.Config.Database = {
    db = "",
    user = "",
    password = "",
    port = 3306,
    ip = ""
}

-- Should debug prints be enabled? 
MySQLData.Config.Debug = false
