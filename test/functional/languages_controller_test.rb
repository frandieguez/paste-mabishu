require 'test_helper'

class LanguagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:languages)
  end
  def show
    get :show
    assert_response :success
    assert_not_nil assigns(:languages)
  end


end
