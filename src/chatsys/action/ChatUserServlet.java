package chatsys.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chatsys.db.ConnDB;

/**
 * Servlet implementation class ChatUserServlet
 */
@WebServlet("/ChatUserServlet")
public class ChatUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ConnDB conn = new ConnDB();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ChatUserServlet() {
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
		response.setHeader("content-type", "text/html; charset=utf8");
		request.setCharacterEncoding("utf8");
		PrintWriter out = response.getWriter();
		String action = request.getParameter("action");
		String user = request.getParameter("user");
		String toUser = request.getParameter("toUser");
		// 用户和客服的聊天记录
		if ("getUserChat".equals(action)) {
			String sql = "select * from chatlog where (user='" + user + "' and toUser='" + toUser + "')" + "or (user='"
					+ toUser + "' and toUser='" + user + "')";
			try {
				ResultSet rs=conn.doQuery(sql);
				int counter = 0;
				StringBuffer chatlog = new StringBuffer("[");
				while(rs.next()) {
					if (counter>0) {
						chatlog.append(",");
					}
					chatlog.append("{user: '"+rs.getString("user")+"',toUser: '"+rs.getString("toUser")+
							"',cltext: '"+rs.getString("cltext")+"',cltime: '"+rs.getString("cltime")+"'}");
					counter++;
				}
				chatlog.append("]");
				out.write(chatlog.toString());
			}catch (Exception e) {
				
			}finally {
				conn.closeConnection();
			}
		}
		
		//保存聊天内容
		else if("sendChatContent".equals(action)) {
			SimpleDateFormat now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String time = now.format(new Date());
			String chatContent = request.getParameter("chatcontent");
			String sql = "insert into chatlog(user,touser,cltext,cltime,clstate) values ("
					+ " '"+user+"','"+toUser+"','"+chatContent+"','"+time+"','0')";
			try {
				int result = conn.doUpdate(sql);
				if (result == 1) {
					out.write("ChatTrue");
				}else {
					out.write("ChatFalse");
				}
			}catch (Exception e) {
				// TODO: handle exception
			}finally {
				conn.closeConnection();
			}
		}
		
		//聊天记录(分页用)
		else if("getUserChatHistory".equals(action)) {
			String sql = "select * from chatlog where (user='" + user + "' and toUser='" + toUser + "')" + "or (user='"
					+ toUser + "' and toUser='" + user + "')";
			try {
				ResultSet rs=conn.doQuery(sql);
				int counter = 0;
				StringBuffer chatlog = new StringBuffer("[");
				while(rs.next()) {
					if (counter>0) {
						chatlog.append(",");
					}
					chatlog.append("{user: '"+rs.getString("user")+"',toUser: '"+rs.getString("toUser")+
							"',cltext: '"+rs.getString("cltext")+"',cltime: '"+rs.getString("cltime")+"'}");
					counter++;
				}
				chatlog.append("]");
				out.write(chatlog.toString());
			}catch (Exception e) {
				
			}finally {
				conn.closeConnection();
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
