Return-Path: <ceph-devel+bounces-2263-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BABDA9E779C
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 18:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DDE316A0CE
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 17:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A792206B3;
	Fri,  6 Dec 2024 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b5E7V3ty"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5921C2206A6;
	Fri,  6 Dec 2024 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733506837; cv=fail; b=Pe6/UTlZIWxB89Ieb4+Rh/b/Yo2go9AXrS6L8OhRk8axbr3nr4jlTyUTgtQt9BrYJ7tHHoH6DG/i5sSa1oRL1tIgdpJN3iWt3lAm7MZ6g0hBZLtzsCV0RjMb7Z9eP172PSn4rkw1LrVbpds0t+CWw48JQsnn6/zTav8b2aD3AWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733506837; c=relaxed/simple;
	bh=gfXQMkxQnZviz6gNqLxmQ/0Z9w3pzmgaHeXMhAzalJY=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=rTmEIayv6Vw5/8YxdXR73Z385YD6ZbBW/3jaSBNjbYXCzT45jGxRuvhegZEmy6tGgBL8CRdYu34EpZ1HaFhmDfkTdfy2LZWEga/RYvCxIpKp2x631o392oHMsL9QLDvIPOnL/6EfhE+N+DFIx1JqiP4Mon8oQxhIPO2YsVtZo1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b5E7V3ty; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6CSI5O010838;
	Fri, 6 Dec 2024 17:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=gfXQMkxQnZviz6gNqLxmQ/0Z9w3pzmgaHeXMhAzalJY=; b=b5E7V3ty
	rss0Rmfl2MKLJiRMOld1XtV2rKVqqWpfEv2V1MKvr80HOw4dFENJGIg/WRMA4Cng
	jxh+9KNWzOwNBKbXjhZlLlJhXJ7KGBZHqnfKEd4upgliiM8kSaAEWpsS+C3jzDTi
	TMEy2O1h9t0F4zdV4FsSpvje0HMyTZKmL27xwhbD6pNR0ZlZLP+E7VxphBo848kT
	gNxf3mjlqpKlk3yVexTka0ihYMZAI4Y6rk89Tm7z/0siMKmVf/XbFC1CDAKDK56C
	8D9P1nhytWU+ZfPndx+Zg9BVNMsJFeB+CQemv9KRjYczYWcCLRsw7p8tzOL10HB+
	HWZw0EHBm1uYpg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43b24rjd9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 17:40:31 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B6HMlPL002174;
	Fri, 6 Dec 2024 17:40:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43b24rjd9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 17:40:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPURmo+ExejGXtU3nK2LP3QMgyt1LTrIzaQHn2azDcrjY2+1dNL7IbJA1Pwf/h7KpHEq8I5Cwa81GPWluIqOJC4TRwKwVDACeMilI0k1jOvA+ijOj8DUkSjQjdtnyzO9mVvFiJGC72K0RVLLlYganH3tIyVH5G13k9KVRy8RcGoWLfHDuQi2X2GObP8DSAsw+TC88ZAztI9QAKgs+13o0LaxOqOwiszRdYS1v5qnxvgMRVSO44CEWOYwPSNrkpCxLatpNsZWom+d7JrryybZUeHmT37WW2m7If09ePS3RzurwapXVwvFq1v62sLRwWF6foB3QDdDTbPuEtURm2PO2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfXQMkxQnZviz6gNqLxmQ/0Z9w3pzmgaHeXMhAzalJY=;
 b=q9OrsW1xzVA659z5VrFaFaqY+ECTB4NbTtcj6COaJ8aDsBkEiF7BZzNsQ7wcjCpeZDxuNE0gnNr/Hsbp3N2OEBaci0LPGALwdyaClI9FfUUaUz7btCKmT70PRb74gnaexN8yMf9VCc3FT/Ql/fP8Z6n/TUVYaxsIF70YmQYNMdVwHrYIY4s9q1SSeM4H3flvTn5kZufdgw12WVB7nB1m+Edpz1ONMS1AHFgbekRva1AauY2jIUg0fAuZpZe2SuXgRs7d3wj6zGWcvEiGMx70R8FZg1A4Zqr8fWuRyGBj+NIrE6PfCBvJPYRYPgInXPv7rt0BmhqSv7cZZLOb7UiHaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ2PR15MB6492.namprd15.prod.outlook.com (2603:10b6:a03:575::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Fri, 6 Dec
 2024 17:40:27 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 17:40:27 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH] fs/ceph/io: make ceph_start_io_*() killable
Thread-Index: AQHbR/77IilvImq6iE2O4OIIUn4bb7LZe+AA
Date: Fri, 6 Dec 2024 17:40:27 +0000
Message-ID: <d3a588b67c3b1c52a759c59c19685ab8fcd59258.camel@ibm.com>
References: <20241206165014.165614-1-max.kellermann@ionos.com>
In-Reply-To: <20241206165014.165614-1-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ2PR15MB6492:EE_
x-ms-office365-filtering-correlation-id: 1d1a050a-ea83-4a42-2c6f-08dd161d126b
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WjlDYUVwSUZreTJHODY2WUtYNHd4S1duUW1NTzQzREhsb05DajUra05oT2tG?=
 =?utf-8?B?YXJncjJvdW5KQVpWekxIQ0tRK08yczhCd2tmU3F4T2pjV3FEVHZ4Z25LeHJw?=
 =?utf-8?B?MUFJUVpNanZ3ZVdTaFVQRUR6RlRaS1RQNGxQZzN1RGhKdUtlbWJodW5RWnRJ?=
 =?utf-8?B?b1FrdVB1MEVyaU1pcWdJWnZ5N1Fmc3FUSHBIRERtSy9OaXJHVEVqQkgyNmZT?=
 =?utf-8?B?WEZwTVU5RlVpUzhGa2JmVUNLNkhhd2Fsdmt2UFg2bDB0WUF2QStRUWU5OFI1?=
 =?utf-8?B?M2J6RnY4WkZVVVMzQ3pZc3ZmZEJzV2NjdTNrYVVBODNKcnNVWTYrRWRIU1pJ?=
 =?utf-8?B?M0xMSXFCNEpDN2FpYTRmdXVaVHJHVlFFcDBtOFZaZ3NKU3pFQVp5amN5V2Zj?=
 =?utf-8?B?ZVhlbUN5MktXNHFFeVlXalBDMG9yUWlYS2Q2WE9RblN3NnJzUUVxWU1vbnFC?=
 =?utf-8?B?WDNRSWlTL0ZpREhqYzhiVTBBdHFubmZLRkxTNmlFWjJ1REMwR2pubDhrYzRx?=
 =?utf-8?B?S01Pa1pFVXhWRlhyWEF1WFRnbjl4QXc3dHRvS3hmNDg4SlpUT1lseGZ5bENy?=
 =?utf-8?B?NzRBdkd6eUVGTVJJbDhRREY2SVNKUE1pcTl6akZrUWtQcGcwOTI4dEczK3Fz?=
 =?utf-8?B?WElkeXk5NTJydSs1SWo4RkZFaTF4QkxCUUtZZkVKUjdPdnJhN3doVlhDdEN2?=
 =?utf-8?B?ZGlRa0xnOEY0ekFqeUlzeVEzTzdoY2JxUnlacDNwdmlRYk5wM3k2SW10QnN3?=
 =?utf-8?B?V1JyZ0tsRVgzdkM0MFNtS0pVV1pjNGMxTnlxWEt5LzlBaDRjOGQwZllTMzdR?=
 =?utf-8?B?OVYzOTl2MG5nbGhxbmt1Z1pyQ2NKL1JOZWVvMWptQ0lhdHdObVFhNWphb0p0?=
 =?utf-8?B?WDJCbWtINlozd2liTDV1Ky90TFZVd3VrcW5BbnBid0FmRThIaGkwdmpsQzk2?=
 =?utf-8?B?L0t3S3NpVndKa2pNNDlNQkpzOUsyLzJHeDNmVzBDNFhyY2lBOWk1MFMxK3Ft?=
 =?utf-8?B?MTcrRUFFcGZMaWRSUjNnRW8ycVV4MkY0YWVZbjUvNG5xNDZITUhXMjFVaEZ3?=
 =?utf-8?B?QTFNdVpaNDQySkxhWWJuZkFtU3ExdlE2ZHF4S2cwOWJEUmxDcno4NmJJcERh?=
 =?utf-8?B?WVJ0VXUzeTFTZ09WdmZEU05sMWpiSUw2cVNOOVVMd3BueXpMc2NCcFNRVlg3?=
 =?utf-8?B?dFZESnJ3SG1HQWVQZUp3eHNwM2puZWtKQk5ZanJRbEJGUWt5M2t1cFJBc3lR?=
 =?utf-8?B?TjVubC93NENtbVB3aG54N2wyZHVKYk9Vb0ZjS3ZSUDdKQlFzbi9NRWhQcUpM?=
 =?utf-8?B?bER2eTJjQkxxdDdOZU1ZdnVnTGZXL2NoQU80SnZQcVY4ZzB3Ylk2cFVtR3FC?=
 =?utf-8?B?TENYV2x1RFF1cEp2MHo1OWQ4eWFhaytMT3BhbVRHNjgrTi94Nkd3Nm1JdGM3?=
 =?utf-8?B?ZTlpTHlGMlEwM2ljM0crVzVJQU5kWEwwbEk0SUpKaGVUUDRRV1BGS0k1b2VH?=
 =?utf-8?B?Wm1rYTZzSGFMc25EZW10RzdTTllHd2V5YU9nVSs5ME1ENEo4Tk94czk4L3E0?=
 =?utf-8?B?NUtnZklETnU5M3RVOVFBL1pwbnB0WnNjUGcvUE1RcmszZjM0ZjkyeWwxMFVI?=
 =?utf-8?B?cnh4MDZJc2YzVUpMR2t4cC9veVVnZDFTbC9GQUF6TDRrbms0bEdWQUMrbmNS?=
 =?utf-8?B?a3dvcEQxaHZiNUQ0N3FKaXBydGM4Zm16a2R5ZmhJdlkvaWM5SVJEenNlSE5p?=
 =?utf-8?B?ZFBxcnJDcXd1REZVb2ZNb3M3Q25HZWs3czFKUE5NOXQwZVBxaURidEIyM2oz?=
 =?utf-8?B?WDB2eTJVMjRrNU1kTS83YlQ3UkIwQndYS3h2QXljL2tJTWFYTDg0SkZiazBF?=
 =?utf-8?B?WHNyZWRJcnZVMlFZTUhzQmVKczRjbmpmZm95MUVqWnNrY2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eEUyQm91bnlNRFZsUUl2RjhEbExiWTIrd1pGT2FZeXB6RmJZYklia1ArTVdO?=
 =?utf-8?B?NzY0Q0NmcVhSZmtrNUc2VTFGVmJKMk0wUDZaRGcvQ0cyWSt1elFOS1BuQmJF?=
 =?utf-8?B?azkwWktmWFZpMUJWRk0wUkwwQXl2T3lDL21xcjJ1bmpGS1VLRDZyUlVCZ1VV?=
 =?utf-8?B?bDQzVFRYQjNCSXRyVVBiRGlDM28xSmdoMEVUdFZNQkM2MW1PZkFQL0E4dDF4?=
 =?utf-8?B?ZkVtdUZiWS9YaVRWa0Zta2p0SzhnY3g3QzVGYm5rZFYwME1nSkdvSGk4MndW?=
 =?utf-8?B?SzRGci9WOWVkWjk4U0tFODhNaU9HSURhWldTakkrMFlKOXJIYmRSZTlFYmNB?=
 =?utf-8?B?M0pmWFVhY0RLMWlYZXNoaURWUlFiRHEzWFlrSnovb1RIRjdSVldmZFgvaWx6?=
 =?utf-8?B?WllDYkliYW9peFFmenNoVVdWNVdtcHoxME1QUjhWVklaYWtCMDRhQjJKYlZB?=
 =?utf-8?B?YllDaWhWWFpCSHZvdk9iM09yVWxCS0phTkY3eU9IcWRucEdyYWFCcGU0TTNr?=
 =?utf-8?B?eU9wVTJtaERrL09MMXlUcTBpM2NtN1VNVzMyQ0FOcnhRZStjUUpnZFplemU3?=
 =?utf-8?B?eWhTYTk2QTV1Yk5SRWtzZkpWbXFYWTZOOVlzd0hkTGhLaFkwdlhRNkozR0Vl?=
 =?utf-8?B?cWlSVEdRWlgrbTByTktOU1hWNWZhZ2VMM3JXOGtFRHF6ckcwM0kySklrbjl3?=
 =?utf-8?B?YnhHRmh1ZUN4bit6MFhQS09FWU9xYmdWZXlzVE84KzhQcXlJVGxOMFI0VUYy?=
 =?utf-8?B?UXBzVmplUGkweXY1OUlLUE9UVlY0MmdMb0JoelVZM2VHQmc5YzRxckZJRlZq?=
 =?utf-8?B?N3lueFJEWmxRZzdlV0FFZEF3d3ZCYkNoOWNNVVFLVjRFSzh5clg1OEs5Vzk1?=
 =?utf-8?B?cVcwcHZBVk1hekNISHd5QWhTS2RBRjNVZWY0QkkzU2N4TUxhRERJbGRUN1gz?=
 =?utf-8?B?c1RrMVpqRnQ1YVlJVzNBcXVFdUVZTlZXamtMc2FrSFFSTE5qNkJ0Zi9jQkdQ?=
 =?utf-8?B?OHRCMGtobkVySkcxU3JUYzlCUUFCSW1WdkpWRjNsdTJKcExhUkZIdDNsSlRs?=
 =?utf-8?B?c1ZFNlg2T1gvZEw2S3NzRy92ekNHSUF5azBFNlhqNEQ3T1g3bGhSeWFHTVdZ?=
 =?utf-8?B?cDhCZUJWV2k4K3JjQTc4ZllJbkZaa2NQdlc0ZHF1MWZRY1FwUEE2bGxhU2dW?=
 =?utf-8?B?U0hsbGZVNkkyRXRVN0lmODdoR0kweloyc2c5ZUc4dXZmNzVrL0ErZ3VSakR1?=
 =?utf-8?B?WjR2TkxwNG1sakY2bE4rTURwQ3A3bGV1Y0JKUlZrWVVGS0xja3FDS1lKdHg1?=
 =?utf-8?B?b3MvSkt3WFdrMXZ4TG5ZYWlVQ3JyYjZ1MitLc2QwMjZ2NStsR2ZnKytWK1Rr?=
 =?utf-8?B?Tzl0UkVLWWY5aFFzWC9XYXpyMEU4Tk92TmJiVC9kcjFSY2JrUzJnanNqMTJy?=
 =?utf-8?B?NVlscmlQdm5FdXFQa1lRN3Z0VUozajRPNGQzOWVyU3BTc3NrWUFaY2hnL2Jy?=
 =?utf-8?B?NTdrQjJwcVVGcGxoV3VUdzZlbzJRV2JONmJhUnFPYTFtUUVxUUV1QXVIL0xB?=
 =?utf-8?B?cTZBR0VzUmFZRnR0OTlvSnZ6ZUVwTmZjc1IzZzE0cmpicVFaRTBtdnluMHQ3?=
 =?utf-8?B?MzFRNDJpM2NsUk1sSUswajFlcFhhcVo4K0NPVURnZU4xK1FBeGt4d3I5dDc1?=
 =?utf-8?B?SmNiL2F2WG84RUx3dlYrSjZyYlVzU0tPcU1uSGVhb05Vd1I1WjkyOFk1TzZi?=
 =?utf-8?B?VWhUdmkzWmpneXpXRmhKRUszSlZ2MFJaYXREOVlZZ1ZTSzVXbDRXNitQQnRp?=
 =?utf-8?B?TDVWOSt2QVp0am5vaXIzTzdBeUViK3pTQTNGVjI4THM1dndBMW91SWUraGV2?=
 =?utf-8?B?Ykt5S2RHZ1kya0ZyLzBGMjR2cWdEMEp2RnhGZXQ5Ynh4RkZ3OUxvMHUrcTlV?=
 =?utf-8?B?bW5TQTFma3A5TFJrck1URE5ZRXI4NFRSOVAxMG9kdGM0L1E2ZjNBWi9MSGNm?=
 =?utf-8?B?RnJ4bVYvc0lHRlhpeEgvL0RERE5IUDFlLzAzaW9qdzBLSHNadDhYUm5qM3Yy?=
 =?utf-8?B?NklyczRkV3BodjFNUHRkWFp3Ukt6cEt6Q0RsUzZXQlVralBxRVZPYytCMHFT?=
 =?utf-8?B?R0hYNWIzcTV5dlFyTzZRWkJ6bG5UUkhDYzh6ZGVYNjlWUHRNWEFCNW1WVGZ1?=
 =?utf-8?Q?n/jyVGrYTG7Q8Cd1TN4ZIX8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B987791110CA084EA8F0933660074709@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1a050a-ea83-4a42-2c6f-08dd161d126b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2024 17:40:27.4831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T0OemMxGwhP6I3nlJeLWzU5hjvN4KqKiPdEF5CGTJaXvC707Np9lFohwfZTyjkyAzUaCYP7u/wBfZT62oHzV4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR15MB6492
X-Proofpoint-GUID: 2wSH5pKwsIXDhn4HXjKdo3I2xH4DoeiG
X-Proofpoint-ORIG-GUID: 8cCLtno4huipvNrfQhEyzMnYm1BIQxwr
Subject: Re:  [PATCH] fs/ceph/io: make ceph_start_io_*() killable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412060131

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDE3OjUwICswMTAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gVGhpcyBhbGxvd3Mga2lsbGluZyBwcm9jZXNzZXMgdGhhdCB3YWl0IGZvciBhIGxvY2sgd2hl
biBvbmUgcHJvY2Vzcw0KPiBpcw0KPiBzdHVjayB3YWl0aW5nIGZvciB0aGUgQ2VwaCBzZXJ2ZXIu
wqAgVGhpcyBpcyBzaW1pbGFyIHRvIHRoZSBORlMgY29tbWl0DQo+IDM4YTEyNWIzMTUwNCAoImZz
L25mcy9pbzogbWFrZSBuZnNfc3RhcnRfaW9fKigpIGtpbGxhYmxlIikuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBNYXggS2VsbGVybWFubiA8bWF4LmtlbGxlcm1hbm5AaW9ub3MuY29tPg0KPiAtLS0N
Cj4gwqBmcy9jZXBoL2ZpbGUuYyB8IDIyICsrKysrKysrKysrKystLS0tLS0tLS0NCj4gwqBmcy9j
ZXBoL2lvLmPCoMKgIHwgNDQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0NCj4gwqBmcy9jZXBoL2lvLmjCoMKgIHzCoCA4ICsrKysrLS0tDQo+IMKgMyBmaWxlcyBj
aGFuZ2VkLCA1MSBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gDQo+IA0KDQo8c2tp
cHBlZD4NCg0KPiDCoA0KPiDCoC8qKg0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9pby5oIGIvZnMv
Y2VwaC9pby5oDQo+IGluZGV4IGZhNTk0Y2Q3NzM0OC4uMDhkNTgyNTNmNTMzIDEwMDY0NA0KPiAt
LS0gYS9mcy9jZXBoL2lvLmgNCj4gKysrIGIvZnMvY2VwaC9pby5oDQo+IEBAIC0yLDExICsyLDEz
IEBADQo+IMKgI2lmbmRlZiBfRlNfQ0VQSF9JT19IDQo+IMKgI2RlZmluZSBfRlNfQ0VQSF9JT19I
DQo+IMKgDQo+IC12b2lkIGNlcGhfc3RhcnRfaW9fcmVhZChzdHJ1Y3QgaW5vZGUgKmlub2RlKTsN
Cj4gKyNpbmNsdWRlIDxsaW51eC9jb21waWxlcl9hdHRyaWJ1dGVzLmg+IC8vIGZvciBfX211c3Rf
Y2hlY2sNCg0KRG8gd2UgcmVhbGx5IG5lZWQgdGhpcyBjb21tZW50IChmb3IgX19tdXN0X2NoZWNr
KT8gSXQgbG9va3MgbGlrZSBub3QNCnZlcnkgaW5mb3JtYXRpdmUuIFdoYXQgZG8geW91IHRoaW5r
Pw0KDQpJIGFtIG5vdCBjb21wbGV0ZWx5IHN1cmUgdGhhdCBpdCByZWFsbHkgbmVlZHMgdG8gcmVx
dWVzdCBjb21waWxlciB0bw0KY2hlY2sgdGhhdCByZXR1cm4gdmFsdWUgaXMgcHJvY2Vzc2VkLiBE
byB3ZSByZWFsbHkgbmVlZCB0byBlbmZvcmNlIGl0Pw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiAr
DQo+ICtfX211c3RfY2hlY2sgaW50IGNlcGhfc3RhcnRfaW9fcmVhZChzdHJ1Y3QgaW5vZGUgKmlu
b2RlKTsNCj4gwqB2b2lkIGNlcGhfZW5kX2lvX3JlYWQoc3RydWN0IGlub2RlICppbm9kZSk7DQo+
IC12b2lkIGNlcGhfc3RhcnRfaW9fd3JpdGUoc3RydWN0IGlub2RlICppbm9kZSk7DQo+ICtfX211
c3RfY2hlY2sgaW50IGNlcGhfc3RhcnRfaW9fd3JpdGUoc3RydWN0IGlub2RlICppbm9kZSk7DQo+
IMKgdm9pZCBjZXBoX2VuZF9pb193cml0ZShzdHJ1Y3QgaW5vZGUgKmlub2RlKTsNCj4gLXZvaWQg
Y2VwaF9zdGFydF9pb19kaXJlY3Qoc3RydWN0IGlub2RlICppbm9kZSk7DQo+ICtfX211c3RfY2hl
Y2sgaW50IGNlcGhfc3RhcnRfaW9fZGlyZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUpOw0KPiDCoHZv
aWQgY2VwaF9lbmRfaW9fZGlyZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUpOw0KPiDCoA0KPiDCoCNl
bmRpZiAvKiBGU19DRVBIX0lPX0ggKi8NCg0K

