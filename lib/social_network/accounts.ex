defmodule SocialNetwork.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias SocialNetwork.Repo
  alias SocialNetwork.Accounts.{User, Profile, Friend}

  def friends_and_subs(user_id) do
    Repo.all(
      from f in Friend,
      join: u in User,
      where: u.id == f.first_user_id or u.id == f.second_user_id,
      where: u.id != ^user_id and (f.first_user_id == ^user_id or f.second_user_id == ^user_id),
      select: %{user: u, state: f.state}
    )
  end

  def add_friend(user_id, friend_id) do
  end

	@doc """
	Return user found by username

	## Example
			iex> find_by_username("Bob")
			%User{username: "Bob"}

	"""

	def find_by_username(username) do
		Repo.one(from u in User, where: u.username == ^username, preload: :profile)
	end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(_, _) do
    {:ok, Repo.all(User)}
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(Map.merge(attrs, %{profile: %{}}))
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

	def update_user_profile(%{user_id: user_id} = params) do
		Repo.one(from p in Profile, where: p.user_id == ^user_id)
		|> Profile.changeset(params)
		|> Repo.update
	end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
