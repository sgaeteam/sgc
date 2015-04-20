package br.com.sgaeteam.sgc.component;

import java.io.Serializable;

import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.SessionScoped;
import br.com.sgaeteam.sgc.model.Usuario;

@Component
@SessionScoped
public class UsuarioSessao implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private Usuario usuarioLogado;

	public void login(Usuario usuario) {
		this.usuarioLogado = usuario;
	}
	
	public void logout() {
		this.usuarioLogado = null;
	}
	
	public String getNome() {
		return usuarioLogado.getNome();
	}
		
	public String getCpf() {
		return usuarioLogado.getCpf();
	}
	
	public boolean isLogado() {
		return usuarioLogado != null;
	}
}