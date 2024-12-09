Return-Path: <ceph-devel+bounces-2281-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5229E9EED
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 20:05:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A0741882D7A
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 19:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1F8161311;
	Mon,  9 Dec 2024 19:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LgfbDK0b"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3819D892;
	Mon,  9 Dec 2024 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733770816; cv=fail; b=vC5eog5sUpXvyNS6kYAdkbOzTPcbjwOtb+JfGhB8h+KyLWJ0xkpLQD6KEMGKOR3tISfqls+8PpVFB5CUdYVm98aymtcMiCS/5MwxMbXgR0ON4H7hkQOb9XHR5wckw8UCtBiQn67Jab4/9NBssCAmCH/KnRwUrtrZYObMy3lH2oI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733770816; c=relaxed/simple;
	bh=Gxx2FdGCtAZXZhdFfEA49sMHH0b+HEdc63Xb7GQ5+PE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=n/nF6pC0Gh8XA3QafECUt21uCB9Q/j/sMKI1T2cCB/IBgqTS1otXObUEYTzP4zuI9tdftu9VzxYtzniqcpJScjNKCs5zvYa1PW4ZjVIEUWpi6vfS20qCqYMgCSFm3ju7MZZODDWQsbhEDjTOvYnyELcrrx6oKpzIeZOM68Mp23c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LgfbDK0b; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9CfUS3015089;
	Mon, 9 Dec 2024 19:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=Gxx2FdGCtAZXZhdFfEA49sMHH0b+HEdc63Xb7GQ5+PE=; b=LgfbDK0b
	J85992qwy0J/8MZTdQul80Uzt0by3573bdamr1ibbrlg3tjkMdWjFzC0HpxYvci4
	EAxA3qOu7AZtdXab5CXyfcmnHHQmrqYuQJfzERYkHK9E4Bobq+yg3YxUf9O+IvRa
	1WuuyYtokzD3U5nqMd38u1F4qakbYyKX6VrafR/dQJ27rOUUDyuXmM58j+bFuy2m
	MIOmKaiT/HAwEM+al2rUCWfn7NbrDH8c9uUTz9Lj1Qkk3KV4EwaFCq4divXnaZUw
	D3Fth7jDxFMa8OqDiQhmkQYPlHmBaGQrzyTq8OIUByyraQLsYZq5Eic6jrv0xSGB
	C70tb8qUagXmYA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce38k26x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 19:00:05 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B9Iw7ik013074;
	Mon, 9 Dec 2024 19:00:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce38k261-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 19:00:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYu8vZnnnM4qaiepAmf+Mm6d3M2fD0qCoQTO5fCY3aayCViCyJ8dC7YE30wBwKwBEbHTQvVuWQ5kMOcXIjNBPfrOWPqK7tBDI4UYb9g68pckHazsMS9j0+bPYiW/fOvgwAiSPawitsP4B+4Z7g51kZMRq+Ez5lWp9HyR2KgXtHKC5cRUBdu6tWPqp3PzOGAcWKZ4AoUclwVR2How2LAaMLp5d7qu8lRxWoDXVF1DG9eDHoHki5Y66oNR6OV7usrhnvQkvEP6JiSiIlp48eZ8nkBlghS5sO3H3FnKJUhEE1MGcyumSNXGBxCvlExyg4x3yKtLLJNJYAqGyy7paGeW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gxx2FdGCtAZXZhdFfEA49sMHH0b+HEdc63Xb7GQ5+PE=;
 b=jWxbogPrcaEnzsaBXyD8Btnbyz8xIcj4mzFcfQyQY7wcxKaMU5nUcBtTErH7q7B/ZTa1mf/RexeR3VCWwueHbXLOa/G/T8ESZr7icqFSt600X2ljhjx1vihcTEmPM1GNwzql8b233x7wWFZBJtWGpHbr+07WHfSmmLNizaXIPPNN6FDv4AN4a1VujpMbt79bkx6VHpzF3oVtWIHoLl/gwnTzShYy7TCnqPTXiw7l9gVND/2cEPl7LclFgO/nOE76ylDIOjW1k8h7gF8CcQYYk5G1KmMWRC3voNv+MKPJoRRX63mBRZrxn5yGXzRzOq4QS7Tpq/vpqM3pk9D5q0qX+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB5798.namprd15.prod.outlook.com (2603:10b6:806:334::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 18:59:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 18:59:51 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/io: make ceph_start_io_*()
 killable
Thread-Index: AQHbSBDvGioVo1fY1kSWst7E0f1e0LLZlUSAgAA8dQCABHcwAA==
Date: Mon, 9 Dec 2024 18:59:51 +0000
Message-ID: <caf3a8455673bc602194c702de9b1013722ce4a2.camel@ibm.com>
References: <20241206165014.165614-1-max.kellermann@ionos.com>
	 <d3a588b67c3b1c52a759c59c19685ab8fcd59258.camel@ibm.com>
	 <CAKPOu+-6SfZWQTazTP_0ipnd=S0ONx8vxe070wYgakB-g_igDg@mail.gmail.com>
	 <cd3c88aae12ad392f815c15bab0d54c8f9092e46.camel@ibm.com>
	 <CAKPOu+-AwRayUqOR9fEmZ88bpJkrknMbsZadknjDsBW=jcFL0g@mail.gmail.com>
In-Reply-To:
 <CAKPOu+-AwRayUqOR9fEmZ88bpJkrknMbsZadknjDsBW=jcFL0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB5798:EE_
x-ms-office365-filtering-correlation-id: a7e65df3-b0dc-4308-09f0-08dd1883a928
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RzNPK1BRbktIOHVEYmpwYW82aHlhVFE5ODRTTFJMbUExaWVtYlhCMlBGVjZV?=
 =?utf-8?B?RTNnUlE2Z3UyemVKN2FxcjNVWHF4ejdjTzF6NkN6dWwzcHBRTkZyOEpzaHov?=
 =?utf-8?B?c2V5QVlZMlRvUGNsOGpJQkVhQ3VDVEVXWkNpai9JVm14azJwSkNQd3BMUlFr?=
 =?utf-8?B?YUtJN3BhV2NPb3BMOW9oZWRVaG5ZTkM5ME9SOHJlYVM3QlhJL2NhUkExWVhK?=
 =?utf-8?B?b09SZVB1NENZV1VzajIySVdHaWhEYkthTlE3MnJPcFFkUE5JaFpjTUhlUFlN?=
 =?utf-8?B?dG54b2xYVjVMUUdJUEtRTnp5eVkrK0VXY0NNZmJPM0EyQnFXVStpb3Zjb2lI?=
 =?utf-8?B?Qnc5ZklNVTI0cGxzMTlmK05FQ0diU3Q3Uk1SVHNLT014bktDVk1TVmVUSmJ0?=
 =?utf-8?B?RWVIejNOZUZBSDVpUFNmbU9tU25XeEFtNWZMeGphYlZRSmxVUUJGRWJmOXRm?=
 =?utf-8?B?Y3hDNWJsejQ1SmMxWEtwNkwvUVVwbm45UGF2a2w3b0FTLzdMYWVFeWt4NjVl?=
 =?utf-8?B?UC9qR2hLMVl4NkNML2xkSjdKV21qall0SjEybkE2N0dKSVlOTDVkYXFFdFk0?=
 =?utf-8?B?dzVvb3c3dGhkUEMyM21aT1YrbE1CY2tRVlh5MXdXQkFmbzAvak90TkxLaFJM?=
 =?utf-8?B?TG5jak5qc1NMRVZxbXNGOGVwZ3dmRVduZ1NrTGZuV0NieVN6R2x4QklFRmI1?=
 =?utf-8?B?cEZFendyL0JsL1QzYnlqL016bENiUi9OZEt3cWNlU2NlMFloRnZ6UTRqbncy?=
 =?utf-8?B?SVRJRUt5VVUzbjBvUDhWbGNqdDdjYWVGMEZXdTJxQ3FWUnFiRnVqUUtmV0Nl?=
 =?utf-8?B?YkoyWFE0WkdBaDA1d1lhOVE5VitkMGFaWTdzYnhVMDdyYzFmcS9XcmpraEFQ?=
 =?utf-8?B?eHptSzZNaWorbEdJREVuUG9qLzNZYUo4cXp2NVkwYmdOOFJrdy9uMm9MeGpD?=
 =?utf-8?B?MVdKd21YWDZFM1oxejJjMkVMRk5NS2dhQk1ZNzFvdjNNN2pIUGhnOXU2L1VO?=
 =?utf-8?B?QzZVaklqUTZqNHpXVit2QjVnSk8rc3JVVE8xWEtsU0F2RnVGaFQyQXJpV2t0?=
 =?utf-8?B?TUxCQjlqNjdYT3FyUnVCZUV3aHN0b2JiWi9OejVEOVhVSy9ua3ptc3VESmhW?=
 =?utf-8?B?ODl0cWhIT09GTWpQOXljd1E0NG1oaEVCeFk0RTR0Mlc1Q0taWHMyMUhNQkRN?=
 =?utf-8?B?YVJWU1kwNVB0SGZCdmxmYnpyaHkxRmVHVHhvVjJtaWNzVVluaExxZDdxTUxB?=
 =?utf-8?B?MlN6OEtBSmVqWUFUM0cxWXNnS2ZlS2pNWjhMNzZoZFlvTzdnWFBJYkE5NkQ5?=
 =?utf-8?B?WHhrOEExUWl1VitLWXNJOEtqWkNUaWlWNW5FSWdZY0tOQlJnZlFoV0xJeEtt?=
 =?utf-8?B?dmowZWxpOE9tWnNaYTFQSW4rZzFUN2piZUt3bnNLQlVtQkprdnZsYWxBeFZx?=
 =?utf-8?B?ZG5TajVxRGtJTktDeTBETCtOMUd2Z2RUY0ZhYjR5cFBJdGh4V0dSbElaZVJL?=
 =?utf-8?B?WjlBc0pqcEtTeGdMUWlEU293cnJQZ1NYTVZuSm5zZDgwT0NqcTFJMEpSaUlv?=
 =?utf-8?B?SHNENm9yOFljZndUNHozd011aHdvVEZKTFEyRHhKS0VFeU9zdTlMenVVUmRQ?=
 =?utf-8?B?TWQ5dHZpWUxOWEVnL3hkUHArVWxXY0pmdk4rMGpxa3FyMnZkUUdwK3ZGdURD?=
 =?utf-8?B?UTJLeXdWaWl4ZkIwNDVvaWYzN09NNnBkdUxMN3lrQmlNSzM2NW9GTzJibDdS?=
 =?utf-8?B?VmRrVlI4ZDFIT2pnSmp1N3NsZW00K2thWFJwd2dPbGJtSndsd0VFNTE3TjlV?=
 =?utf-8?Q?S87bYkU//L48Oyk32zFwB1p1/2zFvejvDPMFM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzVxeUl5NjBlTzRqVHAwcU5WOHhaMXV3cFVsdmFJSVdjRTJkRGFDbEUrclAz?=
 =?utf-8?B?Qmdid2xXS3dBZkJIZ1JVUDF0eFNxNHJBMWdjYzcrSlp4VHZnTDMxN3pzREJB?=
 =?utf-8?B?NlZXUW5BT2pBc29ZcUUxV01lVE43ZSs0SGMya2lWOFFWV0ZHTFdLZVYxUVI1?=
 =?utf-8?B?T2sxaUc0RVJQUHJIV05lak5JWEtCdjNCM1RkWFllYStzVGxqSStKNXlTaFlj?=
 =?utf-8?B?ZUVWZ3RQclgrc09zTU8ydjlZN2IxZXFIa3NoWGVuNGpwbmkwb0tlZzZSQllN?=
 =?utf-8?B?ZE5hZEZuRnJvMlZnWERkajhqSVVJTkhUKy9DKzk3bzh4SU16Rml1SThxeFB6?=
 =?utf-8?B?WTBuN2ZDWHBldmhvVVVkK0FqY3VZZ05EeXJCZVN5cXYrNHhxOE90TkRwNzNi?=
 =?utf-8?B?U01PNlJtTjNEM0UvSzNpTjJlSUhCZHR2VG4wNEJIclU2TFlkUGs5ODlLUUtB?=
 =?utf-8?B?NFpsaEdBUUwvTHpBRHEzTWJJN2hJbmw0eFBwWU4reWV3YnRST3VwaU5GUmRl?=
 =?utf-8?B?YVcxUVJHaHpzR1NCMlBBUisxL2VwY0dlQ01mUFU3ZUZvaUJLQmtiemZ3UWJX?=
 =?utf-8?B?Z0hiT0YzMVlyMW85U2srbUs2TmJJMGZLeDIvaU5PVjZTS3AyakpQeThZbGVi?=
 =?utf-8?B?NGQ4V2pnRnBKaW0rQUZqc0N3bCtrTHRQUDZzWFlISFczUGEwS0xVUGE4UGhG?=
 =?utf-8?B?K1RoRXZranFoejdWYzhmakJ3QWNMOHkrb01CSmlrZmxRK2hRQkV5ZU1wRXN1?=
 =?utf-8?B?NndubkZ1ekJLcEFxRlFDU2VGNG5udWl3RSs1Z1dMUVYrcFp1ZTRYbTFCZHFT?=
 =?utf-8?B?amRNSklyMHV5WlFxWFdZZnlQUG1TdGJRekQ0ZE41dzArbklzTy8xUmNpZ1VM?=
 =?utf-8?B?SmlhTHEwbmJTZ1JiYXFpK2tRc3R3aFBrU09lYU9FQ29VNUpncXlDSG1HSVlH?=
 =?utf-8?B?MVNHa3RoWDh6UCt0Y2V5bDhUYzROYUp5MTdPY3AyQnhwK21vbVlsOHM3TEZ1?=
 =?utf-8?B?OXdpcG41OWlFbUNiSGwyTjZxdjdrVTZNYTFaK3JKc2NoakhmQUpiMEJsQmQ2?=
 =?utf-8?B?YkUvdHhPT3lmbXhuYUpucFJWR0JuNTJGQ0huWnZJVWZpaTVwbG5PT3VJOE5v?=
 =?utf-8?B?TGVEQ1lQMXJpdE5obEE3ZEszcFpiYzRWdU9QNTBYUHhJSFdqQiszOTFUcVJC?=
 =?utf-8?B?MC9ocW1jUlNRQW0ydmFmdTNIMDZpbkJGdytVMEJoNkM3MUhkWlFrVVFDa3NG?=
 =?utf-8?B?QWpHU2wvMmR2YlJ6YUdzSVRxeTVoMlNaVXJuVVN6TmNXZnNqMzBabS9ZdXJm?=
 =?utf-8?B?d1dOaDNVbjU4ais0SlBsb3kxRnVtMUZ6MExSbnlIeDI2eXl0TTd5dFBQTEhT?=
 =?utf-8?B?eklkZ2FDZEJ5OWE4Z3ZZWERLMjVyamxXVEU5NVNXT0liN2YzLzA3WUlkYmFP?=
 =?utf-8?B?bnBxVkwrTURIK1RVUFREQmtaVXBYTFdLQkZNTFBBaGhKTWhmbmZ5OVhmSEk4?=
 =?utf-8?B?RXQzdVYzM1I0aDltWlcraWNLYjBjRnhWMmxPRUJaU2J1aVBrNDVZcVg0YUdL?=
 =?utf-8?B?b3pQZ0ZCUklPcUpyejV1UjJLWDlXd2ZnNktKT0dCUERzVGtDam5uck9oRURk?=
 =?utf-8?B?YkJiaTFmNGdkUi9oTVFoRG1uSUQ4MmZvNVpqWjZiQk5zSVBjRzdDeVQwazN5?=
 =?utf-8?B?VHZsVEJOcmN1U0FrUEt3N1h4Tm9qQ2xpOFJHbCtqVWlySmFnNlRuTnpaUzkz?=
 =?utf-8?B?enhpcWx1N1lPdzRjdDc0OGtBQmNGU1Joc1VEQXgySGtoTWZVTmJWWkhLSFB6?=
 =?utf-8?B?QkRNSithRzBXamxWaEowNkVhSU5rT2lTM04xNUhGbUJHb1lLWFhEejNDeXZU?=
 =?utf-8?B?M3VmWjZlY2NyMW1MK2c3M2dkRjFMNWxMQTFzVGFXem9CYXJMaVMyME9BMW9E?=
 =?utf-8?B?ZmdvTGZ5ZGdxMXQvNlVaVlNXQjltVXpLZHo2bTlUTnB0UVhDNjFWQ3dDaWdS?=
 =?utf-8?B?Y3RrK05WWThjeTQ0dmd0bVJvOWFvZjZpQ2VFQzIwOG5nWGFSNTl6dmFJWmZh?=
 =?utf-8?B?aTNrRmtGK0hGV1oyZHdLeWRrT2hxR1RYRnM1TGhtM3RsQ2RGODlqMklrOTFI?=
 =?utf-8?B?cDFzZ1Nvazl3SGlWV0c3SSt5WThPRGNSWFFVN1M4SFB4YzYyM0NyREljcFdT?=
 =?utf-8?Q?6cCtWDNHSuUF/M15S2cmrgg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D53BC5341C5A641BD97483B4D985F18@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e65df3-b0dc-4308-09f0-08dd1883a928
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2024 18:59:51.3679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UCow2/KmslDz6EgtcKhXVnKzXxnJsbr4xg3sAl+Rypr0bE6w8ZEuT/VlOvI5ExuTeEprGQ1o0Pu5fTQFLxBdxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5798
X-Proofpoint-GUID: lcyAqQUklGC82l9GLY7BEPgrCBkrGkK3
X-Proofpoint-ORIG-GUID: ntGnkbIobaHGMwpFiiFYOYdZXl6dmTtg
Subject: RE: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=909
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090147

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDIzOjQ4ICswMTAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gT24gRnJpLCBEZWMgNiwgMjAyNCBhdCA4OjEx4oCvUE0gVmlhY2hlc2xhdiBEdWJleWtvDQo+
IDxTbGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IFNob3VsZCBiZSB0aGUgY2hlY2sg
b2YNCj4gPiB0aGlzIGZ1bmN0aW9uJ3Mgb3V0cHV0IG1hbmRhdG9yeT8gSSBhbSBub3QgZnVsbHkg
c3VyZS4NCj4gDQo+IEJ1dCBJIGFtIGZ1bGx5IHN1cmUuDQo+IElmIHlvdSBkb24ndCBjaGVjayB0
aGUgcmV0dXJuIHZhbHVlLCB5b3UgZG9uJ3Qga25vdyB3aGV0aGVyIHRoZSBpbm9kZQ0KPiB3YXMg
bG9ja2VkLiBJZiB5b3UgZG9uJ3Qga25vdyB0aGF0LCB5b3UgY2FuJ3QgZGVjaWRlIHdoZXRoZXIg
eW91IG5lZWQNCj4gdG8gdW5sb2NrIGl0LiBUaGF0IGJlaW5nIG9wdGlvbmFsIG5vdyAoY2FuY2Vs
IGxvY2tpbmcgaWYgU0lHS0lMTCB3YXMNCj4gcmVjZWl2ZWQpIGlzIHRoZSBzb2xlIHBvaW50IG9m
IG15IHBhdGNoLiBZb3UgTVVTVCBjaGVjayB0aGUgcmV0dXJuDQo+IHZhbHVlLiBUaGVyZSBpcyBu
byBvdGhlciB3YXkuIERvbid0IHRydXN0IG15IHdvcmQgLSBqdXN0IHJlYWQgdGhlDQo+IGNvZGUu
DQoNCg0KVGhlIGRvd25fd3JpdGVfa2lsbGFibGUoKSBjYW4gcmV0dXJuIC1FSU5UUiwgY3VycmVu
dGx5Og0KaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTIuNC9zb3VyY2Uva2Vy
bmVsL2xvY2tpbmcvcndzZW0uYyNMMTU5Mw0KDQpBbmQgLUVJTlRSIGNhbiBpbXBseSB0aGF0IGNs
aWVudCBoYXMgYmVlbiBraWxsZWQ6DQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92
Ni4xMi40L3NvdXJjZS9pbmNsdWRlL3VhcGkvYXNtLWdlbmVyaWMvZXJybm8tYmFzZS5oI0w4DQoN
Ckl0IHNvdW5kcyB0byBtZSB0aGF0IHdlIHNpbXBseSBuZWVkIG5vdCB0byBleGVjdXRlIHRoZSBs
b2dpYy4gQnV0IGRvIHdlDQpyZWFsbHkgbmVlZCB0byByZXBvcnQNCnRoZSBlcnJvciB0byB0aGUg
Y2FsbGVyPyBJIGFtIHNpbXBseSB0cnlpbmcgdG8gZG91YmxlIGNoZWNrIHRoYXQNCmNhbGxlcidz
IGxvZ2ljIGlzIHJlYWR5DQp0byBwcm9jZXNzIHRoZSBlcnJvciBjb25kaXRpb24gaW4gdGhlIGNv
cnJlY3Qgd2F5Lg0KDQpUaGFua3MsDQpTbGF2YS4NCiANCg==

