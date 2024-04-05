package mkcl.oesclient.api.controllers;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*", allowedHeaders = "*",methods = {RequestMethod.GET})
@RestController
@RequestMapping("preCheck")
public class PreCheckAPIController 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(PreCheckAPIController.class);
	
	@GetMapping("/dateTime")
	public ResponseEntity<String> paperSchedule(HttpServletRequest request)
	{
		String  dateStr="";
		try 
		{
			 if(!authenticateUserForBasicAuth(request.getHeader("Authorization")))
			 {
				 return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);				 
			 }
			 
			ZonedDateTime zdt = ZonedDateTime.now(ZoneOffset.UTC);
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
			dateStr = zdt.format(formatter);
		} 
		catch (Exception e) 
		{
			LOGGER.error("Error in DateCreated api:", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<String>(dateStr,HttpStatus.OK);
	}
	
	public boolean authenticateUserForBasicAuth(String authString) throws Exception 
	{
		String authUserName="datetimeapi";
		String authPassword="d@t3t!m3@p!";
		try 
		{
			String[] credArr = new String(Base64.getDecoder().decode(authString.split("\\s+")[1])).split(":");			

			if (credArr[1]!=null && !credArr[1].isEmpty() && credArr[0]!=null && !credArr[0].isEmpty() && credArr[0].equals(authUserName) && credArr[1].equals(authPassword)) 
			{
				return true;
			}
			else
			{
				LOGGER.error("Invalid credentials for datetime API.");
				return false;
			}

		} catch (Exception e) {
		
			LOGGER.error("Error in user authentication:", e);
			throw e;
		}
		
	}
	
	
}
