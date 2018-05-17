-- lapis app for enabling JetBrain license
local lapis = require("lapis")
local pkey = require("openssl.pkey")
local digest = require("openssl.digest")
-- private key
local cert = "2D2D2D2D2D424547494E205253412050524956415445204B45592D2D2D2D2D0A4D4949424F77494241414A42414" ..
        "C656371334277414934594A5A77684A2B736E6E44466A336C4633444D714E506F72563679355A4B584369434D716A384" ..
        "F654F0A6D786B34595A573961615639636B6C2F7A6C414F49306D7042337044542B586C6A3273434177454141514A415" ..
        "7362F61564430357162735A484D765A755332410A613546704E4E6A3042446C663338684F746B68447A7A2F686B59622" ..
        "B4542594C4C766C6468677344304F76524E793879687A37456A6155714C4342306A75494E0A34514968414D734A51337" ..
        "8694A656D6E4A327044363569524E43432F4B72376A74786262427761365A464C6A703132704169454135344A436E343" ..
        "1664638475A0A393062394C356474465142322F794963475834586F376243766C384461504D434942674F5A2B3254333" ..
        "35159747758544F465869566D2F4F317179355A4663540A366E67306D33427177736A4A41694541716E612F6C3777417" ..
        "95031453455376B487162684B78577369544155674C4458747A52624D4E48464D514543495143410A786C70584550716" ..
        "E43335038696630473978486F6D714A353331724F4A757A4238664E7452466D786E413D3D0A2D2D2D2D2D454E4420525" ..
        "3412050524956415445204B45592D2D2D2D2D"

function wtf()
    local result = ""
    for i = 1, #cert, 2 do
        local char = string.sub(cert, i, i+1)
        local binchar = tonumber(char, 16)
        result = result .. string.char(binchar)
    end
    print(result)
    return result
end

local key = pkey.new(wtf())

local app = lapis.Application()

function signed(con)
    print(con)
    local dig = digest.new("md5")
    dig:update(con)
    local s = key:sign(dig)
    local bytearr = {}
    for i=1, #s do
        table.insert(bytearr, string.format("%02x", string.byte(s, i)))
    end
    return table.concat(bytearr)
end

-- Routes
function app:default_route()
    return {status = 404, layout = false}
end

--app:get("/", function()
--  return "Welcome to Lapis " .. require("lapis.version")
--end)
--
app:match("/rpc/obtainTicket.action", function(self)
    local content = "<ObtainTicketResponse><message></message>" ..
        "<prolongationPeriod>607875500</prolongationPeriod><responseCode>OK</responseCode>" ..
        "<salt>" .. self.params.salt .. "</salt><ticketId>1</ticketId>" ..
        "<ticketProperties>licensee=" .. self.params.userName .. "\tlicenseType=0\t</ticketProperties>" ..
        "</ObtainTicketResponse>"
    local responce = "<!-- " .. signed(content) .. " -->\n" .. content
    return {layout = false, responce}
end)

app:match("/rpc/releaseTicket.action", function(self)
    local content = "<ReleaseTicketResponse><message></message><responseCode>OK</responseCode>" ..
        "<salt>" .. self.params.salt .. "</salt></ReleaseTicketResponse>"
    local responce = "<!-- " .. signed(content) .. " -->\n" .. content
    return {layout = false, responce}

end)

app:match("/rpc/prolongTicket.action", function(self)
    local content = "<ProlongTicketResponse><message></message><responseCode>OK</responseCode>" ..
        "<salt>" .. self.params.salt .. "</salt><ticketId>1</ticketId></ProlongTicketResponse>"
    local responce = "<!-- " .. signed(content) .. " -->\n" .. content
    return {layout = false, responce}
end)

app:match("/rpc/ping.action", function(self)
    local content = "<PingResponse><message></message><responseCode>OK</responseCode>" ..
        "<salt>" .. self.params.salt .. "</salt></PingResponse>"
    local responce = "<!-- " .. signed(content) .. " -->\n" .. content
    return {layout = false, responce}
end)

app:match("/rpc/ping.action", function(self)
    local content = "<PingResponse><message></message><responseCode>OK</responseCode>" ..
        "<salt>" .. self.params.salt .. "</salt></PingResponse>"
    local responce = "<!-- " .. signed(content) .. " -->\n" .. content
    return {layout = false, responce}
end)

return app
