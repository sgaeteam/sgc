<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->

 <!-- BEGIN HEAD -->
<head>
      <meta charset="UTF-8" />
    <title>SGC : Sistema para Gerenciamento de Clubes</title>
     <meta content="width=device-width, initial-scale=1.0" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />
  <!-- GLOBAL STYLES -->
    <link rel="stylesheet" type="text/css" href="<c:url value ="/css/bootstrap.css"/>" />
    <link rel="stylesheet" type="text/css" href="<c:url value ="/css/font-awesome.css"/>" />
    <!--END GLOBAL STYLES -->

     <!-- PAGE LEVEL STYLES -->
    <link rel="stylesheet" type="text/css" href="<c:url value ="/css/custom.css"/>" />
      <!--END PAGE LEVEL STYLES -->
</head>
     <!-- END HEAD -->
     <!-- BEGIN BODY -->
<body  >
      <!-- PAGE CONTENT --> 
  <div class="container">
        <div class="col-lg-8 col-lg-offset-2 text-center">
	  <div class="logo">
	    <h2>Ops, erro 405! Método não permitido!!</h2>
          </div>
             <div class="clearfix"></div>            
             <div class="col-lg-8  col-lg-offset-2">
               <div class="input-group">
		      <input type="text" placeholder="Informe ao administrador do sistema" class="form-control" />
		      <span class="input-group-btn">
			<button class="btn btn-danger" type="button">Enviar</button>
		      </span>
		    </div>
                 </div>
            <div class="clearfix"></div>
            <br /><br />
          <p class="text-muted">Desculpe, algo deu errado aqui! :( </p>
          <div class="clearfix"></div>
             <br /><br />
                <div class="col-lg-6 col-lg-offset-3">
                    <form action="#">
                    
                    <div class="input-group">
		      <input type="text" placeholder="ajuda ..." class="form-control" />
		      <span class="input-group-btn">
			<button class="btn btn-primary" type="button">Buscar</button>
		     </span>
		    </div>
		    
                    </form>
                </div>
            <div class="clearfix"></div>
            <br />
                <div class="col-lg-6  col-lg-offset-3">
		  <div class="btn-group btn-group-justified">
		      <a href="<c:url value="/index"/>" class="btn btn-primary">Painel de controle</a>
			  <a href="<c:url value="/logout"/>" class="btn btn-success">Sair</a> 
		  </div>
                        
                </div>
            
        </div>
                
                
        </div>
      <!-- END PAGE CONTENT --> 


</body>
     <!-- END BODY -->
</html>