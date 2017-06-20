library(alexar)

#* @post /
#* @serializer unboxedJSON
function(req){
  dispatchAlexaRequest(req, intent=function(name, slots, ...){
    if (name=="askIntent"){
      alexaResponse(output="Thank you for asking, but try with some manners!")
    } else if (name=="pleaseIntent"){
      alexaResponse(output="You said the magic word!")
    }
  }, launch=function(){
    alexaResponse("You can ask to test the app, try using please")
  })
}

