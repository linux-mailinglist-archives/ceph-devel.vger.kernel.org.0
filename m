Return-Path: <ceph-devel+bounces-3887-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBF1C1615C
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Oct 2025 18:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E80E421CD8
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Oct 2025 17:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77DA296BCB;
	Tue, 28 Oct 2025 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JKg3cU3K"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8F9288C3D;
	Tue, 28 Oct 2025 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671289; cv=fail; b=G0L0ttAxmEC77Go3cbTnW5zJ2+JRXrjnLLacP7w3yEyk6pdHJP6l2LlGXASqui6a8wXRlhwuYz1s5twnyqI8n1jiLMSoPRZIb8wx8rox68AJMPP7hfd12qP5lgjfC+nsUpM5ZMIm8Ckfc4rASoThjNRRh1Eypp+WKW9DTYkn5QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671289; c=relaxed/simple;
	bh=kzU/JUnfYVkcoMbOYVVcSLDlGZpmMlVQIL74v2iVIZc=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=s4MdBFCvMSNXn4ErSagvDwpB/D/IRstYVjp2s7wQdx/bvLLYlBXh/mwyURg/FIqdq0OUSjok9BE8DxWKkq7TxxAqqhMh17oLzYzeGBq+oCpUmVPlzN0Be40BfH/m2f6m7i9yMbUQpq8yY6N9eAWhpmCuvvGi0SMWjBCqVzuSjB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JKg3cU3K; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SGHGiv027900;
	Tue, 28 Oct 2025 17:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=kzU/JUnfYVkcoMbOYVVcSLDlGZpmMlVQIL74v2iVIZc=; b=JKg3cU3K
	83jhpPXxvrbu3N1W9wJu0JjsrN4isse9ArFoXAH31qlQjvfpcmYpqeRsa1T7f5+q
	Onq49Yn3VI8R4gwZBkY9hiUf5bPnaZrPuX3GZs2HYgqlKaE4WDWz1bttq9B2bFAJ
	Em26DnPJxbxWLbL3sJuNbzvC1w+zrCuK93zTI2WCYqJ6urQ01R+yf8Q7Sj7NHnzr
	u73LQMswnDirRmo/kNWJaHKJe4H5v5z2VWJjVKknByGBPDkPLMUttMKv8EWaRO/T
	ZLB05boW6Rq0lcg0GVBuLBXGt8xi+pqoOaaTDiaglH+F5MOV2UDFVI4PjZf3Eoaw
	+II+dh2gKIhsrg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p81wt85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 17:07:34 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59SH6cXX024946;
	Tue, 28 Oct 2025 17:07:33 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p81wt7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 17:07:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D1wMJjHKVO4OUORnqQxTYyUT4qsOWY6SIZxmTnAlpIgpDXVNbmY3enS95oew2WMkjOIslN2IEzvZynR/4U8TIX8nr8VoGAjeTRdMytb3xMzdoWcmu687EnBkaX5NBiYQR5F/b9VNaRdgXMMuuiqTH0vR6tcyQe5TWygugjjSGsiaA4IjF4qgEyumgWkaxsjkpvqJxw1qjeimdsPWkRJ2w06MA/k5tkCZ9xfc6H7fwe2A4Mj/67VuSp8/bJunWdxAJ1EZmX19BNiV3ySSdj7WZUDvgQLXe0eBqi+aF5lxIsfKBxY6qsEvnkxbZjH4/ZOhVoxnty1wKufJVIpBol1Kbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzU/JUnfYVkcoMbOYVVcSLDlGZpmMlVQIL74v2iVIZc=;
 b=HJ1EJtBJ2uuFzcF5FRdprDFz7aenVNzkHkR0OGCfgYSk8576m2qhhqPuyD9+4GVat0I1wrku9gwBVvPLu0inzlmZ5dNuzvFY/M7KKS7pwI5nn+WCn0uxWBnnYyUkAwMCzPjOw13v4nrozufeUE5UVnfm9RYsmA8icE4alzoitiWwMY55AEf2VuEsVM4BwW7vHWsHaHAObsO4QhXLJW/xdBWe2fReA7NcirHwE0ILsjD48pL9ffLPGQpL0qH42BPlspz7NsqCxycY4sZESoYCy1dYSJ5WcjPBvQwYTbqts2DxuOPotLHEkl3nz7fiPJh0LSmcD1xydkBkG+GakVVtNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA1PR15MB6005.namprd15.prod.outlook.com (2603:10b6:208:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Tue, 28 Oct
 2025 17:07:31 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 17:07:31 +0000
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
Thread-Topic: [EXTERNAL] [RFC PATCH 0/5] BLOG: per-task logging contexts with
 Ceph consumer
Thread-Index: AQHcRMI/2Rj41CKePUS/yncl0VrstbTX0SsA
Date: Tue, 28 Oct 2025 17:07:30 +0000
Message-ID: <e5c4eb9033b93b06c1f7a17ecc79d8dd766bf86f.camel@ibm.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA1PR15MB6005:EE_
x-ms-office365-filtering-correlation-id: a98a0874-76f6-43f5-0284-08de16447afa
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ek03aWsyTmMxRFpqcXRoSHE3ZTNTUmNHRUFXVmpyckpNTmZkNmExQkVHWXVz?=
 =?utf-8?B?Q2wxTkd5VzhGVU8rZ1VEYmU0djhJQU5BMERSMnF6MVJDOFZKRllmWVIwMEZo?=
 =?utf-8?B?MENyaHpqeXRnd1ZBcTc5b0ZjVUx1Qkhrd0ZVRE0wenZ4MEVveTA3MGNBWjBn?=
 =?utf-8?B?QnNTcUdUNGxzVHk1UFRpMTZ6dzhjOE1VcWsvNzBMTXhBWE1qQU9QRDRaa1VS?=
 =?utf-8?B?dXF5azR4aVYwU1hFczVEb2UzcDRhT0FkZ3dvWkhoT2J3d2FYbk4yUGpUYWVV?=
 =?utf-8?B?RXNJQkZiZmpGVjIyQmFaRVNscWtxMklocGNaOU1rSHk4ZDZwWkxwSkVYeEt5?=
 =?utf-8?B?bWRzWWY0TDI5aWZNY0p5V3dneFZ6VWd1REtpTi9ML2hYeFVKd3RPRXFDOWpW?=
 =?utf-8?B?dmE5b1FKSVdKTFdJNVZFVU04eFA3RDViOHFsWXF4Tm1GZlJ0aGJMV1ZmSmc5?=
 =?utf-8?B?Qm9KQTlWTkphUXlPNGJWcGhmOVM1cGV6T0lnUmJJWTV4Y2tKSHVzeXdHUk5Q?=
 =?utf-8?B?KzZwdXVrTE81aEFSek9hOWsyKzhoVytOeG9pRUt6RVY0SDU2TW4rTzdQNGxm?=
 =?utf-8?B?Q2xIajlxMEphUW1qbStaNWJGeVFoYVNkN21lUWVBb2gwZ3JjQXJINU1SVFZC?=
 =?utf-8?B?NVoxOU5pS1R5WXdmd090UjhGU0ZzdXVxOTB0WW9LYWNsTHk0TDVCOU1hSVoz?=
 =?utf-8?B?STNaMm9xZ0E5MitaekpNSmM0RzVIMTdoNGJrSzNEYWlrdEtRQ3J3ckMxUHpu?=
 =?utf-8?B?Q0hsbE4wdFdtRXBFZElRNHR6S2VYdllpaG4zSUlNMmJmRXlRRGJDa2psSkNy?=
 =?utf-8?B?Tyt5Q0FDZENCZVJubDJ4QUk1WnlpY3JoK1JRa2FnWitIbytrTXlJOWhnTHl2?=
 =?utf-8?B?NHJURDJvdHg4RjZoZThkcVpVZWdoakhMVWRkVFRZK2ZVbWk1NG5RQitzc2dz?=
 =?utf-8?B?aDZ3ZDRSMTZLMnVVOFllQkE2Ujh0N09vOXdaUkJSWGJZN3RqbnlLdWNRclJB?=
 =?utf-8?B?elNDSUpNV0FwWmYxbjhsVm5zcTRIbUVYZ1JtdGtNSktOUW83K0JvUnRpcTY0?=
 =?utf-8?B?V1Bwb1NXYzBUUCtXQXNFQ1hMV1BQS2NtdFlWNTBYWWIyQXVVeWdWSGFvbG9C?=
 =?utf-8?B?MkJpM2psQWlHdGR0bHFVN3hveS9idW1sUjRDcERwenkxQUt1L0lTL25MODBZ?=
 =?utf-8?B?ZTdrTDJnbVA5Qk9VdDhOeFlJL0FLcXA0V0pQK1hVRWFod2JzODBVZVg2MDEx?=
 =?utf-8?B?bGNTYm9SQzE4bEVNMS92OHc2bVkydU5XcGpQbnMrRmVRK1RiREp1VTMzS1NU?=
 =?utf-8?B?RjJvSTFsNVo4bjBPZFV5STE3ZmNSTlRtVFlURjRCUnFOOGtjZTBhRHRrYXUv?=
 =?utf-8?B?TllQMnR0SjJ6UkFDNTlWNnhrLzVJOEhocmxkcC8wUHRLZUNMNTVxNVhvTjJ2?=
 =?utf-8?B?Q21Bdis2Q2hPMjBYS0NabXFDVWkwbk9GbXFMaXRsaEQ4bTAxdVRoa2F6c1B3?=
 =?utf-8?B?bThKaEcvai93NXp2ZkVGOVJQS1U4dk1IaXNjcmhpU0JJWUFjejlsT0E2MTk1?=
 =?utf-8?B?Z2ExZjJ3eCsyT2F3a3hxNHNHRDlNYUtVeTQvdVJYa0o2WlNiVWdPbkVyRHBI?=
 =?utf-8?B?TEZMNk9hNzZwN29EVEU3bjlNdlY4QUI3WC9KQ3oxcmVjcGxuT3U5WFRtZWVa?=
 =?utf-8?B?SDIvVDRFRWxtV2hrNngzQm9aUVhPK0ZYV2NkamRpWndsd05BUWJOWnBqOVUw?=
 =?utf-8?B?QnY3TngxdWZKeS8xU0lTMUd3dzlmRENjYXo5cktmb1JOT2VIUDA1TVdPSXNE?=
 =?utf-8?B?ZTdMYklEeUpKWHVHMkt3WDNiMHZPdDJQTDBWTlU4TVVaMEtXMC8rSjM0Ulhn?=
 =?utf-8?B?aFlabTRmNXlsbXVPRzJNdkRzNXhHS3pjdllDQ3pCM3ROTU0yNHpOdnJVNmRU?=
 =?utf-8?B?Y292b0tqU0ZlSzV3TFpKOVJiMkV2c1MwbDUwZGR1SHdMSUlNQTk1b0RRMDR3?=
 =?utf-8?B?VFl1Z0MxS1JtRThzNnlNSDZnZ2dubzlabm9xVTNxejdFVG1HQU1KRWZzR3dr?=
 =?utf-8?Q?Ll+Xgh?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R3pqejF0UlhOUkNpRHNCamtVcTgxdU5NNjgrNHZzLzRxc2p0SmJOeXZwU3NP?=
 =?utf-8?B?TDhvQ2djTExHWTY2TU01d0xnU3kzQXRMRmNpbGRmdGEzUWZEKzBXUG1QWWUy?=
 =?utf-8?B?bm5uejJlclZhdUNwaUtaeDBVWnJrRS9sNmpHbGdJQUxuUE44cUNkcXVaUUV2?=
 =?utf-8?B?OExVUEJDME9LK3lLTkdJL21icFVHSlYvcDNXdmpPcm1WdXd6aDFoUUk4VUJu?=
 =?utf-8?B?R3FGMktjc0lXZWgwZ2xWT2RHVXExSDFNemxOTUVic1BkWm5tSmZrd3FVNjNK?=
 =?utf-8?B?elNwTURoc2ZCQjdmNzRKdnM2d2N4OWdtYmhIdHVZS3ozaFYrdkhmM0w0NjF3?=
 =?utf-8?B?dFhiUmZNMXB3bFljcWxTZThhZTRuY0MvRU5ORC9ITVo1RnB0R25scFJNL1Zu?=
 =?utf-8?B?UEx3RlNGWU1TMUpCOTV6eTh0MXFycmlIK1Bua2l4WFFTeFBMSXFwTzRpczRZ?=
 =?utf-8?B?clF6TU5kNU5xS2ZIalNoZ1dwbjBDVW9ualJkYnE4Rys4V3AzNjFpY2laT1dK?=
 =?utf-8?B?YnlsVHM2NU4weGZzbFlNUk9kRnhQWWY1SUpNYStCa2NscnJIdzUxa2VtT3pU?=
 =?utf-8?B?NGtjNDdOMFJYMDJFb2YxNmdvTmgwbGljSDk2MVp0clpvMkZScWU0c25FM3Zp?=
 =?utf-8?B?eHpVRUIyZWEyemEza3FxNXNOL2JJK1lRNWM1TWhHcmcxVWx1ZWZRTGJuUitO?=
 =?utf-8?B?SVJMaFFNa3FnYUt5czdJZ2RrS3MzblRTc3hvRGxwQkNBQjhwZFFZNVhOWHNo?=
 =?utf-8?B?Si9MMDAxYVdaV3ZkNU9iYWpaY3NnNUFVdWgzNGJ6VHFBbURpVjJSYVMxejlh?=
 =?utf-8?B?dmpqQnRUcVFQcTh1RzBMN3R0NUo0bGhqaERkRXlDOHdKQ1VsQ0lzamRuMXIw?=
 =?utf-8?B?a3BnQ29PTmhFem9BUitXRnZ2amNnRWZpZkgrWHpaa010QlNsc2NBUDA1amhF?=
 =?utf-8?B?aitjdmNPeGd3TzgzT2x4NWVMYVlhUlV4TU90TnRBaGhzaHBpMklhdlYya0Rl?=
 =?utf-8?B?bGNmTEQ2dldySnBTbG1pNHhlUDQybnRzb2wvMkJqaXZORXNkV09MU0hsU3hQ?=
 =?utf-8?B?SjFnZlhvWnprUkdZNkhuWjRwRXNuKzBudFRKWDVMdUsvSm4vM2YxUTNVK1k5?=
 =?utf-8?B?aXcydTJMbzJVRkszaXUrVU9VaVFLS2J4YmthRlBmSzFKRnJxa2NFV1lGdlp0?=
 =?utf-8?B?QzZCL25NV1pkY2FNR2d3K0hDdDFHOEc2MUE1ZnVXRUE1c3VrQzdrcjU1bmx2?=
 =?utf-8?B?SEJVdGpPR0F5bitYc0NKVUVLekRCSlVsdkN5RUx6REViYTc2WlJzTjI2UmRK?=
 =?utf-8?B?YUR3YmJVYVloVzhHbStnRkJQc0RzMkxEUXIwUjd6R3FyVE9MTjBvaXZaQ3pa?=
 =?utf-8?B?Rmw5VVBVVnFBTnhCa0RwVUxHNEYyeTY3clZ1RWJuRUZFUFNxTllRaFBMVm1Y?=
 =?utf-8?B?QmZqVVlRY1h4NHlhZzJiSVhKU0QxSGRQS0Z1WmVsaVVsUU00a1d5clZQNzR3?=
 =?utf-8?B?bGFHcTUvZG9YaEtIUmdJaG5nWFRUUjBUNkw3bkVuT1ZmS0h1QmMvKzEyZGlT?=
 =?utf-8?B?d2JKUEltSjdOTWQrbTRvZUY4VHN1M0pWTG1ZdG5oOFU5a0cyMjY1dGYzNVZB?=
 =?utf-8?B?YWNrb3VLVWlCaGRUdkErUUU3ZW5HNnhTVzExZ09Rc2EvTHRUK1RxL3pnQnM5?=
 =?utf-8?B?Y3hnTnRWakhPNkxibUk2ZkU0UUltSzdDY1MzZ1RnQ2cyOUpsT2tSMHZMR0l3?=
 =?utf-8?B?VHMySGF4eW9YaTMrTFRUUFp1RFU1dXdqWXE0WjI4NGNTRS9oR3VqTDVKaWpW?=
 =?utf-8?B?M1pUQm5PQkJRb2NjYjF1NG5McWRwRUVsNmU5SG5hblluc1kzdG9wWlYxUkRI?=
 =?utf-8?B?NUIxY3haOWFVamFpT1lRTGVVeDVwRm80bE5aaHVRaW9LVStJZk1sMk1TYlJ2?=
 =?utf-8?B?NE5pb2ptWnRQTmdKMVVhM1BYVkQ4d254cmJPbFRuV1N0VzNHOC9xbE1wcW1X?=
 =?utf-8?B?akRET21MTHVub09lbGVYckMzcWF0MzY2VXhUcHlmTkRzLyt6bUpoSTJXOE1Y?=
 =?utf-8?B?dyt6TmR5YlNlZWxpcUs4NGxhK2FtUzNNYk9aTHdtZ1Vmb3JYenRyTkNRU3NW?=
 =?utf-8?B?ZHAxMHdwL1FUcjh1MmgrVHBkeUMvRVlocEVQQlRpUW5SZVZ5aHgxSEErbHNo?=
 =?utf-8?Q?JM7f+NvsNn7QTl9Uo9WC/mI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1B79E83DB697E40B68B497402C14AEF@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a98a0874-76f6-43f5-0284-08de16447afa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 17:07:30.9042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSRdTT4ia5adkGnnH6DqCCSrbO0Zmo9szY5UwLtbiJmk0noL1CdLHVmhchHvA3Ch1mCz5bFlrqtwKcleCIJJFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB6005
X-Authority-Analysis: v=2.4 cv=fIQ0HJae c=1 sm=1 tr=0 ts=6900f856 cx=c_pps
 a=ziZy7zD1dJq8wwEro8zYwA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=XlvuBuXmY-mi7aJuRnEA:9
 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: ZyG_pUOXs9pykP5jvLLoMW3C6nRc2nJ2
X-Proofpoint-GUID: _kEdg6lFaAA6BshWiryWAZeZqvz8Erz1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAyNCBTYWx0ZWRfXzmZdZvOQE57s
 zOsJPTWustDymWZZneU+9g5vqlOOhG14UTrGtqCt49R5r6o5Q/+MvPxztadONsYvTdnXU0pB2Ds
 pPyvkz8PCOSbHEjJWMrBGpDY2n3faaj8YH8f+iakTBwWmrQzk2mpddmx9o4v5Ab0XVKm23su0wg
 t7xyJKThtf4/7kotCQ2MP67Te4lW/O8tTO3QTaiewywvvu6bZFaBNLkramVPlzPv80rm89niKjW
 8sKafyFg6JEcbw/BfeO4ONhsnKgHWR6clO2jTEFJzJdXmHFemHFaenEP6w33VQ2BCjzbWvIqPDa
 1Vt+v0Y+RlFzw6Sv7BxZanLu7wtLqksRfoIhZlp7NCuFmWOAzqQTLDfc3KVpm5DIAqHI+Wudp1r
 CebUN6JwwMqxDNXJNwlsz8TSmL3AoA==
Subject: Re:  [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph
 consumer
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250024

T24gRnJpLCAyMDI1LTEwLTI0IGF0IDA4OjQyICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQoN
ClByb2JhYmx5LCBpdCBtYWtlIHNlbnNlIHRvIGNvbnNpZGVyIGl0IGFzIGEgdG9waWMgZm9yIExT
Ri9NTS9CUEYgY29uZmVyZW5jZS4NCkJlY2F1c2UsIGl0IGNvdWxkIGJlIG5vdCBlYXN5IHRvIGNv
bnZpbmNlIHBlb3BsZS4NCg0KQXMgZmFyIGFzIEkgY2FuIHNlZSwgZnJvbSBteSBwb2ludCBvZiB2
aWV3LCB0aGUgbW90aXZhdGlvbiBkb2Vzbid0IGNvbnRhaW4NCmVub3VnaCBleHBsYW5hdGlvbiBv
ZiBiZW5lZml0cywgYmVuY2htYXJraW5nIHJlc3VsdHMgYW5kIGNvbXBhcmlzb24gd2l0aCBhbHJl
YWR5DQpleGlzdGluZyBpbmZyYXN0cnVjdHVyZXMuIFRoZSBjbGVhciBleHBsYW5hdGlvbiBvZiB0
aGVzZSBwb2ludHMgY291bGQgYmUgYSBnb29kDQpzdGVwIHRvIGNvbnZpbmNlIHBlb3BsZSB0byB0
cnkgYW5kIHRvIGFkb3B0IHRoZSBuZXcgaW5mcmFzdHJ1Y3R1cmUuDQoNCj4gTW90aXZhdGlvbjog
aW1wcm92ZSBvYnNlcnZhYmlsaXR5IGluIHByb2R1Y3Rpb24gYnkgcHJvdmlkaW5nIHN1YnN5c3Rl
bXNhd2l0aCANCg0KInN1YnN5c3RlbXNhd2l0aCIgLT4gc3Vic3lzdGVtIHdpdGg/DQoNCj4gYSBs
b2dnZXIgdGhhdCBrZWVwcyB1cCB3aXRoIHRoZWlyIHZlcmJvdXNlIHVuc3RydWN0dXJlZCBsb2dz
IGFuZCBhZ2dyZWdhdGluZw0KPiBsb2dzIGF0IHRoZSBwcm9jZXNzIGNvbnRleHQgbGV2ZWwsIGFr
aW4gdG8gdXNlcnNwYWNlIFRMUy4gDQo+IA0KPiBCaW5hcnkgTE9HZ2luZyAoQkxPRykgaW50cm9k
dWNlcyBhIHRhc2stbG9jYWwgbG9nZ2luZyBjb250ZXh0OiBlYWNoIGNvbnRleHQNCj4gb3ducyBh
IHNpbmdsZSA1MTLigK9LaUIgZnJhZ21lbnQgdGhhdCBjeWNsZXMgdGhyb3VnaCDigJxyZWFkeSDi
hpIgaW4gdXNlIOKGkiBxdWV1ZWQgZm9yDQoNCldoeSBleGFjdGx5IDUxMuKAr0tpQj8gQ291bGQg
aXQgYmUgaW5jcmVhc2VkL2RlY3JlYXNlZD8gQW55IGF2YWlsYWJsZSBvcHRpbWl6YXRpb24NCnBh
cmFtZXRlcnMgb2YgaW5mcmFzdHJ1Y3R1cmU/DQoNCkNvdWxkIHRoZSBpbmZyYXN0cnVjdHVyZSAi
ZWF0IiB0aGUgd2hvbGUgbWVtb3J5IGlmIHdlIGhhdmUgYSBsb3QgdGFza3MvY29yZXM/IERvDQp3
ZSBoYXZlIGFueSBkYW5nZXIgb2YgaW50cm9kdWNpbmcgdGhlIHN5c3RlbSBjcmFzaGVzIGJlY2F1
c2Ugb2YgQkxPRyBzdWJzeXN0ZW0ncw0KbWVtb3J5IHJlcXVpcmVtZW50cz8NCg0KSSBhc3N1bWUg
dGhhdCBCTE9HJ3MgNTEyIEtpQiBmcmFnbWVudCB3b3JrcyBhcyBhIGNpcmN1bGFyIGJ1ZmZlci4g
QW0gSSByaWdodA0KaGVyZT8gU28sIGhvdyBsb25nIGNvdWxkIGJlIHRoZSByZWNvcmRlZCBoaXN0
b3J5IG9mIG9wZXJhdGlvbnM/IENvdWxkIG5ldw0KcmVjb3JkcyBvdmVyd3JpdGUgdGhlIGluZm9y
bWF0aW9uIHRoYXQgbmVlZHMgZm9yIHRoZSBpc3N1ZSBhbmFseXNpcz8NCg0KPiByZWFkZXJzIOKG
kiByZXNldCDihpIgcmVhZHnigJ0gd2l0aG91dCByZS1lbnRlcmluZyB0aGUgYWxsb2NhdG9yLiBX
cml0ZXJzIGNvcHkgdGhlDQo+IHJhdyBwYXJhbWV0ZXJzIHRoZXkgYWxyZWFkeSBoYXZlOyByZWFk
ZXJzIGZvcm1hdCB0aGVtIGxhdGVyIHdoZW4gdGhlIGxvZyBpcw0KPiBpbnNwZWN0ZWQuDQo+IA0K
PiBCTE9HIGJvcnJvd3MgaWRlYXMgZnJvbSBmdHJhY2UgKGNhcHR1cmVhYmluYXJ5ICBkYXRhIG5v
dywgZm9ybWF0IGxhdGVyKSBidXQgDQoNCiJjYXB0dXJlYWJpbmFyeSIgLT4gY2FwdHVyZSBhIGJp
bmFyeT8NCg0KPiB1bmxpa2UgZnRyYWNlIHRoZXJlIGlzIG5vIGdsb2JhbCByaW5nLiBFYWNoIG1v
ZHVsZSByZWdpc3RlcnMgaXRzIG93biBsb2dnZXIsDQo+IG1hbmFnZXMgaXRzIG93biBidWZmZXJz
LCBhbmQga2VlcHMgdGhlIHN0YXRlIHNtYWxsIGVub3VnaCBmb3IgcHJvZHVjdGlvbiB1c2UuDQo+
IA0KPiBUbyBob3N0IHRoZSBwZXItbW9kdWxlIHBvaW50ZXJzIHdlIGV4dGVuZCBgc3RydWN0IHRh
c2tfc3RydWN0YCB3aXRoIG9uZQ0KPiBhZGRpdGlvbmFsIGB2b2lkICpgLCBpbiBsaW5lIHdpdGgg
b3RoZXIgdGFzayBleHRlbnNpb25zIGFscmVhZHkgaW4gdGhlIGtlcm5lbC4NCj4gRWFjaCBtb2R1
bGUga2VlcHMgaW5kZXBlbmRlbnQgYmF0Y2hlczogYGFsbG9jX2JhdGNoYCBmb3IgY29udGV4dHMg
d2l0aA0KPiByZWZjb3VudCAwIGFuZCBgbG9nX2JhdGNoYCBmb3IgY29udGV4dHMgdGhhdCBoYXZl
IGJlZW4gZmlsbGVkIGFuZCBhcmUgd2FpdGluZw0KPiBmb3IgcmVhZGVycy4gVGhlIGJhdGNoaW5n
IGxheWVyIGFuZCBidWZmZXIgbWFuYWdlbWVudCB3ZXJlIG1pZ3JhdGVkIGZyb20gdGhlDQo+IGV4
aXN0aW5nIENlcGggU0FOIGxvZ2dpbmcgY29kZSwgc28gdGhlIGJlaGF2aW91ciBpcyBiYXR0bGUt
dGVzdGVkOyB3ZSBzaW1wbHkNCg0KSSBhbSBub3QgY29tcGxldGVseSBmb2xsb3dpbmcgd2hhdCBk
byB5b3UgbWVhbiBieSBDZXBoIFNBTiBsb2dnaW5nIGNvZGUuIE1heWJlLA0KaXQgbWFrZXMgdG8g
c2hhcmUgdGhlIGxpbmsgb24gaXQ/IA0KDQo+IG1hZGUgdGhlIGJ1ZmZlciBpbmxpbmUgc28gZXZl
cnkgY29tcG9zaXRlIHN0YXlzIHdpdGhpbiBhIHNpbmdsZSA1MTLigK9LaUINCj4gYWxsb2NhdGlv
bi4NCj4gDQo+IFRoZSBwYXRjaCBzZXJpZXMgbGFuZHMgdGhlIEJMT0cgbGlicmFyeSBmaXJzdCwg
dGhlbiB3aXJlcyB0aGUgdGFzayBsaWZlY3ljbGUsDQo+IGFuZCBmaW5hbGx5IHN3aXRjaGVzIENl
cGjigJlzIGBib3V0KmAgbG9nZ2luZyBtYWNyb3MgdG8gQkxPRyBzbyB3ZSBleGVyY2lzZSB0aGUN
Cg0KV2hhdCBkbyB5b3UgbWVhbiBieSBDZXBo4oCZcyBgYm91dCpgIGxvZ2dpbmcgbWFjcm9zPyBE
byB5b3UgbWVhbiAnZG91dConIGhlcmU/DQoNClRoYW5rcywNClNsYXZhLg0KDQo+IG5ldyBwYXRo
Lg0KPiANCj4gUGF0Y2ggc3VtbWFyeToNCj4gICAxLiBzY2hlZCwgZm9yazogd2lyZSBCTE9HIGNv
bnRleHRzIGludG8gdGFzayBsaWZlY3ljbGUNCj4gICAgICAtIEFkZHMgYHN0cnVjdCBibG9nX3Rs
c19jdHggKmJsb2dfY29udGV4dHNbQkxPR19NQVhfTU9EVUxFU11gIHRvDQo+ICAgICAgICBgc3Ry
dWN0IHRhc2tfc3RydWN0YC4NCj4gICAgICAtIEZvcmsvZXhpdCBwYXRocyBpbml0aWFsaXNlIGFu
ZCByZWN5Y2xlIGNvbnRleHRzIGF1dG9tYXRpY2FsbHkuDQo+IA0KPiAgIDIuIGxpYjogaW50cm9k
dWNlIEJMT0cgKEJpbmFyeSBMT0dnaW5nKSBzdWJzeXN0ZW0NCj4gICAgICAtIEFkZHMgYGxpYi9i
bG9nL2Agc291cmNlcyBhbmQgaGVhZGVycyB1bmRlciBgaW5jbHVkZS9saW51eC9ibG9nL2AuDQo+
ICAgICAgLSBFYWNoIGNvbXBvc2l0ZSAoYHN0cnVjdCBibG9nX3Rsc19wYWdlZnJhZ2ApIGNvbnNp
c3RzIG9mIHRoZSBUTFMNCj4gICAgICAgIG1ldGFkYXRhLCB0aGUgcGFnZWZyYWcgc3RhdGUsIGFu
ZCBhbiBpbmxpbmUgYnVmZmVyIHNpemVkIGF0DQo+ICAgICAgICBgQkxPR19QQUdFRlJBR19TSVpF
IC0gc2l6ZW9mKHN0cnVjdCBibG9nX3Rsc19wYWdlZnJhZylgLg0KPiANCj4gICAzLiBjZXBoOiBh
ZGQgQkxPRyBzY2FmZm9sZGluZw0KPiAgICAgIC0gSW50cm9kdWNlcyBgaW5jbHVkZS9saW51eC9j
ZXBoL2NlcGhfYmxvZy5oYCBhbmQgYGZzL2NlcGgvYmxvZ19jbGllbnQuY2AuDQo+ICAgICAgLSBD
ZXBoIHJlZ2lzdGVycyBhIGxvZ2dlciBhbmQgbWFpbnRhaW5zIGEgY2xpZW50LUlEIG1hcCBmb3Ig
dGhlIHJlYWRlcg0KPiAgICAgICAgY2FsbGJhY2suDQo+IA0KPiAgIDQuIGNlcGg6IGFkZCBCTE9H
IGRlYnVnZnMgc3VwcG9ydA0KPiAgICAgIC0gQWRkcyBgZnMvY2VwaC9ibG9nX2RlYnVnZnMuY2Ag
c28gZmlsbGVkIGNvbnRleHRzIGNhbiBiZSBkcmFpbmVkLg0KPiANCj4gICA1LiBjZXBoOiBhY3Rp
dmF0ZSBCTE9HIGxvZ2dpbmcNCj4gICAgICAtIFN3aXRjaGVzIGBib3V0KmAgbWFjcm9zIHRvIEJM
T0csIG1ha2luZyBDZXBoIHRoZSBmaXJzdCBjb25zdW1lci4NCj4gDQo+IFdpdGggdGhlc2UgcGF0
Y2hlcywgQ2VwaCBub3cgd3JpdGVzIGl0cyB2ZXJib3NlIGxvZ2dpbmcgdG8gdGFzay1sb2NhbCBi
dWZmZXJzDQo+IG1hbmFnZWQgYnkgQkxPRywgYW5kIHRoZSBpbmZyYXN0cnVjdHVyZSBpcyByZWFk
eSBmb3Igb3RoZXIgc3Vic3lzdGVtcyB0aGF0IG5lZWQNCj4gYWxsb2NhdGlvbi1mcmVlLCBtb2R1
bGUtb3duZWQgbG9nZ2luZy4NCj4gDQo+IEFsZXggTWFya3V6ZSAoNSk6DQo+ICAgc2NoZWQsIGZv
cms6IFdpcmUgQkxPRyBjb250ZXh0cyBpbnRvIHRhc2sgbGlmZWN5Y2xlDQo+ICAgbGliOiBJbnRy
b2R1Y2UgQkxPRyAoQmluYXJ5IExPR2dpbmcpIHN1YnN5c3RlbQ0KPiAgIGNlcGg6IEFkZCBCTE9H
IHNjYWZmb2xkaW5nDQo+ICAgY2VwaDogQWRkIEJMT0cgZGVidWdmcyBzdXBwb3J0DQo+ICAgY2Vw
aDogQWN0aXZhdGUgQkxPRyBsb2dnaW5nDQo+IA0KPiAgZnMvY2VwaC9NYWtlZmlsZSAgICAgICAg
ICAgICAgICAgICB8ICAgMiArDQo+ICBmcy9jZXBoL2FkZHIuYyAgICAgICAgICAgICAgICAgICAg
IHwgMTMwICsrLS0tDQo+ICBmcy9jZXBoL2Jsb2dfY2xpZW50LmMgICAgICAgICAgICAgIHwgMjQ0
ICsrKysrKysrKw0KPiAgZnMvY2VwaC9ibG9nX2RlYnVnZnMuYyAgICAgICAgICAgICB8IDM2MSAr
KysrKysrKysrKysrDQo+ICBmcy9jZXBoL2NhcHMuYyAgICAgICAgICAgICAgICAgICAgIHwgMjQy
ICsrKystLS0tLQ0KPiAgZnMvY2VwaC9jcnlwdG8uYyAgICAgICAgICAgICAgICAgICB8ICAxOCAr
LQ0KPiAgZnMvY2VwaC9kZWJ1Z2ZzLmMgICAgICAgICAgICAgICAgICB8ICAzMyArLQ0KPiAgZnMv
Y2VwaC9kaXIuYyAgICAgICAgICAgICAgICAgICAgICB8ICA4OCArKy0tDQo+ICBmcy9jZXBoL2V4
cG9ydC5jICAgICAgICAgICAgICAgICAgIHwgIDIwICstDQo+ICBmcy9jZXBoL2ZpbGUuYyAgICAg
ICAgICAgICAgICAgICAgIHwgMTMwICsrLS0tDQo+ICBmcy9jZXBoL2lub2RlLmMgICAgICAgICAg
ICAgICAgICAgIHwgMTgyICsrKy0tLS0NCj4gIGZzL2NlcGgvaW9jdGwuYyAgICAgICAgICAgICAg
ICAgICAgfCAgIDYgKy0NCj4gIGZzL2NlcGgvbG9ja3MuYyAgICAgICAgICAgICAgICAgICAgfCAg
MjIgKy0NCj4gIGZzL2NlcGgvbWRzX2NsaWVudC5jICAgICAgICAgICAgICAgfCAyNzggKysrKyst
LS0tLQ0KPiAgZnMvY2VwaC9tZHNtYXAuYyAgICAgICAgICAgICAgICAgICB8ICAgOCArLQ0KPiAg
ZnMvY2VwaC9xdW90YS5jICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQ0KPiAgZnMvY2VwaC9z
bmFwLmMgICAgICAgICAgICAgICAgICAgICB8ICA2NiArLS0NCj4gIGZzL2NlcGgvc3VwZXIuYyAg
ICAgICAgICAgICAgICAgICAgfCAgODIgKy0tDQo+ICBmcy9jZXBoL3hhdHRyLmMgICAgICAgICAg
ICAgICAgICAgIHwgIDQyICstDQo+ICBpbmNsdWRlL2xpbnV4L2Jsb2cvYmxvZy5oICAgICAgICAg
IHwgNTE1ICsrKysrKysrKysrKysrKysrKysNCj4gIGluY2x1ZGUvbGludXgvYmxvZy9ibG9nX2Jh
dGNoLmggICAgfCAgNTQgKysNCj4gIGluY2x1ZGUvbGludXgvYmxvZy9ibG9nX2Rlcy5oICAgICAg
fCAgNDYgKysNCj4gIGluY2x1ZGUvbGludXgvYmxvZy9ibG9nX21vZHVsZS5oICAgfCAzMjkgKysr
KysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L2Jsb2cvYmxvZ19wYWdlZnJhZy5oIHwgIDMzICsr
DQo+ICBpbmNsdWRlL2xpbnV4L2Jsb2cvYmxvZ19zZXIuaCAgICAgIHwgMjc1ICsrKysrKysrKysN
Cj4gIGluY2x1ZGUvbGludXgvY2VwaC9jZXBoX2Jsb2cuaCAgICAgfCAxMjQgKysrKysNCj4gIGlu
Y2x1ZGUvbGludXgvY2VwaC9jZXBoX2RlYnVnLmggICAgfCAgIDYgKy0NCj4gIGluY2x1ZGUvbGlu
dXgvc2NoZWQuaCAgICAgICAgICAgICAgfCAgIDcgKw0KPiAga2VybmVsL2ZvcmsuYyAgICAgICAg
ICAgICAgICAgICAgICB8ICAzNyArKw0KPiAgbGliL0tjb25maWcgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgMiArDQo+ICBsaWIvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgIHwgICAy
ICsNCj4gIGxpYi9ibG9nL0tjb25maWcgICAgICAgICAgICAgICAgICAgfCAgNTYgKysrDQo+ICBs
aWIvYmxvZy9NYWtlZmlsZSAgICAgICAgICAgICAgICAgIHwgIDE1ICsNCj4gIGxpYi9ibG9nL2Js
b2dfYmF0Y2guYyAgICAgICAgICAgICAgfCAzMTEgKysrKysrKysrKysrDQo+ICBsaWIvYmxvZy9i
bG9nX2NvcmUuYyAgICAgICAgICAgICAgIHwgNzcyICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4gIGxpYi9ibG9nL2Jsb2dfZGVzLmMgICAgICAgICAgICAgICAgfCAzODUgKysrKysrKysr
KysrKysNCj4gIGxpYi9ibG9nL2Jsb2dfbW9kdWxlLmMgICAgICAgICAgICAgfCA3ODEgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysNCj4gIGxpYi9ibG9nL2Jsb2dfcGFnZWZyYWcuYyAgICAg
ICAgICAgfCAxMjQgKysrKysNCj4gIDM4IGZpbGVzIGNoYW5nZWQsIDUxNjMgaW5zZXJ0aW9ucygr
KSwgNjY3IGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGZzL2NlcGgvYmxvZ19j
bGllbnQuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGZzL2NlcGgvYmxvZ19kZWJ1Z2ZzLmMNCj4g
IGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L2Jsb2cvYmxvZy5oDQo+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgaW5jbHVkZS9saW51eC9ibG9nL2Jsb2dfYmF0Y2guaA0KPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGluY2x1ZGUvbGludXgvYmxvZy9ibG9nX2Rlcy5oDQo+ICBjcmVhdGUgbW9kZSAx
MDA2NDQgaW5jbHVkZS9saW51eC9ibG9nL2Jsb2dfbW9kdWxlLmgNCj4gIGNyZWF0ZSBtb2RlIDEw
MDY0NCBpbmNsdWRlL2xpbnV4L2Jsb2cvYmxvZ19wYWdlZnJhZy5oDQo+ICBjcmVhdGUgbW9kZSAx
MDA2NDQgaW5jbHVkZS9saW51eC9ibG9nL2Jsb2dfc2VyLmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCBpbmNsdWRlL2xpbnV4L2NlcGgvY2VwaF9ibG9nLmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBs
aWIvYmxvZy9LY29uZmlnDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgbGliL2Jsb2cvTWFrZWZpbGUN
Cj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBsaWIvYmxvZy9ibG9nX2JhdGNoLmMNCj4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCBsaWIvYmxvZy9ibG9nX2NvcmUuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGxp
Yi9ibG9nL2Jsb2dfZGVzLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBsaWIvYmxvZy9ibG9nX21v
ZHVsZS5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgbGliL2Jsb2cvYmxvZ19wYWdlZnJhZy5jDQo=

