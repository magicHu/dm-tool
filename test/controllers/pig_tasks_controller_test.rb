require 'test_helper'

class PigTasksControllerTest < ActionController::TestCase
  setup do
    @pig_task = pig_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pig_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pig_task" do
    assert_difference('PigTask.count') do
      post :create, pig_task: { command: @pig_task.command }
    end

    assert_redirected_to pig_task_path(assigns(:pig_task))
  end

  test "should show pig_task" do
    get :show, id: @pig_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pig_task
    assert_response :success
  end

  test "should update pig_task" do
    patch :update, id: @pig_task, pig_task: { command: @pig_task.command }
    assert_redirected_to pig_task_path(assigns(:pig_task))
  end

  test "should destroy pig_task" do
    assert_difference('PigTask.count', -1) do
      delete :destroy, id: @pig_task
    end

    assert_redirected_to pig_tasks_path
  end
end
