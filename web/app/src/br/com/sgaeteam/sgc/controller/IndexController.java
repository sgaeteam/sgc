package br.com.sgaeteam.sgc.controller;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;

@Resource
public class IndexController {

	private final Result result;
	
	public IndexController(Result result) {
		this.result = result;
	}

	@Get("/index")
	public void index() {
		this.result.include("opcao", "Painel de Controle");
	}

}
