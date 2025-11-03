Return-Path: <ceph-devel+bounces-3909-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B33C3C2E11D
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 22:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B6D3A2F39
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 21:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F321DED49;
	Mon,  3 Nov 2025 21:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bjd4X0il"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D739734D3A3;
	Mon,  3 Nov 2025 21:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762203641; cv=fail; b=mYZ0PJlDJ3hWtguzh+5xup/MRK35cms0fQEPC40AoD+qskD5U2oHXjsq0PFvc3362edTZhgN+RG+WPrBOZ/6RKuUi9m6b7F2n9RJbhuUTEHgKL9RJvpd8Aid2OaKOlAg5gJOiwdacSZeZgGHgiP9XkRgyH5MzRQ/H2el2tVpHqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762203641; c=relaxed/simple;
	bh=roD/geUxv9ogO8GdhSIAddUyDeesnANw4bDNPI+eWwk=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=GKm8UKYynnHvJcM5kZdUv5XskTG8BTBqrd8YV4PkMvKHgFGCxxX5fGBzp1fLsdTScVLiKRM/xp0oOix3x+AMkQ/0SFyScqF3K0NU2aX+Airkc13l0oc4+F0NaibLm0Fx93vdQuqMAoszYXgXImhW8cPIol0qqY5DAsJLIDXB0Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bjd4X0il; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3Ek6b0004950;
	Mon, 3 Nov 2025 21:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=roD/geUxv9ogO8GdhSIAddUyDeesnANw4bDNPI+eWwk=; b=bjd4X0il
	jfZMgivd07K+WSF5PhTZsbqvdGt1TvEWm7vCrzaHZ2cj2v6KLa0DoIsWnZkBaDdJ
	WdMe0kgFCzEibgBCoiaMxuKJF9dKsMxDByvL1M89dxGwsUq4s01g0PdxQimFK7Tn
	WtFoNs9lRV8f5+ZHH3EXPz4x2Be2lVu6k5x8VyIqGABLuUwztHhIIu7V2IRw62HX
	xqFcp05Zxnon7PE8UO6zGwFHYPvYzz5N5m5MVgzO6wgBFXuK3ryE2ZhITQQgjAaA
	jQVgWb8l5fxeR8yuZNGyLyWyIwSj5gpaBESlYiW822sfo36r4EB8IMN5m+mzul7z
	PQ/yiayMEaSeRg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a57mr0rbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 21:00:05 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A3KsE5w009713;
	Mon, 3 Nov 2025 21:00:04 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a57mr0rbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 21:00:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBkgA7xbf6sMmSWx3r6h64A9MuMOB/BOE27+LU57r4qko8Q4AGUG67OnSQvkGzH6P+QakSZH/e3EgPi2G5l1MB4cstLone38AeCBhoBuTG2Kst6vTHpxbAuudmu3WmmKY4s/OYjluWkYtCSA970Vas7Y0VYEFK4QuPKnfyy5ybUmHnN/OODyx91VRk+h/jUTDam5XRDMmU30p9Ks9vXSKrgdWX0Hdhtqvfajh3CzxW74ygWUiZnT9rJIETsLSEGekJAgUtEBxu6SPF9w+OJumQaJaFAqWdN9vJJQPSIOzMQ91t2d4XyD7RA+NEOptPO5hghA+0UPDr4096HM8mbRXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roD/geUxv9ogO8GdhSIAddUyDeesnANw4bDNPI+eWwk=;
 b=EgFcW/81rn/XtCSSRExiCvfWibEdaBrM8dSeYEGeDLPEYOPqHWrIa7MtkY3Zw7fB3knIwiiyVB7Qzsk8laBZ/N92VSS0ZxCm4dYteC/4Y5Z2j5BoVxRvGFLmLaRR91qU2vUBDPee8P629zIiRKBfpQHam6tgmRB3rhtTsbF10kCSHhjODlH56fRVSs66uyzk8v5px6uKqnBS79Zy6FC06XwK2c6skZLoRI1/qT8A8dUyFm+KFCOPYcaaet9o7fH9Hz9b+LC0+eA3KCIYPoEx80qM2479Jw/BWsg6LyWmOv9ZmeeZhUMG46Qe0Kp0vuHPmQt1iYl29LmQBdJ+koyM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM6PR15MB3767.namprd15.prod.outlook.com (2603:10b6:5:2b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 3 Nov
 2025 21:00:01 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 21:00:01 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Alex Markuze
	<amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
        "rppt@kernel.org"
	<rppt@kernel.org>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "david@redhat.com" <david@redhat.com>,
        "mgorman@suse.de" <mgorman@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
        "vincent.guittot@linaro.org"
	<vincent.guittot@linaro.org>,
        "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>,
        "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "surenb@google.com"
	<surenb@google.com>,
        Valentin Schneider <vschneid@redhat.com>,
        "kees@kernel.org" <kees@kernel.org>,
        "peterz@infradead.org"
	<peterz@infradead.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "juri.lelli@redhat.com"
	<juri.lelli@redhat.com>
Thread-Topic: [EXTERNAL] [RFC PATCH 5/5] ceph: Activate BLOG logging
Thread-Index: AQHcRMJKRMiUSlL1ZUyN4EQ9q+DQ7rThgB+A
Date: Mon, 3 Nov 2025 21:00:01 +0000
Message-ID: <c5968bdea851365e6c27637a16ccb094f8254e5d.camel@ibm.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	 <20251024084259.2359693-6-amarkuze@redhat.com>
In-Reply-To: <20251024084259.2359693-6-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM6PR15MB3767:EE_
x-ms-office365-filtering-correlation-id: 0c4e801b-c787-42ab-d9a1-08de1b1bf4b2
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?M1BXaWlHY1o1QmYxYUg1NUlEM0dSSEMwZEZjUU9rUDZoNHROeml4aHZxaTFM?=
 =?utf-8?B?TE1uc1FQejU1NHlhYVZubU13TW16YWxBQXlZR3NXVURPQjFOOHNSRWZhLzQ0?=
 =?utf-8?B?Ty85Qzh1bURLcm9zVDZnNDdGalRxYWlFaEdxaFJKbHRDQitQTk13ZWZ4bWhI?=
 =?utf-8?B?eFpvVFdneE4zTXNGODVjUUpHME5UbXlJczViZFg1cWlKd1FsVVpab1hKcU5l?=
 =?utf-8?B?QW9nQU56VmhVTlphU3dudmVMdDFRUGd6cTRDY1FKOGlEc2wrb29xMlVoNTJO?=
 =?utf-8?B?Z3hVSkJoMktkUkZEdnN5SytTbStYVHBTNTRvN1VPeXp3TS9mNWVuODJOdWJE?=
 =?utf-8?B?QUI0bGkrZHRVSjFqaTYyb3ZTT0Y2cFBwejZaVElYZ3JqQXV3QWpVaGR5c1pV?=
 =?utf-8?B?aStuajBvWXdVVWJlSDhhMXoxRHJFLzhKVmZLU3FuSHU0OGEvZ0NpN3lySzVT?=
 =?utf-8?B?R1d0V2VoTDZ1NFZtOGhUZGRvTHR5OGw5QmdWenE0RjJSOC9VdkNaRE02b2Ni?=
 =?utf-8?B?UVg0c3VGUGpiUHlXVG1sY1NEWUFBSFgrSmRGcFFqUS8vR3A0MVJjWjViZ2NE?=
 =?utf-8?B?dWNFNlVHSE04VjJHMjBXa3pZNnNVZWlCMWdKbFlwSTdPVlh0TWtaU2FDQkpq?=
 =?utf-8?B?QkZZeEticUhzNUlWK1NOUEIzWi93MXFhN1FrZHJZUVlyaTlFendJNG54WGZ4?=
 =?utf-8?B?cEovVm9ITlNRNGRhMkI3VHpHSURzNksyS2J2MFJtekpiT3Q4Nmg4UVNpOHRk?=
 =?utf-8?B?NHkraFhsWitJUERaU0MzemFzVmpEdWZkdmRzdGdYSEZyK2d2ZzNIMnA4RUxI?=
 =?utf-8?B?dlhpNDhoYzBYaHpmVDBxSUdtRk9vN1hjOEN6VVAvTnFmTkluazRhTkMyc25Z?=
 =?utf-8?B?TVJzTENKNURUaDhZbTZlV0I1QlpvdGpQa0wwc0VldFdaenlsREY5eEF5N1Bl?=
 =?utf-8?B?djMrdXpvTHc5VkhYZVNTMERWbXRGV2ZLQTFYY1hvZ2hPVS84c0lTakVKRm00?=
 =?utf-8?B?eWZpZFF5TUN1NXkyZ3JIOHpwb1dKdEMwbWVmS3BJc0dNTkRvQzBsakVwYWhT?=
 =?utf-8?B?WGVVcXRXVk12cWc0ZVNrSEtUUHRJMlZoNHZpM3IyM2MyOU9EYVRBV1U5MUZ4?=
 =?utf-8?B?RjNvb0pNRGdKcm9WcEV4Q1pWc1dYRHErdndTSTNwenRNcGpOZWpnQTVlWjBF?=
 =?utf-8?B?WTAwMndGbWo5NXY1eXJJK2s3Q2xvblREYXBDRFFnSXUrdXZ2SEZmZGp0bEJP?=
 =?utf-8?B?WkFLMG5CRVU3K3hVbWx2MVMzdWE0NWtnUWt1cWxoeXZRQ085SzBzbjNZK09m?=
 =?utf-8?B?TFJHUm5wNFpYbFBGTFF1bmIrTHV2QzlZWElVMi9VWlo2M2VIR0dqb3dCc1JE?=
 =?utf-8?B?NGJGNmZtYWNLWm41cFpzSHJwdmYyaEtCRjloNmZnQk9MdHI5bXNUTmdBeGk1?=
 =?utf-8?B?UENsOVhrMUN5RElaQ0h0WUZMMUx3VkRRQUpqQ0JIS3BkNjhzbjZwdXdSaFFP?=
 =?utf-8?B?dEcxMFRDYWJVVW9lbjJrQVFZNmsyVG5WbVpYQWJmVVRmSUNaMnpnM3hXQmNz?=
 =?utf-8?B?Q0Y1N0ZmL05kdDRsZ05lN1FhZ3JGRFYya0luT2lHNVVxL3lDTG52cVFzdFRt?=
 =?utf-8?B?ZG1GUWNZVmdsQVpzSnNiQzFTSmNieGlkLzM3MURBQURmWUNqWU9XVHcxMjVj?=
 =?utf-8?B?M2lrNGJoL29TTU5LejF2L2Vqb1NLT09DZlJaVERCTDRaRTFKeWFkdTl6SnFm?=
 =?utf-8?B?NGR0c2RmRWNVM1MzVjlkY2NReHlaODFPQk9KdG1KNjQzMXgvZzVmcFdyWlUx?=
 =?utf-8?B?ekUzQ3BsbVRnTStabFIzYlNlclVFME9XVnozc1ZkT1F0dUNHS0JveS9rV0wr?=
 =?utf-8?B?ZURhaUNkd1FNS2w2Wi9DalRuYWNDV1JGZmVsM1pZQnRyNGR6UUtJanF2dmdp?=
 =?utf-8?B?ZHdpaTB6TzRqNmw3NXArcW9jTWtGeHAyNWVrVWsxNVp2a3pFbzYyZUVsSFlP?=
 =?utf-8?B?N1JGYyt1bUJCYStEbEVidU85em5PanJxUW5KeVM5b0oxVkRqL2gyRDNiWTNr?=
 =?utf-8?Q?5oPJHC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODgxRmlTSk1lY3lNSisrT3BKdytCQlpoYXhacGsrZjgydExpSGJDdnJ3VFo1?=
 =?utf-8?B?NGFFb2RZbDhKbGRIdXN6bjUrL081NzhhQVBVZUY5MzgrcTNYMHRsakNHZVBW?=
 =?utf-8?B?ZU5KbHh1ZUkxVE54VkY5NE5qa1ZyVVk4ajVsWWRpWkpGQkJ4VDdwRWxDSi9L?=
 =?utf-8?B?dzd3S1FBY2ozUnBSWk95bXZuNTVLZmM4NkhxSWRqNVI3Q0srWitYRjloREJ2?=
 =?utf-8?B?RlJKSG43WktLWHlWVlBxa2NybnlhWkFaMjdHZnVYeU5FNithY1hQZVZJTnJX?=
 =?utf-8?B?cWIyeVpobTlZUmZhYjZtYVg0RWpXZFZKbWdaTkxtVmVTTDJsMDUrUnBoMkxt?=
 =?utf-8?B?SVArMzNFSXlsdkdjaVJrOTRYTGlJdDdpcm5XNFc2emoyQVc2bkpoUCtQbEVr?=
 =?utf-8?B?NThtMTVPSUc0REJoQnJKMkJ5M0lVb3RIUWZXc2hmZWFrZVdmTEtYWEhzM2M1?=
 =?utf-8?B?TUxET3JsRSt2eHZKenJJcVZuN2pYMmtSN3J3VC9rSEZ1UllHemFST2JBeEpv?=
 =?utf-8?B?NUl5ZjJ3UmxRMXdQaWVHdHBkbkRJUWpCYi9hZ091V1VDeHgxekpYZEVFaDEy?=
 =?utf-8?B?d0wzalAzK0N1M3pDUUp3dDRLcEJxRDBIMkNMK0xpWW1ta1cxS1BIaVhoUTdx?=
 =?utf-8?B?SS9PNUZHTENqQ0czZEwzL3c1SWlaNnIzcEo1azhucE5IZ0ZDVHdzVG9VMU5h?=
 =?utf-8?B?MURYZzN6K29XUlRodElHYjZTUHZRN3Q3bnFTbi9wL1prUnJhMzJGUlFDSkcx?=
 =?utf-8?B?Rjh2ZVcwWFN4Q0dzL0prUk9GWUtWejd1ejZmN3FwbHZFWDZSVWhPcUdEYUk0?=
 =?utf-8?B?Nmw4TlJzNW9CZll4NXdaTWlFSUhqeEVaSFBmYlFLRDB6d1FycXR6UTBwUENE?=
 =?utf-8?B?L1FkY2hrcDNMREV6eFF4RVJJSlpVQnVBMU5SRzM0a2VxUWRhQ2ttNVhKV2ZO?=
 =?utf-8?B?U1ZtM3RUTlN6ZnJKK0dKeEFRQnRYN0p1YzNvbWpxQlRWbFgwd0NBVXVSejdr?=
 =?utf-8?B?NFVXUVR3NGVBME9DMFMvcDFZOEJxazMvVFVGSlNZLzN2UTJkTUt5WFlnTE15?=
 =?utf-8?B?UGE3dlRPTUhmTEFpb1pvU1BMMTMvM3ZpdWlmdlJDcy80K2h2QjFBNUhZbmVW?=
 =?utf-8?B?QnVPV2dHWTlsZDJGZEgwaFQ0Z0tKMDRsZlF2UUNkWlJDZUJ6YUpXTnNrOG5N?=
 =?utf-8?B?ellWazJGWTVnMzhhUHlYZXZCNHJVMVFENG81YVJVUkRhU2ZwNTJUREl1WkYr?=
 =?utf-8?B?ME12cmlpdmpKVk84cFNOL1JkQVZ1NEttWTNBZDRUWHpQQTNkSzFRWjY3SWdq?=
 =?utf-8?B?b3I2TmxFVGh6MVVJUkdDdEhiSC9jbWhaNFNPdzNFRWRmeUwwZUpHVzNIdmd4?=
 =?utf-8?B?VUxrTUJFVGFsZmowNFhxWTVYbnJDTkZHU0tVRFhrN01JK2RPYW9KdmxSaFgz?=
 =?utf-8?B?ck1zQ2NlZm1uNVIvUlpyRC9MR0FDdHRieTRwVTdQY1g4TjNIUXZQanlXMGZi?=
 =?utf-8?B?Zkx6Ym1jZy9ZdEdXOW52Ymg3QjJqU2x6WnhPcHNlN21xMGV0Q1JPZ0RtalBN?=
 =?utf-8?B?dTAzcVdPNmZQQ1IwdUdGRGFCbnZsTVRkQ1RJVE1Kc0czaUQrNnE3aCtlNVkw?=
 =?utf-8?B?WHRPVHE2YWgxbWZRa2s3MGtFSDJKc1JlbUUyM0tCdXluL0ZPMExzakkrQUo1?=
 =?utf-8?B?N09JT093b1d6R0RsRFUyRTVWTU5XR003NUpBT05lTFpoYmJzZ3B3dS9RbTU2?=
 =?utf-8?B?eFNWNHF6bkI2NTdRbzU2V2VYVEZYVW5TVmtOanM5aEo0SFhMWTZCSExtbGdy?=
 =?utf-8?B?ZDM0Uy9SZ2s4UFBqMTUweHNOVXdKaUJoRXNSd0FOeHM2RWJPOHJiYW5QZUtk?=
 =?utf-8?B?U0MxT3lFSmQ4TGhuMEc5VUpjbFBKOVdqOVd1OER1ZnNaTWFkc1QwSXA0b0I1?=
 =?utf-8?B?ZGtDN2pwcE8yYVZyQkcybitjSkdkWVQrOFBaaTBIVWdrNHZIQ0MxTHI2ZTYz?=
 =?utf-8?B?a3pTcWx0VzdmaVovUEZHQ3VncDU5eHlDck5sSjBCSlVJU2I2dVg3MCtFcDk1?=
 =?utf-8?B?dWRBaFJ6VDdmdzF3QTRZdjg0ZkdSRlZRM0ROYjlHOHRnRzgvTXlralFuL3BY?=
 =?utf-8?B?c25SeVJ4bnk4RzZXbzNnLzhZckZmNEdTRGthZ3d4MFpmR1kxN2F6cXR5SGQr?=
 =?utf-8?Q?TALMRn78SYCSOKkYVhCS3rU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF462C29EC7B864AB7D53262AF4E1A75@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4e801b-c787-42ab-d9a1-08de1b1bf4b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 21:00:01.6367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JVB3nOppCtL+guurqKzdGj/8RE7C8h0zYw/e9Ke62g70Y99c4yX2L+vIZqTLCCniu25mDGqZLlZ3WNN2u2NBbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3767
X-Proofpoint-GUID: fsy4G0xvf2N3boVZKxIhHyRndU3rciKv
X-Authority-Analysis: v=2.4 cv=MKhtWcZl c=1 sm=1 tr=0 ts=690917d5 cx=c_pps
 a=QnZ2uEdZlRAtgHxfLCbJPw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=fAvBXI6azVoAxJ-ElrcA:9
 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: AonKANr7agUJUQ07oq7i7V6NQ7MidE1h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwMSBTYWx0ZWRfX58XLke1frLZ9
 Z/r7ak/xpBa3yY647bAUfRZinZONd7ZFchTtnkacSrTPVFIRNXpfGqHe0AK0cRU9UFcOi03A6Fy
 7H+ExWMwgC8jIvK2BOChHdULTeR8fPxR9F4Lz0jpReG31OAdAVZifXnXNGNA2GuM9fBJYXn5CZL
 wCGs2AQ0JY/5+SwKvaCy5HMhbMJhJ7kx+lA85EszNaSifwA2MUEdHFpwLmW32gGIJ5OyBEjxYWz
 GKbKV6kpaPUFrC9o9ANhDLyfwXKbk1LsW8M7+fsX3LjaOVJLkg4uMLAOuuyM9jpBCrX/oPpGI+G
 d8xc64KvPnVSgQMrWh2ePvcRBuQfRmH7uPPwmd+LRXgd4aPsjJN3/lCrYn4kyGNhUs9BWjHUq+R
 tHwmmUK7RIu1nm39gnaRbzAko9U0Lw==
Subject: Re:  [RFC PATCH 5/5] ceph: Activate BLOG logging
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_05,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010001

T24gRnJpLCAyMDI1LTEwLTI0IGF0IDA4OjQyICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IENvbnZlcnQgYWxsIGRlYnVnIGxvZ2dpbmcgY2FsbHMgZnJvbSBkb3V0L2RvdXRjIHRvIGJvdXQv
Ym91dGMgdGhyb3VnaG91dA0KPiB0aGUgQ2VwaCBmaWxlc3lzdGVtIGNvZGUsIGVuYWJsaW5nIGJp
bmFyeSBsb2dnaW5nIGZvciBpbXByb3ZlZCBwZXJmb3JtYW5jZQ0KPiBhbmQgcmVkdWNlZCBvdmVy
aGVhZCBvbiBob3QgcGF0aHMuDQo+IA0KPiAqKlNjb3BlIG9mIGNoYW5nZXM6KioNCj4gVGhpcyBj
b21taXQgaXMgYSBtZWNoYW5pY2FsIHRyYW5zZm9ybWF0aW9uIHRoYXQgcmVwbGFjZXMgZXZlcnkg
aW5zdGFuY2Ugb2YNCj4gdGhlIHRyYWRpdGlvbmFsIHRleHQtYmFzZWQgbG9nZ2luZyBtYWNyb3Mg
KGRvdXQvZG91dGMpIHdpdGggdGhlaXIgYmluYXJ5DQo+IGxvZ2dpbmcgZXF1aXZhbGVudHMgKGJv
dXQvYm91dGMpIGFjcm9zcyB0aGUgZW50aXJlIENlcGggY2xpZW50IGNvZGViYXNlLg0KPiANCj4g
KipNb2RpZmllZCBzdWJzeXN0ZW1zOioqDQo+IC0gKipBZGRyZXNzIHNwYWNlIG9wZXJhdGlvbnMq
KiAoYWRkci5jKTogUGFnZSBjYWNoZSwgd3JpdGViYWNrLCByZWFkYWhlYWQNCj4gLSAqKkNhcGFi
aWxpdHkgbWFuYWdlbWVudCoqIChjYXBzLmMpOiBNRFMgY2FwYWJpbGl0eSB0cmFja2luZyBhbmQg
cmV2b2NhdGlvbg0KPiAtICoqQ3J5cHRvIG9wZXJhdGlvbnMqKiAoY3J5cHRvLmMpOiBFbmNyeXB0
aW9uIGNvbnRleHQgaGFuZGxpbmcNCj4gLSAqKkRpcmVjdG9yeSBvcGVyYXRpb25zKiogKGRpci5j
KTogTG9va3VwcywgcmVhZGRpciwgZGNhY2hlIG1hbmFnZW1lbnQNCj4gLSAqKkV4cG9ydCBvcGVy
YXRpb25zKiogKGV4cG9ydC5jKTogTkZTIGV4cG9ydCBzdXBwb3J0DQo+IC0gKipGaWxlIG9wZXJh
dGlvbnMqKiAoZmlsZS5jKTogT3BlbiwgcmVhZCwgd3JpdGUsIG1tYXAsIGZzeW5jDQo+IC0gKipJ
bm9kZSBvcGVyYXRpb25zKiogKGlub2RlLmMpOiBJbm9kZSBsaWZlY3ljbGUsIGF0dHJpYnV0ZSB1
cGRhdGVzDQo+IC0gKipJb2N0bCBvcGVyYXRpb25zKiogKGlvY3RsLmMpOiBTcGVjaWFsIGZpbGUg
b3BlcmF0aW9ucw0KPiAtICoqUE9TSVggbG9ja3MqKiAobG9ja3MuYyk6IEZpbGUgbG9ja2luZyBv
cGVyYXRpb25zDQo+IC0gKipNRFMgY2xpZW50KiogKG1kc19jbGllbnQuYyk6IE1ldGFkYXRhIHNl
cnZlciBjb21tdW5pY2F0aW9uIGFuZCBzZXNzaW9ucw0KPiAtICoqTURTIG1hcCoqIChtZHNtYXAu
Yyk6IE1EUyBjbHVzdGVyIHRvcG9sb2d5IHRyYWNraW5nDQo+IC0gKipRdW90YSBtYW5hZ2VtZW50
KiogKHF1b3RhLmMpOiBEaXJlY3RvcnkgcXVvdGEgZW5mb3JjZW1lbnQNCj4gLSAqKlNuYXBzaG90
IG9wZXJhdGlvbnMqKiAoc25hcC5jKTogU25hcHNob3QgcmVhbG0gbWFuYWdlbWVudA0KPiAtICoq
U3VwZXJibG9jayBvcGVyYXRpb25zKiogKHN1cGVyLmMpOiBNb3VudCwgdW5tb3VudCwgc3RhdGZz
DQo+IC0gKipFeHRlbmRlZCBhdHRyaWJ1dGVzKiogKHhhdHRyLmMpOiBHZXR4YXR0ciwgc2V0eGF0
dHIsIGxpc3R4YXR0cg0KPiANCj4gKipjZXBoX2RlYnVnLmggbW9kaWZpY2F0aW9uczoqKg0KPiBV
cGRhdGVkIHRoZSBkZWJ1ZyBoZWFkZXIgdG8gZGVmaW5lIGJvdXQvYm91dGMgYXMgdGhlIHByaW1h
cnkgbG9nZ2luZw0KPiBpbnRlcmZhY2Ugd2hlbiBDT05GSUdfQkxPRyBpcyBlbmFibGVkLCB3aXRo
IGF1dG9tYXRpYyBmYWxsYmFjayB0byBkb3V0L2RvdXRjDQo+IHdoZW4gQkxPRyBpcyBkaXNhYmxl
ZC4gVGhpcyBlbnN1cmVzIHRoZSBjb2RlIGJ1aWxkcyBhbmQgcnVucyBjb3JyZWN0bHkgaW4NCj4g
Ym90aCBjb25maWd1cmF0aW9ucy4NCj4gDQo+ICoqUGVyZm9ybWFuY2UgaW1wYWN0OioqDQo+IEJp
bmFyeSBsb2dnaW5nIHNpZ25pZmljYW50bHkgcmVkdWNlcyB0aGUgb3ZlcmhlYWQgb2YgZGVidWcg
bG9nZ2luZyBieToNCj4gLSBEZWZlcnJpbmcgc3RyaW5nIGZvcm1hdHRpbmcgdG8gdXNlcnNwYWNl
IGRlc2VyaWFsaXphdGlvbiB0aW1lDQo+IC0gVXNpbmcgbG9jay1mcmVlIFRMUyBjb250ZXh0cyBm
b3IgbG9nIGJ1ZmZlciBhbGxvY2F0aW9uDQo+IC0gRWxpbWluYXRpbmcgc3ByaW50ZiBvdmVyaGVh
ZCBvbiBob3QgcGF0aHMNCj4gLSBSZWR1Y2luZyBjYWNoZSBwcmVzc3VyZSBmcm9tIGZvcm1hdCBz
dHJpbmcgcHJvY2Vzc2luZw0KPiANCj4gRGVidWcgbG9ncyBjYW4gbm93IGJlIGVuYWJsZWQgaW4g
cHJvZHVjdGlvbiB3aXRoIG1pbmltYWwgcGVyZm9ybWFuY2UgaW1wYWN0LA0KPiBwcm92aWRpbmcg
dmFsdWFibGUgZGlhZ25vc3RpYyBkYXRhIHdpdGhvdXQgdGhlIG92ZXJoZWFkIG9mIHRyYWRpdGlv
bmFsIHRleHQNCj4gbG9nZ2luZy4gVGhlIGJpbmFyeSBmb3JtYXQgYWxzbyBlbmFibGVzIG1vcmUg
c29waGlzdGljYXRlZCBhbmFseXNpcyB0b29scw0KPiBhbmQgaGlnaGVyIGxvZyB0aHJvdWdocHV0
Lg0KPiANCj4gKipDb21wYXRpYmlsaXR5OioqDQo+IFRoZSBsb2dnaW5nIHNlbWFudGljcyByZW1h
aW4gaWRlbnRpY2FsIC0gc2FtZSBsb2cgbGV2ZWxzLCBzYW1lIHN1YnN5c3RlbQ0KPiBmaWx0ZXJp
bmcsIHNhbWUgY29uZGl0aW9uYWwgbG9naWMuIEV4aXN0aW5nIGxvZyBhbmFseXNpcyB3b3JrZmxv
d3MgY2FuIGJlDQo+IGFkYXB0ZWQgYnkgZGVzZXJpYWxpemluZyBCTE9HIGJ1ZmZlcnMgZXhwb3J0
ZWQgdGhyb3VnaCBkZWJ1Z2ZzIChpbnRyb2R1Y2VkDQo+IGluIHRoZSBwcmV2aW91cyBjb21taXQp
Lg0KPiANCj4gQWZ0ZXIgdGhpcyBjb21taXQsIHRoZSBDZXBoIGZpbGVzeXN0ZW0gdXNlcyBCTE9H
IGZvciBhbGwgZGVidWcgbG9nZ2luZyB3aGVuDQo+IENPTkZJR19CTE9HIGlzIGVuYWJsZWQuIFVz
ZXJzcGFjZSB0b29scyBjYW4gcmVhZCBiaW5hcnkgbG9ncyBmcm9tIGRlYnVnZnMNCj4gYW5kIGRl
c2VyaWFsaXplIHRoZW0gYmFjayB0byBodW1hbi1yZWFkYWJsZSBmb3JtYXQgdXNpbmcgdGhlIGZv
cm1hdCBzdHJpbmdzDQo+IHJlZ2lzdGVyZWQgaW4gdGhlIEJMT0cgc291cmNlIElEIHJlZ2lzdHJ5
Lg0KDQpJIGFtIHNsaWdodGx5IGxvc3QgbXlzZWxmIGluIHRoZSBjb2RlLiBBbmQsIHByb2JhYmx5
LCBJIGFtIG1pc3NpbmcgdGhlIHBvaW50Lg0KQnV0LCBhcyBmYXIgYXMgSSBjYW4gc2VlLCB0aGUg
ZG91dGMgbWFjcm8gaGFzIHNpbXBseSBiZWluZyByZW5hbWVkIG9uIGJvdXRjOg0KDQotIyBkZWZp
bmUgZG91dGMoY2xpZW50LCBmbXQsIC4uLikJCQkJCVwNCisjIGRlZmluZSBib3V0YyhjbGllbnQs
IGZtdCwgLi4uKQkJCQkJXA0KIAlwcl9kZWJ1ZygiIFslcFUgJWxsdV0gJXM6ICIgZm10LCAmY2xp
ZW50LQ0KPmZzaWQsCQkJXA0KIAkJIGNsaWVudC0+bW9uYy5hdXRoLT5nbG9iYWxfaWQsIF9fZnVu
Y19fLCAjI19fVkFfQVJHU19fKQ0KDQpCdXQgaG93IGRvZXMgaXQgdXNlIHRoZSBCTE9HIHN1YnN5
c3RlbT8NCg0KSSBhbSBzaW1wbHkgdHJ5aW5nIHRvIHVuZGVyc3RhbmQgaG93IHRoZSBDZXBoJ3Mg
ZGVidWdnaW5nIHN1YnN5c3RlbSBjYW4gd29yaw0Kd2l0aCBlbmFibGVkIGFuZCBkaXNhYmxlZCBD
T05GSUdfQkxPQiBjb21waWxhdGlvbiBvcHRpb24uDQoNClRoYW5rcywNClNsYXZhLg0KDQo=

