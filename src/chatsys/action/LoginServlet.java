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
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	private ConnDB conn = new ConnDB();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");

		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		String action = request.getParameter("action");

		if (action.equals("Login")) {
			String loginName = request.getParameter("name");
			String loginPwd = request.getParameter("pass");
			String randCode = request.getParameter("code");
			String rand = request.getSession().getAttribute("IdentifyCode").toString();
			if (loginName != null && !loginName.trim().equals("") && loginPwd != null && !loginPwd.trim().equals("")
					&& randCode != null && !randCode.trim().equals("")) {
				if (!randCode.trim().equals(rand)) {
					out.write("CodeFalse");
					return;
				}

				String sql = "select * from  member where loginName='" + loginName + "' and loginPwd='" + loginPwd
						+ "' ";
				ResultSet rs = conn.doQuery(sql);
				try {
					if (rs.next()) {
						// 判断用户状态 如果是用户则跳转到kefu.jsp 如果是客服则跳转到kefuCenter.jsp
						if (rs.getBoolean("UserType") == false) {
							// 登陆成功
							@SuppressWarnings("unchecked")
							ArrayList<String> userList = (ArrayList<String>) getServletContext()
									.getAttribute("userList");// 用户列表
							if (userList == null) {
								userList = new ArrayList<String>();
								userList.add(loginName);
							} else {
								for (String str : userList) {
									if (str.equals(loginName)) {
										out.write("AlreadyLogin");
										return;
									}
								}
								userList.add(loginName);
							}
							getServletContext().setAttribute("userList", userList);

							out.write("LoginSuc");
							session.setAttribute("loginName", loginName);
						} else {
							// 登陆用户为客服
							@SuppressWarnings("unchecked")
							ArrayList<String> servList = (ArrayList<String>) getServletContext().getAttribute("servList");
							if (servList == null) {
								servList = new ArrayList<String>();
								servList.add(loginName);
							}else {
								for (String str1 : servList) {
									if (str1.equals(loginName)) {
										out.write("AlreadyLogin");
										return;
									}
								}
								servList.add(loginName);
							}
							getServletContext().setAttribute("servList", servList);
							out.write("KefuLogin");
							session.setAttribute("serLoginName", loginName);
						}
					} else {
						// 登陆失败
						out.write("LoginFalse");
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					conn.closeConnection();
				}
			}
		}

		// 检查账号账号的唯一性
		else if ("IsAlreadyReg".equals(action)) {
			String loginName = request.getParameter("loginName");
			if (loginName != null && !loginName.trim().equals("")) {
				String sql = "select * from member where loginName = '" + loginName + "' ";
				try {
					ResultSet rs = conn.doQuery(sql);
					if (rs.next()) {
						out.write("AlreadyReg");
						return;
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					conn.closeConnection();
				}
			}
		}
		// 注册
		else if (action.equals("Register")) {
			String loginName = request.getParameter("loginName");
			String passWord = request.getParameter("password");
			String memberName = request.getParameter("memberName");
			String sex = request.getParameter("sex");
			String email = request.getParameter("email");
			String qq = request.getParameter("qq");
			String memberPic = "img/head/2023.jpg";
			if (loginName != null && !loginName.trim().equals("") && loginName != null && !loginName.trim().equals("")
					&& passWord != null && !passWord.trim().equals("")) {
				String sql = "insert into member(loginName,loginPwd,memberName,sex,email,qq,memberPic) values" + "('"
						+ loginName + "','" + passWord + "','" + memberName + "','" + sex + "','" + email + "','" + qq
						+ "','" + memberPic + "')";
				try {
					int intTemp = conn.doUpdate(sql);
					if (intTemp == 1) {
						out.write("RegSuc");
					} else {
						out.write("RegFail");
					}
				} catch (Exception e) {

				} finally {
					conn.closeConnection();
				}
			}
		}
		// 安全退出
		else if (action.equals("Logout")) {
			if (session.getAttribute("loginName") != null) {
				String loginName = (String) session.getAttribute("loginName");
				if (loginName != null && !loginName.equals("")) {
					@SuppressWarnings("unchecked")
					ArrayList<String> userList = (ArrayList<String>) getServletContext().getAttribute("userList");
					if (userList != null) {
						userList.remove(loginName);
						session.invalidate();
						getServletContext().setAttribute("userList", userList);
					}
				}
			}
			response.sendRedirect("login.html");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}
}
