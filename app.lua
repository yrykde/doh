-- lapis app for enabling JetBrain license
local lapis = require("lapis")
local pkey = require("openssl.pkey")
local digest = require("openssl.digest")
-- private key
local cert = [[-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBALecq3BwAI4YJZwhJ+snnDFj3lF3DMqNPorV6y5ZKXCiCMqj8OeO
mxk4YZW9aaV9ckl/zlAOI0mpB3pDT+Xlj2sCAwEAAQJAW6/aVD05qbsZHMvZuS2A
a5FpNNj0BDlf38hOtkhDzz/hkYb+EBYLLvldhgsD0OvRNy8yhz7EjaUqLCB0juIN
4QIhAMsJQ3xiJemnJ2pD65iRNCC/Kr7jtxbbBwa6ZFLjp12pAiEA54JCn41fF8GZ
90b9L5dtFQB2/yIcGX4Xo7bCvl8DaPMCIBgOZ+2T33QYtwXTOFXiVm/O1qy5ZFcT
6ng0m3BqwsjJAiEAqna/l7wAyP1E4U7kHqbhKxWsiTAUgLDXtzRbMNHFMQECIQCA
xlpXEPqnC3P8if0G9xHomqJ531rOJuzB8fNtRFmxnA==
-----END RSA PRIVATE KEY-----]]
local key = pkey.new(cert)
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
