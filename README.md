### MySQL PData
MySQL PData is a simple and effecient way to save strings using MySQL without the need of creating multiple, scattered out scripts relying on different databases and tables. The installation process is extremely straightforward, simply drag 'n' drop the repository contents and insert your database details in `lua/mysql_pdata/sv_config.lua`. 

### Usage 
Similarily to PData this only allows saving strings, that being said you're able to save data types that can be converted to string using [tostring](https://wiki.facepunch.com/gmod/Global.tostring), for example integers. You can also, in theory, store tables using [util.TableToJSON](https://wiki.facepunch.com/gmod/util.TableToJSON). This has not been intensively tested, which means there could be some errors or sub-optimal solutions - I encourage everyone to submit issues/pull requests.  

```lua
PLAYER:SetData(strKey, strData)` 
PLAYER:GetData(strKey, funcCallback(strData))
``` 
Example:
```lua
hook.Add("PlayerInitialSpawn", "MySQLPDataTest", function(pPlayer) 
    pPlayer:SetData("money", 1500) 
end) 

hook.Add("PlayerSay", "MySQLPDataTest", function(pPlayer, strText, bTeam) 
    pPlayer:GetData("money", function(strData) 
        pPlayer:ChatPrint("You currently have $"..strData.." in your wallet!") 
    end)
end)
```

### Credits
- SaturdaysHeroes (Code) 
- [fesh](https://steamcommunity.com/profiles/76561198139510546) (Help) 
- [GlorifiedPig](https://steamcommunity.com/id/GlorifiedPig/) (Idea & Help) 
