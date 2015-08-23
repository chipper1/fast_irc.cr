private macro slice_getter(name)
    def {{name.id}}
        unless @{{name.id}}
            if ({{name.id}}_start = @{{name.id}}_start) && ({{name.id}}_length = @{{name.id}}_length)
                @{{name.id}} = String.new @str[{{name.id}}_start, {{name.id}}_length]
            end
        end
        @{{name.id}}
    end
end

module FastIrc
    struct Prefix
        slice_getter target
        slice_getter user
        slice_getter host

        def_equals target, user, host

        private def initialize(@str : Slice(UInt8), @target_start, @target_length, @user_start = nil, @user_length = nil, @host_start = nil, @host_length = nil)
        end

        def initialize(@target, @user, @host)
            @str = Slice(UInt8).new(0)
        end

        def inspect(io)
            io << "Prefix(@target=#{target}, @user=#{user}, @host=#{host})"
        end

        def to_s(io)
            io << ":"
            io << target

            if user = user
                io << '!'
                io << user
            end

            if host = host
                io << '@'
                io << host
            end
        end

        alias_method to_irc, to_s
    end

    struct Message
        getter      prefix
        slice_getter command

        def_equals prefix, command, params

        private def initialize(@str : Slice(UInt8), @prefix, @command_start, @command_length, @params_start = nil, @params_length = nil)
        end

        def initialize(@prefix, @command, @params)
            @str = Slice(UInt8).new(0)
        end

        def inspect(io)
            io << "Message(@prefix=#{prefix.inspect}, @command=#{command}, @params=#{params})"
        end

        def to_s(io)
            if prefix = prefix
                io << prefix
                io << ' '
            end

            io << command

            if params = params
                params.each do |param|
                    io << ' '
                    if param.includes? ' '
                        io << ':'
                    end
                    io << param
                end
            end
        end

        alias_method to_irc, to_s
    end
end