Return-Path: <ceph-devel+bounces-3073-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 451B3AD07A4
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 19:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4D6F189913E
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 17:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15AB328C013;
	Fri,  6 Jun 2025 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mmR6Uub1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC7A28A3ED;
	Fri,  6 Jun 2025 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231732; cv=fail; b=hLVaFohKn4kyM3P5SdVO1pEgA1DlO/tLkXceehnaSbQ/lxYLR5MDAzp3kHtdDDWyHwnSh2p1WSJvYwF/7F4PwyGOrfG9v1Bqq8cHYUHqG2tPP4i5tBeMbdbHZ+HgZ3wZU8hZ0rtimdSJKFA0CfYcXIkLLv+/mBiJwVG+zgw/WDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231732; c=relaxed/simple;
	bh=JkVE6LWQMkGqoQnvvZsT2rT4QXKyM4eSFdN4J9j39eU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=tFYxsT7sQut1BrhHsk77AB3ELI9E/XEMQnHntj0Zr6KgJk3Q9K72IzeOx7PRZuwzv4cWvJzywM4hknPWE55nNHmbl/D5Ta8hTb8ZPtulwr94TUbxlTqx6hAI7OMx62EiaBe35/FInKHKOlBpjYPsmEVWmZjdiG/wVVAZ4JBnRY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mmR6Uub1; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 556EtbpT011285;
	Fri, 6 Jun 2025 17:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=JkVE6LWQMkGqoQnvvZsT2rT4QXKyM4eSFdN4J9j39eU=; b=mmR6Uub1
	3NsZyfQolfiEpFqPrALyFYpZM10a5auBuRU778fUavZe61ENmodyEw+zJY0qCvRt
	cihF2v5H0Lp+jTIc9kAQTXaasEhDh6o4DtSw/1YC63K1aKGc2IZ34VH+MQBqd0I0
	k9GmoFxhTS1AIGzHDRhuAKmj9sUWanyUA9Pey42QobVCxcALDPXyEW5QlFpg+5iP
	6zlOrEGET4cAYrdMHS0tucu45T/T3xY9iKo/cUEpxq0+xdvIoGnZBRNZnGCE0gBy
	8rOqdEXlUKiCjUpD5fUJy67ctYWz9WS6TPGMUT3JtAwrK50d6uwoslxeXkk8Pett
	lSO2famrlAViqw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf07jvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 17:42:07 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 556Hbx8i024735;
	Fri, 6 Jun 2025 17:42:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf07jvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 17:42:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BqIrYb5zX1OnFLnAvaWegrysWYBzs76JyCj1a9wWkQhp1fCnVaCqNrcxw9e4KZL0xd35bcOp4AH0jMBGx0sV+KkG/rfHuFw5PYWuS67QZX6WnhjX0EvPyeZcpdnMrHxe06H2sqnnv5b73u5Bs5ljSA0P6qzgE7BEULZdKPidkRfvMknKpHGNIwBTrXgNXKC8RUCGXGTCLwsX+I9MGZYKWpW5azyFOUZTCXyg8tOE40RPefmZKTXv5l4En9AVarnAogyHBVYbSDG/uyluM6cpq//WmmARGNOaqilP7FGMR+aitiN2D38UxQfLxrR1QQk9H3NZoY5kZxAaOyF56x/HCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkVE6LWQMkGqoQnvvZsT2rT4QXKyM4eSFdN4J9j39eU=;
 b=JHVbQfzIDaijjiv8Ymvfw8zh8bziibByx6BLVlGukceShpitMFGg5xXhMRdAkXjdbTdEULmYkSSdQq27g3b4Ecl/HmBhJ7O9FTYE9DYVKzVg9rxLs779vdPLmcn3KixFbbWYZvSxQiFthGnpL2RQkFdDVb7+WtiVWfKUHpMIKqAJuHz4Wo2To39C2OFrcr1GZ3uDIr9A24bVwjV1JrGssrIiaT06qAZ/cngKabCbwn4AFjfLirsjmEtAaSQRjDp5yFlK5f3F9QNDTnzGQVEkyRc/J1trVZiiQIJW/OAEs/nvC//DkGu//UEj2Nj1eQq4FFEoRjWCS5i63tN/xIGwew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH7PR15MB6178.namprd15.prod.outlook.com (2603:10b6:510:249::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Fri, 6 Jun
 2025 17:42:02 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8813.018; Fri, 6 Jun 2025
 17:42:02 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/io: make ceph_start_io_*()
 killable
Thread-Index: AQHbyKb5tFKUiuV04kGNfjNavnZanrP2efAAgAAB6wCAAAVKAIAAAisA
Date: Fri, 6 Jun 2025 17:42:02 +0000
Message-ID: <5d195404b0c997b65633eab4c0326c9c9466bd85.camel@ibm.com>
References: <20241206165014.165614-1-max.kellermann@ionos.com>
	 <CAKPOu+8eQfqJ9tVz-DzDzqKPEtQVCooxtxe1+OZanu5gi3oQzQ@mail.gmail.com>
	 <CAOi1vP-dARssCkj-2FiKDJLRv9+Dq+_GE3pfQy4BseF_8sjUNQ@mail.gmail.com>
	 <b4ac9be24677c76a04c99aab04f572abaa4cf8af.camel@ibm.com>
	 <CAKPOu+9GHo3_Uf+b_8-p0Hg=gdJJnRE62Go9UZz9WHqR6WF5Lw@mail.gmail.com>
In-Reply-To:
 <CAKPOu+9GHo3_Uf+b_8-p0Hg=gdJJnRE62Go9UZz9WHqR6WF5Lw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH7PR15MB6178:EE_
x-ms-office365-filtering-correlation-id: a4c874c8-120b-414b-c5a1-08dda5217257
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QzFQMzJialFjZ1R6RnlUMHVBV3JFUnRxTWNnTGptRUw0SURpNGlRR25mbjBu?=
 =?utf-8?B?cnZMUTZYdVBlOTlOWlZuNXZIRTZyZnQ2R1ZxbVdhRVUvY0VpVW1pUlYxNmtu?=
 =?utf-8?B?U2k2cVpUUkllTWRxK1UyYkgxMDVWYURlcEhMd2pIZkduN2lwb1l0RmN2Z1pP?=
 =?utf-8?B?Sm9EbENlWDRmUzljRzNZWjJVdE1uNHJiVG5hRUF2T3JMYVVUdkc4S2E0Nnhs?=
 =?utf-8?B?Nk9OU3pqVWhtQmIzUGtCd1BtZWlMOUJuRk1uaXNTL3piMzYrcVlZS3ZDZG12?=
 =?utf-8?B?Ykw4dGlBdlNabkpRQ015TEgySlFUSk5NL05ZS0ZPcVdlcjVQbml4Ky9aUzFE?=
 =?utf-8?B?eDNPQXYreGdUUHg0Umxjc0Y0RVh0SFpic250UUFJcnhPbzNZYUdHWWp2NDdz?=
 =?utf-8?B?RkpSNmcvYkVPemczbTNod2xQeEtNOFR4NHBwVlZ2QVRqRlljRHpZTmlDZG14?=
 =?utf-8?B?cjdnQWpiT21YbkMwRFQzN3RSai9QeG9HQnhMS3Vwbml0N0J0dkRuejh0aWcz?=
 =?utf-8?B?ZzJvd2RCYXpva2V5OFV3QWk5bjVQeW5FWE1wWFNZSXNPb255Q3IxOUxjd1Rs?=
 =?utf-8?B?bGpvc0ZaM3FLUkVVclpYNGcxOHFRcHhVazZ4MjJBaE1MeWJvV0tETmZDNm01?=
 =?utf-8?B?Qi9FUXYwdlVBanFPS0V0b1pGZ0ZMVGs4QVd4eXZoNHoyQlZJbWZQSklIblFO?=
 =?utf-8?B?M0RkTWNGQVJhQmJrYVJ4RWpQemZ0RStXSGtDK01pRUVITUZ5TWhyc09mMkxO?=
 =?utf-8?B?ZG0rT3djekNsN0FsM2RZNEJ5elhGbzJweDRHZy9CaTFNU2ViV1NwT0NZN0V6?=
 =?utf-8?B?eDRjKzAvOHRVU1pUUGNkWlpQbDY2bmVMcDgvSElNWkRXVmxUT0Vwb2pZamxF?=
 =?utf-8?B?T0J1WEdneVF1K01jalZIRmFjUkIvbU1XZklDUEFMeHNlcmFPTkdyekFlL2d3?=
 =?utf-8?B?eG9SVTN0N1pPSGs1b0wvL1JIVCtSTm9iL01HdW0wQjVVVG9oeXhHM2RkRUli?=
 =?utf-8?B?dzF5aFUwNFhRUU9aS3B4NWVWZDN4eVZuRUkzWURXcWZWUXVSZ1RzNy9TdXc3?=
 =?utf-8?B?WGVHZm9LQjlwNjZpN2pybmRBTEdWd3RCY0RQemlaZTh3WTgwUGp3R1p4TFY0?=
 =?utf-8?B?V0ErMmh1TEJQRCs0R3FlVXY2czZFZ3FKNmtBM3g1ZngreUNOdjMrY2VyV2hD?=
 =?utf-8?B?c1N2R0xhTUlPQlE3L0V3dGs4MTViTEFiMDlMVXYrUFA0Vnl0RkJJaE5Pb3hO?=
 =?utf-8?B?STFJUWZqaGRwaEp2S21NZzVUSEhrdDVXendjODRKekFhVWl4NkxFeXpLQnh2?=
 =?utf-8?B?ZmlTZCtncDFiVm84N3FaMlJoYjl2dS9NQWV3ZnBVeklKR3VrNW85R2tkdGtU?=
 =?utf-8?B?RzdCM1hhaFZkQTNnQlFuZDBKZFdxNWtSWVltNXNjN05hdkovc2hITmJBNitX?=
 =?utf-8?B?SFBDUUR1UU9pbWJKMGswaUcrOCtseWRNTnlSL1k3OGY3SUpRTXNReVdOYU1M?=
 =?utf-8?B?UEl5VzI0aDVnbUw0U3hsVVU5cm54ZzhldVp6ZEdTM3AyM3I5c2I4RnRLcUh1?=
 =?utf-8?B?aGZJMUV5cW1RemRsWEJlM21uZ0pqM2VHclZaREhqTGJHTGtMVWJ0TjVyeU1p?=
 =?utf-8?B?bTNNMkdYUmZIR2l2SlI2cko0RHZGTGU4UEpxRVpEYVRBODRhUlpab1hxMUNo?=
 =?utf-8?B?VGxZK3RXVUVBY3MzQzF0UkdNdzM4SHRyMnFqYzY4UkY4RjVlYWFlamxlWHdJ?=
 =?utf-8?B?UENMN0lvWkQyNXViYm1MMlNNWjFMcXBiT2RzdytGRTluaGN3V3JJV1J0dlhT?=
 =?utf-8?B?aUtkanVSY04vUGxCeXRlWm1GNGZVT1cyWXM2RHlCQUFxRUcybDhTNDJ4NTJN?=
 =?utf-8?B?UzgycS9laXcrTi9PdFF0L09OL2pHRStHNnFuSEZKYTgraXRMMWhtMlZXTUZm?=
 =?utf-8?B?UU14b0ZVdjdtMkdHYnRhdTZEalhQeUkveExLcEdMS1JneW13MEFPZXJCTnVo?=
 =?utf-8?Q?qsHL8Fy9lZFs/hQiw4dyERUrl56ekc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zm5QZ2lxbUwwN0FFQnhicDdKaXBDQVBBY2FCVkJZbWJlbHFGTWdRZTh1a3Q0?=
 =?utf-8?B?YjZHS1VuUHBKa1JTUXROZkVaTmV3Z2UwZm0zTldzY3BNQXUxR2NhaG5BdURC?=
 =?utf-8?B?ejJra0FFVDk3aEhsTEJGVllHenF1MGEwWDNMUEZFRkJmcW9RdXJzekVKajVC?=
 =?utf-8?B?SzBaWFBIZEFOOEtXY283enNJZDBXa1FVQ0hGRlAwSVNFTVYrTktCU2JXSzlo?=
 =?utf-8?B?T2FxVjRtL2FLc3BzRW5iR25kUk1oNGh3OWllZ0NHdlVVYUkwQWVrQXhEcmhr?=
 =?utf-8?B?N1NDa1FxS2trcllrb1lGaG9CeEh5UnN0TGt1WnZVQVBzM3BzTy9Pa0ZWTDdu?=
 =?utf-8?B?dFg5anhYNXQ3U2ljaWJBUHlrYXpmY2tRQlh4RkY3d0k5ZFFHNUdiZ0swOXFB?=
 =?utf-8?B?YXErQWxHUFdlMzA1OG5zYTRkdXdlWWdIT1JKYWFGYjRhSGNMbzFsbVlDZmV2?=
 =?utf-8?B?cTBxRHNiOUFoS0FUQzZwQ3g3VlBvbXlSZ1VaTURTQjA5aVltd3FyamRtWjRi?=
 =?utf-8?B?Vk4rZ3Y5bzFhVjlZMjlRRGR1MEFKOTBsWVhOazJNZDV4c1N6aUhhOW1aV1pG?=
 =?utf-8?B?YjlnZk1lOFZkalBYekkzd09wVXZaNmdWUkdlR29PaG5jKytxeGxTMzF4eVhx?=
 =?utf-8?B?cWdEZHExbFRVZk5icWdweGt6MjQ3eTdVQmxUczVqUWxxN1daQVN1dDgvNDFP?=
 =?utf-8?B?UGI2TnhiSk1RTnk0Q0tHWGNmaFVFajBLMWhHV0wzY0QxTENNZUoxZUxxd2d2?=
 =?utf-8?B?dVJmZUUvdnI5cVFHR1BtVkxPWE50RElmWHQ1QTFBSG1xUThPcHVMMjJqMU1W?=
 =?utf-8?B?eG8rNVNuQ1N4WG16SGl5ZElhUmRvZzlVRUN0WnFvZVFSa3NYMG5sTGFqQUdz?=
 =?utf-8?B?M29rVWdPZXFiK3FiN0dPaWlFUUV5UWx0NFovdzBxRUhmdWVDN3pUVHh0TEJE?=
 =?utf-8?B?ZzJBQWlzaEFjcFBRVmZFRWRXNmlTTWxGejhyQmJ4NnJLcVVic2o5dGZFRjBG?=
 =?utf-8?B?RXo1aUVxU2RKUjM3cGl0R2QvdTcxN2UxSFdNVlpsSjVYMzV4czRSWnZxSk8y?=
 =?utf-8?B?TUJHUDlJVjgyOHM5MmhrYXI5aVcrUFRMVEhWYUZ3NlNsMWVleDM3Nm9CbXUw?=
 =?utf-8?B?b3pyMGV2eVFRS2N2OEFOcFpmS0RWbmN5a1hGM3hyNGlCeEZMYkRWM3AybkNQ?=
 =?utf-8?B?eUR4SytyVTZUQUZaNmhzL3NscUptRXdFc3R4QVN6Y0JuV2VlQ1hXY1hjZTVh?=
 =?utf-8?B?TE9CSjVPSDlYZkZ6VCtHRjZYNVZRMTRBek5nTzJTSGtrL29GSUVlcGVGWUM3?=
 =?utf-8?B?MUZkdm1aN1IzMy93ZzNydDVXc3RDU0JFL2FiR2tvdEtzMUJxbmVuR1dReFJS?=
 =?utf-8?B?UnBFSkR1MWN6TmlwZTUyNHFWa0o3Y2N4Z0dYYk9FYTlaZHdlN3hsSVRqM3lX?=
 =?utf-8?B?VXBmeklLS1FBcUdpNUVXSEJZZkRBR0xTTjRySldWamJTZ3ByZitFMUpyZEY0?=
 =?utf-8?B?VEhzMVB3THhIeUpOWDcwRVNkenc1REcwcWpiNGdsbTNMV1d5NzRVTlR4Mklt?=
 =?utf-8?B?VjR2Rk4zQWdYdjFhMUx6R05pamRPR0hJTy9tMzQxeUtvRmRCUEREcXRRVHVn?=
 =?utf-8?B?TFlxOG5GbXFjK0NQY3RiLzFPN0R6RGJRamVoNS8vUVV2QTFjaXJIb3VYdmY0?=
 =?utf-8?B?ajhsRkVJRDByREhnSjVHTDJueSsxa2hIMUtqZVZ3YTg1aFBzUWs2L0lxZ2Yv?=
 =?utf-8?B?K3N2RkgrRk1oNU1jUjFUYzdWeHlYUXBlc0pkZHM4RGhZTytGbkR5Vk92QkdT?=
 =?utf-8?B?REcvK2lERW1KbmFWcVQveW5CUnpBQkpEMHZDVTM0RUlqRVRlYW5jRm90Q2Vz?=
 =?utf-8?B?bldia1RiNVlrTC9FQTR6WkJxOHpJUFp3SDR1ZUduMnFzV0ptQ2RFQXdzMFJ3?=
 =?utf-8?B?QmVmcDZqUlBmbm03WWlTMHVReTQyaVlEM0xMdmp3VllqZUhJUVZpQ1pvYlRE?=
 =?utf-8?B?QS92ZVNPN0p5UkpQQTk0a3d5MmpGSytncGpqaGJMcGRjdjlnaWthR05XellL?=
 =?utf-8?B?dEdZSDIvOFJ1OXBlUkpFeCs5WGU4dU1CTitweDJkcktzMmYrejdFTGFod0gv?=
 =?utf-8?B?WllTdzlJcU4yVXgrWXpVNFVvT01PN0UrdlAreXFlUmFpVUpPSGVFZytwaGY5?=
 =?utf-8?Q?TrkIROkW3QmsMsnR3RerpkE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB68C5B5A07C2241B2D763BBE6F57F24@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c874c8-120b-414b-c5a1-08dda5217257
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2025 17:42:02.6988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 87yw0o82KZTRPyi4GmRyQpDZAzTNca78rmK6ynzNpyhEs2+GKIA/2bNevQ3X7rU7AzVBYF3NYQABNDvj++xJNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB6178
X-Proofpoint-GUID: osmU9Rs50rVVqARbFQztErh8T0myExuj
X-Proofpoint-ORIG-GUID: -bd8Ny-Zp6vLJquEfEahW7Uq0Nhsgd1x
X-Authority-Analysis: v=2.4 cv=X4dSKHTe c=1 sm=1 tr=0 ts=6843286f cx=c_pps a=uxpPEJxh2mAsh5WBefDKvg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=gcMWvoPC686HwC6efYYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA2MDE1MCBTYWx0ZWRfXyMfOvaiN+9KI 0NODEUHgBTRJUAgNQYhAxG/syq4LrLeXpDLwKtgdOrQmLOWEKpuat2lBCQXrNyeaR8Zrw0Z8FOs sG+jhoV+p7VHlHEa7J4yLhECsvsPZZJDdbgnlbRXGYZG5EsMqpx/IQaS3j8oej5TfyFHIMzEs9y
 7O52640xmJtySnhiwZVAUrBTl1Qp2Euq17rESZFK/sGP8C6AWW6h87OfBABg5gX8n4bmQBLo73Q rYxmbj059iG9/2v9ZA7e48YdklOZoqDPOv/znpQiivBnhTeZQEnAoJWDmN1Keqb9vTuHlFuheOW OPKxYte1lHB2lQ8zrA3SRMnkXkmggftEac78GKVYTY/dEKwMg/+ytrnAnlXTdfKthi7Xm0hj2aM
 YtVTJEbAEBYJpcxhTHf8AZfdo5Tjd6zTbQdPVIvv7m4vbGsT0yViRaulRkxcJQdlARtqOnaZ
Subject: RE: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-06_06,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=471 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506060150

T24gRnJpLCAyMDI1LTA2LTA2IGF0IDE5OjM0ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gT24gRnJpLCBKdW4gNiwgMjAyNSBhdCA3OjE14oCvUE0gVmlhY2hlc2xhdiBEdWJleWtvIDxT
bGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IEkgc2VlIHRoZSBwb2ludC4gT3VyIGxh
c3QgZGlzY3Vzc2lvbiBoYXMgZmluaXNoZWQgd2l0aCBzdGF0ZW1lbnQgdGhhdCBNYXgNCj4gPiBk
b2Vzbid0IGNhcmUgYWJvdXQgdGhpcyBwYXRjaCBzZXQgYW5kIHdlIGRvbid0IG5lZWQgdG8gcGlj
ayBpdCB1cC4gSWYgaGUgY2hhbmdlZA0KPiA+IGhpcyBtaW5kLCB0aGVuIEkgY2FuIHJldHVybiB0
byB0aGUgcmV2aWV3IG9mIHRoZSBwYXRjaC4gOikgTXkgdW5kZXJzdGFuZGluZyB3YXMNCj4gPiB0
aGF0IGhlIHByZWZlcnMgYW5vdGhlciBwZXJzb24gZm9yIHRoZSByZXZpZXcuIDopIFRoaXMgaXMg
d2h5IEkga2VlcCBzaWxlbmNlLg0KPiANCj4gSSBkbyBjYXJlLCBhbHdheXMgZGlkLiBJIGFuc3dl
cmVkIHlvdXIgcXVlc3Rpb25zLCBidXQgdGhleSB3ZXJlIG5vdA0KPiByZWFsbHkgYWJvdXQgbXkg
cGF0Y2ggYnV0IGFib3V0IHdoZXRoZXIgZXJyb3IgaGFuZGxpbmcgaXMgbmVjZXNzYXJ5Lg0KPiBX
ZWxsLCB5ZXMsIG9mIGNvdXJzZSEgVGhlIHdob2xlIHBvaW50IG9mIG15IHBhdGNoIGlzIHRvIGFk
ZCBhbiBlcnJvcg0KPiBjb25kaXRpb24gdGhhdCBkaWQgbm90IGV4aXN0IGJlZm9yZS4gSWYgbG9j
a2luZyBjYW4gZmFpbCwgb2YgY291cnNlDQo+IHlvdSBoYXZlIHRvIGNoZWNrIHRoYXQgYW5kIHBy
b3BhZ2F0ZSB0aGUgZXJyb3IgdG8gdGhlIGNhbGxlciAoYW5kDQo+IHVubG9ja2luZyBhZnRlciBh
IGZhaWxlZCBsb2NrIG9mIGNvdXJzZSBsZWFkcyB0byBzb3Jyb3cpLiBUaGF0IGlzIHNvDQo+IHRy
aXZpYWwsIEkgZG9uJ3QgZXZlbiBrbm93IHdoZXJlIHRvIHN0YXJ0IHRvIGV4cGxhaW4gdGhpcyBp
ZiB0aGF0DQo+IGlzbid0IGFscmVhZHkgb2J2aW91cyBlbm91Z2guDQo+IA0KPiBJZiB5b3Uga2Vl
cCBxdWVzdGlvbmluZyB0aGF0LCBhcmUgeW91IHJlYWxseSBxdWFsaWZpZWQgdG8gZG8gYSBjb2Rl
IHJldmlldz8NCj4gDQoNCk9LLiBJZiBJIGFtIG5vdCBnb29kIGVub3VnaCwgdGhlbiBzb21lYm9k
eSBlbHNlIGNhbiBkbyB0aGUgcmV2aWV3LiA6KQ0KDQpUaGFua3MsDQpTbGF2YS4NCg0K

