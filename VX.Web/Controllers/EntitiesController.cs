﻿using System.Web.Mvc;
using VX.Web.Infrastructure;

namespace VX.Web.Controllers
{
    public class EntitiesController : ControllerBase
    {
        public EntitiesController(IMembershipService membershipService, ISettingsReader settingsReader) 
            : base(membershipService, settingsReader)
        {
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Banks()
        {
            ViewData["VocabExtServiceRest"] = SettingsReader.VocabExtServiceRest;
            return View();
        }
    }
}