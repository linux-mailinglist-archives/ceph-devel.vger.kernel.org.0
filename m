Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80925137A3C
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jan 2020 00:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgAJX3M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 18:29:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:46942 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbgAJX3M (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 18:29:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 15:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,418,1571727600"; 
   d="scan'208";a="218210898"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jan 2020 15:29:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Jan 2020 15:29:10 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 15:29:10 -0800
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 10 Jan 2020 15:29:10 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 10 Jan 2020 15:29:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb6/HY6lxL46Ei5tEk9kLFWs8wep0KN6ngs+TuCPE7aDIY8t58sly7STN1xfVcW84aylE/PKm3NN8bRy+UDbsRHWH7dUGx4UDHSau1itl3xMKKP0TQb5fttROtw/99Vy7Rm9JKr88TXgN5MAPJ3JskCcuoS8IVMKGl0//ns05z4Jq/JU2+m1C+/G2MiDpkRWpIsnIhPK8r7251dMhuNLLHWJkRicN0T7BvNIp+DnXFHvhTLBAVAxr4WMXMS5fHrSnsY67atuX7crtVGrUwYHgOXHvi1Nsd1qtDZMmPRoQ5xn2WzpUdMpk4xvmlNPHu4m52Pmf0Zyy3ognx1U+z/jVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdG74TMCG3tKDz7zEJ5t4p/Sbm9IqnIVA6cb0vUrAC4=;
 b=Zcq0WW1mbIzD8TdEMkggXA7J0vlZOklTGYVzHy03kEDyfc55aO4xk3D156DxiA/EmWn2TCOtR61Kz4t5YbBj3xlY3b+1rkHaA1WgDqwaA4kx2psiLRPmtA/U02FwodwoYGIZ/4j6lJ5DztOMEt+u+TAszHQjUuislnOjN2j5P/eaEW/3ZBky2Ybj9k9vUWwXlIprK5y5hTZMsBIqlF8Rqd0fw+S+XjYmz4BQJhGYLwOIjTWB+KxlYk7xj+PF3bywyg8iPW8/vrREolJDaIpKlJyziOUx0l/kHPwjkzSeFWiRdm2qdKHxz9w1bo0iMGtKCf9ce1ZZNCJITg2EG5xANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdG74TMCG3tKDz7zEJ5t4p/Sbm9IqnIVA6cb0vUrAC4=;
 b=GjdX+GM9VeIGAXSKw55sWodAO4kW6Ps4NM2fQrOvMWlBJ8qLssD4ufNEVjK0Cxl6H3b82AcpbcFqOEy4JIkxcmN1u4xESsoZ4lHBhiB9XgTv8JaNMFPdrXfZsdLkTY16RV0RG/1RJV3ZGMasz2GZ9HS/8HZ62dG3rT3k7y7gHoo=
Received: from BY5PR11MB4273.namprd11.prod.outlook.com (52.132.255.32) by
 BY5PR11MB4210.namprd11.prod.outlook.com (52.132.253.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 23:28:59 +0000
Received: from BY5PR11MB4273.namprd11.prod.outlook.com
 ([fe80::9404:81be:8a3e:5477]) by BY5PR11MB4273.namprd11.prod.outlook.com
 ([fe80::9404:81be:8a3e:5477%6]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 23:28:59 +0000
From:   "Liu, Chunmei" <chunmei.liu@intel.com>
To:     Roman Penyaev <rpenyaev@suse.de>, kefu chai <tchaikov@gmail.com>,
        "Ma, Jianpeng" <jianpeng.ma@intel.com>
CC:     Radoslaw Zarzynski <rzarzyns@redhat.com>,
        Samuel Just <sjust@redhat.com>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
Subject: RE: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
Thread-Topic: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
Thread-Index: AQHVxvPkJuFmrnJTI0aYjAoqNUuMEKfkFTEAgAArcACAAEdSIA==
Date:   Fri, 10 Jan 2020 23:28:59 +0000
Message-ID: <BY5PR11MB4273BE8C4A3FB0E3D01A20ACE0380@BY5PR11MB4273.namprd11.prod.outlook.com>
References: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
 <CAJE9aON93O75PPRjfuFGYrtpBxRHHuepGX+tEC3FkBSgM6TgNQ@mail.gmail.com>
 <f3a976a6d2eba9cd8bd6bf46c0fc9967@suse.de>
In-Reply-To: <f3a976a6d2eba9cd8bd6bf46c0fc9967@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-reaction: no-action
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWY5YTNkNGMtOGNlNy00NGVkLWFkMTYtOWFlNWYxZDAzYmM3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUm5STTY3XC8yTlJXVytzKzZ2WHNRajdiZzYzWHVaRFNRcG81emtcL2Y1Umh1Z01VbVpmV1UwVDA0eG5abVdOaUFcLyJ9
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=chunmei.liu@intel.com; 
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a1ecf32-e59a-41d4-bdbf-08d79624dec6
x-ms-traffictypediagnostic: BY5PR11MB4210:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4210AF270014C7131E87F466E0380@BY5PR11MB4210.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39860400002)(396003)(376002)(189003)(199004)(8936002)(81156014)(81166006)(66476007)(2906002)(66946007)(55016002)(52536014)(76116006)(54906003)(6506007)(8676002)(64756008)(71200400001)(316002)(33656002)(66446008)(4326008)(9686003)(966005)(26005)(53546011)(66556008)(110136005)(5660300002)(478600001)(15650500001)(186003)(6636002)(86362001)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR11MB4210;H:BY5PR11MB4273.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ixTUquJh86JgpIz4EiwAe0FsqMhxBdXmXZUTuTY3G25WFO/XTScH+yMAsfIsvYSS++/MgW3QTRsLvYX1k2vKx9AG/cIJIUB8UDSSKKpid3BChPiErmXudiw6xlXqTJVL6Tw4J/D2SUreqZza6fNytAZ4M3NXFrp2wMXDg6zlCYuvpd6Pi1eXKWbhtmntoSDGPtq8cqM3bSpc8HwDI2brKjTj6PojwS5bZKlEUMROKpv4usnYHBL/Y7zxn8UAG/4gm9QaHz8U752jSQQOdOlCaae+NFIPkNPsf4GqqGLyez9egVeCuhqM+GNwewzfcFFiwbKkWgJyDgRALavjFW5ih3Cp39kG4mX3/X6BqbYW+Q6KUPiaPAu3KcH0BtqEoHizI4ypUaopJwViqDVfW90ABwJ+KORAShs9Wqz/U6BaABIbnKv/7dXEwqTfD6qD2VOXRit/8/27VsKwOB2OPo31WkIFdUG7yejub1HY2ExUWAw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1ecf32-e59a-41d4-bdbf-08d79624dec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 23:28:59.4841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dq9Artq5Yp+XC+Yx+Z26AT+h2Xq0E6E9CWfhZ4+2kheTZIfYgXLPW9NGwKx3jBCKI/1aEnBRGGhWdtJ45vv//w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4210
X-OriginatorOrg: intel.com
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



> -----Original Message-----
> From: ceph-devel-owner@vger.kernel.org <ceph-devel-owner@vger.kernel.org>
> On Behalf Of Roman Penyaev
> Sent: Friday, January 10, 2020 10:54 AM
> To: kefu chai <tchaikov@gmail.com>
> Cc: Radoslaw Zarzynski <rzarzyns@redhat.com>; Samuel Just
> <sjust@redhat.com>; The Esoteric Order of the Squid Cybernetic <ceph-
> devel@vger.kernel.org>
> Subject: Re: crimson-osd vs legacy-osd: should the perf difference be alr=
eady
> noticeable?
>=20
> On 2020-01-10 17:18, kefu chai wrote:
>=20
> [skip]
>=20
> >>
> >> First thing that catches my eye is that for small blocks there is no
> >> big difference at all, but as the block increases, crimsons iops
> >> starts to
> >
> > that's also our findings. and it's expected. as async messenger uses
> > the same reactor model as seastar does. actually its original
> > implementation was adapted from seastar's socket stream
> > implementation.
>=20
> Hm, regardless of model messenger should not be a bottleneck.  Take a loo=
k on
> the results of fio_ceph_messenger load (runs pure messenger), I can squee=
ze
> IOPS=3D89.8k, BW=3D351MiB/s on 4k block size, iodepth=3D32.
> (also good example https://github.com/ceph/ceph/pull/26932 , almost
> ~200k)
>=20
> With PG layer (memstore_debug_omit_block_device_write=3Dtrue option) I ca=
n
> reach 40k iops max.  Without PG layer (immediate completion from the
> transport callback, osd_immediate_completions=3Dtrue) I get almost 60k.
>=20
> Seems that here starts playing costs on client side and these costs preva=
il.
>=20
> >
> >> decline. Can it be the transport issue? Can be tested as well.
> >
> > because seastar's socket facility reads from the wire with 4K chunk
> > size, while classic OSD's async messenger reads the payload with the
> > size suggested by the header. so when it comes to larger block size,
> > it takes crimson-osd multiple syscalls and memcpy calls to read the
> > request from wire, that's why classic OSD wins in this case.
>=20
> Do you plan to fix that?
>=20
> > have you tried to use multiple fio clients to saturate CPU capacity of
> > OSD nodes?
>=20
> Not yet.  But regarding CPU I have these numbers:
>=20
> output of pidstat while rbd.fio is running, 4k block only:
>=20
> legacy-osd
>=20
> [roman@dell ~]$ pidstat 1 -p 109930
> Linux 5.3.13-arch1-1 (dell)     01/09/2020      _x86_64_        (8 CPU)
>=20
> 03:51:49 PM   UID       PID    %usr %system  %guest   %wait    %CPU
> CPU  Command
> 03:51:51 PM  1000    109930   14.00    8.00    0.00    0.00   22.00
> 1  ceph-osd
> 03:51:52 PM  1000    109930   40.00   19.00    0.00    0.00   59.00
> 1  ceph-osd
> 03:51:53 PM  1000    109930   44.00   17.00    0.00    0.00   61.00
> 1  ceph-osd
> 03:51:54 PM  1000    109930   40.00   20.00    0.00    0.00   60.00
> 1  ceph-osd
> 03:51:55 PM  1000    109930   39.00   18.00    0.00    0.00   57.00
> 1  ceph-osd
> 03:51:56 PM  1000    109930   41.00   20.00    0.00    0.00   61.00
> 1  ceph-osd
> 03:51:57 PM  1000    109930   41.00   15.00    0.00    0.00   56.00
> 1  ceph-osd
> 03:51:58 PM  1000    109930   42.00   16.00    0.00    0.00   58.00
> 1  ceph-osd
> 03:51:59 PM  1000    109930   42.00   15.00    0.00    0.00   57.00
> 1  ceph-osd
> 03:52:00 PM  1000    109930   43.00   15.00    0.00    0.00   58.00
> 1  ceph-osd
> 03:52:01 PM  1000    109930   24.00   12.00    0.00    0.00   36.00
> 1  ceph-osd
>=20
>=20
> crimson-osd
>=20
> [roman@dell ~]$ pidstat 1  -p 108141
> Linux 5.3.13-arch1-1 (dell)     01/09/2020      _x86_64_        (8 CPU)
>=20
> 03:47:50 PM   UID       PID    %usr %system  %guest   %wait    %CPU
> CPU  Command
> 03:47:55 PM  1000    108141   67.00   11.00    0.00    0.00   78.00
> 0  crimson-osd
> 03:47:56 PM  1000    108141   79.00   12.00    0.00    0.00   91.00
> 0  crimson-osd
> 03:47:57 PM  1000    108141   81.00    9.00    0.00    0.00   90.00
> 0  crimson-osd
> 03:47:58 PM  1000    108141   78.00   12.00    0.00    0.00   90.00
> 0  crimson-osd
> 03:47:59 PM  1000    108141   78.00   12.00    0.00    1.00   90.00
> 0  crimson-osd
> 03:48:00 PM  1000    108141   78.00   13.00    0.00    0.00   91.00
> 0  crimson-osd
> 03:48:01 PM  1000    108141   79.00   13.00    0.00    0.00   92.00
> 0  crimson-osd
> 03:48:02 PM  1000    108141   78.00   12.00    0.00    0.00   90.00
> 0  crimson-osd
> 03:48:03 PM  1000    108141   77.00   11.00    0.00    0.00   88.00
> 0  crimson-osd
> 03:48:04 PM  1000    108141   79.00   12.00    0.00    1.00   91.00
> 0  crimson-osd
>=20
>=20
> Seems quite saturated, almost twice more than legacy-osd.  Did you see
> something similar?
Crimson-osd (seastar) use epoll, by default, it will use more cpu capacity,=
(you can change epoll mode setting to reduce it), add Ma, Jianpeng in the t=
hread since he did more study on it.=20
BTW, by default crimson-osd is one thread, and legacy ceph-osd (3 threads f=
or async messenger, 2x8 threads for osd (SDD), finisher thread etc,) ,so by=
 default setting, it is 1 thread compare to over 10 threads work,  it is ex=
pected crimson-osd not show obvious difference. you can change the default =
thread number for legacy ceph-osd(such as thread=3D1 for each layer to see =
more difference.)
BTW, please use release build to do test.=20
Crimson-osd is aysnc model, if workload is very light, can't take more adva=
ntage of it.
>=20
> --
> Roman

