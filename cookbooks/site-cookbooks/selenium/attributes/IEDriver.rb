default['selenium']['IEDriver']['directory'] = 'C:\selenium'
case node["kernel"]["machine"]
when "x86_64"
  default["selenium"]["IEDriver"]["url"] = "https://selenium.googlecode.com/files/IEDriverServer_x64_2.32.3.zip"
else
  default["selenium"]["IEDriver"]["url"] = "https://selenium.googlecode.com/files/IEDriverServer_Win32_2.32.3.zip"
end
