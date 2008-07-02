require 'test_helper'

class PaginasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:paginas)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pagina
    assert_difference('Pagina.count') do
      post :create, :pagina => { }
    end

    assert_redirected_to pagina_path(assigns(:pagina))
  end

  def test_should_show_pagina
    get :show, :id => paginas(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => paginas(:one).id
    assert_response :success
  end

  def test_should_update_pagina
    put :update, :id => paginas(:one).id, :pagina => { }
    assert_redirected_to pagina_path(assigns(:pagina))
  end

  def test_should_destroy_pagina
    assert_difference('Pagina.count', -1) do
      delete :destroy, :id => paginas(:one).id
    end

    assert_redirected_to paginas_path
  end
end
