package br.com.sgaeteam.sgc.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgc.model.Usuario;
import br.com.sgaeteam.sgc.util.Util;

@Component
public class UsuarioDAO {

	private final Session session;

	public UsuarioDAO(Session session) {
		this.session = session;
	}

	public boolean existeUsuario(Usuario usuario) {

		Usuario encontrado = (Usuario) session.createCriteria(Usuario.class)
											  .add(Restrictions.eq("cpf", usuario.getCpf()))
											  .uniqueResult();
		return encontrado != null;
	}

	public void adiciona(Usuario usuario) {
		Transaction tx = this.session.beginTransaction();
		this.session.save(usuario);
		tx.commit();
	}

	public Usuario carrega(Usuario usuario) {
		return (Usuario) this.session.getNamedQuery("Usuario.findByCpfSenha")
	    		   					 .setParameter("cpf", usuario.getCpf())
	    		   					 .setParameter("senha", Util.converterMD5(usuario.getCpf()+usuario.getSenha()))
	    		   					 .uniqueResult();		
	}
	
	@SuppressWarnings("unchecked")
	public List<Usuario> listaTudo() {
		return this.session.getNamedQuery("Usuario.findAll").list();
	}
		
}