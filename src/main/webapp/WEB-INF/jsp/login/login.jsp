    <div class="container">
        <div class="row text-center ">
            <div class="col-md-12">
                <br /><br />
                <h2> SGC - Clube 2004 </h2>
               
                <h5>( Sistema para Gerenciamento de Clubes )</h5>
                 <br />
            </div>
        </div>
         <div class="row ">
               
                  <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                        <strong>   Informe os dados para acessar </strong>  
                            </div>
                            <div class="panel-body">
                                <form id="formLogin" role="form" action="<c:url value="login"/>" method="post">
                                       <br />
                                     <div class="form-group input-group">
                                            <span class="input-group-addon"><i class="fa fa-tag"  ></i></span>
                                            <input type="text" class="form-control" id="cpf" name="usuario.cpf" placeholder="Informe o C.P.F" />
                                        </div>
                                                                              <div class="form-group input-group">
                                            <span class="input-group-addon"><i class="fa fa-lock"  ></i></span>
                                            <input type="password" class="form-control" id="senha" name="usuario.senha" placeholder="Informe a senha" />
                                        </div>
                                    <div class="form-group">
                                            <label class="checkbox-inline">
                                                <input type="checkbox" /> Continuar conectado
                                            </label>
                                            <span class="pull-right">
                                                   <a href="#" >Esqueceu a senha ? </a> 
                                            </span>
                                        </div>
                                     
                                     <a href="javascript: document.getElementById('formLogin').submit();" class="btn btn-primary ">Entrar</a>
                                     <a href="javascript: document.getElementById('formLogin').reset();" class="btn btn-danger">Limpar</a>
                                    <hr />
                                    Criar uma conta ? <a href="#" >solicite aqui</a> 
                                    </form>
                            </div>
                           
                        </div>
                    </div>
                
                
        </div>
    </div>
