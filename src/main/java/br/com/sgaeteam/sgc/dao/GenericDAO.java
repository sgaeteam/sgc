package br.com.sgaeteam.sgc.dao;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.Transaction;

import br.com.caelum.vraptor.ioc.Component;

@Component
public abstract class GenericDAO<T, I extends Serializable> {
	
	protected final Session session;
    protected final Class<T> clazz;  
  
    @SuppressWarnings("unchecked")
    protected GenericDAO(Session session) {

        this.session = session;
        Class<T> clazz = (Class<T>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
        this.clazz = clazz;    
    }
    
    public void insert(T entity) {
    	Transaction tx = this.session.beginTransaction();
        session.persist(entity);
        session.flush();
        tx.commit();
    }

    @SuppressWarnings("unchecked")
    public T update(T entity) {
    	Transaction tx = this.session.beginTransaction();
        entity = (T) session.merge(entity);
        session.flush();
        tx.commit();
        return entity;
    }
     
    public void delete(T entity) {  
    	Transaction tx = this.session.beginTransaction();
        session.update(entity);
        session.flush();
        tx.commit();
    }
    
    @SuppressWarnings("unchecked")  
    public T findById(Long id) {  
        return (T) session.get(this.clazz, id);
    }
    
    @SuppressWarnings("unchecked")  
    public List<T> findAll() {
    	Criteria c = session.createCriteria(this.clazz);  
        return c.list();
    }
}
