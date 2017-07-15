 require 'httparty'
 require 'json'
 
class Kele
  include HTTParty
  
  def initialize(username, password)
     response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { "username": username, "password": 
     password })
    raise "invalid email/password" if response.code != 200
    @auth_token = response["auth_token"] 
  end
  
  def get_me
    url = "https://www.bloc.io/api/v1/users/me"
    response = self.class.get(url, headers: { "authorization" => auth_token })
    @user = JSON.parse(response.body)
  end
end