 require 'httparty'
 require 'json'
 require './lib/roadmap.rb'
 
class Kele
  include HTTParty
  include Roadmap
  
  def initialize(email, password)
     response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { "email": email, "password": 
     password })
    raise "invalid email/password" if response.code != 200
    @auth_token = response["auth_token"] 
  end
  
  def get_me
    url = "https://www.bloc.io/api/v1/users/me"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end
  
  def get_mentor_availability(mentor_id)
    url = "https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability"  
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    available = []
    @mentor_availability = JSON.parse(response.body).each do |time|
      if time["booked"] == nil
        available << time
      end
    end
    available
  end
  
  def get_messages
    url = "https://www.bloc.io/api/v1/message_threads"    
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    @messages = JSON.parse(response.body)
  end
  
  def create_message(sender, recipient_id, token, subject, stripped_text)
    url = "https://www.bloc.io/api/v1/messages"    
    response = self.class.post(url, headers: { "authorization" => @auth_token }, 
    body: { 
      "sender": sender, 
      "recipient_id": recipient_id, 
      "token": token, 
      "subject": subject, 
      "stripped_text": stripped_text 
    })
  end
  
  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    url = "https://www.bloc.io/api/v1/checkpoint_submissions"
    response = self.class.post(url, headers: { "authorization" => @auth_token }, 
    body: {
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "checkpoint_id": checkpoint_id,
      "comment": comment,
      "enrollment_id": enrollment_id
    })
  end
end

