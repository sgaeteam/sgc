package br.com.sgaeteam.sgc.controller;

import javax.servlet.http.HttpSession;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.Validator;
import br.com.caelum.vraptor.validator.ValidationMessage;
import br.com.sgaeteam.sgc.annotation.Public;
import br.com.sgaeteam.sgc.component.UsuarioSessao;
import br.com.sgaeteam.sgc.constants.ValidatorMessage;
import br.com.sgaeteam.sgc.dao.UsuarioDAO;
import br.com.sgaeteam.sgc.model.Usuario;


@Resource
public class LoginController {

	private final UsuarioDAO usuarioDAO;
	private final Result result;
	private final Validator validator;
	private final UsuarioSessao usuarioSessao;
	private HttpSession sessao;
		
	public LoginController(UsuarioDAO usuarioDAO, Result result, Validator validator, UsuarioSessao usuarioSessao, HttpSession sessao) {
		this.usuarioDAO = usuarioDAO;
		this.result = result;
		this.validator = validator;
		this.usuarioSessao = usuarioSessao;
		this.sessao = sessao;
	}
	
	@Public
	@Get("/")
	public void login() {
	}
	
	@Public
	@Post("/login")
	public void login(Usuario usuario) {

		Usuario carregado = usuarioDAO.carrega(usuario);

		if (carregado == null) {
			validator.add(new ValidationMessage("C.P.F inv&aacute;lido ou senha incorreta. ", ValidatorMessage.DANGER));
		}
		validator.onErrorUsePageOf(LoginController.class).login();

		usuarioSessao.login(carregado);

		result.redirectTo(IndexController.class).index();

	}
	
	@Get("/logout")
	public void logout() {
		usuarioSessao.logout();
		sessao.setMaxInactiveInterval(0); 
		sessao.invalidate();
		result.redirectTo(this).login();
	}
		
}