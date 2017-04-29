defmodule Jirasaur.UserTask do
  use Jirasaur.Web, :model

  schema "usertasks" do
    field :started, Ecto.DateTime
    field :finished, Ecto.DateTime
    belongs_to :task, Jirasaur.Task
    belongs_to :user, Jirasaur.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:started, :finished])
    |> validate_required([:started, :finished])
  end
end
