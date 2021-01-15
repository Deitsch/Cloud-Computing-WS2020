import os
import sys
import exoscale

apiKey = os.getenv('EXOSCALE_KEY')
apiSecret = os.getenv('EXOSCALE_SECRET')
zone = os.getenv('EXOSCALE_ZONE')
poolId = os.getenv('EXOSCALE_INSTANCEPOOL_ID')

size = int(sys.argv[1])

# run: scale.py size

exo = exoscale.Exoscale(api_key=apiKey, api_secret=apiSecret) 
exoZone = exo.compute.get_zone(zone)

instancePool = exo.compute.get_instance_pool(id=poolId, zone=exoZone)
instancePool.scale(size)