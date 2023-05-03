using System.Text;

namespace ReverseWords557
{
	internal class Solution
	{

		public string ReverseWords(string s)
		{

			int sLength = s.Length;
			StringBuilder stringBuilder = new StringBuilder(sLength);

			int wordStart;
			int wordEnd;

			for (int i = 0; i < sLength; i++)
			{
				wordStart = i;
				for (int j = i; j < sLength; j++)
				{
					if (s[j] == ' ')
					{
						wordEnd = j - 1;

						for (int k = wordEnd; k > wordStart - 1; k--)
						{
							stringBuilder.Append(s[k]);
						}
						stringBuilder.Append(" ");

						i = j;

						break;
					}
					else if (j == sLength - 1)
					{
						wordEnd = j;

						for (int k = wordEnd; k > wordStart - 1; k--)
						{
							stringBuilder.Append(s[k]);
						}

						i = j;

						break;
					}

				}

			}

			return stringBuilder.ToString();
		}

        public string ReverseWords2(string s)
        {

            string[] splitted = s.Split(" ");
            string result = "";

            foreach (string word in splitted)
            {
                result += new string(word.Reverse().ToArray()) + " ";
            }

            return result.TrimEnd();
        }

    }

}
