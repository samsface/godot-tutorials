extends Viewport

export(bool) var paused := false setget set_paused
var empty_texture   := preload("res://junk/empty-256x256.png")
var mutex_          := Mutex.new()
var done_mutex_     := Mutex.new()
var semaphore_      := Semaphore.new()
var thread_         := Thread.new()
var abort_          := false
var job_queue_      := []
var done_queue_     := []

var main_thread_job_semaphore_ := Semaphore.new()
var main_thread_job_:Job 
var main_thread_job_co_:GDScriptFunctionState

func set_paused(value:bool) -> void:
	#if value != paused:
	#	prints("WORKER PAUSED", value)
	paused = value

func _ready() -> void:
	thread_.start(self, "work_", "no_arg")

func bake() -> Texture:
	var data    := get_texture().get_data()
	var texture := ImageTexture.new()
	texture.create_from_image(data, 0)

	return texture

func post_job(job:Job) -> void:
	mutex_.lock()
	job_queue_.push_back(job)
	mutex_.unlock()
	
	semaphore_.post()

func _process(delta : float) -> void:
	if paused:
		return

	if main_thread_job_:
		if main_thread_job_co_:
			main_thread_job_co_ = main_thread_job_co_.resume()
			
			if not main_thread_job_co_:
				main_thread_job_ = null
				main_thread_job_semaphore_.post()

		else:
			main_thread_job_co_ = main_thread_job_._instance()
			if not main_thread_job_co_:
				main_thread_job_ = null
				main_thread_job_semaphore_.post()

	var done_job:Job
	done_mutex_.lock()
	if not done_queue_.empty():
		done_job = done_queue_.pop_front()
	done_mutex_.unlock()
	
	if done_job:
		if is_instance_valid(done_job.requester):
			done_job.requester.call(done_job.callback_func, done_job)
		else:
			print("instance_valid " + str(done_job.requester))
			done_job._on_requester_invalid()

func work_(no_arg) -> void:
	while true:
		semaphore_.wait()
		
		if abort_:
			return
		
		var job:Job
		mutex_.lock()
		if not job_queue_.empty():
			job = job_queue_.pop_front()
		mutex_.unlock()

		if job:
			job.work()
		
			done_mutex_.lock()
			done_queue_.push_back(job)
			done_mutex_.unlock()

func _exit_tree() -> void:
	abort_ = true
	if thread_.is_active():
		semaphore_.post()
		main_thread_job_semaphore_.post()
		thread_.wait_to_finish()
