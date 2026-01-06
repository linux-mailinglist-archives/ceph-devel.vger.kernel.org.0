Return-Path: <ceph-devel+bounces-4271-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B137CFB4A3
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 23:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C3A9303F369
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 22:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE162E1C6B;
	Tue,  6 Jan 2026 22:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Mgf8v8IO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0713D280033;
	Tue,  6 Jan 2026 22:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767739658; cv=fail; b=aFFlpQN4VRCva2O77np2WzaWr5Cn1ZzriUq28TBELyrx9PMUHBwqpl/kUR9JSQXyLbCcDJNYQVq0rtLxgl3Jh+cIjY4uuXs/heDtYi028n7vKm7eO+WhPQMm8u1QnapoUHAHOYgndxdwuK+n3mgNuKKeW/CurGswsOHWu74VkGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767739658; c=relaxed/simple;
	bh=7fDi4IelGTFLXfCs4br1S7+FxsZmx4i0U9AMttDuFtA=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=cIbtfrDFbNl1c8X4JPXFbvI37dK53trlNeICInvDttSZ+hudlInXWxzDH6YY6uOdRyQ42noZpaLxyLt/u/fln5dzlXmo9L2rMOHniqGWK3NwGFUl2R+6NjQMB1P1heCiPqknH2Qv1/ucOxUxZ6rvKp7+yN1F+eXlj8fZHHpWRjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Mgf8v8IO; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 606IFlSb013183;
	Tue, 6 Jan 2026 22:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=7fDi4IelGTFLXfCs4br1S7+FxsZmx4i0U9AMttDuFtA=; b=Mgf8v8IO
	kuh999j0fT/Qd8A882TVDl7YMyk9AfJ47mwo9vYc2HSdBgR8tu2h8fkZBEwl32cG
	Zz798C4C/2rHfYUsJ7XiETlJStOkGbkBRBgXA6vbLNwr0seJBAZ0Jm5QUH+UZ9Tc
	D3u4Lv7SCzE5SLaZ0sj78TTlyyu1GYr/7XMRqFYQ3bz+hIHkFfyZpMFHQdxrEWa5
	d25WlembOGhtrhP1IOsTqi14F781M3Fhz9tyun3ix/jyZAtcWAv+i/c5L28qD5sU
	0CqGdn7mJiLB0NeIUdPRWhqH8kH7cC2B3p4SbX2MMyZKQk0TU6iMXSRy7qgFcPov
	xdWVYC6OS0l9Lg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu6656v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 22:47:31 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 606MjFwP029849;
	Tue, 6 Jan 2026 22:47:30 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu6656u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 22:47:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TB3F2RpZbEb242kSK/0ncJKn6/Y2Rfb5QbnP5B8LAv02GF0gpN7PLwVgmFM3I8TuujPCJBZMIrNQ/1s4SveFUTc830/0m/NrXCMS4GOWjodxKp5gWyxdgFTsZDBibImrzDZepxIyG9fZ/7ZCtQGLkifTd2YPOL7QrV0I1ibrPOGYu+TAJqLBREIcWuo9tfOkDo8CfsbHokPjFr6Q7QsmBSkTxRnTV0YajDIkcytEvY/AaMY9c2Ki27siXfsocUdJbCvQ+1HKRime8ProARm+Z6+KHXL36Cso14MH6gLmhEXxJT08xrpVtqC81OlqC31Y/YzaySRXXTt4SYo0nH2UCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fDi4IelGTFLXfCs4br1S7+FxsZmx4i0U9AMttDuFtA=;
 b=OaxbcHyUBwuwvd3yI7EKFr2vG9F+Y6bUxjZUi9BgktRhC/8Ue4qs8lzG1RDfRlpoIVWmK2Iu/32IwYwqpvYM/m4JmoULQLPiJoDo3K9mpUP7k2Mk8xeuX8ZAHIGuh6wtKHy0/x+KEzOL7knkmnk78nuDBuhl29Qd87k1eumAeCCZ+2YRH9ECyxdj9BpBOBsZvMV5etqw6pDemR+ON/qrpRy5sNr1CgodQ9D+V9txvXYr9rQsXljnE933CwriatMjcnYYGM4R5V5Tbr52s4MR3Iw5SVcrNOD0gqppxkdth7Pg7uZW8DnD02TYs1ObcRU4dRL1FUseYtfR/mH8Kq0ykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MN6PR15MB6341.namprd15.prod.outlook.com (2603:10b6:208:47e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 22:47:28 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 22:47:28 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "brauner@kernel.org"
	<brauner@kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH 2/5] ceph: Remove error return from
 ceph_process_folio_batch()
Thread-Index: AQHcftkKFvKZgmbhYkqmcheUzaGSJ7VFvyqA
Date: Tue, 6 Jan 2026 22:47:28 +0000
Message-ID: <d680c81d5f48e02a1282cc029aacdb7e093d2d5c.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-3-CFSworks@gmail.com>
	 <fe859743904a2add8d7d67f64ab9686769670782.camel@ibm.com>
	 <CAH5Ym4jnsYNp7Y5icBtQJZvX_JW=nvprj61ZH1XDX3Js0ePggA@mail.gmail.com>
In-Reply-To:
 <CAH5Ym4jnsYNp7Y5icBtQJZvX_JW=nvprj61ZH1XDX3Js0ePggA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MN6PR15MB6341:EE_
x-ms-office365-filtering-correlation-id: d0df8657-6737-4557-1af7-08de4d759188
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q1QxWVZ1bUlobHZDVzZsWG5hMTBHQzNPem9NTWFiaE05UmhLVDZjTXJjeFlR?=
 =?utf-8?B?SW50elYwRURiM0tuMUNpVzA5eXUrOTVUaWtwQ0V0QzNYU2hvWkxhL3p3alhH?=
 =?utf-8?B?QkJBT0VMMHdGZnFlY1o2QytaRlFHQ2xjWkEwZ1dXa3FLWUw3M2hBZ3h5bllC?=
 =?utf-8?B?NnNPSTdKcWhSem1xMzJlQ2wzMmVnZDI2ejNKT2o3NUZIam1tdXUxUXl4enNo?=
 =?utf-8?B?UTRDa0g3Z2kvNkdDS3ZxY1pmZHcwdmY3aFJCK2hhdGVCYWg5c3FId3ExQ0hT?=
 =?utf-8?B?OU13WWQraS9tcjNHeXN6UEk0SDl3YnVzUXpEcUtiQ0ZxdWhDalp5UmNDNXZz?=
 =?utf-8?B?SlQ4UzhzMm9lQnJqcUl1eHIwSk1HckdiYUxYN3E1aFgvY2hzb0VpclhiYnpD?=
 =?utf-8?B?ZERkTkZIQS9PNFUySzVXUW8zbjVwbFVPZ2wzZ2h2a0RuY1QzL05aUVFPUUkw?=
 =?utf-8?B?bHUxOC9wTkdwaVRreFFzb2dBdG1lTzkyOWlyZFhydUcwdlIvQWZmTU4wUDFH?=
 =?utf-8?B?L01VTkdoSFhnbUhDZXhMeDYzSFAvMUg0U0JtbVVhS2lOY2IxRS8zR3k1MVBN?=
 =?utf-8?B?eVc0VWVISC9rTVo3bktRYTZFelVxRDl2Y3gzTDBXWnRjTkg1bEo3MEdsOSsr?=
 =?utf-8?B?NzJDYk9oejF4aEJGdHhwVW1uTGRwRzNIRTFJUnFUT3lnTmJ1cmhCZnVrVzRX?=
 =?utf-8?B?aUY0dXJZMFVpVE05aVBVc3JBdnlhS3JNZmVvUk5zSGYrR0R3Zk12bUpoOXZO?=
 =?utf-8?B?dzEzaCtPL3JWNCtLUFlxbmtNZ25TNmt1L1ZvTDhPUkkvSmpHa2xwanhjZlph?=
 =?utf-8?B?NEEwYUROellNU3pRUEtzM1ZFVk1DUDZxL3Z0bGg1bkF4VHpnRnd5QkcwN0tv?=
 =?utf-8?B?N0RPT2ZpZkhKRHBMeGQ4U29JQ1RFSlpxV0Nxc005UmlpTWhpNmxaV2h2U2dC?=
 =?utf-8?B?MlQza1I5SzFCUnA2Ty9CWXo2RU9KRUVLYmNEMTZBRXdidGZhb2VhQTZRU3Jv?=
 =?utf-8?B?bkl3cWpYWWtoUm1PZVB5eC93am9OTjE5WE9XN29tZXp3alJHQmFMaUFtWFE1?=
 =?utf-8?B?dW1JREdzNEYwcXRBYTh3WFYwMFZlZDVXTWlnWHRSQWc5aklrUjJ0ekFyaUR1?=
 =?utf-8?B?bE1CSHlleElpbGVRTFhnWHluU1NYS3JoZXd0Rlg2c0h2NEpzcGg3UjN6eTNr?=
 =?utf-8?B?UnA2YWRlYkFXMjJOZmtqT1JjbEh2eUdmUmVjUlEvSmVHTFEvS1ZvaHI4blZi?=
 =?utf-8?B?RzdvbjlROHBoMFlRbVd1bkc0Z25aV3ZPRzVCQ2wrd2FSbEpjN0FrZWh4N0ZQ?=
 =?utf-8?B?SnVobFMrV0FaQXlxdVlmUkZ5d1ZVRVhZSGZoWmdKRkVMc1lCdm50RG5xV1ZH?=
 =?utf-8?B?cWZtNFZTdDlDRGMxVkxYNzBxa3NPRXRMWWFQbkZwQVljakU1WjVxYmF5OUV3?=
 =?utf-8?B?dG8ySUwvNGJTZjNadk5YQWdGZktkdDZKVm1aSnJWbHB0R2d6TEFXTjNPQVJK?=
 =?utf-8?B?clR6bjVqKzFoTjJTclh6U1JyZ1NVdzFtaTh6OVEzUVRLZW9XcHR1QWZ0Uzhk?=
 =?utf-8?B?aDBHd0kwN290amV1ZEtDai9IK3l4bnRSQjhLa1N6UmdtWDhIOElVdFE3N216?=
 =?utf-8?B?RXEzMG1td3R6MWg4bm1CZGZlVXJXcTBKc2lVS0R0bVA3R3Y0QllWUUlISTNl?=
 =?utf-8?B?YlBEc1hzYUljOWszS1ZkOFlPTHpMRml0cVRGVFVNS1BSL0Q0MlBEeFlqTkJH?=
 =?utf-8?B?Smpwd0pMVnNINW5tVGJPZDFrT1BXZWtCM0d4SHl2Wi9xTWQwZG95MkcwT05k?=
 =?utf-8?B?c0ltTG1XSitLZVU5bDN1UUZaWW52ZU1uUmlndEdMdjN2NEVyRHpFVnBEUERn?=
 =?utf-8?B?d3F4MWpRdzNyQXY3cENSSXFXTmJZLyszWVpJUzMyazd6N3JyVGVNNk9CTTBi?=
 =?utf-8?B?MG94R3JBaUUzV1VVWkF6OFhNSjdoUThMRDdPWllwNnd3OFNIcmYwTUg5cEox?=
 =?utf-8?B?WTRMQ2I1a0ZNV3dQTDZaWjBEVTdic0gxenY0ME5HdVJrZ2xkY25qSE9YNTJ1?=
 =?utf-8?Q?mcFmB8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ajF3SWY3UG8wc1lMYVc1ZU9jTlpQWFJKbXhTRmlzcitkODhEZjNEZmcvRndV?=
 =?utf-8?B?Sko4TnRFRlVCd0FSbWdBeFQ2cWxjTVRFTHN5L0FpVkJrZnh6SVZHYkpZUHp5?=
 =?utf-8?B?SVUxN1k3OHdyLzRkWEdsWk5EVTdOY0RwNjFlTnkxQUxyWi9FOUdBZjAyNFRM?=
 =?utf-8?B?aDNVaU5pQUpNYllnTGZQYks1MTlDQnVkcXZUdWJWV3JMNEVpQWU1MzJDUGVV?=
 =?utf-8?B?SEJ0R2NMeVM1dFVDVWoyNTBZR3REVnF3VnJ5bllIajFmQ29GRFU1eHJBWlQ2?=
 =?utf-8?B?SDNJRk8zdVBmK0NLQ2RMZnVXSFlHUFJPYzlsd2NrRVBKRGNJa3lkMkdMUFIx?=
 =?utf-8?B?dm9LWE52ODVPWHA2em9NMWVYRXdQTHFqKzhQRHdrVlVOempTZDVNQzVYNW5Y?=
 =?utf-8?B?QW5yTDg0aXF5YStvbmtKZkhpdTZnQmFqYlV4UEFrd1dkdmEwRk5sZjhNaFVj?=
 =?utf-8?B?SXRINVFWMmNSUGdWQXhyRGhlWkovVHl4UTJIT0htM29ENm01eExVMmZmelN4?=
 =?utf-8?B?QmkycHJmK0VnanhHSzdmSkx4SUpDTG5RUnhtM3o0VmprelZHZFBDY3NrTU00?=
 =?utf-8?B?d2ZSMEF2NzVyMExSeDlyZHdNcXFWajRnVXVpeHFFeEVJSkI0WnRrVDlKNEpN?=
 =?utf-8?B?Z3ZjMnc1Y3lTMk9DVEswYUVEUDhvQkFTYi8wNDQrWEt1WFNjczNvWWRKTmU4?=
 =?utf-8?B?VHJ2U29CRlp2TGFrSndXQVRSM1cxMG5KbkxQaDQxRjRiZ2dsUGhoalhhZDhr?=
 =?utf-8?B?ZnRLVERHeDdKV3MvdGFibGRsUG52bDNmQnZLbEdrU1ZVNHprMmM0SHVUNkFw?=
 =?utf-8?B?RFBHL0Q1RDRrR29GbXJ0d2hwSXlsVjJkMGxLTDUwckpFdVIrSUlDMHlEZ2tI?=
 =?utf-8?B?Q3hJVzBtNmpQYnhnUWNTTnFCWnhXNEpTTkZXYkg4bVNVSlZLR2dDV0N0UTV0?=
 =?utf-8?B?R2hCNlkyMSt5a3dPNjk4d1F4OEJOVUdEMTZFdDJrVTRDSTljczhzK1FFbU16?=
 =?utf-8?B?cWVGK2ozRWRNVERyT0lCYTc2d2ZaNUJYc0RvUmRCWEt3Mk1PV2UwaGZvaHFV?=
 =?utf-8?B?YTkrVkppbVZqcFI3bjA1NGJlby9lN3VxaVZOQWVBVVVxZzVTMElFeHBid2Ex?=
 =?utf-8?B?dyswN3NBSmpDZWtyVGZLWEpOUGdoWWl1cGk5bE5lYU5OcjhGL1hnYmdkRnhL?=
 =?utf-8?B?OHZCUE4rbFhZbk53eUxGV3RlRXVseWszcEZqdHBwdTBZTkJSaW9SbU9VVW0v?=
 =?utf-8?B?eEZaelN1ZVVvSzAwM2U4QmpsdndmTDUzQzZpVExodDBwRS9rMkhrR0JIZGxm?=
 =?utf-8?B?Q3B2Tys3ZjBZZVc1b2JhM3dIMjRudG9RdE0vTStOVEw4ckFKNmdVZHA4aHAr?=
 =?utf-8?B?d0pXNHdobU4xK21iNkd0a3pETXM0YTFDVUkyeHVXNW5jbXpjamE3Z2hXWTdv?=
 =?utf-8?B?eVJGdHVRcjNpQjhNL2w1UjlUR3dFREZNcElrZHI3VHg4eDEzbjArTVA0NllN?=
 =?utf-8?B?VkpDeWRUdEx0Z2xaRStmK3dTL1FhNVduZm5jUjFVQ2FFTmd2NjBIUC9DdmRu?=
 =?utf-8?B?Nk1GeFhLOXN0dENRdDdra1BIMzJVTVYzRXZTVzBPdDBTVG81UXVBZGFBdC85?=
 =?utf-8?B?Z1VLd3R2MjZSaWpqb1NtZW55WHIrTUsxaXFnNk5HRUd1dW5vZ083cnEvaDlW?=
 =?utf-8?B?anF2a2NjWXhVL1dQZjRKVjIzMGhsNVhDSVN0OUQvaDNEb1ZnOE1WNjVqejVt?=
 =?utf-8?B?a2crbk4wMXZkclhoT2Vua0pvL0NvTzlMQ2RUaTBDRmlCdkxJUTl6bDZkUTdM?=
 =?utf-8?B?NlcrdEZla09yVzRKbHY5K3M3eHVocW1YYkR2SXJKS0pqeUdkbHZkV1pGZXZM?=
 =?utf-8?B?L1ZndndkYzBIY2hyL1pDbEtEN2pjRmhPMUF1Q21iN3BrdFZEM2E3bVRsMGU0?=
 =?utf-8?B?YURmWDFZQ2tZekg0YTlSSTRvZjdRd1VpYVE2MDU1L0NVU0ovMmdHZlRGR1NK?=
 =?utf-8?B?ZmFFNEhoSFBGS0taL1FMbllnY0tSaUFvMTVYeTFFRHB3d25qRTRGelZudENV?=
 =?utf-8?B?TVNUTEUzKzlaNDU4eE1MQjBuaUUwVmZzc2ZxU1V2VUl0bENpZzc2T3RMOXJN?=
 =?utf-8?B?SXdLMkZrREdqZjd5bEF3TFBNcGY1M2RSYStDNnpFNk9XbWl0MGRydjUyVzVU?=
 =?utf-8?B?YnVRSGpsTnhudTJ3QStCSkJrb0JOQ3JWK1dKdUc1QTlyZjM5b0FYbzA3OStx?=
 =?utf-8?B?cXJEMDFBN3dON0tWSmFkdDZuT2k3cDhVWXUrY0xYekZOR0s3UkZmL2hLSHBB?=
 =?utf-8?B?aTBEbjJ6aTN4SFpnZlFWdlRXd3l4bXFNaDA0MDM3QXdpVW02dU1GZXgydFJM?=
 =?utf-8?Q?aQOkjR9rmqwjI8gU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16D669882596B44A88EBFC87A7A8B58E@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d0df8657-6737-4557-1af7-08de4d759188
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 22:47:28.1235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 94r8G70aYmnEAepstzTIPBf0cz1AW63vJkAzu/wnkZeIlpTxzc8C4IxyXoF7saempEBY0gvcE2vmI0IIjSZ1og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6341
X-Authority-Analysis: v=2.4 cv=QbNrf8bv c=1 sm=1 tr=0 ts=695d9103 cx=c_pps
 a=O2ROGSCZJc1UeeGV/dUHAw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=2WAN3aMRuqXLn6KeFsQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: faNuqAYHDnMxeNrwCMK28hb7BHRHcX-i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE5NyBTYWx0ZWRfX2l5BhkbR0Jo3
 ricb/iKI1/nK3mr7NLOOA+iBVFY/xD8LenFoiQaAh0+caAYsFE6gDpCGrUCqN49fbS2j96pPRGl
 GuC2cBlBkFDqLpNjJTdV0z6soBlUZfxfoQzfsm5Xv4+hOwwImo6zXVsioXcI62AD/c/XAU6P8MZ
 hoZTx51zYkMDqe9Rd2qi1DC+EoQuNG1KM9siyhzQYQQgs52dOyG3bEKh9nINmIhSrGadgl5JWiR
 PNeOLh9YTNTIzEotAb2csLPpnnKPsggm1qfbRGBncB8NUlU3uCHDGyj60VIwfRjQ6PdrpUos04i
 nyWQUyRpz7lWjWUFMr54iI7SjqSBsgzjZuT+PQEKvjNnuggqeJB9nSb/A+fHbP3KeoZn36vLrex
 aLqwtk4QEvUspWn29QePRu/2pa6LWnoBWTxA5IhyYWHRNdOdlS/mMxn42ko5jbiwuamLeIxXqGn
 +PUmKi0DauuSes3PtoQ==
X-Proofpoint-GUID: TScnpaO0gvlnGuiRS5z0PAp7Ym3BWm3a
Subject: RE: [PATCH 2/5] ceph: Remove error return from
 ceph_process_folio_batch()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_02,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601060197

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDIyOjUyIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
T24gTW9uLCBKYW4gNSwgMjAyNiBhdCAxMjozNuKAr1BNIFZpYWNoZXNsYXYgRHViZXlrbw0KPiA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUdWUsIDIwMjUtMTIt
MzAgYXQgMTg6NDMgLTA4MDAsIFNhbSBFZHdhcmRzIHdyb3RlOg0KPiA+ID4gRm9sbG93aW5nIHRo
ZSBwcmV2aW91cyBwYXRjaCwgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgbm8gbG9uZ2VyDQo+
ID4gPiByZXR1cm5zIGVycm9ycyBiZWNhdXNlIHRoZSB3cml0ZWJhY2sgbG9vcCBjYW5ub3QgaGFu
ZGxlIHRoZW0uDQo+ID4gDQo+IA0KPiBIaSBTbGF2YSwNCj4gDQo+ID4gSSBhbSBub3QgY29tcGxl
dGVseSBjb252aW5jZWQgdGhhdCB3ZSBjYW4gcmVtb3ZlIHJldHVybmluZyBlcnJvciBjb2RlIGhl
cmUuIFdoYXQNCj4gPiBpZiB3ZSBkb24ndCBwcm9jZXNzIGFueSBmb2xpbyBpbiBjZXBoX3Byb2Nl
c3NfZm9saW9fYmF0Y2goKSwgdGhlbiB3ZSBjYW5ub3QgY2FsbA0KPiA+IHRoZSBjZXBoX3N1Ym1p
dF93cml0ZSgpLiBJdCBzb3VuZHMgdG8gbWUgdGhhdCB3ZSBuZWVkIHRvIGhhdmUgZXJyb3IgY29k
ZSB0byBqdW1wDQo+ID4gdG8gcmVsZWFzZV9mb2xpb3MgaW4gc3VjaCBjYXNlLg0KPiANCj4gVGhp
cyBnb3RvIGlzIGFscmVhZHkgcHJlc2VudCAoc2VhcmNoIHRoZSBjb21tZW50ICJkaWQgd2UgZ2V0
IGFueXRoaW5nPyIpLg0KPiANCj4gPiANCj4gPiA+IA0KPiA+ID4gU2luY2UgdGhpcyBmdW5jdGlv
biBhbHJlYWR5IGluZGljYXRlcyBmYWlsdXJlIHRvIGxvY2sgYW55IHBhZ2VzIGJ5DQo+ID4gPiBs
ZWF2aW5nIGBjZXBoX3diYy5sb2NrZWRfcGFnZXMgPT0gMGAsIGFuZCB0aGUgd3JpdGViYWNrIGxv
b3AgaGFzIG5vIHdheQ0KPiA+IA0KPiA+IEZyYW5rbHkgc3BlYWtpbmcsIEkgZG9uJ3QgcXVpdGUg
Zm9sbG93IHdoYXQgZG8geW91IG1lYW4gYnkgInRoaXMgZnVuY3Rpb24NCj4gPiBhbHJlYWR5IGlu
ZGljYXRlcyBmYWlsdXJlIHRvIGxvY2sgYW55IHBhZ2VzIi4gV2hhdCBkbyB5b3UgbWVhbiBoZXJl
Pw0KPiANCj4gSSBmZWVsIGxpa2UgdGhlcmUncyBhIGxhbmd1YWdlIGJhcnJpZXIgaGVyZS4gSSB1
bmRlcnN0YW5kIGZyb20geW91cg0KPiBob21lcGFnZSB0aGF0IHlvdSBzcGVhayBSdXNzaWFuLiBJ
IGJlbGlldmUgdGhlIFJ1c3NpYW4gdHJhbnNsYXRpb24gb2YNCj4gd2hhdCBJJ20gdHJ5aW5nIHRv
IHNheSBpczoNCj4gDQo+INCt0YLQsCDRhNGD0L3QutGG0LjRjyDRg9C20LUg0YHQuNCz0L3QsNC7
0LjQt9C40YDRg9C10YIg0L4g0YLQvtC8LCDRh9GC0L4g0L3QuCDQvtC00L3QsCDRgdGC0YDQsNC9
0LjRhtCwINC90LUg0LHRi9C70LANCj4g0LfQsNCx0LvQvtC60LjRgNC+0LLQsNC90LAsINC/0L7R
gdC60L7Qu9GM0LrRgyBjZXBoX3diYy5sb2NrZWRfcGFnZXMg0L7RgdGC0LDRkdGC0YHRjyDRgNCw
0LLQvdGL0LwgMC4NCg0KSXQgaGF2ZW4ndCBtYWRlIHlvdXIgc3RhdGVtZW50IG1vcmUgY2xlYXIu
IDopDQoNCkFzIGZhciBhcyBJIGNhbiBzZWUsIHRoaXMgc3RhdGVtZW50IGhhcyBubyBjb25uZWN0
aW9uIHRvIHRoZSBwYXRjaCAyLiBJdCBpcyBtb3JlDQpyZWxldmFudCB0byB0aGUgcGF0Y2ggMy4N
Cg0KPiANCj4gSXQncyBsaWtlbHkgdGhhdCBJIGRpZG4ndCBwaHJhc2UgdGhlIEVuZ2xpc2ggdmVy
c2lvbiBjbGVhcmx5IGVub3VnaC4NCj4gRG8geW91IGhhdmUgYSBjbGVhcmVyIHBocmFzaW5nIEkg
Y291bGQgdXNlPyBUaGlzIGlzIHRoZSBjZW50cmFsIHBvaW50DQo+IG9mIHRoaXMgcGF0Y2gsIHNv
IGl0J3MgY3J1Y2lhbCB0aGF0IGl0J3Mgd2VsbC11bmRlcnN0b29kLg0KPiANCj4gPiANCj4gPiA+
IHRvIGhhbmRsZSBhYmFuZG9ubWVudCBvZiBhIGxvY2tlZCBiYXRjaCwgY2hhbmdlIHRoZSByZXR1
cm4gdHlwZSBvZg0KPiA+ID4gY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgdG8gYHZvaWRgIGFu
ZCByZW1vdmUgdGhlIHBhdGhvbG9naWNhbCBnb3RvIGluDQo+ID4gPiB0aGUgd3JpdGViYWNrIGxv
b3AuIFRoZSBsYWNrIG9mIGEgcmV0dXJuIGNvZGUgZW1waGFzaXplcyB0aGF0DQo+ID4gPiBjZXBo
X3Byb2Nlc3NfZm9saW9fYmF0Y2goKSBpcyBkZXNpZ25lZCB0byBiZSBhYm9ydC1mcmVlOiB0aGF0
IGlzLCBvbmNlDQo+ID4gPiBpdCBjb21taXRzIGEgZm9saW8gZm9yIHdyaXRlYmFjaywgaXQgd2ls
bCBub3QgbGF0ZXIgYWJhbmRvbiBpdCBvcg0KPiA+ID4gcHJvcGFnYXRlIGFuIGVycm9yIGZvciB0
aGF0IGZvbGlvLg0KPiA+IA0KPiA+IEkgdGhpbmsgeW91IG5lZWQgdG8gZXhwbGFpbiB5b3VyIHBv
aW50IG1vcmUgY2xlYXIuIEN1cnJlbnRseSwgSSBhbSBub3QgY29udmluY2VkDQo+ID4gdGhhdCB0
aGlzIG1vZGlmaWNhdGlvbiBtYWtlcyBzZW5zZS4NCj4gDQo+IEFDSzsgYSBnb29kIGNvbW1pdCBt
ZXNzYWdlIG5lZWRzIHRvIGJlIGNsZWFyIHRvIGV2ZXJ5b25lLiBJJ20gbm90IHN1cmUNCj4gd2hl
cmUgSSB3ZW50IHdyb25nIGluIG15IHdvcmRpbmcsIGJ1dCBJJ2xsIHRyeSB0byByZXN0YXRlIG15
IHRob3VnaHQNCj4gcHJvY2Vzczsgc28gbWF5YmUgeW91IGNhbiB0ZWxsIG1lIHdoZXJlIEkgbG9z
ZSB5b3U6DQo+IDEpIEF0IHRoaXMgcG9pbnQgaW4gdGhlIHNlcmllcyAoYWZ0ZXIgcGF0Y2ggMSBp
cyBhcHBsaWVkKSwgdGhlcmUgaXMgbm8NCj4gcmVtYWluaW5nIHBvc3NpYmxlIHdheSBmb3IgY2Vw
aF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgdG8gcmV0dXJuIGENCj4gbm9uemVybyB2YWx1ZS4gQWxs
IHBvc3NpYmxlIGNvZGVwYXRocyByZXN1bHQgaW4gcmM9MC4NCg0KSSBhbSBzdGlsbCBub3QgY29u
dmluY2VkIHRoYXQgcGF0Y2ggMSBpcyBjb3JyZWN0LiBTbywgd2Ugc2hvdWxkIGV4cGVjdCB0bw0K
cmVjZWl2ZSBlcnJvciBjb2RlIGZyb20gbW92ZV9kaXJ0eV9mb2xpb19pbl9wYWdlX2FycmF5KCks
IGVzcGVjaWFsbHkgZm9yIHRoZQ0KY2FzZSBpZiBubyBvbmUgZm9saW8gaGFzIGJlZW4gcHJvY2Vz
c2VkLiBBbmQgaWYgbm8gb25lIGZvbGlvIGhhcyBiZWVuIHByb2Nlc3NlZCwNCnRoZW4gd2UgbmVl
ZCB0byByZXR1cm4gZXJyb3IgY29kZS4NCg0KVGhlIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaCgp
IGlzIGNvbXBsZXggZnVuY3Rpb24gYW5kIHdlIG5lZWQgdG8gaGF2ZSB0aGUgd2F5DQp0byByZXR1
cm4gdGhlIGVycm9yIGNvZGUgZnJvbSBpbnRlcm5hbCBmdW5jdGlvbidzIGxvZ2ljIHRvIHRoZSBj
YWxsZXIncyBsb2dpYy4NCldlIGNhbm5vdCBhZmZvcmQgbm90IHRvIGhhdmUgdGhlIHJldHVybiBl
cnJvciBjb2RlIGZyb20gdGhpcyBmdW5jdGlvbi4gQmVjYXVzZQ0Kd2UgbmVlZCB0byBiZSByZWFk
eSB0byByZWxlYXNlIHVucHJvY2Vzc2VkIGZvbGlvcyBpZiBzb21ldGhpbmcgd2FzIHdyb25nIGlu
IHRoZQ0KZnVuY3Rpb24ncyBsb2dpYy4NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gMikgVGhlcmVm
b3JlLCB0aGUgYGlmYCBzdGF0ZW1lbnQgdGhhdCBjaGVja3MgdGhlDQo+IGNlcGhfcHJvY2Vzc19m
b2xpb19iYXRjaCgpIHJldHVybiBjb2RlIGlzIGRlYWQgY29kZS4NCj4gMykgVHJ5aW5nIHRvIGBn
b3RvIHJlbGVhc2VfZm9saW9zYCB3aGVuIHRoZSBwYWdlIGFycmF5IGlzIGFjdGl2ZQ0KPiBjb25z
dGl0dXRlcyBhIGJ1Zy4gU28gdGhlIGBpZiAoIWNlcGhfd2JjLmxvY2tlZF9wYWdlcykgZ290bw0K
PiByZWxlYXNlX2ZvbGlvcztgIGNvbmRpdGlvbiBpcyBjb3JyZWN0LCBidXQgdGhlIGBpZiAocmMp
IGdvdG8NCj4gcmVsZWFzZV9mb2xpb3M7YCBpcyBpbmNvcnJlY3QuIChJdCdzIGRlYWQgY29kZSBh
bnl3YXksIHNlZSAjMiBhYm92ZS4pDQo+IDQpIFRoZXJlZm9yZSwgZGVsZXRlIHRoZSBgaWYgKHJj
KSBnb3RvIHJlbGVhc2VfZm9saW9zO2AgZGVhZCBjb2RlIGFuZA0KPiByZWx5IHNvbGVseSBvbiBg
aWYgKCFjZXBoX3diYy5sb2NrZWRfcGFnZXMpIGdvdG8gcmVsZWFzZV9mb2xpb3M7YA0KPiA1KSBT
aW5jZSB3ZSBhcmVuJ3QgdXNpbmcgdGhlIHJldHVybiBjb2RlIG9mIGNlcGhfcHJvY2Vzc19mb2xp
b19iYXRjaCgpDQo+IC0tIGEgc3RhdGljIGZ1bmN0aW9uIHdpdGggbm8gb3RoZXIgY2FsbGVycyAt
LSBpdCBzaG91bGQgbm90IHJldHVybiBhDQo+IHN0YXR1cyBpbiB0aGUgZmlyc3QgcGxhY2UuDQo+
IDYpIEJ5IGRlc2lnbiBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goKSBpcyBhICJiZXN0LWVmZm9y
dCIgZnVuY3Rpb246DQo+IGl0IHRyaWVzIHRvIGxvY2sgYXMgbWFueSBwYWdlcyBhcyBpdCAqY2Fu
KiAoYW5kIHRoYXQgbWlnaHQgYmUgMCEpIGFuZA0KPiByZXR1cm5zIG9uY2UgaXQgY2FuJ3QgcHJv
Y2VlZC4gSXQgaXMgKm5vdCogYWxsb3dlZCB0byBhYm9ydDogdGhhdCBpcywNCj4gaXQgY2Fubm90
IGNvbW1pdCBzb21lIHBhZ2VzIGZvciB3cml0ZWJhY2ssIHRoZW4gY2hhbmdlIGl0cyBtaW5kIGFu
ZA0KPiBwcmV2ZW50IHdyaXRlYmFjayBvZiB0aGUgd2hvbGUgYmF0Y2guDQo+IDcpIFJlbW92aW5n
IHRoZSByZXR1cm4gY29kZSBmcm9tIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaCgpIGRvZXMgbm90
DQo+IHByZXZlbnQgY2VwaF93cml0ZXBhZ2VzX3N0YXJ0KCkgZnJvbSBrbm93aW5nIGlmIGEgZmFp
bHVyZSBoYXBwZW5lZCBvbg0KPiB0aGUgZmlyc3QgZm9saW8uIGNlcGhfd3JpdGVwYWdlc19zdGFy
dCgpIGFscmVhZHkgY2hlY2tzIHdoZXRoZXINCj4gY2VwaF93YmMubG9ja2VkX3BhZ2VzID09IDAu
DQo+IDgpIFJlbW92aW5nIHRoZSByZXR1cm4gY29kZSBmcm9tIGNlcGhfcHJvY2Vzc19mb2xpb19i
YXRjaCgpICpkb2VzKg0KPiBwcmV2ZW50IGNlcGhfd3JpdGVwYWdlc19zdGFydCgpIGZyb20ga25v
d2luZyAqd2hhdCogd2VudCB3cm9uZyB3aGVuDQo+IHRoZSBmaXJzdCBmb2xpbyBmYWlsZWQsIGJ1
dCBjZXBoX3dyaXRlcGFnZXNfc3RhcnQoKSB3YXNuJ3QgZG9pbmcNCj4gYW55dGhpbmcgd2l0aCB0
aGF0IGluZm9ybWF0aW9uIGFueXdheS4gSXQgb25seSBjYXJlZCBhYm91dCB0aGUgZXJyb3INCj4g
c3RhdHVzIGFzIGEgYm9vbGVhbi4NCj4gOSkgTW9zdCBpbXBvcnRhbnRseTogVGhpcyBwYXRjaCBk
b2VzIE5PVCBjb25zdGl0dXRlIGEgYmVoYXZpb3JhbA0KPiBjaGFuZ2UuIEl0IGlzIHJlbW92aW5n
IHVucmVhY2hhYmxlIChhbmQsIHdoZW4gcmVhY2hlZCwgYnVnZ3kpDQo+IGNvZGVwYXRocy4NCj4g
DQo+IFdhcm0gcmVnYXJkcywNCj4gU2FtDQo+IA0KPiANCj4gDQo+ID4gDQo+ID4gVGhhbmtzLA0K
PiA+IFNsYXZhLg0KPiA+IA0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTYW0gRWR3YXJk
cyA8Q0ZTd29ya3NAZ21haWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZnMvY2VwaC9hZGRyLmMg
fCAxNyArKysrKy0tLS0tLS0tLS0tLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2Vw
aC9hZGRyLmMgYi9mcy9jZXBoL2FkZHIuYw0KPiA+ID4gaW5kZXggMzQ2MmRmMzVkMjQ1Li4yYjcy
MjkxNmZiOWIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9mcy9jZXBoL2FkZHIuYw0KPiA+ID4gKysrIGIv
ZnMvY2VwaC9hZGRyLmMNCj4gPiA+IEBAIC0xMjgzLDE2ICsxMjgzLDE2IEBAIHN0YXRpYyBpbmxp
bmUgaW50IG1vdmVfZGlydHlfZm9saW9faW5fcGFnZV9hcnJheShzdHJ1Y3QgYWRkcmVzc19zcGFj
ZSAqbWFwcGluZywNCj4gPiA+ICB9DQo+ID4gPiANCj4gPiA+ICBzdGF0aWMNCj4gPiA+IC1pbnQg
Y2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLA0K
PiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHdyaXRlYmFja19jb250cm9s
ICp3YmMsDQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgY2VwaF93cml0
ZWJhY2tfY3RsICpjZXBoX3diYykNCj4gPiA+ICt2b2lkIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRj
aChzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywNCj4gPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzdHJ1Y3Qgd3JpdGViYWNrX2NvbnRyb2wgKndiYywNCj4gPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgY2VwaF93cml0ZWJhY2tfY3RsICpjZXBoX3diYykN
Cj4gPiA+ICB7DQo+ID4gPiAgICAgICBzdHJ1Y3QgaW5vZGUgKmlub2RlID0gbWFwcGluZy0+aG9z
dDsNCj4gPiA+ICAgICAgIHN0cnVjdCBjZXBoX2ZzX2NsaWVudCAqZnNjID0gY2VwaF9pbm9kZV90
b19mc19jbGllbnQoaW5vZGUpOw0KPiA+ID4gICAgICAgc3RydWN0IGNlcGhfY2xpZW50ICpjbCA9
IGZzYy0+Y2xpZW50Ow0KPiA+ID4gICAgICAgc3RydWN0IGZvbGlvICpmb2xpbyA9IE5VTEw7DQo+
ID4gPiAgICAgICB1bnNpZ25lZCBpOw0KPiA+ID4gLSAgICAgaW50IHJjID0gMDsNCj4gPiA+ICsg
ICAgIGludCByYzsNCj4gPiA+IA0KPiA+ID4gICAgICAgZm9yIChpID0gMDsgY2FuX25leHRfcGFn
ZV9iZV9wcm9jZXNzZWQoY2VwaF93YmMsIGkpOyBpKyspIHsNCj4gPiA+ICAgICAgICAgICAgICAg
Zm9saW8gPSBjZXBoX3diYy0+ZmJhdGNoLmZvbGlvc1tpXTsNCj4gPiA+IEBAIC0xMzIyLDEyICsx
MzIyLDEwIEBAIGludCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goc3RydWN0IGFkZHJlc3Nfc3Bh
Y2UgKm1hcHBpbmcsDQo+ID4gPiAgICAgICAgICAgICAgIHJjID0gY2VwaF9jaGVja19wYWdlX2Jl
Zm9yZV93cml0ZShtYXBwaW5nLCB3YmMsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBjZXBoX3diYywgZm9saW8pOw0KPiA+ID4gICAgICAgICAg
ICAgICBpZiAocmMgPT0gLUVOT0RBVEEpIHsNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICBy
YyA9IDA7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgZm9saW9fdW5sb2NrKGZvbGlvKTsN
Cj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBjZXBoX3diYy0+ZmJhdGNoLmZvbGlvc1tpXSA9
IE5VTEw7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ID4gPiAgICAg
ICAgICAgICAgIH0gZWxzZSBpZiAocmMgPT0gLUUyQklHKSB7DQo+ID4gPiAtICAgICAgICAgICAg
ICAgICAgICAgcmMgPSAwOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGZvbGlvX3VubG9j
ayhmb2xpbyk7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgY2VwaF93YmMtPmZiYXRjaC5m
b2xpb3NbaV0gPSBOVUxMOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+
ID4gQEAgLTEzNjksNyArMTM2Nyw2IEBAIGludCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goc3Ry
dWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ID4gPiAgICAgICAgICAgICAgIHJjID0gbW92
ZV9kaXJ0eV9mb2xpb19pbl9wYWdlX2FycmF5KG1hcHBpbmcsIHdiYywgY2VwaF93YmMsDQo+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb2xpbyk7DQo+ID4gPiAgICAgICAgICAg
ICAgIGlmIChyYykgew0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgIHJjID0gMDsNCj4gPiA+
ICAgICAgICAgICAgICAgICAgICAgICBmb2xpb19yZWRpcnR5X2Zvcl93cml0ZXBhZ2Uod2JjLCBm
b2xpbyk7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgZm9saW9fdW5sb2NrKGZvbGlvKTsN
Cj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gPiA+IEBAIC0xMzgwLDggKzEz
NzcsNiBAQCBpbnQgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0cnVjdCBhZGRyZXNzX3NwYWNl
ICptYXBwaW5nLA0KPiA+ID4gICAgICAgfQ0KPiA+ID4gDQo+ID4gPiAgICAgICBjZXBoX3diYy0+
cHJvY2Vzc2VkX2luX2ZiYXRjaCA9IGk7DQo+ID4gPiAtDQo+ID4gPiAtICAgICByZXR1cm4gcmM7
DQo+ID4gPiAgfQ0KPiA+ID4gDQo+ID4gPiAgc3RhdGljIGlubGluZQ0KPiA+ID4gQEAgLTE2ODUs
MTAgKzE2ODAsOCBAQCBzdGF0aWMgaW50IGNlcGhfd3JpdGVwYWdlc19zdGFydChzdHJ1Y3QgYWRk
cmVzc19zcGFjZSAqbWFwcGluZywNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBicmVhazsN
Cj4gPiA+IA0KPiA+ID4gIHByb2Nlc3NfZm9saW9fYmF0Y2g6DQo+ID4gPiAtICAgICAgICAgICAg
IHJjID0gY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKG1hcHBpbmcsIHdiYywgJmNlcGhfd2JjKTsN
Cj4gPiA+ICsgICAgICAgICAgICAgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKG1hcHBpbmcsIHdi
YywgJmNlcGhfd2JjKTsNCj4gPiA+ICAgICAgICAgICAgICAgY2VwaF9zaGlmdF91bnVzZWRfZm9s
aW9zX2xlZnQoJmNlcGhfd2JjLmZiYXRjaCk7DQo+ID4gPiAtICAgICAgICAgICAgIGlmIChyYykN
Cj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICBnb3RvIHJlbGVhc2VfZm9saW9zOw0KPiA+ID4g
DQo+ID4gPiAgICAgICAgICAgICAgIC8qIGRpZCB3ZSBnZXQgYW55dGhpbmc/ICovDQo+ID4gPiAg
ICAgICAgICAgICAgIGlmICghY2VwaF93YmMubG9ja2VkX3BhZ2VzKQ0K

