local molde = require 'molde'

describe('Molde parse function', function()
	it('empty template', function()
		assert.are.same(molde.parse(''), {})
	end)

	it('content tags', function()
		local one_of_each = molde.parse('literal {{ value }} {% statement %}')
		assert.are.same({
			{literal = 'literal '},
			{value = ' value '},
			{literal = ' '},
			{statement = ' statement '},
		}, one_of_each)
	end)

	it('invalid template', function()
		assert.is_nil(molde.parse('{% this statement never closes } }'))
		assert.is_nil(molde.parse('{{ nor does this value } }'))
		assert.is_nil(molde.parse('{% unmatching delimiters }}'))
		assert.is_nil(molde.parse('{{ (more) unmatching delimiters %}'))
	end)

	it('escaping braces on literal', function()
		local escaped_literal = molde.parse([[\{\{this is escaped\}\}]])
		assert.are.same(1, #escaped_literal)
		local tag, literal = next(escaped_literal[1])
		assert.are.same('literal', tag)
		assert.are.same('{{this is escaped}}', literal)
	end)

	it('escaping braces on value', function()
		local escaped_value = molde.parse([[{{\{{this is escaped}\}}}]])
		assert.are.same(1, #escaped_value)
		local tag, value = next(escaped_value[1])
		assert.are.same('value', tag)
		assert.are.same('{{this is escaped}}', value)
	end)

	it('escaping braces on statement', function()
		local escaped_statement = molde.parse([[{%\{%this is escaped%\}%}]])
		assert.are.same(1, #escaped_statement)
		local tag, statement = next(escaped_statement[1])
		assert.are.same('statement', tag)
		assert.are.same('{%this is escaped%}', statement)
	end)
end)
