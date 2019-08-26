#!/bin/bash
DB_NAME=$1

echo '{' > /root/docker/aspnetcore22/appsettings.json
echo '  "ConnectionStrings": {' >> /root/docker/aspnetcore22/appsettings.json
echo '    "BaseCotacoes": "Host='$DB_NAME';Port=5432;Pooling=true;Database='$DB_NAME';User Id=postgres;Password=J4n10.123;"' >> /root/docker/aspnetcore22/appsettings.json
echo '  },' >> /root/docker/aspnetcore22/appsettings.json
echo '  "Logging": {' >> /root/docker/aspnetcore22/appsettings.json
echo '    "IncludeScopes": false,' >> /root/docker/aspnetcore22/appsettings.json
echo '    "LogLevel": {' >> /root/docker/aspnetcore22/appsettings.json
echo '      "Default": "Debug",' >> /root/docker/aspnetcore22/appsettings.json
echo '      "System": "Information",' >> /root/docker/aspnetcore22/appsettings.json
echo '      "Microsoft": "Information"' >> /root/docker/aspnetcore22/appsettings.json
echo -e '    }'\\n'  }'\\n'}' >> /root/docker/aspnetcore22/appsettings.json
