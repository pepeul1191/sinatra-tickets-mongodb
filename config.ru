require_relative 'config/environment'

use TagController
use AssetController
use IssueStateController
use PriorityController

run ApplicationController