package mkcl.oesclient.appmanager.utilities;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.appmanager.model.PropertiesModel;

public class PropertiesService {

	private static String resourcesPath = null;
	public static String removedKeys="";

	public static String getFilePath(HttpServletRequest request) {

		if (resourcesPath == null) {
			String serverpath = request.getSession().getServletContext().getRealPath("");
			resourcesPath = serverpath + "\\WEB-INF\\classes";

		}
		return resourcesPath;
	}

	public static List<String> listOfPropertiesFile(HttpServletRequest request) {
		List<String> list = new ArrayList<String>();
		String path = PropertiesService.getFilePath(request);

		File folder = new File(path);
		File[] listOfFiles = folder.listFiles();

		for (int i = 0; i < listOfFiles.length; ++i) {
			if (listOfFiles[i].isFile()) {
				String filename = listOfFiles[i].getName();
				if (filename.contains(".properties")) {
					list.add(filename);
				}
			}
		}

		return list;
	}

	public Map<String, String> readValues(String fileName) {
		HashMap<String, String> map = new HashMap();
		Properties prop = new Properties();
		InputStream inputStream = null;
		BufferedReader bufferedReader = null;
		inputStream = this.getClass().getResourceAsStream("/" + fileName);

		try {
			bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF8"));
			prop.load(bufferedReader);
			Set set = prop.entrySet();
			Iterator itr = set.iterator();
			Map.Entry entry = null;
			while (itr.hasNext()) {
				entry = (Map.Entry) itr.next();
				String key = (String) entry.getKey();
				String value = (String) entry.getValue();
				map.put(key, value);

			}
			inputStream.close();
			bufferedReader.close();
		} catch (IOException e) {
			System.out.println(e);
		}

		return map;
	}

	public boolean updatePropertyfile(Map<String, String> updatedValuesMap, HttpServletRequest request, String totalPath) {

		String existingComments = fetchComments(totalPath);

		Map<String, String> dataWithoutRemovedKeysMap = fetchDataWithoutRemovedKeys(updatedValuesMap);
		String allComments=existingComments+removedKeys;

		//Clearing property file before adding all data
		Properties prop = loadPropertiesFile(totalPath);
		FileOutputStream out = null;
		try {
			out = new FileOutputStream(totalPath);
			prop.clear();
			
			// write new data in file(dataWithoutRemovedKeysMap) 
			Map<String, String> sorted = new TreeMap<>(dataWithoutRemovedKeysMap); 
			
			for (Map.Entry<String, String> entry : sorted.entrySet())  {	
				prop.setProperty(entry.getKey(), entry.getValue());
				}
			prop.store(out, null);
			out.close();

			}catch(Exception e) {
				System.out.println("error while writing file\n" + e);
			}
			return updateCurrentDataWithComments(totalPath, allComments);
		}
	

		public Map<String, String> fetchDataWithoutRemovedKeys(Map<String, String> map) {
			//String removedKeys = "";

			Map<String,String> mapToReturn = new HashMap<String,String>();

			Set<String> keyset = map.keySet();
			Iterator iter = keyset.iterator();
			while (iter.hasNext()) {
				String key = (String) iter.next();
				if(key.startsWith("REMOVED_")) {
					String val = key.substring(8,key.length());

					removedKeys = removedKeys +"#"+ val +"="+map.get(key)+ "\n";
					//	map.remove(key);
				}else {
					mapToReturn.put(key, map.get(key));
				}

			}
		return mapToReturn;
		}

		private Properties loadPropertiesFile(final String propFileName) {

			Properties prop = new Properties();
			InputStream input = null;
			try {
				input = new FileInputStream(propFileName);
				prop.load(input);
				input.close();
			} catch (IOException ex) {
				System.out.println("Cannot open properties file: " + propFileName + " exception: \n" + ex);
			} finally {
				if (input != null) {
					try {
						input.close();
					} catch (IOException e) {
						System.out.println(e);
					}
				}
			}
			return prop;
		}

		public String fetchComments(String totalPath) {
			String content = "";
			String currLine;
			try {
				BufferedReader bufferedReader = new BufferedReader(new FileReader(totalPath));

				while ((currLine = bufferedReader.readLine()) != null) {
					if ((currLine.startsWith("#Mon") || (currLine.startsWith("#Tue")) || (currLine.startsWith("#Wed"))
							|| (currLine.startsWith("#Thur")) || (currLine.startsWith("#Fri"))
							|| (currLine.startsWith("#Sat")) || (currLine.startsWith("#Sun"))) && currLine.endsWith("2020")
							|| currLine.endsWith("2021")) {

					} else if (currLine.startsWith("#")) {
						content = content + currLine + "\n";
					}
				}

				bufferedReader.close();

			} catch (IOException e) {
				e.printStackTrace();
			}
			return content;
		}

		public boolean updateCurrentDataWithComments(String totalPath, String existingComments) {

			String data = "";
			String currLine;
			BufferedReader bufferedReader;
			try {
				bufferedReader = new BufferedReader(new FileReader(totalPath));

				while ((currLine = bufferedReader.readLine()) != null) {
						data = data + currLine + "\n";
					}
				
				bufferedReader.close();
				BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(totalPath));
				bufferedWriter.write(data);
				bufferedWriter.write(existingComments);
				bufferedWriter.close();
			} catch (IOException e) {
				return false;
			}

			return true;
		}
	}
