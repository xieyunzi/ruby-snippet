require 'json'

res = %q({
 "client"   : {
    "friendlyName" : "76598140",
    "appId"        : "e462aba25bc6498fa5ada7eefe1401b7",
    "charge"       : "1",
    "mobile"       : "18612345678",
    "clientType"   : "1"
    }
})

puts JSON.parse(res)['client']
