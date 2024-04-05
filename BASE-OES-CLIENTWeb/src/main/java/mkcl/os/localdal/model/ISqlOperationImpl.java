/**
 * This Class implements ISql interface
 */
package mkcl.os.localdal.model;

import java.beans.PropertyVetoException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import mkcl.os.security.AESHelper;

import org.apache.log4j.Logger;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.mchange.v2.c3p0.DataSources;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

// TODO: Auto-generated Javadoc
/**
 * The Class ISqlOperationImpl Helps to create Connection through database.
 * 
 * @author Avinash Pandey
 * @author Alok kumar
 */
public class ISqlOperationImpl implements ISqlOperation {

	/** The data source. */
	private static ComboPooledDataSource dataSource;

	/** The Constant LOGGER. */
	private static final Logger LOGGER = Logger.getLogger(ISqlOperation.class);

	/** The text. */
	private static String text = "4c5d6e7f08192a3b";

	/** OS name. */
	public static String osname = System.getProperty("os.name").toLowerCase();

	public boolean closeDataSource() throws Exception
	{
		try {
			if (dataSource != null) {
				dataSource.close();	
				DataSources.destroy(dataSource);
				Enumeration<Driver> drivers = DriverManager.getDrivers();     
		        Driver driver = null;
		        while(drivers.hasMoreElements()) {
		            try {
		                driver = drivers.nextElement();
		                DriverManager.deregisterDriver(driver);

		            } catch (SQLException ex) {
		            	LOGGER.error(ex);
		            }
		        }
		        try {
		            AbandonedConnectionCleanupThread.checkedShutdown();
		        } catch (Exception e) {
		        	LOGGER.error(e);
		        }
			}
		} catch (Exception e) {			
			throw e;
		}
		return true;
	}
	
	/**
	 * Sets the up connection pooling.
	 * 
	 * @param encrpytedFilePath
	 *            the encrpytedFilePath
	 * @throws LocalDALException
	 *             the local dal exception
	 */
	private void setUpConnectionPooling(String encrpytedFilePath)
			throws LocalDALException {
		ComboPooledDataSource cpds = new ComboPooledDataSource();
		Properties properties = new Properties();
		InputStream connectionStream = null;
		InputStream dalPropertyStream = null;
		try {
			connectionStream = Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("connection.properties");
			properties.load(connectionStream);
			setDSProperties(properties, cpds);
		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			if (connectionStream != null) {
				try {
					connectionStream.close();
					connectionStream = null;
				} catch (IOException e) {
					throw new LocalDALException(e);
				}
			}
		}

		String password = null;
		InputStream jfile = null;
		OutputStream out = null;
		try {

			if (encrpytedFilePath == null
					|| encrpytedFilePath.trim().equals("")) {
				dalPropertyStream = Thread.currentThread()
						.getContextClassLoader()
						.getResourceAsStream("dal.properties");
				properties.load(dalPropertyStream);
				String path = properties.getProperty("path.value");
				jfile = Thread.currentThread().getContextClassLoader()
						.getResourceAsStream(path);
			} else {
				jfile = new FileInputStream(new File(encrpytedFilePath));
			}
			String textVal = DAL_Utility.getString(text);
			out = AESHelper.decryptAsStream(jfile, textVal);
			password = out.toString();
			cpds.setPassword(password);
		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			try {
				if (dalPropertyStream != null) {
					dalPropertyStream.close();
					dalPropertyStream = null;
				}
				if (jfile != null) {
					jfile.close();
					jfile = null;
				}
				if (out != null) {
					out.close();
					out = null;
				}
			} catch (IOException e) {
				throw new LocalDALException(e);
			}
		}
		dataSource = cpds;
	}

	/**
	 * Sets the ds properties.
	 * 
	 * @param properties
	 *            the properties
	 * @param cpds
	 *            the cpds
	 * @throws PropertyVetoException
	 *             the property veto exception
	 */
	private void setDSProperties(Properties properties,
			ComboPooledDataSource cpds) throws PropertyVetoException {
		LOGGER.info("***************Custom ISQL IMPL Loaded.*******************");
		// JDBC parameters
		final String jdbcDriver = properties.getProperty("JDBC_DRIVER");
		final String dbURL = properties.getProperty("DB_URL");
		final String userName = properties.getProperty("USERNAME");
		final String minPoolSize = properties.getProperty("MINPOOLSIZE");
		final String acquireIncrement = properties
				.getProperty("ACQUIREINCREMENT");
		final String maxPoolSize = properties.getProperty("MAXPOOLSIZE");

		final String initialPoolSize = properties
				.getProperty("INITIALPOOLSIZE");
		final String noHelperThread = properties
				.getProperty("NUMBERHELPERTHREAD");
		final String maxIdleTime = properties.getProperty("MAXIDLETIME");
		final String maxStatement = properties.getProperty("MAXSTATEMENT");
		final String maxStatementPerConn = properties
				.getProperty("MAXSTATEMENTPERCONNECTION");
		final String idleConnTestPeriod = properties
				.getProperty("IDLECONNECTIONTESTPERIOD");
		final String acquireRetryAttempt = properties
				.getProperty("ACQUIRERETRYATTEMPT");
		final String acquireRetryDelay = properties
				.getProperty("ACQUIRERETRYDELAY");
		final String autoCommitOnClose = properties
				.getProperty("AUTOCOMMITONCLOSE");
		final String breakAfterAcquireFailure = properties
				.getProperty("BREAKAFTERACQUIREFAILURE");
		final String testConnOnCheckOut = properties
				.getProperty("TESTCONNECTIONONCHECKOUT");
		final String testConnOnCheckIn = properties
				.getProperty("TESTCONNECTIONONCHECKIN");
		
		String preferredTestQuery = properties
			      .getProperty("PREFERREDTESTQUERY");
	    String debugUnreturnedConnectionStackTraces = properties.getProperty("debugUnreturnedConnectionStackTraces");
			    
	    String unreturnedConnectionTimeout = properties.getProperty("unreturnedConnectionTimeout");
	    
	    cpds.setPreferredTestQuery(preferredTestQuery);
	    
	    if(debugUnreturnedConnectionStackTraces != null)
	    	cpds.setDebugUnreturnedConnectionStackTraces(Boolean.valueOf(debugUnreturnedConnectionStackTraces).booleanValue());
	    if(unreturnedConnectionTimeout != null)
	    	cpds.setUnreturnedConnectionTimeout(Integer.valueOf(unreturnedConnectionTimeout).intValue());

	    cpds.setPrivilegeSpawnedThreads(true);
	    cpds.setContextClassLoaderSource("library");
		cpds.setJdbcUrl(dbURL);
		cpds.setDriverClass(jdbcDriver);
		cpds.setUser(userName);
		cpds.setMinPoolSize(Integer.parseInt(minPoolSize));
		cpds.setAcquireIncrement(Integer.parseInt(acquireIncrement));
		cpds.setMaxPoolSize(Integer.parseInt(maxPoolSize));

		cpds.setInitialPoolSize(Integer.parseInt(initialPoolSize));
		cpds.setNumHelperThreads(Integer.parseInt(noHelperThread));
		cpds.setMaxIdleTime(Integer.parseInt(maxIdleTime));
		cpds.setMaxStatements(Integer.parseInt(maxStatement));
		cpds.setMaxStatementsPerConnection(Integer
				.parseInt(maxStatementPerConn));
		cpds.setIdleConnectionTestPeriod(Integer.parseInt(idleConnTestPeriod));
		cpds.setAcquireRetryAttempts(Integer.parseInt(acquireRetryAttempt));
		cpds.setAcquireRetryDelay(Integer.parseInt(acquireRetryDelay));
		cpds.setAutoCommitOnClose(Boolean.parseBoolean(autoCommitOnClose));
		cpds.setBreakAfterAcquireFailure(Boolean
				.parseBoolean(breakAfterAcquireFailure));
		cpds.setTestConnectionOnCheckout(Boolean
				.parseBoolean(testConnOnCheckOut));
		cpds.setTestConnectionOnCheckin(Boolean.parseBoolean(testConnOnCheckIn));

	}

	/**
	 * Sets the up connection pooling.
	 * 
	 * @param encrpytedFilePath
	 *            the encrpytedFilePath
	 * @param connectionFilePath
	 *            the connectionFilePath
	 * @throws LocalDALException
	 *             the local dal exception
	 */
	private void setUpConnectionPooling(String encrpytedFilePath,
			String connectionFilePath) throws LocalDALException {
		ComboPooledDataSource cpds = new ComboPooledDataSource();
		Properties properties = new Properties();
		FileInputStream connectionStream = null;
		try {
			connectionStream = new FileInputStream(connectionFilePath
					+ File.separator + "connection.properties");
			properties.load(connectionStream);
			setDSProperties(properties, cpds);
		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			try {
				if (connectionStream != null) {
					connectionStream.close();
					connectionStream = null;
				}
			} catch (IOException e) {
				throw new LocalDALException(e);
			}

		}

		String password = null;
		InputStream jfile = null;
		OutputStream out = null;
		FileInputStream dalPropertiesStream = null;

		try {
			if (encrpytedFilePath == null
					|| encrpytedFilePath.trim().equals("")) {
				dalPropertiesStream = new FileInputStream(connectionFilePath
						+ File.separator + "dal.properties");
				properties.load(dalPropertiesStream);
				String path = properties.getProperty("path.value");
				jfile = Thread.currentThread().getContextClassLoader()
						.getResourceAsStream(path);
			} else {
				jfile = new FileInputStream(new File(encrpytedFilePath));
			}
			String textVal = DAL_Utility.getString(text);
			out = AESHelper.decryptAsStream(jfile, textVal);

			password = out.toString();

			cpds.setPassword(password);
		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			try {
				if (dalPropertiesStream != null) {
					dalPropertiesStream.close();
					dalPropertiesStream = null;
				}
				if (jfile != null) {
					jfile.close();
					jfile = null;
				}
				if (out != null) {
					out.close();
					out = null;
				}
			} catch (IOException e) {
				throw new LocalDALException(e);
			}
		}
		dataSource = cpds;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see mkcl.os.localdal.model.ISqlOperation#getConnection()
	 */
	public Connection getConnection() throws LocalDALException {
		if (dataSource == null) {
			setUpConnectionPooling(null);
		}
		try {
			return dataSource.getConnection();
		} catch (SQLException e) {
			throw new LocalDALException(e);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * mkcl.os.localdal.model.ISqlOperation#getConnectionByPath(java.lang.String
	 * )
	 */
	public Connection getConnectionByPath(String encrpytedFilePath)
			throws LocalDALException {
		if (dataSource == null) {
			setUpConnectionPooling(encrpytedFilePath);
		}
		try {
			return dataSource.getConnection();
		} catch (SQLException e) {
			throw new LocalDALException(e);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * mkcl.os.localdal.model.ISqlOperation#getConnectionByPath(java.lang.String
	 * , java.lang.String)
	 */
	public Connection getConnectionByPath(String encrpytedFilePath,
			String connectionFilePath) throws LocalDALException {
		if (dataSource == null) {
			setUpConnectionPooling(encrpytedFilePath, connectionFilePath);
		}
		try {
			return dataSource.getConnection();
		} catch (SQLException e) {
			throw new LocalDALException(e);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * mkcl.os.localdal.model.ISqlOperation#executeDMLQuery(java.lang.String)
	 */
	public int executeDMLQuery(String sqlQuery) throws LocalDALException {
		Statement statement = null;
		Connection connection = getConnection();
		int status = 0;
		try {
			statement = connection.createStatement();
			status = statement.executeUpdate(sqlQuery);
			LOGGER.debug("Executing DML query...");
		} catch (SQLException e) {
			LOGGER.error("Error occured while creating statement or executing query.."
					+ e.getMessage());
			throw new LocalDALException(e);
		} finally {
			// finally block used to close resources
			try {
				if (statement != null) {
					statement.close();
					statement = null;
				}
				if (connection != null) {
					connection.close();
					connection = null;
				}
			} catch (SQLException e) {
				LOGGER.error("Error occured while closing connection.."
						+ e.getMessage());
				throw new LocalDALException(e);
			}
		}
		return status;
	}

	/**
	 * Gets the my sql path.
	 * 
	 * @param host
	 *            the host
	 * @param dbUsername
	 *            the db username
	 * @param dbPassword
	 *            the db password
	 * @return the my sql path
	 * @throws LocalDALException
	 *             the local dal exception
	 */
	private static String getMySqlPath(String host, String dbUsername,
			String dbPassword) throws LocalDALException {

		String dbUrl = ("jdbc:mysql://" + host + "/?user=" + dbUsername
				+ "&password=" + dbPassword);
		String dbClass = "com.mysql.jdbc.Driver";
		java.sql.Connection con = null;
		java.sql.Statement stmt = null;
		try {

			Class.forName(dbClass);
			con = DriverManager.getConnection(dbUrl);
			stmt = con.createStatement();
			ResultSet res = stmt.executeQuery("select @@basedir");
			String Mysqlpath = "";

			while (res.next()) {
				Mysqlpath = res.getString(1);
			}

			Mysqlpath = Mysqlpath.replace("Data", "bin");
			return Mysqlpath + "bin" + "/";

		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			// finally block used to close resources
			try {
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
				if (con != null) {
					con.close();
					con = null;
				}
			} catch (SQLException e) {
				throw new LocalDALException(e);
			}
		}

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * mkcl.os.localdal.model.ISqlOperation#createDBBackup(java.lang.String)
	 */
	public boolean createDBBackup(String backupPath) throws LocalDALException {

		if (backupPath == null || backupPath.trim().isEmpty()) {
			throw new LocalDALException("backupPath cannot be null or empty.");
		}

		String fileLocation = backupPath;

		InputStream inputstream = null;
		InputStreamReader inputstreamreader = null;
		BufferedReader bufferedreader = null;
		Process proc = null;
		try {
			String host = dataSource.getJdbcUrl().split("/")[2];
			final String dbUsername = dataSource.getUser();
			final String dbPassword = dataSource.getPassword();
			String databaseName = dataSource.getJdbcUrl().split("/")[3];

			if (databaseName.contains("?")) {
				databaseName = databaseName.substring(0,
						databaseName.indexOf("?"));
			}

			String mySqlPath = null;
			if (osname.indexOf("win") >= 0) {
				mySqlPath = getMySqlPath(host, dbUsername, dbPassword);
				mySqlPath = "\"" + mySqlPath.replace("\\", "/")
						+ "mysqldump.exe" + "\"";

				backupPath = "\"" + backupPath.replace("\\", "/") + "\"";
			} else if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) {
				mySqlPath = "mysqldump";
			}
			String port = null;
			// Now split host and take out port
			if (host.contains(":")) {
				port = host.split(":")[1];
				host = host.split(":")[0];
			}
			String[] executeCmd = null;
			if (port == null) {
				executeCmd = new String[] { mySqlPath, "-h" + host,
						"--user=" + dbUsername, "--password=" + dbPassword,
						databaseName, "-r", backupPath };
				// System.out.println(executeCmd);
			} else {
				executeCmd = new String[] { mySqlPath, "-h" + host,
						"--port=" + port, "--user=" + dbUsername,
						"--password=" + dbPassword, databaseName, "-r",
						backupPath };
			}
			/*
			 * for (int i = 0; i < executeCmd.length; i++) {
			 * System.out.println(executeCmd[i]); }
			 */
			ProcessBuilder builder = new ProcessBuilder(executeCmd);
			proc = builder.start();
			inputstream = proc.getErrorStream();

			inputstreamreader = new InputStreamReader(inputstream);
			bufferedreader = new BufferedReader(inputstreamreader);

			// read the output
			String line;
			while ((line = bufferedreader.readLine()) != null) {
				LOGGER.debug(line);
			}

			// check for failure
			try {
				if (proc.waitFor() != 0) {
					LOGGER.error("exit value = " + proc.exitValue());
					return false;
				}
			} catch (InterruptedException e) {
				throw new LocalDALException(e);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new LocalDALException(e);
		} finally {
			try {
				if (proc != null) {
					proc.destroy();
				}
				if (inputstream != null) {
					inputstream.close();
					inputstream = null;
				}
				if (inputstreamreader != null) {
					inputstreamreader.close();
					inputstreamreader = null;
				}
				if (bufferedreader != null) {
					bufferedreader.close();
					bufferedreader = null;
				}
				// delete batch file
				// batchFile.delete();
			} catch (Exception e) {
				throw new LocalDALException(e);
			}
		}
		// Encryption and Compression of dump file
		try {
			String textVal = DAL_Utility.getString(text);
			File file = new File(fileLocation);
			AESHelper.encryptAsCompress(file, file, textVal);
		} catch (Exception e) {
			throw new LocalDALException(e);
		}
		return true;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * mkcl.os.localdal.model.ISqlOperation#restoreBackupFile(java.lang.String,
	 * java.lang.String)
	 */
	public boolean restoreBackupFile(String database, String srcFilePath)
			throws LocalDALException {
		if (database == null || database.trim().isEmpty()) {
			throw new LocalDALException("database cannot be null or empty.");
		}

		if (srcFilePath == null || srcFilePath.trim().isEmpty()) {
			throw new LocalDALException("srcFilePath cannot be null or empty.");
		}

		// Decryption and Decompression
		try {
			String textVal = DAL_Utility.getString(text);
			File file = new File(srcFilePath);
			AESHelper.decryptAsdecompress(file, file, textVal);

		} catch (Exception e) {
			throw new LocalDALException(e);
		}

		Connection con = null;
		Statement stmt = null;
		ResultSet res = null;
		Process proc = null;
		String Mysqlpath = null;
		InputStream inputstream = null;
		InputStreamReader inputstreamreader = null;
		BufferedReader bufferedreader = null;
		try {
			String host = dataSource.getJdbcUrl().split("/")[2];
			final String dbUsername = dataSource.getUser();
			final String dbPassword = dataSource.getPassword();

			if (osname.indexOf("win") >= 0) {
				Mysqlpath = getMySqlPath(host, dbUsername, dbPassword);
				Mysqlpath = Mysqlpath.replace("\\", "/") + "mysql.exe";
				Mysqlpath = "\"" + Mysqlpath + "\"";
			} else if ((osname.indexOf("nux") >= 0)
					|| (osname.indexOf("nix") >= 0)) {
				Mysqlpath = "mysql";
			}

			String port = null;

			if (host.contains(":")) {
				port = host.split(":")[1];
				host = host.split(":")[0];
			}
			String[] executeCmd = null;
			if (port == null)
				executeCmd = new String[] { Mysqlpath, "-h" + host,
						"--user=" + dbUsername, "--password=" + dbPassword,
						database, "-e source " + srcFilePath };
			else {
				executeCmd = new String[] { Mysqlpath, "-h" + host,
						"--port=" + port, "--user=" + dbUsername,
						"--password=" + dbPassword, database,
						"-e source " + srcFilePath };
			}

			ProcessBuilder builder = new ProcessBuilder(executeCmd);

			proc = builder.start();
			inputstream = proc.getErrorStream();

			inputstreamreader = new InputStreamReader(inputstream);
			bufferedreader = new BufferedReader(inputstreamreader);

			// read the output
			String line;
			while ((line = bufferedreader.readLine()) != null) {
				LOGGER.debug(line);
			}
			proc.waitFor();
			if (proc.exitValue() != 0) {
				return false;
			} else {
				return true;
			}
		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			proc.destroy();
			try {
				if (res != null) {
					res.close();
					res = null;
				}
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
				if (con != null) {
					con.close();
					con = null;
				}
				if (inputstream != null) {
					inputstream.close();
					inputstream = null;
				}
				if (inputstreamreader != null) {
					inputstreamreader.close();
					inputstreamreader = null;
				}
				if (bufferedreader != null) {
					bufferedreader.close();
					bufferedreader = null;
				}
				String textVal = DAL_Utility.getString(text);
				File file = new File(srcFilePath);
				AESHelper.encryptAsCompress(file, file, textVal);

			} catch (Exception ex) {
				throw new LocalDALException(ex);
			}

		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see mkcl.os.localdal.model.ISqlOperation#getPassword(java.lang.String)
	 */
	@Override
	public String getPassword(String encrpytedFilePath)
			throws LocalDALException {

		Properties properties = new Properties();
		InputStream dalPropertyStream = null;
		InputStream jfile = null;
		OutputStream out = null;
		String strPassword = null;
		try {

			if (encrpytedFilePath == null
					|| encrpytedFilePath.trim().equals("")) {
				dalPropertyStream = Thread.currentThread()
						.getContextClassLoader()
						.getResourceAsStream("dal.properties");
				properties.load(dalPropertyStream);
				String path = properties.getProperty("path.value");
				jfile = Thread.currentThread().getContextClassLoader()
						.getResourceAsStream(path);
			} else {
				jfile = new FileInputStream(new File(encrpytedFilePath));
			}

			String textVal = DAL_Utility.getString(text);
			out = AESHelper.decryptAsStream(jfile, textVal);
			strPassword = out.toString();

		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			try {
				if (dalPropertyStream != null) {
					dalPropertyStream.close();
					dalPropertyStream = null;
				}
				if (jfile != null) {
					jfile.close();
					jfile = null;
				}
				if (out != null) {
					out.close();
					out = null;
				}
			} catch (IOException e) {
				throw new LocalDALException(e);
			}
		}
		return strPassword;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * mkcl.os.localdal.model.ISqlOperation#getdbProperties(java.lang.String)
	 */
	public Map<String, Object> getdbProperties(String connectionFilePath)
			throws LocalDALException {
		Map<String, Object> dbPropertiesMap = null;
		Properties properties = new Properties();
		InputStream connectionStream = null;
		String dbUsername = null, dbName = null, dbPort = null, dbUrl = null;

		try {
			if (connectionFilePath != null) {
				connectionStream = new FileInputStream(connectionFilePath
						+ File.separator + "connection.properties");
			} else {
				connectionStream = Thread.currentThread()
						.getContextClassLoader()
						.getResourceAsStream("connection.properties");
			}
			properties.load(connectionStream);

			if (!properties.isEmpty()) {
				dbPropertiesMap = new HashMap<String, Object>();
				// dbUsername
				dbUsername = properties.getProperty("USERNAME");

				// dbUrl
				dbUrl = properties.getProperty("DB_URL");

				// dbName
				if (dbUrl.indexOf("?") != -1) {
					dbName = dbUrl.substring(dbUrl.lastIndexOf("/") + 1,
							dbUrl.indexOf("?"));
				} else {
					dbName = dbUrl.substring(dbUrl.lastIndexOf("/") + 1);
				}

				// dbPort
				if (dbUrl.indexOf(":") != -1) {
					dbPort = dbUrl.substring(dbUrl.lastIndexOf(":") + 1,
							dbUrl.lastIndexOf("/"));
				}

				// add al the required properties to the map
				dbPropertiesMap.put("dbUsername", dbUsername);
				dbPropertiesMap.put("dbName", dbName);
				dbPropertiesMap.put("dbPort", dbPort);

			}

		} catch (Exception e) {
			throw new LocalDALException(e);
		} finally {
			try {
				if (connectionStream != null) {
					connectionStream.close();
					connectionStream = null;
				}
				properties = null;
			} catch (IOException e) {
				throw new LocalDALException(e);
			}

		}
		return dbPropertiesMap;
	}
}
