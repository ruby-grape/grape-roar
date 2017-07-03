# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Exceptions
          class InvalidRelationError < StandardError; end
          class UnsupportedRelationError < StandardError; end
        end
      end
    end
  end
end
