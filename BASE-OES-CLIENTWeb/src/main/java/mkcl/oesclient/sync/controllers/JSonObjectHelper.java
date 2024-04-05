/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package mkcl.oesclient.sync.controllers;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;
/**
 *
 * @author yograjs
 */
public final class JSonObjectHelper {
        private static final Logger LOGGER = LoggerFactory.getLogger(JSonObjectHelper.class);

/**
 * Method to return Object
 * @param jsonText
 * @return Object this returns object
 */
public static Object getReturnObject(String jsonText) {
		ObjectMapper mapper = new ObjectMapper();
		Object returObject = null;
		try {
			HashMap payload = mapper.readValue(jsonText, HashMap.class);
			Iterator it = payload.entrySet().iterator();
			while (it.hasNext()) {

				Map.Entry pairs = (Map.Entry) it.next();
				if (pairs.getKey().toString().equals("returnObject")) {
					return pairs.getValue();
				}

			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured in JSonObjectHelper: " + e);
		}
		return returObject;
	}
}
