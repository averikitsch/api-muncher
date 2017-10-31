require 'httparty'

class ApiMuncherWrapper
  # Your code here!
  BASE_URL = "https://api.edamam.com/search"
  APP_ID = ENV["APP_ID"]
  APP_KEY = ENV["APP_KEY"]
  NUMBER_OF_ENTRIES = 30

  def self.search_recipes(name)
    url = BASE_URL + "?q=#{name.gsub(' ', '+')}&app_id=#{APP_ID}&app_key=#{APP_KEY}&to=#{NUMBER_OF_ENTRIES}"
    data = HTTParty.get(url)
    if data["hits"]
      recipes = data["hits"].map do |hash|
        recipe = hash["recipe"]
        Recipe.new(recipe["label"],
        recipe["uri"],
        image: recipe["image"] #,
        # source: recipe["source"],
        # url: recipe["url"],
        # yield: recipe["yield"],
        # calories: recipe["calories"],
        # labels: recipe["healthLabels"],
        # diets: recipe["dietLabels"],
        # ingredients: recipe["ingredientLines"],
        # dietary: recipe["digest"]
        )
      end
      return recipes
    else
      return []
    end
  end

  def self.find_recipes(uri)

    url = BASE_URL +
    "?r=http://www.edamam.com/ontologies/edamam.owl%23recipe_#{uri}&app_id=#{APP_ID}&app_key=#{APP_KEY}"
    recipe = HTTParty.get(url).parsed_response[0]
    return Recipe.new(recipe["label"],
        recipe["uri"],
        image: recipe["image"],
        source: recipe["source"],
        url: recipe["url"],
        yield: recipe["yield"],
        calories: recipe["calories"],
        labels: recipe["healthLabels"],
        diets: recipe["dietLabels"],
        ingredients: recipe["ingredientLines"],
        dietary: recipe["digest"])
  end
  # def self.send_msg(channel, msg)
  #   p "Sending #{msg} to channel: #{channel}"
  #
  #   url = BASE_URL + "chat.postMessage?token=#{TOKEN}"
  #
  #   response = HTTParty.post(url,
  #   body: {"text"=> "#{msg}", "channel"=>"#{channel}",
  #   "username"=> "KHALEESI", "icon_emoji"=>":khaleesi:",
  #   "as_user" => "false"},
  #   :headers => { 'Content-Type' => 'application/x-www-form-urlencoded'})
  #
  #   return response.success?
  # end
end