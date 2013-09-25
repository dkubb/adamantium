# encoding: utf-8

module Adamantium

  # Key type used for memoized methods
  #
  # Since arguments passed into a memoized method could be mutable, their #hash
  # key should be pre-computed so that any subsequent mutations to those
  # arguments don't affect the hash lookup of the memoized value. This approach
  # can also limit memory leaks that could be caused by using the entire
  # argument array as part of the hash key.
  #
  # @private
  #
  class SendKey

    # Initialize a key
    #
    # @return [undefined]
    #
    def initialize(method_name, args)
      @hash = method_name.hash ^ args.hash
      freeze
    end

    # @return [Fixnum]
    attr_reader :hash

    # Compare with another key
    #
    # @param [SendKey] other
    #
    # @return [Boolean]
    #
    def eql?(other)
      other.is_a?(self.class) && other.hash.eql?(hash)
    end
  end # SendKey

end # Adamantium