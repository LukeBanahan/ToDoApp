require "test_helper"

# from Integration Testing, Week 10
# file: test/integration/create_todo_workflow_test.rb

# Note: see http://www.railsstatuscodes.com/ for response codes

class CreateTodoWorkflowTest < ActionDispatch::IntegrationTest

  test "should try to create a new todo that is completed" do
    # can reach the page
    get "/todos/new"
    assert_response :ok

    # can create a new entry
    post "/todos", params: {todo: {title: "Paint the house", completed: true}}
    # puts(response.parsed_body)
    assert_response :found
    assert_select "a", "redirected"

    # test new entry (five in total):
    # 4 test entries from test/fixtures/todos.yml + 1 new one added via post
    get "/todos"
    puts(response.parsed_body)
    assert_response :ok
    assert_select "div div", 5    # 4 + 1!
    ### assert_select "div div p strong", "Completed" ### check partial
    assert_select "div div p", "Title:\n    Paint the house"
  end

  test "should try to create a new todo that is NOT completed" do
    # can reach the page
    get "/todos/new"
    assert_response :ok

    # can create a new entry
    post "/todos", params: {todo: {title: "Cut the grass", completed: false}}
    # puts(response.parsed_body)
    assert_response :found
    assert_select "a", "redirected"

    # test new entry (five in total):
    # 4 test entries from test/fixtures/todos.yml + 1 new one added via post
    get "/todos"
    puts(response.parsed_body)
    assert_response :ok
    assert_select "div div", 5    # N+1 test entries, see test/fixtures/todos.yml
    ### assert_select "div div p strong", "In Progress" ### check partial
    assert_select "div div p", "Title:\n    Cut the grass"
  end

  test "should edit the cat todo entry" do
    todo = todos(:cat_task)
    get "/todos/#{todo.id}/edit"
    assert_response :ok

    patch "/todos/#{todo.id}", params: {todo: {title: "Buy cat food", completed: false}}
    assert_select "a", "redirected"
    assert_response :found

    get "/todos"
    assert_response :ok
    assert_select "div div", 4    # N test entries, see test/fixtures/todos.yml
    ### assert_select "div div p strong", "In Progress" ### check partials
    assert_select "div div p", "Title:\n    Buy cat food"
  end

end
