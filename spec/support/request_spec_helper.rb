module RequestSpecHelper
  def parsed_json
    JSON.parse(response.body, symbolize_names: true)
  end
end
