require 'test_helper'

class PastesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:paste)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_paste
    assert_difference('Paste.count') do
      post :create, :paste => { }
    end

    assert_redirected_to paste_path(assigns(:paste))
  end

  def test_should_show_paste
    get :show, :id => pastes(:one).id
    assert_response :success
  end

end
