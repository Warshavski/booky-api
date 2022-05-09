# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'authors' do
    let!(:authors) { create_pair(:author, :with_books) }

    let(:query) do
      %(query {
        authors {
          edges {
            node {
              id
              firstName
              lastName
              biography
              bornIn
              diedIn
              books {
                edges {
                  node {
                    id
                  }
                }
              }
              createdAt
              updatedAt
            }
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = authors.map do |author|
        {
          'node' => {
            'id' => author.id.to_s,
            'firstName' => author.first_name,
            'lastName' => author.last_name,
            'biography' => author.biography,
            'bornIn' => author.born_in&.iso8601,
            'diedIn' => author.died_in&.iso8601,
            'books' => {
              'edges' => author.books.map do |book|
                { 'node' => { 'id' => book.id.to_s } }
              end
            },
            'createdAt' => author.created_at.iso8601,
            'updatedAt' => author.updated_at.iso8601
          }
        }
      end

      actual_results = result.dig('data', 'authors', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'author' do
    let!(:author) { create(:author, :with_books) }

    let(:query) do
      %(query {
        author(id:#{author.id}) {
          id
          firstName
          lastName
          biography
          bornIn
          diedIn
          books {
            edges {
              node {
                id
              }
            }
          }
          createdAt
          updatedAt
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results =  {
        'id' => author.id.to_s,
        'firstName' => author.first_name,
        'lastName' => author.last_name,
        'biography' => author.biography,
        'bornIn' => author.born_in&.iso8601,
        'diedIn' => author.died_in&.iso8601,
        'books' => {
          'edges' => author.books.map do |book|
            { 'node' => { 'id' => book.id.to_s } }
          end
        },
        'createdAt' => author.created_at.iso8601,
        'updatedAt' => author.updated_at.iso8601
      }

      actual_results = result.dig('data', 'author')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'books' do
    let!(:books) { create_pair(:book, :with_authors, :with_genres) }

    let(:query) do
      %(query {
        books {
          edges {
            node {
              id
              title
              description
              pagesCount
              weight
              isbn10
              isbn13
              createdAt
              updatedAt
              publishedAt
              authors {
                id
              }
              genres {
                id
              }
            }
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = books.map do |item|
        {
          'node' => {
            'id' => item.id.to_s,
            'title' => item.title,
            'description' => item.description,
            'pagesCount' => item.pages_count,
            'weight' => item.weight,
            'isbn10' => item.isbn10,
            'isbn13' => item.isbn13,
            'createdAt' => item.created_at.iso8601,
            'updatedAt' => item.updated_at.iso8601,
            'publishedAt' => item.published_at.iso8601,
            'authors' => item.authors.map { |a| { 'id' => a.id.to_s } },
            'genres' => item.genres.map { |a| { 'id' => a.id.to_s } }
          }
        }
      end

      actual_results = result.dig('data', 'books', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'book' do
    let!(:book) { create(:book, :with_authors, :with_genres) }

    let(:query) do
      %(query {
        book(id:#{book.id}) {
          id
          title
          description
          pagesCount
          weight
          isbn10
          isbn13
          createdAt
          updatedAt
          publishedAt
          authors {
            id
          }
          genres {
            id
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = {
        'id' => book.id.to_s,
        'title' => book.title,
        'description' => book.description,
        'pagesCount' => book.pages_count,
        'weight' => book.weight,
        'isbn10' => book.isbn10,
        'isbn13' => book.isbn13,
        'createdAt' => book.created_at.iso8601,
        'updatedAt' => book.updated_at.iso8601,
        'publishedAt' => book.published_at.iso8601,
        'authors' => book.authors.map { |a| { 'id' => a.id.to_s } },
        'genres' => book.genres.map { |a| { 'id' => a.id.to_s } }
      }

      actual_results = result.dig('data', 'book')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'genres' do
    let!(:genres) { create_pair(:genre) }

    let(:query) do
      %(query {
        genres {
          edges {
            node {
              id
              name
              description
              createdAt
              updatedAt
            }
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = genres.map do |item|
        {
          'node' => {
            'id' => item.id.to_s,
            'name' => item.name,
            'description' => item.description,
            'createdAt' => item.created_at.iso8601,
            'updatedAt' => item.updated_at.iso8601
          }
        }
      end

      actual_results = result.dig('data', 'genres', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'genre' do
    let!(:genre) { create(:genre) }
    let!(:book) { create(:book, :with_authors, genres: [genre]) }

    let(:query) do
      %(query {
        genre(id:#{genre.id}) {
          id
          name
          description
          createdAt
          updatedAt
          books {
            edges {
              node {
                id
                title
                description
                pagesCount
                weight
                isbn10
                isbn13
                createdAt
                updatedAt
                publishedAt
                authors {
                  id
                }
              }
            }
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results =
        {
          'id' => genre.id.to_s,
          'name' => genre.name,
          'description' => genre.description,
          'createdAt' => genre.created_at.iso8601,
          'updatedAt' => genre.updated_at.iso8601,
          'books' => {
            'edges' => [
              {
                'node' => {
                  'id' => book.id.to_s,
                  'title' => book.title,
                  'description' => book.description,
                  'pagesCount' => book.pages_count,
                  'weight' => book.weight,
                  'isbn10' => book.isbn10,
                  'isbn13' => book.isbn13,
                  'createdAt' => book.created_at.iso8601,
                  'updatedAt' => book.updated_at.iso8601,
                  'publishedAt' => book.published_at.iso8601,
                  'authors' => book.authors.map { |a| { 'id' => a.id.to_s } }
                }
              }
            ]
          }
        }

      actual_results = result.dig('data', 'genre')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'publishers' do
    let!(:publishers) { create_pair(:publisher, :with_books) }

    let(:query) do
      %(query {
        publishers {
          edges {
            node {
              id
              name
              description
              email
              phone
              address
              postcode
              books {
                edges {
                  node {
                    id
                  }
                }
              }
              createdAt
              updatedAt
            }
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = publishers.map do |publisher|
        {
          'node' => {
            'id' => publisher.id.to_s,
            'name' => publisher.name,
            'description' => publisher.description,
            'email' => publisher.email,
            'phone' => publisher.phone,
            'address' => publisher.address,
            'postcode' => publisher.postcode,
            'books' => {
              'edges' => publisher.books.map do |book|
                { 'node' => { 'id' => book.id.to_s } }
              end
            },
            'createdAt' => publisher.created_at.iso8601,
            'updatedAt' => publisher.updated_at.iso8601
          }
        }
      end

      actual_results = result.dig('data', 'publishers', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'publisher' do
    let!(:publisher) { create(:publisher, :with_books) }

    let(:query) do
      %(query {
        publisher(id:#{publisher.id}) {
          id
          name
          description
          email
          phone
          address
          postcode
          books {
            edges {
              node {
                id
              }
            }
          }
          createdAt
          updatedAt
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results =  {
        'id' => publisher.id.to_s,
        'name' => publisher.name,
        'description' => publisher.description,
        'email' => publisher.email,
        'phone' => publisher.phone,
        'address' => publisher.address,
        'postcode' => publisher.postcode,
        'books' => {
          'edges' => publisher.books.map do |book|
            { 'node' => { 'id' => book.id.to_s } }
          end
        },
        'createdAt' => publisher.created_at.iso8601,
        'updatedAt' => publisher.updated_at.iso8601
      }

      actual_results = result.dig('data', 'publisher')

      expect(actual_results).to match_array(expected_results)
    end
  end
end
