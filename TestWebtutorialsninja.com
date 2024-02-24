import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.time.Duration;

//tulis manual dari sini
public class SeleniumTest {
WebDriver driver;

@Test
public void loginTest(){
    //open browser
    WebDriverManager.firefoxdriver().setup();
    driver = new FirefoxDriver();
    driver.manage().window().maximize();
    driver.get("https://tutorialsninja.com/demo/index.php");
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(30));

    //click My Account
    wait.until((ExpectedConditions.visibilityOfElementLocated(By.xpath("//span[.='My Account']"))));
    driver.findElement(By.xpath("//span[.='My Account']")).click();
    driver.findElement(By.xpath("//a[.='Login']")).click();

    //input username and password
    wait.until((ExpectedConditions.visibilityOfElementLocated(By.xpath("//input[@id='input-email']"))));
    driver.findElement(By.xpath("//input[@id='input-email']")).sendKeys("hilibrikateu-4757@yopmail.com");
    driver.findElement(By.xpath("//input[@id='input-password']")).sendKeys("123456");
    driver.findElement(By.xpath("//input[@class='btn btn-primary']")).click();

    //verify Success login
    wait.until((ExpectedConditions.visibilityOfElementLocated(By.xpath("//h2[.='My Orders']"))));
    String txtSecureAreaActual = driver.findElement(By.xpath("//h2[.='My Orders']")).getText();
    String txtSecureAreaExpected = "My Orders";

    Assert.assertEquals(txtSecureAreaActual, txtSecureAreaExpected);

    //close browser
    driver.quit();

    }

}
