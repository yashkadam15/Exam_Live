/**
 * 
 */
package mkcl.oesclient.commons.controllers;


import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oes.commons.CaptchaUtil;
import mkcl.oesclient.utilities.SessionHelper;
/**
 * @author rakeshb
 *
 */

@Controller
@RequestMapping("captcha")
public class CaptchaController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CaptchaController.class);
	
	protected static Font font = new Font("Verdana", Font.ITALIC | Font.BOLD, 28);
	
	protected static int width = 300;
	
	protected static int height = 80;
	
	/**
	 * Get method for Captcha
	 * @param session
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "getCaptcha")
	public void getCaptchaAjax(HttpSession session, HttpServletRequest request, HttpServletResponse response) 
	{
		try 
		{
			CaptchaUtil.removeCaptcha(session);
			CaptchaUtil.setCaptcha(session,0);
			String code = (String)SessionHelper.getVariable(CaptchaUtil.CAPTCHACODE, request);
	        char[] strs = code.toCharArray();
			try (ServletOutputStream sos = response.getOutputStream()) 
			{
	            BufferedImage bi = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
	            Graphics2D g = (Graphics2D) bi.getGraphics();
	            AlphaComposite ac3;
	            Color color;
	            int len = strs.length;
	            g.setColor(Color.WHITE);
	            g.fillRect(0, 0, width, height);
	            for (int i = 0; i < 15; i++) 
	            {
	                color = color(150, 250);
	                g.setColor(color);
	                g.drawOval(num(width), num(height), 5 + num(10), 5 + num(10));
	            }
	            g.setFont(font);
	            int h = height - ((height - font.getSize()) >> 1), w = width / len, size = w - font.getSize() + 1;
	            for (int i = 0; i < len; i++) 
	            {
	                // 
	                ac3 = AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.7f);
	                g.setComposite(ac3);

	                color = new Color(20 + num(110), 30 + num(110), 30 + num(110));
	                g.setColor(color);
	                g.drawString(strs[i] + "", (width - (len - i) * w) + size, h - 4);
	            }
	            
	            response.addIntHeader("Expires", 0);
	            response.addHeader("Cache-Control", "no-cache");
	            response.addHeader("Pragma", "no-cache");
	            response.setContentType("image/png");
	            
	            bi.flush();
	            ImageIO.write(bi, "png", sos);
	            sos.flush();
			}
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in getCaptchaAjax: " ,e);
		}
	}
	
	/**
	 * Method for Color
	 * @param fc
	 * @param bc
	 * @return Color this returns the color
	 */
	protected static Color color(int fc, int bc) 
	{
        if (fc > 255)
            fc = 255;
        if (bc > 255)
            bc = 255;
        int r = fc + num(bc - fc);
        int g = fc + num(bc - fc);
        int b = fc + num(bc - fc);
        return new Color(r, g, b);
    }
	
	/**
	 * Method for Random Number
	 * @param num
	 * @return int this returns the random number
	 */
	protected static int num(int num) 
	{
        return (new Random()).nextInt(num);
    }
}
