class PagesController < ApplicationController
  def home
    @game = GameFactory.build
  end
end
