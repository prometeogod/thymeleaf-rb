class Expr
	def call(ctx, expr)
      ctx[expr] # Poner to_s si tiene que devolver un string
	end
end