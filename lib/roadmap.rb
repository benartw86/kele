module Roadmap

  def get_roadmap(roadmap_id)
    url = "https://www.bloc.io/api/v1/roadmaps/#{roadmap_id}"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end
  
  def get_checkpoint(checkpoint_id)
    url = "https://www.bloc.io/api/v1/checkpoints/#{checkpoint_id}"  
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
end