default['selenium']['chromedriver']['directory']

case node["os"]
when "linux"
  default['selenium']['chromedriver']['directory'] = "/usr/local/bin"
  case node["kernel"]["machine"]
  when "x86_64"
    default["selenium"]["chromedriver"]["url"] = "https://chromedriver.googlecode.com/files/chromedriver2_linux64_0.8.zip"
  else
    default["selenium"]["chromedriver"]["url"] = "https://chromedriver.googlecode.com/files/chromedriver_linux32_26.0.1383.0.zip"
  end
when "windows"
  default['selenium']['chromedriver']['directory'] = 'C:\selenium'
  default["selenium"]["chromedriver"]["url"] = "https://chromedriver.googlecode.com/files/chromedriver2_win32_0.8.zip"
end
