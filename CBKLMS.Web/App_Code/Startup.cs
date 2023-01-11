using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CBKLMS.Web.Startup))]
namespace CBKLMS.Web
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
