 require 'httparty'
 
class Kele
  include HTTPARTY
  
  def initialize(username, password)  
    
   response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {username: "username", password: 
   password})
   
   raise "invalid email/password" if response.code != 200
   
  end
end