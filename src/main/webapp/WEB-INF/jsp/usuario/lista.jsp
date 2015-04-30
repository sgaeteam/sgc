<div id="page-wrapper">
	<div id="page-inner">
		<div class="row">
			<div class="col-md-12">
				<h2>Usu&aacute;rios</h2>
			</div>
		</div>
		<hr />
		<table cellpadding="0" cellspacing="0" border="0" class="table"
			id="example">
			<thead>
				<tr>
					<th align="left">Nome</th>
					<th align="left">C.P.F</th>
					<th align="left">E-mail</th>
					<th align="left">Situação</th>
					<th align="left">Alterar</th>
					<th align="left">Excluir</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${usuarioList}" var="usuario">
					<tr>
						<td>${usuario.nome}</td>
						<td>${usuario.cpf}</td>
						<td>${usuario.email}</td>
						<td>${usuario.ativo}</td>
						<td><a href="<c:url value="/usuario/${usuario.cpf}"/>">Editar</a>
						</td>
						<td>
							<form action="<c:url value="/usuario/${usuario.cpf}"/>"
								method="POST">
								<button class="link" name="_method" value="DELETE">Remover</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>