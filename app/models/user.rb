# frozen_string_literal: true

# User
#
#   Represents a registered user
#
class User < ApplicationRecord
  include Avatarable
  include CaseSensible
  include Sortable
  include Searchable

  #
  # Include default devise modules. Others available are:
  #   - :timeoutable
  #   - :omniauthable
  #
  devise :database_authenticatable, :lockable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :registerable

  #
  # Virtual attribute for authenticating by either username or email
  #
  attr_accessor :login

  #
  # Validations
  #
  # NOTE:  devise :validatable above adds validations for :email and :password
  #
  validates :username, presence: true, uniqueness: true
  validates :email, confirmation: true
  validates :bio, length: { maximum: 255 }, allow_blank: true

  scope :admins, -> { where(admin: true) }

  scope :banned,    -> { where.not(banned_at: nil) }
  scope :active,    -> { where(banned_at: nil) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  scope :order_recent_sign_in, -> { reorder(Booky::Database.nulls_last_order('current_sign_in_at', 'DESC')) }
  scope :order_oldest_sign_in, -> { reorder(Booky::Database.nulls_last_order('current_sign_in_at', 'ASC')) }

  scope :by_username, ->(usernames) { iwhere(username: Array(usernames).map(&:to_s)) }

  class << self
    #
    # Devise method overridden to allow sign in with email or username
    #
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)

      return find_by(conditions) if login.nil?

      where(conditions).find_by('lower(username) = :value OR lower(email) = :value', value: login.downcase.strip)
    end

    def sort_by_attribute(method)
      order_method = method || 'id_desc'

      case order_method.to_s
      when 'recent_sign_in' then order_recent_sign_in
      when 'oldest_sign_in' then order_oldest_sign_in
      else
        order_by(order_method)
      end
    end

    def filter(filter_name)
      case filter_name.to_s
      when 'admins'
        admins
      when 'banned'
        banned
      when 'confirmed'
        confirmed
      else
        active
      end
    end

    # Searches users matching the given query.
    #
    # NOTE : This method uses ILIKE on PostgreSQL and LIKE on MySQL.
    #
    # @param [String] query the search query as a String
    #
    # @return [ActiveRecord::Relation]
    #
    def search(query)
      return none if query.blank?

      query = query.downcase

      order = <<~SQL.squish
        CASE
          WHEN users.username = %{query} THEN 0
          WHEN users.email = %{query} THEN 1
          ELSE 2
        END
      SQL

      where(
        fuzzy_arel_match(:username, query, lower_exact_match: true).or(arel_table[:email].eq(query))
      ).reorder(format(order, query: ActiveRecord::Base.connection.quote(query)), :username)
    end

    # Limits the result set to users _not_ in the given query/list of IDs.
    #
    # users - The list of users to ignore. This can be an `ActiveRecord::Relation`, or an Array.
    #
    def where_not_in(users = nil)
      users ? where.not(id: users) : all
    end

    def reorder_by_username
      reorder(:username)
    end

    def by_login(login)
      return nil unless login

      if login.include?('@')
        unscoped.iwhere(email: login).take
      else
        unscoped.iwhere(username: login).take
      end
    end

    def find_by_username(username)
      by_username(username).take
    end

    def find_by_username!(username)
      by_username(username).take!
    end
  end
end
