# encoding: utf-8

module Adamantium

  # Methods mixed in to adamantium classes
  module ClassMethods

    # Instantiate a new frozen object
    #
    # @example
    #   object = AdamantiumClass.new  # object is frozen
    #
    # @return [Object]
    #
    # @api public
    def new(*)
      freezer.freeze(super)
    end

  end # module ClassMethods
end # module Adamantium
