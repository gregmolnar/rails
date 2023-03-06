# frozen_string_literal: true

class Object
  # Sets and restore the provided attributes around a block.
  #
  #   client.timeout # => 5
  #   client.with(timeout: 1) do
  #     client.timeout # => 1
  #   end
  #   client.timeout # => 5
  #
  # This method is a shorthand for the common begin/ensure pattern:
  #
  #   old_value = object.attribute
  #   begin
  #     object.attribute = new_value
  #     # do things
  #   ensure
  #     object.attribute = old_value
  #   end
  #
  # It can be used on any object as long as both the reader and writer methods
  # are public.
  def with(**attributes)
    old_values = {}
    begin
      attributes.each do |key, value|
        old_values[key] = public_send(key)
        public_send("#{key}=", value)
      end
      yield
    ensure
      old_values.each do |key, old_value|
        public_send("#{key}=", old_value)
      end
    end
  end
end