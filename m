Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D25F271A5F
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Sep 2020 07:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIUFYu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Sep 2020 01:24:50 -0400
Received: from mailout11.telekom.de ([194.25.225.207]:9667 "EHLO
        mailout11.telekom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIUFYu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Sep 2020 01:24:50 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 01:24:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=t-systems.com; i=@t-systems.com; q=dns/txt; s=mail;
  t=1600665888; x=1632201888;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
  b=FMB06ssltItCkufzxljjz4g0qwtmdbsyfcOxHEDZDNK3s5ioX6UIoAnq
   zHfi2IFtb/cY4L2kIYIVlAUiwfdkrZb4+UU8cCjtAElyOtGyWyOSk4zqS
   cwt9F9MkTdGiuxHO7zoCNNEbEApWE1CuuZM5qydD7nOunvKphh0+y0sHS
   +qOqJWj6Wx52zgUlEHGidzxa4b8W5rSwhvS7Sd/S1nzX2fmiMJvfrThoX
   fmnkNcM90RkyDCA8NV3mtWUHUs3fQad0jiiOYhq+ExYPsooIiRxu4+tjA
   oqXPuSKY7sQc/iFdJQOl8U4nnw8f77rQ3oVjj0RF4oZ0A8zO4p3jmHnxH
   g==;
Received: from qde9xy.de.t-internal.com ([10.171.254.32])
  by MAILOUT11.dmznet.de.t-internal.com with ESMTP/TLS/DHE-RSA-AES128-SHA256; 21 Sep 2020 07:15:03 +0200
IronPort-SDR: X4DmpUj05ElRjgbyH7lJxWgVqJsRE76zEX71wmNcdbGeqzeDQqzNAsnb7QGjFIOhh0k79+BwGU
 Bq56swWpjbW0QnATlQL7XjPp7uhfXXYeU=
X-IronPort-AV: E=Sophos;i="5.77,285,1596492000"; 
   d="scan'208";a="176191734"
X-MGA-submission: =?us-ascii?q?MDHkWqbPfcs3rYd3xlN8Q1Ew0LlK71PG2JmpfK?=
 =?us-ascii?q?MG+gbtAi3BOyraYTAV3FpGEbANRjxpUJCDT7+tEP5xNAn+457Ys6QlLw?=
 =?us-ascii?q?xfFx4voVnDLPxDosjO1/9P98asaGtiJ8Xc9rLsJIVY34wjJQ9YuqFWoR?=
 =?us-ascii?q?o0HFtKHywteWrglItSXm7j2w=3D=3D?=
Received: from he105712.emea1.cds.t-internal.com ([10.169.118.43])
  by QDE9Y1.de.t-internal.com with ESMTP/TLS/ECDHE-RSA-AES128-SHA256; 21 Sep 2020 07:15:03 +0200
Received: from HE105717.EMEA1.cds.t-internal.com (10.169.118.53) by
 HE105712.emea1.cds.t-internal.com (10.169.118.43) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 21 Sep 2020 07:15:02 +0200
Received: from HE106564.emea1.cds.t-internal.com (10.171.40.16) by
 HE105717.EMEA1.cds.t-internal.com (10.169.118.53) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2 via Frontend Transport; Mon, 21 Sep 2020 07:15:03 +0200
Received: from GER01-LEJ-obe.outbound.protection.outlook.de (51.5.80.17) by
 O365mail01.telekom.de (172.30.0.234) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 21 Sep 2020 07:14:59 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzl51z/spJO920vchg70uJbq3pIqFdyLL5VVC6cAosFlO4YFbBdepQjBNA96HoyEwzdz7vbFbelk27DYjKhRnASfFAyW/jYtr7fpqlRyh5S330nO8S9C9ZAryxphKe38HY+DeLWNjbn7H86uFWK5IdlgvcxkoxJEV5kh7hWD3SPWa19Pf5BUijawhdxALVmFbU2wT3+8/N2cHYTf+5yKf2N57Lec3xRWRGocsE9xkPdonYCJyyNiO9om5tH+MGCKGumnl+WVqmMIOD8tocRSuAdBg4mvAKE/ZA3enMFKS+Kl+ktGEVU3ac9STeCnkI8hXz6EyoF9tfR3/CxCUKqR6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
 b=Qsh8pfT50wVgEVSskveK+o17Bxi2OFDEQLdO4KOVv5yLF4/5WCZaMaEi4v05RAi5FytVYBImIf0DExM8lN+4+18RiH8iHx4KnmkfbFavk9klE5ulLzunq6e3lXCG2aN53qrPQ9WYbjJW0voD6Wx4j4VKrFGc1a5qj65Cj+PbkWjl6guftWzzaIX2iM8cVsXEkmaKhMD2UcSOjpk126GO4v977XJfSjjAlJuN1XCXx9OrZ+Ujy8LK2TPVpZZK7+bev3QOezR4MDaCsGDXwqbpCFhdC9zZZ/W68ysPI1SX6qY9HHDFucXSUC/nssH5AHdhuFZuRI76jDyzgB3hRHDYIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=t-systems.com; dmarc=pass action=none
 header.from=t-systems.com; dkim=pass header.d=t-systems.com; arc=none
Received: from LEXPR01MB0720.DEUPRD01.PROD.OUTLOOK.DE (2a01:4180:c013:5::25)
 by LEXPR01MB0719.DEUPRD01.PROD.OUTLOOK.DE (2a01:4180:c013:e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.11; Mon, 21 Sep
 2020 05:15:02 +0000
Received: from LEXPR01MB0720.DEUPRD01.PROD.OUTLOOK.DE
 ([fe80::6523:3408:8606:5329]) by LEXPR01MB0720.DEUPRD01.PROD.OUTLOOK.DE
 ([fe80::6523:3408:8606:5329%4]) with mapi id 15.20.3412.018; Mon, 21 Sep 2020
 05:15:02 +0000
From:   <Dennis.Grandt@t-systems.com>
To:     <ceph-devel@vger.kernel.org>
Subject: AW: 
Thread-Index: AQHWjHqAMwDjMmR8xUaKOeE1JsQIAqlyk0uw
Date:   Mon, 21 Sep 2020 05:15:02 +0000
Message-ID: <LEXPR01MB07204087B9568D1581E07704A53A0@LEXPR01MB0720.DEUPRD01.PROD.OUTLOOK.DE>
References: <DD45753A-F168-4ED4-B7FD-1492466F02FB@gmail.com>
In-Reply-To: <DD45753A-F168-4ED4-B7FD-1492466F02FB@gmail.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=t-systems.com;
x-originating-ip: [95.222.239.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 610f55b0-8411-49e5-1e72-08d85ded4b39
x-ms-traffictypediagnostic: LEXPR01MB0719:
x-microsoft-antispam-prvs: <LEXPR01MB07190BE6DB95D350FF07762AA53A0@LEXPR01MB0719.DEUPRD01.PROD.OUTLOOK.DE>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gMQJFX+zWd2S0/Xdh7JycFdooxvRWROlqu+2Jo6W5z8mRI5rPV3diXfrGt94elBZ0UfD0vXfOs9fM9+e1neQz9YC9E1/QbCUKsLpgZqaRLZE7D6FB/uFz8qO52HhkyGMX8gVvgW8hxQL/Ibn2XuEz4kpcMn6LU3+A7irCwkYuNdJYhPw/x38GOnJN0XPIGtc4i8WUSwgBlYJCN4r6EodH2sApU1pfX9lwqi16JT460K2WlEbZC8usLALQx1LO9MduJQM2bM776wqeMPCek6hKbpU1vx9KpSb/22RPO18x/Tf8q1YZzLNjbNXnPeoJ8AZ1BZ2ilFHlrg5c+UplcKZbHqi5ETk0clSy53UwaB6hFBOZXE09cHCtP0jWYq+rifi+HmVw1nZjbZLu3Zq9uF8ybJT5gHOIG3xAozEfklEbOV/MicuDlUnhssheCMzfoJQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LEXPR01MB0720.DEUPRD01.PROD.OUTLOOK.DE;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(508600001)(2906002)(55016002)(9686003)(4743002)(19618925003)(6916009)(66476007)(66556008)(64756008)(66446008)(71200400001)(66946007)(76116006)(3480700007)(86362001)(7696005)(8936002)(7116003)(26005)(33656002)(8676002)(186003)(558084003)(239884005)(425394004)(19559445001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: O3Fu4k7I6eKi/gx8d9mG5usm2AiT25+/0hc2vY25gqe0oHl4Qi22DW0PPYnatW/gYNZjdtMHobgqvGy7JkB3aoMptZYfKvIsh8bRYl2oA0bnQbZpGRBGBfGvFgkRRQZ7lUtbm6r2u6TcXdu/toC/OBlIwgsPVYkClkNc87lNWyvUhknU72TPA8mxfq/KXdo7IRYatpJErlx7ViFAqsqSLit/GCgCKVKdKCtr6r1A3cv/3ynmMlHxwIOgIPsYSY6Cy66+icGfxpX6iWMReLZ8ZDVtiwv0898zCmgWk5Y+vjCTnGzhq1AvBzQp6CJ9jsicBQAWFWtWz9epwEg6jdGF6naARjEaS6FyHOtrb5Aks0ploRlCoL0SpG9l0AuMwD2nfguESN4nSTnXfzU+kpayEIxx5UzDBfbU+SOcbDDdpP8qJNdVzj50qQ3xs99N3s9JTtD28p9ADt+joDN9IF9tISL0h4+AHoSMdUm8t4mejrrA6Jzk3+/5biivsIqr1NErQnFPI6n0/BA0J06Hd5fjdcPdXLPUxOMR/A3aZEH3pSzcAxbqkrK1z5eJbKU35iUzgIHM9oh/Lxo9TjtAASEZX9C7cs/eGE8VmVxxNyHOXTc063xNZN03N9IIgTlAWe2L/eA+RQTzQCQO1Uss5LzUYg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LEXPR01MB0720.DEUPRD01.PROD.OUTLOOK.DE
X-MS-Exchange-CrossTenant-Network-Message-Id: 610f55b0-8411-49e5-1e72-08d85ded4b39
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 05:15:02.3082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bde4dffc-4b60-4cf6-8b04-a5eeb25f5c4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zrZ43f1o+Jd5sdNUjJEoz9FLXy+yvo+Xb4cIvVV7FvTTZrKI7HUt7CLgNsyhKnestJJMXSWZU+kb5r0crJIzfnQZjz4weaPTrQiy3X616yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LEXPR01MB0719
X-TM-SNTS-SMTP: DD075E6D13BC8AC7C304502DD87385ED808988A9431B79EFF7691DA99A8CFE8E2000:8
X-OriginatorOrg: t-systems.com
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

unsubscribe
