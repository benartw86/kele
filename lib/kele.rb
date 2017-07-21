 require 'httparty'
 require 'json'
 require './lib/roadmap.rb'
 
class Kele
  include HTTParty
  include Roadmap
  
  def initialize(email, password)
     response = self.class.post(base_url("sessions"), body: { "email": email, "password": 
     password })
    raise "invalid email/password" if response.code != 200
    @auth_token = response["auth_token"] 
  end
  
  def get_me
    response = self.class.get(base_url("users/me"), headers: { "authorization" => @auth_token })
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
    url = "message_threads"    
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    @messages = JSON.parse(response.body)
  end
  
  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post(base_url("messages"), headers: { "authorization" => @auth_token }, 
    body: { 
      "sender": sender, 
      "recipient_id": recipient_id, 
      "token": token, 
      "subject": subject, 
      "stripped-text": stripped_text 
    })
    response
  end
  
  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post(base_url("checkpoint_submissions"), headers: { "authorization" => @auth_token }, 
    body: {
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "checkpoint_id": checkpoint_id,
      "comment": comment,
      "enrollment_id": enrollment_id
    })
    response
  end
  
  private
  
  def base_url(uri)
    "https://www.bloc.io/api/v1/#{uri}"
  end
end

