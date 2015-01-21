package br.com.sgaeteam.sgc.component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.caelum.vraptor.ioc.ApplicationScoped;
import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.ComponentFactory;



/**
 * @author mart97
 * FabricaDeSessoes.java
 * Responsável em abrir sessões necessárias para as transações do Hibernate.
 */

@Component
@ApplicationScoped
public class FabricaDeSessoes implements ComponentFactory<SessionFactory> {
	
	private SessionFactory factory;
	private static final Logger logger = LoggerFactory.getLogger(FabricaDeSessoes.class);
	
	@PostConstruct
	public void abre() {
		Configuration configuration = new Configuration();
		configuration.configure();
		
		this.factory = configuration.buildSessionFactory();
		
		logger.info("SGC: Abrindo a fábrica de sessões...");
		
	}

	public SessionFactory getInstance() {
		return this.factory;
	}

	@PreDestroy
	public void fecha() {
		this.factory.close();
		logger.info("SGC: Fechando a fábrica de sessões...");
		
	}
}
