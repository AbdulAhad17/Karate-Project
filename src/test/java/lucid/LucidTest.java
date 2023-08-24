package lucid;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class TestAllFeatures {

    @Test
    void runTests() {
        String environment = System.getenv("LUCID_ENVIRONMENT");

        String tags = System.getProperty("tags");

        Runner.Builder runner = Runner.path("classpath:lucid")
                .outputJunitXml(true)
                .karateEnv(environment);

        if (tags != null && !tags.equals("")) {
            for (String tag : tags.split(",")) {
                runner.tags("@" + tag);
            }
        }

        Results results = runner.parallel(2);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
