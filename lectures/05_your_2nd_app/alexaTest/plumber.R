library(alexar)

#* @post /
#* @serializer unboxedJSON
function(req){
  dispatchAlexaRequest(req, intent=function(name, slots, ...){
    if (name=="intent1"){
      alexaResponse(output="This is how I respond to intent1!")
    } else if (name=="intent2"){
      alexaResponse(output="This is what I say to intent2!")
    }
  }, launch=function(){
    alexaResponse("You can ask for intent1 or intent2")
  })
}

