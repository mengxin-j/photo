package chatsys.action;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RandCodeServlet
 */
@WebServlet("/RandCodeServlet")
public class RandCodeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 产生随即的字使
	private Font getFont() {
		Random random = new Random();
		Font font[] = new Font[1];
		font[0] = new Font("Times New Roman", Font.PLAIN, 24);
		return font[random.nextInt(1)];
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RandCodeServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("image/jpeg");
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "No-cache");
		response.setDateHeader("Expires", 0);
		OutputStream os = response.getOutputStream();
		int width = 83, height = 30;
		// 建立指定宽䀩˘和BufferedImage对象
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

		Graphics g = image.getGraphics();
		Color c = g.getColor();
		g.fillRect(0, 0, width, height);
		char[] ch = "abcdefghjkmnpqrstuvwxyz23456789".toCharArray(); // 随即产生的字符串 不包拿i l(小写L) o（小写O＿1（数孿＿(数字0)
		int length = ch.length; // 随即字符串的长度
		String sRand = ""; // 保存随即产生的字符串
		Random random = new Random();
		for (int i = 0; i < 4; i++) {
			// 设置字体
			g.setFont(getFont());
			// 随即生成0-9的数孿
			@SuppressWarnings("deprecation")
			String rand = new Character(ch[random.nextInt(length)]).toString();  
			sRand += rand;
			g.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
			g.drawString(rand, 20 * i + 6, 25);
		}
		// 产生随即干扰炿
		for (int i = 0; i < 20; i++) {
			int x1 = random.nextInt(width);
			int y1 = random.nextInt(height);
			g.drawOval(x1, y1, 2, 2);
		}
		g.setColor(c); // 将画笔的颜色再设置回县
		g.dispose();

		// 将验证码记录到session
		request.getSession().setAttribute("IdentifyCode", sRand);
		// 输出图像到页靿
		ImageIO.write(image, "JPEG", os);
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
