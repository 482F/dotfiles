local assert = require('util/test')
local stream = require('util/stream')
local fu = require('util/func')
describe('stream', function()
  describe('map', function()
    it('empty', function()
      assert.are.same({}, stream.map({}, fu.identity))
    end)
    it('normal', function()
      local f = function() end
      local expected = { a = 43, 11, [f] = 15 }
      assert.are.same(expected, stream.map(expected, fu.identity))
    end)
  end)

  describe('flat_map', function()
    it('empty', function()
      assert.are.same({}, stream.flat_map({}, fu.identity))
    end)
    it('normal', function()
      local f = function() end
      local expected = { a = 43, 11, [f] = 15 }
      assert.are.same(expected, stream.flat_map(expected, fu.identity))
    end)
    it('nested', function()
      assert.are.same(
        { 1, 2, 3, 4, { 5, 6 }, a = 42, b = { c = 43 } },
        stream.flat_map({ { 1 }, { 2, 3 }, { 4, { 5, 6 } }, a = 42, { b = 43 }, { b = { c = 43 } } }, fu.identity)
      )
    end)
  end)

  describe('filter', function()
    it('empty', function()
      assert.are.same({}, stream.filter({}, fu.is_truthy))
    end)
    it('normal', function()
      local f = function() end
      assert.are.same(
        { a = 1, 3, [f] = 5, 0 },
        stream.filter({ a = 1, b = nil, 3, false, [f] = 5, [function() end] = false, 0 }, fu.is_truthy)
      )
    end)
  end)

  describe('from_pairs', function()
    it('empty', function()
      assert.are.same({}, stream.from_pairs({}))
    end)
    it('normal', function()
      local f = function() end
      assert.are.same({ a = 1, 3, [f] = 5 }, stream.from_pairs({ { 'a', 1 }, { 1, 3 }, { f, 5 } }))
    end)
  end)

  describe('pairs', function()
    it('empty', function()
      assert.are.same({}, stream.pairs({}))
    end)
    it('normal', function()
      local f = function() end
      local pairs = stream.pairs({ a = 1, 3, [f] = 5 })
      assert.has.values(pairs, { 1, 3 }, { 'a', 1 }, { f, 5 })
    end)
  end)

  describe('keys', function()
    it('empty', function()
      assert.are.same({}, stream.keys({}))
    end)
    it('normal', function()
      local f = function() end
      local keys = stream.keys({ a = 1, 3, [f] = 5 })
      assert.has.values(keys, 1, 'a', f)
    end)
  end)

  describe('values', function()
    it('empty', function()
      assert.are.same({}, stream.values({}))
    end)
    it('normal', function()
      local f = function() end
      local values = stream.values({ a = 1, 3, [5] = f })
      assert.has.values(values, 1, 3, f)
    end)
  end)

  describe('slice', function()
    it('empty', function()
      assert.are.same({}, stream.slice({}, 1, 5))
      assert.are.same({}, stream.slice({}))
      assert.are.same({}, stream.slice({}, 1))
    end)
    it('normal', function()
      local f = function() end
      local arr = { a = 1, 3, [5] = f }
      assert.are.same({ 3 }, stream.slice(arr, 1, 5))
      assert.are.same({ 3, f }, stream.slice(arr, 1, 6))
      assert.are.same({ 3, f }, stream.slice(arr, 1))
      assert.are.same({ f }, stream.slice(arr, 2))
      assert.are.same({ 3, f }, stream.slice(arr))
    end)
  end)

  describe('inserted_all', function()
    it('empty', function()
      assert.are.same({}, stream.inserted_all({}, {}))
    end)
    it('normal', function()
      local f = function() end
      local arr = { a = 1, 3, [5] = f }
      assert.are.same({ a = 1, 3, f, 4 }, stream.inserted_all(arr, { 4 }))
      assert.are.same({ a = 2, 3, f }, stream.inserted_all(arr, { a = 2 }))
    end)
  end)

  describe('for_each', function()
    it('empty', function()
      local i = 0
      assert.are.same(
        nil,
        stream.for_each({}, function()
          i = i + 1
        end)
      )
      assert.are.same(i, 0)
    end)
    it('normal', function()
      local i = 0
      local arr = { a = 1, 3, [5] = 2 }
      assert.are.same(
        nil,
        stream.for_each(arr, function()
          i = i + 1
        end)
      )
      assert.are.same(i, 3)
    end)
  end)

  describe('reduce', function()
    it('empty', function()
      assert.are.same(42, stream.reduce({}, fu.identity, 42))
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5 }
      assert.are.same(
        30,
        stream.reduce(arr, function(prev, num)
          return prev * num
        end, 1)
      )
    end)
  end)

  describe('includes', function()
    it('empty', function()
      assert.are.same(false, stream.includes({}, nil))
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5, nil, b = nil }
      assert.are.same(true, stream.includes(arr, 2))
      assert.are.same(true, stream.includes(arr, 3))
      assert.are.same(true, stream.includes(arr, 5))
      assert.are.same(false, stream.includes(arr, nil)) -- table の中に nil があるのか値がないのかを判別する方法はないっぽい
      assert.are.same(false, stream.includes(arr, false))
    end)
  end)

  describe('find', function()
    it('empty', function()
      assert.are.same(
        nil,
        stream.find({}, function()
          return true
        end)
      )
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5, nil, b = nil }
      stream.for_each({
        { 2, 2 },
        { 3, 3 },
        { 5, 5 },
        { 42, nil },
        { nil, nil },
      }, function(pair)
        assert.are.same(
          pair[2],
          stream.find(arr, function(v)
            return v == pair[1]
          end)
        )
      end)
    end)
  end)

  describe('some', function()
    it('empty', function()
      assert.are.same(
        false,
        stream.some({}, function()
          return true
        end)
      )
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5, nil, b = nil }
      stream.for_each({
        { 2, true },
        { 3, true },
        { 5, true },
        { 42, false },
        { nil, false },
      }, function(pair)
        assert.are.same(
          pair[2],
          stream.some(arr, function(v)
            return v == pair[1]
          end)
        )
      end)
    end)
  end)

  describe('every', function()
    it('empty', function()
      assert.are.same(
        true,
        stream.every({}, function()
          return false
        end)
      )
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5, nil, b = nil }
      stream.for_each({
        { 2, false },
        { 3, false },
        { 5, false },
        { 42, true },
        { nil, true },
      }, function(pair)
        assert.are.same(
          pair[2],
          stream.every(arr, function(v)
            return v ~= pair[1]
          end)
        )
      end)
    end)
  end)

  describe('count', function()
    it('empty', function()
      assert.are.same(0, stream.count({}))
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5, nil, b = nil }
      assert.are.same(3, stream.count(arr))
    end)
  end)

  describe('join', function()
    it('empty', function()
      assert.are.same('', stream.join({}, ',,'))
    end)
    it('normal', function()
      local arr = { 2, [5] = 3, a = 5, nil, b = nil }
      assert.are.same(7, stream.join(arr, ',,'):len())
    end)
  end)

  describe('start', function()
    it('empty', function()
      assert.are.same({}, stream.start({}).map(fu.identity).filter(fu.identity).flat_map(fu.identity).terminate())
    end)
    it('short-circuit', function()
      local arr = { 1, 2, 3, 4, 5 }
      local i = 0
      assert.are.same(
        true,
        stream
          .start(arr)
          .map(function(v)
            i = i + 1
            return v
          end)
          .includes(1)
      )
      assert.are.same(1, i)
    end)
  end)
end)
