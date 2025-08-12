Return-Path: <ceph-devel+bounces-3412-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C1A8B23952
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 21:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA890683266
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 19:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF752FA0DB;
	Tue, 12 Aug 2025 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F1VCVB3t"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5AF74420
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 19:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755028362; cv=fail; b=WTJlOZqvLbEtfFH4VLgQR9L6/5QlsL8EDaEDE8qnBfTTzs1l/qVhnwAcbx4soVmAYtde2gMzmx27POh2TXT5Q/ZK+yhnZ6TOGPlJtgNgNAl6d/1pfdBQ0cuZvRtFbuVH5+UY0srlNAULuh91oSdW0NTFJVBTubyujHYTN+jk3Bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755028362; c=relaxed/simple;
	bh=NmBhE3Bkkq0KfjaOe01DMozKVlXudDLt/dQ5uQbqN9w=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=H7dV2bOUeH+/rgGIXGSERqJhqcwE/3PQgqQQ4xtoqEs7xbpuo824YhXJ91Rzt9oxndRjCFRbuyv1ntCdilNuMXoX6OzF5VhVeUayD7vbIqEDx2wZ4oDDx5IPdyrsWYy28G3OPzsSRe/yB+wqcXpa5JKj+98WViAo8xnrLtdd9qU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F1VCVB3t; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CDBkag030834
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 19:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=SWpQ3q2SiC6Pb8LWvqgQDxl6PLwzhtzrv6a/Ri+XNP8=; b=F1VCVB3t
	W0mcE9vmZ8aqDmHdfbqWSWw16yfnHO6PxIaizTu518P+lMRs44zrnB6jBMiFKuEf
	UaOrY/JWhApF6uOwNzn1BSycUH/sVy9p/szDw+XtruDwyRRRN2O0faUFizuuDUU7
	Q4JA9z+nHVzGAGUNBn85uXNrZXCHLfl/rhKgDNcBhcgu0xYz9YNnYFwL05ehVrgE
	B2Fs1pUcrTLegh+FOlhbTLDgZVAc+70jNCCFqGH/UZt2YqbgIDbMt1lhHZYPP87A
	zOADD8m5TvE0HncUyDrkzXMb07PpD3KrUv+Vsy77KVTD9JOVUkCLhcpvdu3650t3
	1H5Adxi7rGhtnQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48ehaa4vpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 19:52:36 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57CJqaCL007653
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 19:52:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48ehaa4vp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Aug 2025 19:52:35 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57CJc063011872;
	Tue, 12 Aug 2025 19:52:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48ehaa4vp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Aug 2025 19:52:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aB5sEsM4nvJMMvDMRNqZRMez7HMWAb/K87JY83cAdCZv2LMpOQSoOtbm7ymhcA6kn/vNxmJBNjOcgGOoIGbs2ufImSEaaDT3YklADLdFq7sPjxremClqm+6LvxHvaLXVwFMkdJbU4pw+5ep9BhBvoDsEZYbPZfkNLIz0lXgPVtY19in0x5HnmTxRoX0v8CVJHaqLMeggGbfAioyh1z/6+XsV2RcceXYLAavks7FRTR6CVXg3xgfB5M7sq6X6Pz9jvwMyijoKZafTpGSLCUId9p6ZX9LadSvvuW94eiU1vQm+G3EzUWdpG86Dqeq5es/vtznok9UPYeGeRuytu2k/zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Hl27DR1ZSAOvYUTGj5pjmjm7W//O9t0cA+YWPD+9HQ=;
 b=Tr2PXtQOGECnwqIJq7sIp2FZrVmWgz7jeySyQIBLh5aBGAuDxNlZ+qK4HXyS87/rYF4jO3Awc4OmIY3RgFaQR1cQ9V/UsyYQYZDo2I8/wcw9LSOMonJawIcgY8tVdNE6xy+rXIWPeVsXU5OrNeY7GcjYezFV1VhB4pHvbDlraO6T1/l6Uu4CA8sQidffIleP0hjZ23AEM0OHhkHu8FUJX9jknm0HhV3wdSDFgcGpF8zwWmVrhRJbxY3RmkIaBoi6Np5jzEbbtLv5WmXH6sNPCcyEEv0ECE5iCmRJfxXzsnOoUp+CAvbpkdrqu1oSrEjCzSDnPzhn6kp+uArmZS1B4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BLAPR15MB3763.namprd15.prod.outlook.com (2603:10b6:208:254::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 19:52:30 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Tue, 12 Aug 2025
 19:52:30 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<amarkuze@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Patrick Donnelly
	<pdonnell@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcAwnX8VFv10r3BUWfP7rTtDMVw7RON+EAgAchUwCACKxSAIAAxVaAgAC0VYA=
Date: Tue, 12 Aug 2025 19:52:30 +0000
Message-ID: <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com>
References: <20250729170240.118794-1-khiremat@redhat.com>
	 <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
	 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
	 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com>
	 <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
	 <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com>
	 <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
In-Reply-To:
 <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BLAPR15MB3763:EE_
x-ms-office365-filtering-correlation-id: cad4344a-0366-4f25-bb25-08ddd9d9c5d0
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bnk1L2dFRVB6STdUeWJlTi8zZktrRUtaYTA4SGw0bk00R3FydWxRZlR2WlpP?=
 =?utf-8?B?Qm1GSGllL2VsWjh3R1RYWElna0FYYUhpM1l3aVFIZTM4UUI3em9QdUVXZ3Z2?=
 =?utf-8?B?MTA1L1pxQ3FqRHVOeXRUM3RnWHpGL3Q2NlJpM1VWdGZjWE9KaHBrOWVuRy8v?=
 =?utf-8?B?YzU4dC9zeS8reS92NDE1K0I5K1FNUFFrRjA4OVBnanVrSm9VTVB6eGc3TE14?=
 =?utf-8?B?YTROajh0RnZ5UzhZdCt3T1ExaVNMSUVSbDRKUWJmZTNPcVduanQvQm1MR2RJ?=
 =?utf-8?B?dU04bklZc2NZWFBrdHVlaXd3blNMOWtiQ2IvaUVxWE1RTGR6cHl4YTdBSjVt?=
 =?utf-8?B?THFDQWJsMGpGeVhUcy9Vb3ppQzdkTFFnanFwaEtFcVlzVlhxOWQ3OEtMUW5u?=
 =?utf-8?B?TnJPcVpJdWJQSmJZMHFVckhOdnpaM3FNVDVVMzZzNXZETDFLT0lxUkpFQjBv?=
 =?utf-8?B?MVJqQlBCUTdub1pzZStQYWR4TkJCWC9vbWl6VFFRMmJoUmJNTS9PclNPdVk5?=
 =?utf-8?B?M3FKK0NST0twVWc5YzdZVU5MK3laNWVjYlA5dk1YK0R5OU5CMlZXZzdQZmRW?=
 =?utf-8?B?MW9PUmxrYkt6QUVOSVJJNTM1WkZmZEtQWUM0V0lGMkNZVmErWWM5d2VaU01F?=
 =?utf-8?B?cFF2WncxcmMxTEpEa09qdlFsSFc2TmZtdUtkdHVDcFZ4eXlOS1FnSDZ2SGt3?=
 =?utf-8?B?ZDF1bVFQdktxQTE1aFByZkozQkZFcTN5TmpralZHWlV0ajJiZ2RvVFFzMDNt?=
 =?utf-8?B?MlRaRU5VbnFxdGtnTFRyZXRTM0g2MkV6V2NYeThTNkR0R3JJUG15RFFkVkZI?=
 =?utf-8?B?ek53WFc5SnFYbmFEVW1UZEJpakVzcDRnNW5NeVpESGRxWW0zUER3SC9sYVBR?=
 =?utf-8?B?NTh3V2l0elhKR2dncUErY1Y5MTFXblpDOU43NmljeVlqejYxUjBsOEVvNFA2?=
 =?utf-8?B?bnhwYkhsTEZaS3pMWEM0NGJaam53OC8wcFpDTHJocFRJcUgzcW5yNVgwK2dO?=
 =?utf-8?B?SGdzMHRtY1Rjc1cxZkQvSFFNamNpc09GaWxJNUFiR2J4MmQxK2FqZFhqNHdW?=
 =?utf-8?B?MllDWndxTmZ4WGRPdk1BUXMvVEJmVGsxcUcwalBYaE1GTWxTZXJsMC9ZR2h6?=
 =?utf-8?B?ZHJPY0VUV3ZrWXZzZ3REK2lmVnF6SkYyaWlmbUd0dG92TzZBNlpLN2crWjRD?=
 =?utf-8?B?Y1NkRmgvV0doeTdOSTcwdHQ4eEI4SWxMUllNMWFja1ZOOG1SeVJmVEpsdnBP?=
 =?utf-8?B?RzY3ZVFrRDdJdVliWFNGcDFpRDhjSU9VdE9uaGd6UG9mVHNxRStqYkVlUzVD?=
 =?utf-8?B?RVF5VTJTUGcwQ2paOEhRWEpvU3ZZVVUzWGpXZVBCRmhRWC9CZndCaUI0cXhI?=
 =?utf-8?B?UTJrSXlkV2tsb09KZk5hQXZBK2EwT3FkT2ptcTM2UWlIdm5pckhtVGZXalkz?=
 =?utf-8?B?d2lBR3A3YjBrM2dZSG55bGlUdnlTQlZwZGkxVnA3bkVmOTMrVTRza0V3Y3A2?=
 =?utf-8?B?WG9uNklYUis5Z0ZlNE51dHYxRGoyYkxWc3RkZzczaFNmK3oxM0VUT29EcUpu?=
 =?utf-8?B?S0QvL2NFd1EyU1FCL2lYVWNWcmhTSWw2MDZuU2FIcUFnQWlBc0U2Q3h2eTgz?=
 =?utf-8?B?dHB3ek10UUJYa1NJK1Y4d0JNVFMwZFg4a0hpQ2RVWCtwaURQUnhMQTlLc2lF?=
 =?utf-8?B?dlRqeElnc0FQSnhjb1hmSHE4eVJYTy9hK0dYMnRFbHpuZ1JsVENsY1ZmWWZG?=
 =?utf-8?B?SllRVGMxVEZOVHNObUhEZG5mejdyeEZHYzd5YkttZGI0Vm5xZTFTTFNPVVdE?=
 =?utf-8?B?VVBpVG5PL0piZDBzc3lYUFliaE9BMmE5MUxiczFESy9wRDBDM1VIQkN6ZnBp?=
 =?utf-8?B?V1F4UlVBbnpZMEt0WGI4UHQ1Yld5MEY2dDloQXdWQmlqU1pSWGZuTzRiY2RU?=
 =?utf-8?Q?e8Sb5ls72l8lni+wWaRszYQEmV3FwVOG?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZFJySTQycndqYXZXTW9nY0E0NFQxUmluZGxEanBseFJSaVJvYVd4cDd6R1N4?=
 =?utf-8?B?Wm1yWnNuaFpmMDlyNDNRNEJVeUQwSkFtcENsK2d0Z2EyWlpSblpYYXdvTFVi?=
 =?utf-8?B?RWl5TGlDT1R4cExMTFFxMDdzRHpOQll3dTB3VDJiTlhydGxydUtZVHhmZzA5?=
 =?utf-8?B?a1VPUldpOC9uYXlTSGN3SEh3VWJoNndqWXcyeWhvbkdvZDZjVWdUM3l5eVZY?=
 =?utf-8?B?dm5iUk92eFBObVNzVnRBakFoVTBYejlUdUZTUWNEWm51Ky9ucWtTUUNld1Yr?=
 =?utf-8?B?VjRqTkgvbGgva3IvYlZVTzZhek15RExuWUFLL2xNdmFaUGlGb0hCMjJnd2ZD?=
 =?utf-8?B?RjJZbFIyZGd4Sld0SWptV1lleWZwMkhkWkwrTWVxOGRsUTNCcmxZRUNmTFd2?=
 =?utf-8?B?alhEczNrQWhKYmZSdDVxdGVXNUt3VUhMajB5b3BLY3J1ZUx2OGtqNlZsSEVF?=
 =?utf-8?B?SEE4aXREbS9QZE5VVEhFTzJ2MFhQL1dHZ01GTWdGUWFpQ3locGFTQUZDTFJt?=
 =?utf-8?B?ZS84SUttbmQwMG1QRzQ4Z1h5UlQxNThubWR1dHZrdVFnc01RSUdpNTRTMHA4?=
 =?utf-8?B?MDhwck44eGxFVWFPcGdweWhESklwYmxwa2J5YUJPS0M3TVY1S3hsbXFFNnFs?=
 =?utf-8?B?ZUF3a01tajNlSE1uQ2VrQ0lCbGhBRG54K2pIeDZFbnlvZ1RKV3ZCaC95M1o5?=
 =?utf-8?B?SS9jWFVYcW00YUhVSzcxMEZvMXJUTk5XdFFHSnByRzlBWDZsRFVZeklmSDl4?=
 =?utf-8?B?ODBCdE4yYlJTSHMrUlRBazFxT2R1Tjd3c3NXRkdpWENIaC9oa1FzVTFYMFgr?=
 =?utf-8?B?TS8vbko0T3FZbU9iRndYelo0c093TXREdDZWRkJSdk9BSy9IU2NWZzVodE0r?=
 =?utf-8?B?cUJhWWJ2dUdLd01BTHFZZC9IVVhCbXZtek5RYXlrT1JBQTVMN0R0VkJKcTFv?=
 =?utf-8?B?QldOWm1FSTRqNTlZblpOL0FQYloxR2lYRkRPSktGbHVleDlSd0g1OUpVbWlM?=
 =?utf-8?B?V2NudlM5WDNBVFk3Q2RkQllYSURwOFBlNzdycER6WjRIRm5ZSTd1VE8zbDdJ?=
 =?utf-8?B?ZkdaREdIUy9pejZFTEFYMHZ4UTRtamcrRWZ6T1FsMWMwMWRuTFdWa3JZNTlR?=
 =?utf-8?B?TVZNZlpMYllYV0ltUTd5ajFVZ3ArUEMxNy9TNXR2WWo5ZzM2M3NVc3BKNWRB?=
 =?utf-8?B?YjFxZG9wclh2QlppTW5IU2hjT3NqWDNyV28zKytOVnhRV29MWDhuMVZ4S3Jr?=
 =?utf-8?B?TXhXeHBCMXRSSkpOOGtzTTlTc1BIZjlFRi9Ba0xCbHVxcTlZQ2MvSE9tWUlM?=
 =?utf-8?B?dDd6bEc3Zy9EOHNaMFlyT3duVzZTYU41V0hiMDN1R1NJZFJjVCtOQkZVZ3RS?=
 =?utf-8?B?YytDRTd3dnpOUExqUjB3b010U05MS1RudVBEUFV4REtqY1RpZTQ0OEhtUkUz?=
 =?utf-8?B?VHRqVkYwbzNZQXJVem54aVU3eFM1RzR4QTJVVlMwOElpMUNVWDdydi9CQzR4?=
 =?utf-8?B?SDJxWUJMU05yamJNZDRWWlRuNXhCRXBOYU9udDhReWJCTm9aZEVuS0cxOEQ3?=
 =?utf-8?B?Mm9FZU1PRzBXQXZOMFpDbGplclRuMWhTWHoxbjVIMk1la1pFM1F2eFUrMWdQ?=
 =?utf-8?B?OEZHNUVqNWFLVTM0cCtSbVhlbER0bUJqc0RFNTlOVk1OMjllU1lPU2NyYkVn?=
 =?utf-8?B?a0xIam4wTG9jSUhBYkdhSkxmODcvMTFZQi9WUzhzRXlwcENMSUtnVmhidmtC?=
 =?utf-8?B?M1FVUS9seXdzVHJMd2ZJZGgwVUdEZVlzdnNxMldub05BeWVpcjZSbytHZC9E?=
 =?utf-8?B?RTZxenVxVVZEdmFXUmsvTFhXb3p4WldQNm5KWnhzNEZEcE9WSVdoMEVQTFE1?=
 =?utf-8?B?dkhwMExYbjhQMUZTbzM0bXZGdGU5dnd1YlBjTytmOVBPTEY1ZlVwSmJyZGpr?=
 =?utf-8?B?VkNxNzV6TTBtREc4amRtWlQ4Q2xXSC95cFJoNTVyNEpNaU8zY29vKzNISGNn?=
 =?utf-8?B?Q3MzT1ZFNnlTRmtudWpoM01JY2FsbExWK0NlbENHUkV2M1N0K3k0VUt3WTRZ?=
 =?utf-8?B?cHNVUWhTdVF2eHc4K2RXTCtqN1U4b3JPRk52a1NFaFZvUjZ0V3NuODdxY1N1?=
 =?utf-8?B?Y29ZSkNNOGppQXFmL21TSUZnZS9ncldRZC95YkZPVE41QXh6K0NIYVVMaTZI?=
 =?utf-8?Q?o3RgXwNPWjPp/cxLPxPtl/w=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad4344a-0366-4f25-bb25-08ddd9d9c5d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 19:52:30.5930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UPYi0giC/uV2CyPeHutk0fCeaA2oqeI235fhK9mPMtLPsUyDJaxASFSD/2f32zUAO7V0fYmyUYDn+HKqjtaiOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3763
X-Authority-Analysis: v=2.4 cv=KPRaDEFo c=1 sm=1 tr=0 ts=689b9b83 cx=c_pps
 a=KB7kLzfingIg7eHt7PrfOA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=NEAV23lmAAAA:8 a=P-IC7800AAAA:8 a=4u6H09k7AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=AUGs6VgNBE38fgUbwY0A:9 a=QEXdDO2ut3YA:10
 a=d3PnA9EDa4IxuAV0gXij:22 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-ORIG-GUID: ET8fb44kLDYCmeJUY5IHZVfnGDFpFJXQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDE4OSBTYWx0ZWRfX/GSYzvQx9TKw
 pAh4zwDqeDYMfg+d9kqMrJ17EvtPMO5DPvGeo4jEyQK1cjlmv7N732hBBhIluo5QuvQAUEuEtgO
 9IzZCk4wWiSTu1ffCk5neNbmpzrEFUc77QGAoknFfNG+MrD10RCl6QxICqk2S774I0zMFFlEDgh
 lyHbd/vPic70upJpV0UVegl4jQKALz8oIbFcBhOWeWdSTpGUkcz/2JvlU1kIVzshUwAfh1Odc0Q
 WvxxhFnntP+8EbarbS8FW18D+Vq43l3mF5sTUyjbPiTFaBRjBzZc1Ukromnj3h5ost1GKyebrEL
 bQxvMMcLRXpINwVd5gMmZCkaG3fy1XjuIha2qPdcVF0uonGvo0+uKrKki+1LJOSjGl0L8xLnTGQ
 McsNZk804iTqcmGiWpMCJzkPZEhXYwmzSLCL/IpeccxpaRUZBj84Qvy5hf2lKHly+b7PabxL
X-Proofpoint-GUID: H3g_ZV46UcQVyeEketlyzvodUBQP8EdS
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B2A07899F9E6242B4DC6E3B5FA9BB8E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_07,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=2
 engine=8.19.0-2507300000 definitions=main-2508120189

On Tue, 2025-08-12 at 14:37 +0530, Kotresh Hiremath Ravishankar wrote:
> On Tue, Aug 12, 2025 at 2:50=E2=80=AFAM Viacheslav Dubeyko
> <Slava.Dubeyko@ibm.com> wrote:
> >=20
> > On Wed, 2025-08-06 at 14:23 +0530, Kotresh Hiremath Ravishankar wrote:
> > > On Sat, Aug 2, 2025 at 1:=E2=80=8A31 AM Viacheslav Dubeyko <Slava.=E2=
=80=8ADubeyko@=E2=80=8Aibm.=E2=80=8Acom> wrote: > > On Fri, 2025-08-01 at 2=
2:=E2=80=8A59 +0530, Kotresh Hiremath Ravishankar wrote: > > > > Hi, > > > =
> 1. I will modify the commit message
> > >=20
> > > On Sat, Aug 2, 2025 at 1:31=E2=80=AFAM Viacheslav Dubeyko <Slava.Dube=
yko@ibm.com> wrote:
> > > >=20
> > > > On Fri, 2025-08-01 at 22:59 +0530, Kotresh Hiremath Ravishankar wro=
te:
> > > > >=20
> > > > > Hi,
> > > > >=20
> > > > > 1. I will modify the commit message to clearly explain the issue =
in the next revision.
> > > > > 2. The maximum possible length for the fsname is not defined in m=
ds side. I didn't find any restriction imposed on the length. So we need to=
 live with it.
> > > >=20
> > > > We have two constants in Linux kernel [1]:
> > > >=20
> > > > #define NAME_MAX         255    /* # chars in a file name */
> > > > #define PATH_MAX        4096    /* # chars in a path name including=
 nul */
> > > >=20
> > > > I don't think that fsname can be bigger than PATH_MAX.
> > >=20
> > > As I had mentioned earlier, the CephFS server side code is not restri=
cting the filesystem name
> > > during creation. I validated the creation of a filesystem name with a=
 length of 5000.
> > > Please try the following.
> > >=20
> > > [kotresh@fedora build]$ alpha_str=3D$(< /dev/urandom tr -dc 'a-zA-Z' =
| head -c 5000)
> > > [kotresh@fedora build]$ ceph fs new $alpha_str cephfs_data cephfs_met=
adata
> > > [kotresh@fedora build]$ bin/ceph fs ls
> > >=20
> > > So restricting the fsname length in the kclient would likely cause is=
sues. If we need to enforce the limitation, I think, it should be done at s=
erver side first and it=E2=80=99s a separate effort.
> > >=20
> >=20
> > I am not sure that Linux kernel is capable to digest any name bigger th=
an
> > NAME_MAX. Are you sure that we can pass xfstests with filesystem name b=
igger
> > than NAME_MAX? Another point here that we can put buffer with name inli=
ne
> > into struct ceph_mdsmap if the name cannot be bigger than NAME_MAX, for=
 example.
> > In this case we don't need to allocate fs_name memory for every
> > ceph_mdsmap_decode() call.
>=20
> Well, I haven't tried xfstests with a filesystem name bigger than
> NAME_MAX. But I did try mounting a ceph filesystem name bigger than
> NAME_MAX and it works.
> But mounting a ceph filesystem name bigger than PATH_MAX didn't work.
> Note that the creation of a ceph filesystem name bigger than PATH_MAX
> works and
> mounting with the same using fuse client works as well.
>=20

The mount operation creates only root folder. So, probably, kernel can surv=
ive
by creating root folder if filesystem name fits into PATH_MAX. However, if =
we
will try to create another folders and files in the root folder, then path
becomes bigger and bigger. And I think that total path name length should be
lesser than PATH_MAX. So, I could say that it is much safer to assume that
filesystem name should fit into NAME_MAX.

> I was going through ceph kernel client code, historically, the
> filesystem name is stored as a char pointer. The filesystem name from
> mount options is stored
> into 'struct ceph_mount_options' in 'ceph_parse_new_source' and the
> same is used to compare against the fsmap received from the mds in
> 'ceph_mdsc_handle_fsmap'
>=20
> struct ceph_mount_options {
>     ...
>     char *mds_namespace;  /* default NULL */
>     ...
> };
>=20

There is no historical traditions here. :) It is only question of efficienc=
y. If
we know the limit of name, then it could be more efficient to have static n=
ame
buffer embedded into the structure instead of dynamic memory allocation.
Because, we allocate memory for frequently accessed objects from kmem_cache=
 or
memory_pool. And allocating memory from SLUB allocator could be not only
inefficient but the allocation request could fail if the system is under me=
mory
pressure.

> I am not sure what's the right approach to choose here. In kclient,
> assuming ceph fsname not to be bigger than PATH_MAX seems to be safe
> as the kclient today is
> not able to mount the ceph fsname bigger than PATH_MAX. I also
> observed that the kclient failed to mount the ceph fsname with length
> little less than
> PATH_MAX (4090). So it's breaking somewhere with the entire path
> component being considered. Anyway, I will open the discussion to
> everyone here.
> If we are restricting the max fsname length, we need to restrict it
> while creating it in my opinion and fix it across the project both in
> kclient fuse.
>=20
>=20

I could say that it is much safer to assume that filesystem name should fit=
 into
NAME_MAX.


Thanks,
Slava.

> >=20
> > > >=20
> > > > > 3. I will fix up doutc in the next revision.
> > > > > 4. The fs_name is part of the mdsmap in the server side [1]. The =
kernel client decodes only necessary fields from the mdsmap sent by the ser=
ver. Until now, the fs_name
> > > > >     was not being decoded, as part of this fix, it's required and=
 being decoded.
> > > > >=20
> > > >=20
> > > > Correct me if I am wrong. I can create a Ceph cluster with several =
MDS servers.
> > > > In this cluster, I can create multiple file system volumes. And eve=
ry file
> > > > system volume will have some name (fs_name). So, if we store fs_nam=
e into
> > > > mdsmap, then which name do we imply here? Do we imply cluster name =
as fs_name or
> > > > name of particular file system volume?
> > >=20
> > > In CephFS, we mainly deal with two maps MDSMap[1] and FSMap[2]. The M=
DSMap represents
> > > the state for a particular single filesystem. So the =E2=80=98fs_name=
=E2=80=99 in the MDSMap points to a file system
> > > name that the MDSMap represents. Each filesystem will have a distinct=
 MDSMap. The FSMap was
> > > introduced to support multiple filesystems in the cluster. The FSMap =
holds all the filesystems in the
> > > cluster using the MDSMap of each file system. The clients subscribe t=
o these maps. So when kclient
> > > is receiving a mdsmap, it=E2=80=99s corresponding to the filesystem i=
t=E2=80=99s dealing with.
> > >=20
> >=20
> > So, it's sounds to me that MDS keeps multiple MDSMaps for multiple file=
 systems.
> > And kernel side receives only MDSMap for operations. The FSMap is kept =
on MDS
> > side and kernel never receives it. Am I right here?
>=20
> No, not really. The kclient decodes the FSMap as well. The fsname and
> monitor ip are passed in the mount command, the kclient
> contacts the monitor and receives the list of the file systems in the
> cluster via FSMap. The passed fsname from the
> mount command is compared against the list of file systems in the
> FSMap decoded. If the fsname is found, it fetches
> the fscid and requests the corresponding mdsmap from the respective
> mds using fscid.
>=20
> >=20
> > Thanks,
> > Slava.
> >=20
> > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h =20
> > > [2] https://github.com/ceph/ceph/blob/main/src/mds/FSMap.h =20
> > >=20
> > > Thanks,
> > > Kotresh H R
> > >=20
> > > >=20
> > > > Thanks,
> > > > Slava.
> > > >=20
> > > > >=20
> > > > >=20
> > > >=20
> > > > [1]
> > > > https://elixir.bootlin.com/linux/v6.16/source/include/uapi/linux/li=
mits.h#L12 =20
> > > >=20
> > > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h#L596 =
=20
> > > > >=20
> > > > > On Tue, Jul 29, 2025 at 11:57=E2=80=AFPM Viacheslav Dubeyko <Slav=
a.Dubeyko@ibm.com> wrote:
> > > > > > On Tue, 2025-07-29 at 22:32 +0530, khiremat@redhat.com wrote:
> > > > > > > From: Kotresh HR <khiremat@redhat.com>
> > > > > > >=20
> > > > > > > The mds auth caps check should also validate the
> > > > > > > fsname along with the associated caps. Not doing
> > > > > > > so would result in applying the mds auth caps of
> > > > > > > one fs on to the other fs in a multifs ceph cluster.
> > > > > > > The patch fixes the same.
> > > > > > >=20
> > > > > > > Steps to Reproduce (on vstart cluster):
> > > > > > > 1. Create two file systems in a cluster, say 'a' and 'b'
> > > > > > > 2. ceph fs authorize a client.usr / r
> > > > > > > 3. ceph fs authorize b client.usr / rw
> > > > > > > 4. ceph auth get client.usr >> ./keyring
> > > > > > > 5. sudo bin/mount.ceph usr@.a=3D/ /kmnt_a_usr/
> > > > > > > 6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
> > > > > > > 7. sudo bin/mount.ceph admin@.a=3D/ /kmnt_a_admin
> > > > > > > 8. echo "data" > /kmnt_a_admin/admin_file1
> > > > > > > 9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED)
> > > > > > >=20
> > > > > >=20
> > > > > > I think we are missing to explain here which problem or
> > > > > > symptoms will see the user that has this issue. I assume that
> > > > > > this will be seen as the issue reproduction:
> > > > > >=20
> > > > > > With client_3 which has only 1 filesystem in caps is working as=
 expected
> > > > > > mkdir /mnt/client_3/test_3
> > > > > > mkdir: cannot create directory =E2=80=98/mnt/client_3/test_3=E2=
=80=99: Permission denied
> > > > > >=20
> > > > > > Am I correct here?
> > > > > >=20
> > > > > > > URL: https://tracker.ceph.com/issues/72167 =20
> > > > > > > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > > > > > > ---
> > > > > > >   fs/ceph/mds_client.c | 10 ++++++++++
> > > > > > >   fs/ceph/mdsmap.c     | 11 ++++++++++-
> > > > > > >   fs/ceph/mdsmap.h     |  1 +
> > > > > > >   3 files changed, 21 insertions(+), 1 deletion(-)
> > > > > > >=20
> > > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > > index 9eed6d73a508..ba91f3360ff6 100644
> > > > > > > --- a/fs/ceph/mds_client.c
> > > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > > @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(struct=
 ceph_mds_client *mdsc,
> > > > > > >        u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsui=
d);
> > > > > > >        u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgi=
d);
> > > > > > >        struct ceph_client *cl =3D mdsc->fsc->client;
> > > > > > > +     const char *fs_name =3D mdsc->mdsmap->fs_name;
> > > > > > >        const char *spath =3D mdsc->fsc->mount_options->server=
_path;
> > > > > > >        bool gid_matched =3D false;
> > > > > > >        u32 gid, tlen, len;
> > > > > > >        int i, j;
> > > > > > >=20
> > > > > > > +     if (auth->match.fs_name && strcmp(auth->match.fs_name, =
fs_name)) {
> > > > > >=20
> > > > > > Should we consider to use strncmp() here?
> > > > > > We should have the limitation of maximum possible name length.
> > > > > >=20
> > > > > > > +             doutc(cl, "fsname check failed fs_name=3D%s  ma=
tch.fs_name=3D%s\n",
> > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > > +             return 0;
> > > > > > > +     } else {
> > > > > > > +             doutc(cl, "fsname check passed fs_name=3D%s  ma=
tch.fs_name=3D%s\n",
> > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > >=20
> > > > > > I assume that we could call the doutc with auth->match.fs_name =
=3D=3D NULL. So, I am
> > > > > > expecting to have a crash here.
> > > > > >=20
> > > > > > > +     }
> > > > > > > +
> > > > > > >        doutc(cl, "match.uid %lld\n", auth->match.uid);
> > > > > > >        if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> > > > > > >                if (auth->match.uid !=3D caller_uid)
> > > > > > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > > > > > index 8109aba66e02..f1431ba0b33e 100644
> > > > > > > --- a/fs/ceph/mdsmap.c
> > > > > > > +++ b/fs/ceph/mdsmap.c
> > > > > > > @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(s=
truct ceph_mds_client *mdsc, void **p,
> > > > > > >                /* enabled */
> > > > > > >                ceph_decode_8_safe(p, end, m->m_enabled, bad_e=
xt);
> > > > > > >                /* fs_name */
> > > > > > > -             ceph_decode_skip_string(p, end, bad_ext);
> > > > > > > +             m->fs_name =3D ceph_extract_encoded_string(p, e=
nd, NULL, GFP_NOFS);
> > > > > > > +             if (IS_ERR(m->fs_name)) {
> > > > > > > +                     err =3D PTR_ERR(m->fs_name);
> > > > > > > +                     m->fs_name =3D NULL;
> > > > > > > +                     if (err =3D=3D -ENOMEM)
> > > > > > > +                             goto out_err;
> > > > > > > +                     else
> > > > > > > +                             goto bad;
> > > > > > > +             }
> > > > > > >        }
> > > > > > >        /* damaged */
> > > > > > >        if (mdsmap_ev >=3D 9) {
> > > > > > > @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsm=
ap *m)
> > > > > > >                kfree(m->m_info);
> > > > > > >        }
> > > > > > >        kfree(m->m_data_pg_pools);
> > > > > > > +     kfree(m->fs_name);
> > > > > > >        kfree(m);
> > > > > > >   }
> > > > > > >=20
> > > > > > > diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> > > > > > > index 1f2171dd01bf..acb0a2a3627a 100644
> > > > > > > --- a/fs/ceph/mdsmap.h
> > > > > > > +++ b/fs/ceph/mdsmap.h
> > > > > > > @@ -45,6 +45,7 @@ struct ceph_mdsmap {
> > > > > > >        bool m_enabled;
> > > > > > >        bool m_damaged;
> > > > > > >        int m_num_laggy;
> > > > > > > +     char *fs_name;
> > > > > >=20
> > > > > > The ceph_mdsmap structure describes servers in the mds cluster =
[1].
> > > > > > Semantically, I don't see any relation of fs_name with this str=
ucture.
> > > > > > As a result, I don't see the point to keep this pointer in this=
 structure.
> > > > > > Why the fs_name has been placed in this structure?
> > > > > >=20
> > > > > > Thanks,
> > > > > > Slava.
> > > > > >=20
> > > > > > >   };
> > > > > > >=20
> > > > > > >   static inline struct ceph_entity_addr *
> > > > > >=20
> > > > > > [1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/mdsma=
p.h#L11 =20
> > > > > >=20

