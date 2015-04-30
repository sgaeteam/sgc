package br.com.sgaeteam.sgc.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.Validator;
import br.com.sgaeteam.sgc.component.UsuarioSessao;
import br.com.sgaeteam.sgc.dao.UsuarioDAO;
import br.com.sgaeteam.sgc.model.Usuario;

@Resource
public class UsuarioController {


	private final UsuarioDAO UsuarioDAO;
	private final Result result;
	private final Validator validator;
	private final UsuarioSessao usuarioSessao;
	private HttpSession sessao;


	public UsuarioController(UsuarioDAO UsuarioDAO, Result result, Validator validator, UsuarioSessao usuarioSessao, HttpSession sessao) {
		this.UsuarioDAO = UsuarioDAO;
		this.result = result;
		this.validator = validator;
		this.usuarioSessao = usuarioSessao;
		this.sessao = sessao;
	}
		
	@Get
	@Path("/usuario/novo")
	public void formulario() {
	}

	@Post
	@Path("/usuario")
	public void adiciona(final Usuario usuario, String callBack) {

		UsuarioDAO.insert(usuario);
		
		result.include("notice","Usu&aacute;rio salvo com sucesso.");
		result.redirectTo(callBack);
		
	}

	@Get
	@Path("/usuarios")
	//@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR, Perfil.USR})
	public List<Usuario> lista() {	
		
		return UsuarioDAO.findAll();
		//return UsuarioDAO.listaUsuariosValidosUnidade(usuarioSessao.getUnidade_id());
		
	}
	

	
	

/*



		@Get
		@Path("/Usuarios/{id}")
		@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
		public Usuario edita(Long id) {
			
			return UsuarioDAO.carrega(id);
			
		}

		@Put
		@Path("/Usuarios/{Usuario.id}")
		//@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
		public void altera(Usuario Usuario, String callBack) {
			
			UsuarioDAO.altera(Usuario);
			result.include("notice","Usuario editado com sucesso.");
			result.redirectTo(callBack);
			
		}

		@Get
		@Path("/Usuarios/rl/{id}")
		//@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
		public void removeLogico(Long id) {
			
			String callBack ="/cadastros/formulario";
			Usuario Usuario = UsuarioDAO.carrega(id);
			Usuario.setValido("N");
			UsuarioDAO.altera(Usuario);
			result.include("notice","Usuario exclu&iacute;do com sucesso.");
			result.redirectTo(callBack);
			
		}	
		
		@Delete
		@Path("/Usuarios/rf/{id}")
		//@Permissao(Perfil.ADM)
		public void removeFisico(Long id, String callBack) {
			
			Usuario Usuario = UsuarioDAO.carrega(id);
			UsuarioDAO.remove(Usuario);
			result.redirectTo(callBack);
			
		}
		

		
		@Path("/Usuarios/csv") 
		public Download csvReport() {
			Report<Usuario> report = generateReport();
			return new ReportDownload(report, Csv());
		}
		
		@Path("/Usuarios/xls") 
		public Download xlsReport() {
			Report<Usuario> report = generateReport();
			return new ReportDownload(report, Xls());
		}
		
		@Path("/Usuarios/docx") 
		public Download docxReport() {
			Report<Usuario> report = generateReport();
			return new ReportDownload(report, Docx());
		}
		
		@Path("/Usuarios/txt") 
		public Download txtReport() {
			Report<Usuario> report = generateReport();
			ExportFormat txt = new Txt();
			txt.configure(JRTextExporterParameter.OFFSET_X, 0)
			   .configure(JRTextExporterParameter.OFFSET_Y, 0);
			return new ReportDownload(report, txt, false);
		}
		
		@Path("/Usuarios/odt") 
		public Download odtReport() {
			Report<Usuario> report = generateReport();
			return new ReportDownload(report, Odt());
		}
		
		@Path("/Usuarios/rtf") 
		public Download rtfReport() {
			Report<Usuario> report = generateReport();
			return new ReportDownload(report, Rtf());
		}
		
		@Path("/Usuarios/pdf")
		public Download pdfReport() {
			Report<Usuario> report = generateReport();
			return new ReportDownload(report, Pdf());
		}
		
		@Path("/Usuarios/zip") 
		public Download zipReport() throws IOException {
			ReportsDownload download = new ReportsDownload();
			Report<Usuario> report = generateReport();
			download.add(report, Pdf())
					.add(report, Csv())
					.add(report, Xls())
					.add(report, Rtf())
					.add(report, Docx())
					.add(report, Txt())
					.add(report, Odt());
			return download;
		}
		
		private Report<Usuario> generateReport(){
			List<Usuario> data = UsuarioDAO.listaUsuariosValidosUnidade(usuarioSessao.getUnidade_id());
			return new UsuariosReport(data);
		}
		
		
	}	*/
}
