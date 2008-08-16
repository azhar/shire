require 'amazon/ecs'
class AdminController < ApplicationController
  def index
    @titles = []
    @authors = []
    Amazon::Ecs.options = {:aWS_access_key_id => ['00D8NKFQ2R8W9EC0J182']}
    res = Amazon::Ecs.item_search('Armadale', :country => :uk)
    res.items.each do |item|
      # retrieve string value using XML path
      item.get('asin')
      item.get('itemattributes/title')
      atts = item.search_and_convert('itemattributes')
      @titles.push atts.get('title')
      @authors.push atts.get('author')
   end
 end
end
