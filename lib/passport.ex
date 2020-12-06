defmodule Aoc2020.Passport do
  @moduledoc """
  Struct for the passport used in day 4's solution.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Ecto.Changeset

  @eye_colors ~w(amb blu brn gry grn hzl oth)

  embedded_schema do
    field(:byr, :integer)
    field(:cid, :string)
    field(:ecl, :string)
    field(:eyr, :integer)
    field(:hcl, :string)
    field(:hgt, :string)
    field(:iyr, :integer)
    field(:pid, :string)
  end

  def changeset(%Passport{} = passport, attrs, validation_level \\ :basic) do
    passport =
      passport
      |> cast(attrs, [:byr, :cid, :ecl, :eyr, :hcl, :hgt, :iyr, :pid])
      |> validate_required([:byr, :ecl, :eyr, :hcl, :hgt, :iyr, :pid])

    if validation_level == :strict do
      passport
      |> validate_inclusion(:byr, 1920..2002)
      |> validate_inclusion(:ecl, @eye_colors)
      |> validate_inclusion(:eyr, 2020..2030)
      |> validate_format(:hcl, ~r/^#[0-9a-f]{6}$/)
      |> validate_height()
      |> validate_inclusion(:iyr, 2010..2020)
      |> validate_format(:pid, ~r/^\d{9}$/)
    else
      passport
    end
  end

  def validate_height(%Changeset{valid?: false} = changeset), do: changeset

  def validate_height(%Changeset{} = changeset) do
    height =
      changeset
      |> get_field(:hgt, "0cm")
      |> Integer.parse()

    case is_height_valid?(height) do
      true -> changeset
      false -> add_error(changeset, :hgt, "hgt is invalid")
    end
  end

  def is_height_valid?({height, "cm"}), do: Enum.member?(150..193, height)
  def is_height_valid?({height, "in"}), do: Enum.member?(59..76, height)
  def is_height_valid?(_), do: false
end
