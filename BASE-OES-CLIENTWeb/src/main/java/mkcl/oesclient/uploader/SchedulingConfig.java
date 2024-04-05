package mkcl.oesclient.uploader;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;

@Configuration
@EnableScheduling
public class SchedulingConfig implements SchedulingConfigurer 
{
	
	@Override
	public void configureTasks(ScheduledTaskRegistrar taskRegistrar) 
	{
		taskRegistrar.setScheduler(taskExecutor());
	}
	
	@Bean(destroyMethod="shutdown",name="taskExecutor",value="taskExecutor")
    public ScheduledExecutorService taskExecutor() 
	{
        return Executors.newScheduledThreadPool(10, new CustomThreadFactory());
    }
	
	@Bean(name="candidateExamDataUploader",value="candidateExamDataUploader")
    public CandidateExamDataUploader candidateExamDataUploader() 
	{
        return new CandidateExamDataUploader();
    }

}

class CustomThreadFactory implements ThreadFactory 
{
	AtomicInteger threadNo = new AtomicInteger(0);
	@Override
	public Thread newThread(Runnable r) {
		return new Thread(r,"TASK_EXECUTOR_THREAD_" + threadNo.getAndIncrement());
	}
}
