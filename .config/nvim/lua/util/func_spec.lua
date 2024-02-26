local assert = require('util/test')
local fu = require('util/func')

describe('func', function()
  describe('identity', function()
    it('normal', function()
      local obj = {}
      assert.are.equal(obj, fu.identity(obj))
      assert.are.not_equal({}, fu.identity(obj))
    end)
  end)

  describe('is_truthy', function()
    it('normal', function()
      assert.are.equal(true, fu.is_truthy({}))
      assert.are.equal(true, fu.is_truthy(1))
      assert.are.equal(true, fu.is_truthy(0))
      assert.are.equal(true, fu.is_truthy('a'))
      assert.are.equal(true, fu.is_truthy(''))
      assert.are.equal(true, fu.is_truthy(true))
      assert.are.equal(false, fu.is_truthy(false))
      assert.are.equal(false, fu.is_truthy(nil))
    end)
  end)

  describe('picker', function()
    assert.are.equal(42, fu.picker('val')({ val = 42 }))
    assert.are.equal(42, fu.picker('key1', 'key2', 1)({ key1 = { key2 = { 42 } } }))
  end)

  describe('negate', function()
    it('normal', function()
      assert.are.equal(true, fu.negate(fu.is_truthy)(false))
    end)
  end)

  describe('recursivize', function()
    it('normal', function()
      local rf = fu.recursivize(
        ---@param v any
        ---@param max_depth integer
        ---@param depth integer
        ---@return integer
        function(self, v, max_depth, depth)
          if type(v) == 'number' then
            return v
          end
          if max_depth <= depth then
            return 0
          end

          local sum = 0
          for _, item in pairs(v) do
            sum = sum + self(item, max_depth, depth + 1)
          end
          return sum
        end
      )
      assert.are.equal(3, rf({ 1, 1, { 1, { 1 } } }, 2, 0))
    end)
  end)

  describe('override', function()
    it('normal', function()
      local m = {
        f = function(a, b)
          return a + b
        end,
      }

      fu.override(m, 'f', function(original, ...)
        return original(...) + 42
      end)

      assert.are.equal(45, m.f(1, 2))
    end)
  end)
end)
