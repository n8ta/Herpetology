require 'quiz/quiz_controller'
class RedirectController < ApplicationController

  def redir
    @taxons = [Taxon.find(7), Taxon.find(5), Taxon.find(9), Taxon.find(6)]
    render 'quiz/quiz/pick_taxon'
  end

end
