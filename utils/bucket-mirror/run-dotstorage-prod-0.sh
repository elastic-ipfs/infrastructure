for i in $(seq 1 1000); do [ $i -gt 1 ] && sleep 5; export NEXT_CONTINUATION_TOKEN=$(cat NextContinuationToken || "") || true; echo "Run started at $(date +"%T")" >> run-dotstorage-prod-0.log; node bucket-mirror.js && s=0 && break || s=$?; done; (exit $s)