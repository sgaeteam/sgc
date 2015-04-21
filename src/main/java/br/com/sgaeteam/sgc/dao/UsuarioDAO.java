package br.com.sgaeteam.sgc.dao;

import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgc.model.Usuario;
import br.com.sgaeteam.sgc.util.Util;

@Component
public class UsuarioDAO extends GenericDAO<Usuario,Long>{

	public UsuarioDAO(Session session) {
		super(session);
	}

	public boolean existeUsuario(Usuario usuario) {

		Usuario encontrado = (Usuario) session.createCriteria(Usuario.class)
											  .add(Restrictions.eq("cpf", usuario.getCpf()))
											  .uniqueResult();
		return encontrado != null;
	}

	public Usuario carrega(Usuario usuario) {
		return (Usuario) this.session.getNamedQuery("Usuario.findByCpfSenha")
	    		   					 .setParameter("cpf", usuario.getCpf())
	    		   					 .setParameter("senha", Util.converterMD5(usuario.getCpf()+usuario.getSenha()))
	    		   					 .uniqueResult();		
	}
		
}