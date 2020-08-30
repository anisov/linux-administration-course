 
#!/bin/bash

$(dirname $(realpath $0))/lock.sh $(dirname $(realpath $0))/parser.sh | mail -s "Report: " root@localhost
