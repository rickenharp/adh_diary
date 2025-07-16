module ROM
  class Changeset
    # Changeset specialization for upsert commands
    #
    # @see Changeset::Stateful
    #
    # @api public
    class Upsert < Stateful
      command_type :upsert

      def command
        super.new(relation)
      end
    end
  end
end
