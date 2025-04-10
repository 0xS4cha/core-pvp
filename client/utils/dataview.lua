local dataview = {
    ArrayBuffer = function(size)
        local buffer = {
            data = {},
            size = size,
            offset = 0
        }

        function buffer:SetFloat32(offset, value)
            self.data[offset] = value
            return self
        end

        function buffer:GetFloat32(offset)
            return self.data[offset]
        end

        function buffer:Buffer()
            return self.data
        end

        return buffer
    end
}

return dataview 