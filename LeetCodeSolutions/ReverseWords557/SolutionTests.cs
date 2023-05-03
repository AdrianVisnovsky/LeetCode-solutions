using Xunit;

namespace ReverseWords557
{
    public class SolutionTests
    {

        private readonly Solution _sut;

        public SolutionTests()
        {
            _sut = new Solution();
        }

        [Fact]
        public void TestReverse1()
        {

            string input = "Let's take LeetCode contest";
            string result = _sut.ReverseWords(input);
            string expectedResult = "s'teL ekat edoCteeL tsetnoc";

            Assert.Equal(expectedResult, result);

        }

        [Theory]
        [InlineData("Let's take LeetCode contest", "s'teL ekat edoCteeL tsetnoc")]
        [InlineData("God Ding", "doG gniD")]
        [InlineData("", "")]
        public void TestReverse(string input, string expected)
        {

            string result = _sut.ReverseWords(input);

            Assert.Equal(expected, result);

        }

    }
}
