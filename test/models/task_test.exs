defmodule Shtask.TaskTest do
  use Shtask.ModelCase
  import Shtask.Fixtures
  alias Shtask.Task

  @valid_attrs %{name: "JIRA-XXZ", task_type_id: 1, task_status_id: 1}
  #@tasktype %{name:"task"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "task name can't be empty" do
    attrs = %{@valid_attrs | name: ""}
    changeset = Task.changeset(%Task{}, attrs)
    refute changeset.valid?
  end


  test "task name should be unique" do
    task = fixture(:task)
    attrs = %{@valid_attrs | task_type_id: task.task_type_id}
    attrs = %{attrs | task_status_id: task.task_status_id}
    attrs = %{attrs | name: task.name}
    changeset = Task.changeset(%Task{}, attrs)
    assert {:error, _inserted_user} = Shtask.Repo.insert(changeset)
    
  end

  test "task type id should be valid" do
    attrs = %{@valid_attrs | task_type_id: nil}
    changeset = Task.changeset(%Task{}, attrs)
    refute changeset.valid?
  end

  test "task status id should be valid" do
    attrs = %{@valid_attrs | task_status_id: nil}
    changeset = Task.changeset(%Task{}, attrs)
    refute changeset.valid?
  end

  test "task should have no users" do
    task = fixture(:task)
    #task = Task |> Shtask.Repo.get(task.id) |> Shtask.Repo.preload([:users])
    task = Task.preload(task.id)
    length = Kernel.length(task.users)
    assert  length == 0
  end

  test "task should have a user" do
    user_task = fixture(:user_task)
    task = Shtask.Task.preload(user_task.task_id)
    length = Kernel.length(task.users)
    assert  length == 1
  end

  test "task should have a UserTask" do
    user_task = fixture(:user_task)
    task = Shtask.Task.preload(user_task.task_id)
    length = Kernel.length(task.user_tasks)
    assert  length == 1
  end


end
