var request=require('request');
const getFromAddress = (address) => {
    request.get('https://someplace',options,function(err,res,body){
      if(err){
        console.log("Error : " + err)
      }
      if(res.statusCode === 200){
        console.log("request processed correctly")
      } 
      
});
} 