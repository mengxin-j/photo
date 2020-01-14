package chatsys.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import chatsys.db.ConnDB;

/**
 * Servlet implementation class KefuServlet
 */
@WebServlet("/KefuServlet")
public class KefuServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ConnDB conn = new ConnDB();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public KefuServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setCharacterEncoding("utf8");
		response.setHeader("content-type", "text/html;charset=utf-8");
		request.setCharacterEncoding("utf8");
		PrintWriter out = response.getWriter();
		String action = request.getParameter("action");
		HttpSession session = request.getSession();
		// 请求加载在线用户列表,返回用户列表的json数据格式
		if (action.equals("OnlineList")) {
			StringBuffer onlineUserLog = new StringBuffer("[");
			// 从application中获取UserList
			@SuppressWarnings("unchecked")
			ArrayList<String> onlineUserList = (ArrayList<String>) getServletContext().getAttribute("userList");// 在线的用户列表
																												// json格式
			if (onlineUserList == null) { // 没有在线用户
				onlineUserLog = new StringBuffer("");
			} else {
				int counter = 0; // 计数器 判断是否加 ","
				for (String userStr : onlineUserList) {
					if (userStr != null) {
						String sql = "select * from member where loginName='" + userStr + "' ";
						ResultSet rs = conn.doQuery(sql);
						try {
							if (rs.next()) {
								if (counter > 0) {
									onlineUserLog.append(",");
								}
								onlineUserLog.append("{loginName:'" + rs.getString("loginName") + "', memberPic:'"
										+ rs.getString("memberPic") + "' }");
								counter++;
							}
						} catch (Exception e) {
							// TODO: handle exception
						} finally {
							conn.closeConnection();
						}
					}
				}
				onlineUserLog.append("]");
			}
			out.write(onlineUserLog.toString());
		}
		//首页进入客服页面
		else if(action.equals("ToKefu")) {
			if (session.getAttribute("loginName")!=null) {
				response.sendRedirect("kefu.jsp");
			}else {
				response.sendRedirect("login.hmtl");
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
