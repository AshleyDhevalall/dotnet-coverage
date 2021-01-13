using Xunit;

namespace Cover.Tests
{
  public class UnitTest1
  {
    [Fact]
    public void Test1()
    {
      var result = Program.Sum(1, 3);  // This comes from 'using Cover'
      Assert.Equal(4, result);  // This comes from 'using Xunit'
    }
  }
}
