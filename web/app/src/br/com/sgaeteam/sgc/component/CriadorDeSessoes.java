package br.com.sgaeteam.sgc.component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.ComponentFactory;
import br.com.caelum.vraptor.ioc.RequestScoped;



/**
 * @author mart97
 * CriadorDeSessoes.java
 * Responsável em conseguir sessões da Fábrica necessárias para as transações do Hibernate.
 */

@Component
@RequestScoped
public class CriadorDeSessoes implements ComponentFactory<Session> {

	private final SessionFactory sessionFactory;
	public Session session;
	private static final Logger logger = LoggerFactory.getLogger(FabricaDeSessoes.class);

	public CriadorDeSessoes(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	@PostConstruct
	public void abre() {
		this.session = this.sessionFactory.openSession();
		logger.info("SGC: Abrindo a transação com o banco de dados...");
	}

	public Session getInstance() {
		return this.session;
	}

	@PreDestroy
	public void fecha() {
		this.session.close();
		logger.info("SGC: Fechando transação com o banco de dados...");
	}
}
