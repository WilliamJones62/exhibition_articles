class Article < ApplicationRecord
  belongs_to :user
  belongs_to :publication
  belongs_to :exhibition
end
