require 'test_helper'

class PaginasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:paginas)
  end

  def test_should_show_pagina
    get :show, :id => paginas(:one).id
    assert_response :success
  end
end
