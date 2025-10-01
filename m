Return-Path: <ceph-devel+bounces-3777-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC4FBB17A6
	for <lists+ceph-devel@lfdr.de>; Wed, 01 Oct 2025 20:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80ED9188D51B
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Oct 2025 18:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5038C2D373E;
	Wed,  1 Oct 2025 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FnAWjgWX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E4A19E81F
	for <ceph-devel@vger.kernel.org>; Wed,  1 Oct 2025 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759342947; cv=fail; b=QL8/DMcp81d/LGH2m3TdAOKEYwC66qBiZAwpWuZ7009UancuKIiVidjxz/1leMUmZi8J/hZ5SpGqLUUA5HCERhgy8Hnsa2rN/rbSmkPxVnIHPubagsuw3JY96f4HMbfYUCMJrOg/ws9y7iJ5sGQUjhbc74f3YOM4IqOJm0LmmiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759342947; c=relaxed/simple;
	bh=94zx3//r1DKAE7Wa5dpHu7ze3pq+ReN0bI3d2M8dqzU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=L2o5nuNcVJ/axWbXSLdxWhofbkh4FP7+AZH5HfcQvBTKG6BzX6mx/Ve2xQTqi0+349EcUQWBPfJ1CVGxfkx10T63mF3ChKDwHaWNvU/uNl0124fGqFrouLWNpoh4Hi+AHVI58q46pmJbkYtGcO8AgI5L4GdLVGwtdvv8U8Yl0xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FnAWjgWX; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591Gn7n4016074;
	Wed, 1 Oct 2025 18:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=94zx3//r1DKAE7Wa5dpHu7ze3pq+ReN0bI3d2M8dqzU=; b=FnAWjgWX
	BuVSKbQpf68VU4F7FAfdVkL+9TWQmj3KxN/A12aYDokA3JapTTwivT1nOcU8pMlc
	Crf1XSRdUa5iJIAr2BcwLozzwnp/eYI9AOX4s4R1JMKedNs16jhVesLO+MBES997
	eI3yiB02mfzx4h2or2UcDgMHXideCAmLvltsZ8+tdegB2IA6kmSIbdnX3hvYcX64
	NPPQkRJxkTRV0aT5qIKcPNFK0G+5aTyZdwT15FbAj1se55GjfZdNlm43SePTw8kd
	GfJXiMURCOk9ho0zpE8c7siY6pEQQ5XaQ3DP94F8LwgpN2WVv7SHLZXWuGDSVJml
	K++THwnWITGDbw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7e7had0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 18:22:15 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 591IMFux017268;
	Wed, 1 Oct 2025 18:22:15 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7e7hacv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 18:22:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZM/JnJlPRnSS+4E9EX3ppzImn3AGzruqukoJ7ogVLxh/UdrISWXEODjfvm/5mnbJOw8BPbi9cn10Swe8NgbqP3auWEHenuuN/TwrIk3tHOEawgxe0v8E/ouaeocfloPm1WXZqh2m2jZJFDKfHiS2ihIFFU4tjWMlt5LA+gcjjoGc/UW+r7LM9fS1zJA3PU2a8Qvdgg/NSsQe21bSRJKhHsCUUKaNCeo52jbYUBWzudJ7l3JTDD5un+J5KRG0oKHRrw+XYMa3kcs11uB8GuBQnbjkU633vQMqHwJIIqQcgX+LAcjgi2YRuxG5HBvqpFTM1yIXIIYCkVoMgMzkq0lAkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94zx3//r1DKAE7Wa5dpHu7ze3pq+ReN0bI3d2M8dqzU=;
 b=cEx9Nd0aeN57zRWfcbAvdca1UHkKviqTxz08pb8oquBqf1oZ6pT3NWSaSWdtpXiuXRSAtvf0N/qhvBbtx/8IJh0C8UG/9fYt16uaiufHYemASJ7cnZLqPy6Tp47kCkoI0ZFzTARPhWjSqzCsvAhadFSRYmoB2249yKhpaRpkY0vL3XugusQcmlHEENoPQ/erpqN/yJXtKfs9NNwJQfVN88zKkOsI9yMgVIOn6O2L2sXrJN5MMWvpv4E8zNcBdjrbDF71nLm8i9uOJoXwZPFnKjqqVW/NqiXRRwD05QfZPd4plXZLMklJL99u3Cs7vXbPkOZt/N7dv8gSBu+fuy0Sig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH4PR15MB6608.namprd15.prod.outlook.com (2603:10b6:610:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 18:22:10 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Wed, 1 Oct 2025
 18:22:10 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ethan198912@gmail.com"
	<ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH 1/2] ceph: fix snapshot context missing in
 ceph_zero_partial_object
Thread-Index: AQHcMdjuXYLBAWDkZUuhC/83CstMFrSsDYOAgACXcwCAAPfxgA==
Date: Wed, 1 Oct 2025 18:22:10 +0000
Message-ID: <70d56be1a4a21a9424301166050e2222d6710b38.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
	 <20250925104228.95018-2-ethanwu@synology.com>
	 <af89b60b-17e9-4362-bccf-977b4a573a93@Mail>
	 <d9f111e47c7b9ab202f27bf46956c3a5f4d51671.camel@ibm.com>
	 <6e8d05e8302521104a00abf8412568b8baf25d7f.camel@ibm.com>
	 <71034561-e258-46a7-a524-9343a6416a4f@Mail>
In-Reply-To: <71034561-e258-46a7-a524-9343a6416a4f@Mail>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH4PR15MB6608:EE_
x-ms-office365-filtering-correlation-id: 255dbc55-b158-4e3d-45e0-08de01176fa1
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bDhScDQwQ2s5aktEUVNIa0UxUDBEZnNxOHpnZEJ1cEc1dWVtQzNtOE1qL3g2?=
 =?utf-8?B?clhUMDVacGZwcVN5WWt2WWxiaHV4Q0xkUWxYWEc4ZlJGTkFSNnpMYUtJeUl2?=
 =?utf-8?B?V2NmY2ZhMzgwOTA5bi9HVzNjRmFXYkNKamVKRFVvalhUSlI4ZlBzdVg1bkhD?=
 =?utf-8?B?QVY5eXliZUZiQy9Hc01kWlR1ek5TMFVjTUZQVm1rVDU3Y091Rm5WZzVPdDNm?=
 =?utf-8?B?QW9GdkU4dzhqUi9vMEZ1RmpRdFdHZDcxU1htakRiTFplQkRsSEdvbTdtNkpJ?=
 =?utf-8?B?cEFQa0FOUVhxYUorZlpMVnJJMUlzTnl1K2w5dHcwZHY3QVY2ZXlyZERkS281?=
 =?utf-8?B?RVBVM3N6eUhET2RCMDRvSkF4d3oyVGFhNGFieW0ya25lSW81UGJQdE1YV2hG?=
 =?utf-8?B?MGZGWkdhM25VU3VvWFdKMG5BWVE3WW5VMm02eGVmaTQ3K29oSlhaMWVQaVgv?=
 =?utf-8?B?OEozSzREU1l6K2taTHBjN01MWHZxYWZlOXNpR1BKN3FBWmlRSmRyaDRTUi9I?=
 =?utf-8?B?RzhXelJHNGhMdXlMa2hzMDZqWmttYkFLWXJ4MG13bGtBRVgrMGpmVWovdWFC?=
 =?utf-8?B?akYvc2JjUk1DYnJaaHBpUmxDdFIwWUlCMVFBbUMrWE9jMXdYZDltaERxenBw?=
 =?utf-8?B?ajdBeHlibXZheGZSMTU0a00wYjNDZDJscVE3TUdOQ3hCL1NkdkZYZ1gzNlVj?=
 =?utf-8?B?MzhSNGduNmxDdmt6MzJjeVBmRllDOUY5UW5QYy9vMHNOZVJKcWthYzFEMlVT?=
 =?utf-8?B?bmJQSWk3NFRUaWFpNVV6OUJzR1ZXTVg4TDd1RCthS1Z4bmJRYlBCMmlyRnAx?=
 =?utf-8?B?YVVhaXp1SkJjYUZmUFBDZ01IdGpzNERKQk52N0lyaUp6aDR0TkUvREtLNm80?=
 =?utf-8?B?WDFDbkdRVWFHL0lVQTY5QlZJZ05lMHJjLzVPeDlISm5TRzNmOUNKajV0WGhY?=
 =?utf-8?B?bVY3UHdQYkh6NjRZZ2lsMCtERldFb2syZ2JibU1vZmNJbnZxeW9BOS80OFdO?=
 =?utf-8?B?SW1uQnlTRmFWQ1FZQnh2QktSUTFXN25sRk9wbUEydUxsTHVUNlBWNEtHOCts?=
 =?utf-8?B?Uks4cTZZL000RWZLUm8zK3FybVNWUXdJcGdWV0Jqc3UzTE1rdVdBSU9zSXZ3?=
 =?utf-8?B?S1lHZllBblRZbXVTdG92MFZyanowbnVDakJnK1I4Rnp3Uy9CVS9EVVZoTSta?=
 =?utf-8?B?cTg3dzNYNnhmL1krZjVudzRVQXV4ZmQ1QmJtdlVhWFdJZm1STEd3d3k1bUJm?=
 =?utf-8?B?YjZBQWZoQ09wTUxmVVVQcGxiY2huYnBiZW0wZU1vV2daRm10b2R2Zko5NHB5?=
 =?utf-8?B?NmNOZThNYmZqVmdkMWcrSC9rUFJVMXJBL1hWOStLYlVHa3hjTEpBeW13eU5Z?=
 =?utf-8?B?aGppSlV4MEppajVjTTU2K0d6d01jaHFYeGROUVY3TkprNDUvUU1rWXVwbEZG?=
 =?utf-8?B?ZDNTbHQyUzJ2cDg1aFJ5dEI3bmFYZEtCRmZCRWRIazFRZDlpRmF2N3JhZ1E3?=
 =?utf-8?B?UE1jMnJmZ2dGWEN4b1dSNzEyMy9LN0VIQUNveUdpZjhUSTB1d21STTZ5YUdj?=
 =?utf-8?B?dGRRN3BQY3Z5T1Q2dHdmSkM5SGVKaGZrRE1qbkh4bjdoYjlnN24yam5hZUZl?=
 =?utf-8?B?TWl6c3lFa011Sy9CUExnaHNlT21RVGRxaUIrcUx3VHE1NGRVMU5BRTd2dGRm?=
 =?utf-8?B?VFUvTUs1OHdHSm1rNkx3bnNPSTRpeURuMDgzYlVKT1RSZzZidXUxOXk2ZGxC?=
 =?utf-8?B?SVluNVRuazBxN2ZwaFpmRnoyVjZzOU5NWU5mdGlSVW43eVEzbHl0cmM2cjRt?=
 =?utf-8?B?NlBEckdhNWh6Mkd2M2M3TGlHYllsL2tHN1dpKy93K2VneUxCS2pIQUNLOWlk?=
 =?utf-8?B?MkdRNkRXZDVJYVhGdWFBMVBXSWxRK29nU0tSTUZ3OWdrSXpHUGs4Tnc1UjNq?=
 =?utf-8?B?MWxCUmd4ckNSL2swSkJUK0xDRXdMNWZqVWIvZW5HWVJvN0VZWnZqa3UyL0dz?=
 =?utf-8?B?enBjSU10NHNPVVJqTzZsdG5lSXAvVEkreW1sOGxJa0FaRTdvS0NxOXQ3UXd2?=
 =?utf-8?Q?P2gmVR?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0VxaUZuUlp5WFFIdkdURUUrcUlienIvQVVWMjBtaVBvU1BiRUpMTXRxUmNE?=
 =?utf-8?B?dWkxdjRrSldrL05qLzV5dVN0bVc5VGVUUUhLVnd6SUx1M1BTV01SM0ZrMGlH?=
 =?utf-8?B?KzQ0dUlhZmQvZjEwM2tiL2pVNGFLdDNXbWpKYXV5UDgrdHB4M1kvZjR2Tmdq?=
 =?utf-8?B?em9DK2dHaW80NmpRYVIwYWR1dW5CWDBsNFhWTUlIaG1oc2hyODdmcm50cjJi?=
 =?utf-8?B?SkVJTHRKeXF3YUhPNFRqZy9wR3FaTjJRQVkrTlFYMEJOUVpwaFhFR08wVk00?=
 =?utf-8?B?UnU2R1RweVoxdnhFUFVDYVkwZjNqdTZHcDNSY29IeDA0RWt6VWVpa3ZJRzhk?=
 =?utf-8?B?L0tuckN2WkFjM2hHM05YNFdTWmM1NGpwWXRmMi9jUi9pcC9pL3RNY0RMekNp?=
 =?utf-8?B?TTFiYWRSbE9iTkhGNVYzWXZkcmVJVjFjRUdPazlZRzcwZDZkaDFlTG8xV0ta?=
 =?utf-8?B?UGRsbVFkdlZLYXduY2lSTVVhSTJKMXJMcUhiOFA1WWwzc210OUpXdmU4TlVN?=
 =?utf-8?B?VFBWNU5EbFE2aU54bGRlNWMxb0IraEhOd2lLZDJublBuMWZJWFQ5d3RxN2Jo?=
 =?utf-8?B?elk3eCtJalhsOFdqSlZhZVZ0VmVNWGVBNDlrRmRiUlI5VkVBL3RCdmxSa0R6?=
 =?utf-8?B?d2ZZMjh2dk0xOVZLck93S1U2WUI4Mm1aTm5oVWtWa2d1N1QyM1lnNHBVTjh0?=
 =?utf-8?B?K3piRFlsR2hxVDcra0pWVEZlZ0pjTUxtdFBURGY4cVUyamV2ZC9BOUd3T0w0?=
 =?utf-8?B?bkdNSUk2ZEliNzN6WEJPOU9VL1hpbEJVNkJVRTdFTTB5alpsVlNWeURKQ014?=
 =?utf-8?B?emtDRU5wc093MVFxMDlrN1UyMFpnb05aTHMwY3I0UzhveHcyVGk4N1FoVGRM?=
 =?utf-8?B?MnFUL3kra2FhN2N2MjFYMjZJYTdoQU5aRDdlSVpBaDQ4cjVFbDZkM2x2VkU0?=
 =?utf-8?B?MzU4di9neG84YUhwaVRUK3JHNllQWEs3QVR5L0xoMEdXRWFwcGpjdUtkNkNx?=
 =?utf-8?B?UkVEaFBQUHZXQ0d4dS9jTnljSnhLTGJ6eUh1Q2RqWnJOS0Q0TVY0M1d5eFE4?=
 =?utf-8?B?ejF5Um5pcDFjM2hPcWtGNlpKRDY2SzB3aDlsRXNONC93SG5zRlpkNXBiQkRR?=
 =?utf-8?B?VnFta2V2M0VtNzBMMjVMVGVSVzE0TjJ1S2lwQjJjMjJqYmpYZHAwTkg2OHBv?=
 =?utf-8?B?cEZUb3NyTUFuZng2MzFrRy9Ub3c3MlpZSnliRE5MNitIS1JCK0lLOWJJcnZJ?=
 =?utf-8?B?T2lBaXRLckxTOEE0NGNoQkhVQzZFL2JSelY0VFpGd05jdDZwZ29UMi92N3Ra?=
 =?utf-8?B?SXd6Q3AveVJPSitKTzlmMlZyWWRFaEFKcDM1cXJYam45SHB2T2VXb2ZSVVly?=
 =?utf-8?B?dVFYVUh4aDI1bkZvZlJnMFYrWHRNcjV5bCtzOEJWcnZnMnExNlc0N1QyUVVz?=
 =?utf-8?B?dTFFdGNJNnNHQTRqNXY5ZTdkaERwdHRMMEZWOGFoajhjNEt1TkRlVUxKTG9V?=
 =?utf-8?B?dGhpOTVpUm13T05hbHFIWXhwU253Yyt0cnp6VlMzK1o0ekFQUWp2bUN6Si9O?=
 =?utf-8?B?QUFTTUFMOFR4V3VZSFRRbkNjZW5tc0hISTdyWUhnR2xwWHZaanJjLzg2dE1J?=
 =?utf-8?B?VDl4eWVld3RnUUJwRUxuaWJBQS9iZnpCQkVMaHBIcElvQTNWTk9HUitvSHh2?=
 =?utf-8?B?VllBTVZYdkFHd1ltVVdEOThqUnNweVlCSUNwS1M4akNrK0Y5ZDBYaDVVYTQx?=
 =?utf-8?B?N2xrVGVFamw0TnRCODVqYUI5RjJPblhXaG1ZeVFUQVowRVBZTytZREdteURI?=
 =?utf-8?B?VG5PRzh4Mm1ZT2JIYTY2eFlxWDZxbHYrYS85eUVVVE5VZVlTU24xbmF2ZFR0?=
 =?utf-8?B?NlBlR1V2UWFuN3JqRnFGWVlsbE1zV1F5U3dYSHpKeHNrV29oZUJTa1dUZVlH?=
 =?utf-8?B?djFUaHhpZDJuWDZjcDYzejltTk13emUzNE41L0tYYmpxRGErVWUvZ3lGUkFl?=
 =?utf-8?B?T3RNRC9SVlpxbk9mQWFjZ3F6UXlzc1VvTzhzOWk2cnF4YW9uTndMZm1wOXNj?=
 =?utf-8?B?QVBYMi9FR2ZWb0lNbzBvcDlWbE15TUlUOWVYVWlEUEtrb0FJU3VMQUh6Mm1M?=
 =?utf-8?B?NFNnMjk4R3JqRlZNTFJKc0FQYmtoNllyZnFGeHdQbDczY01HY3FCR3Rtd0lk?=
 =?utf-8?Q?gm4cGraYtf5rkgTpxVhKeRc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC0CC57C4670A144ABAB4E92B5C19F9F@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 255dbc55-b158-4e3d-45e0-08de01176fa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 18:22:10.1116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zZTdKyuhEJT1CUyPirpSnw6iaYoyRvsGtSbES0SrlRU+ruVjkWUlR4NDe8fxlkHMVJywjUmN2Mv6tChnIcTfRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR15MB6608
X-Proofpoint-ORIG-GUID: 6viQEdhYB3rSbj7zcYeWAmT9ObHGmYvy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyMCBTYWx0ZWRfX8dC4gBAa3yZt
 3PhXplkdtEcCeUl4aaPlv2A98OY8AhL72Jnou6sF0R6BWHtqYNUxVp6Kk/qkyGBS5WTmgVq/iXe
 TMuVFcbsWuQy+mFne9WbR/DrvmxM9tlSDxjzuocgBmsFwQAogRFh3J9Kusk/8oONC10KHOMSBjh
 pcIA9+A3SI7H2K4KxHmMYXpxffgouH2bgKtkkYNIW7rbGO/dPAJoQKG3cV1La1ntCZRkDSGcJtY
 9zrm6obaUBGZuxPWztoa9YjV2JKdt+0srDomf3jTAshNz7X4WOFgyFU+HReKD0dLdo1hZ5jOpDz
 97D3rm0BeemDX7/h6sJI7jOVinq3erzlQBBbx8F/wCasnwjQPyS6LLNqsQR9MAErNI56Bds1kKA
 SZH4AqSCbcPfu7WOtsVdeqdHPj1rwQ==
X-Proofpoint-GUID: FsjvF_Oyk4PvyW2E4QARJwLDIR6YSmm4
X-Authority-Analysis: v=2.4 cv=Jvj8bc4C c=1 sm=1 tr=0 ts=68dd7157 cx=c_pps
 a=P2JTm3oOj23y55bZWJDDIw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=LM7KSAFEAAAA:8 a=Sxmhp_VLkY4ny8O0UrcA:9
 a=QEXdDO2ut3YA:10
Subject: RE: [PATCH 1/2] ceph: fix snapshot context missing in
 ceph_zero_partial_object
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_05,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270020

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDExOjM0ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBWaWFj
aGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g5pa8IDIwMjUt
MTAtMDEgMDI64oCKMzMg5a+r6YGT77yaIE9uIFR1ZSwgMjAyNS0wOS0zMCBhdCAxNTrigIowNyAr
MDgwMCwgZXRoYW53dSB3cm90ZTogPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLiBEdWJleWtv
QCBpYm0uIGNvbT4g5pa8IDIwMjUtMDktMjcgMDU6IDQxIOWvq+mBk++8miBPbiBUaHUsIDIwMjUt
MDktMjUgYXQgMTg6IDQyICswODAwLCBldGhhbnd1DQo+IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xh
dmEuRHViZXlrb0BpYm0uY29tPiDmlrwgMjAyNS0xMC0wMSAwMjozMyDlr6vpgZPvvJoNCj4gPiBP
biBUdWUsIDIwMjUtMDktMzAgYXQgMTU6MDcgKzA4MDAsIGV0aGFud3Ugd3JvdGU6DQo+ID4gPiBW
aWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g5pa8IDIw
MjUtMDktMjcgMDU64oCKNDEg5a+r6YGT77yaIE9uIFRodSwgMjAyNS0wOS0yNSBhdCAxODrigIo0
MiArMDgwMCwgZXRoYW53dSB3cm90ZTogPiBUaGUgY2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0IGZ1
bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFwc2hvdCA+IGNvbnRleHQgZm9yIGl0cyBPU0Qg
d3JpdGUgb3BlcmF0aW9ucywgd2hpY2gNCj4gPiA+IA0KPiA+ID4gVmlhY2hlc2xhdiBEdWJleWtv
IDxTbGF2YS5EdWJleWtvQGlibS5jb20+IOaWvCAyMDI1LTA5LTI3IDA1OjQxIOWvq+mBk++8mg0K
PiA+ID4gPiBPbiBUaHUsIDIwMjUtMDktMjUgYXQgMTg6NDIgKzA4MDAsIGV0aGFud3Ugd3JvdGU6
DQo+ID4gPiA+ID4gVGhlIGNlcGhfemVyb19wYXJ0aWFsX29iamVjdCBmdW5jdGlvbiB3YXMgbWlz
c2luZyBwcm9wZXIgc25hcHNob3QNCj4gPiA+ID4gPiBjb250ZXh0IGZvciBpdHMgT1NEIHdyaXRl
IG9wZXJhdGlvbnMsIHdoaWNoIGNvdWxkIGxlYWQgdG8gZGF0YQ0KPiA+ID4gPiA+IGluY29uc2lz
dGVuY2llcyBpbiBzbmFwc2hvdHMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gUmVwcm9kdWNlcjoN
Cj4gPiA+ID4gPiAuLi9zcmMvdnN0YXJ0LnNoIC0tbmV3IC14IC0tbG9jYWxob3N0IC0tYmx1ZXN0
b3JlDQo+ID4gPiA+ID4gLi9iaW4vY2VwaCBhdXRoIGNhcHMgY2xpZW50LmZzX2EgbWRzICdhbGxv
dyByd3BzIGZzbmFtZT1hJyBtb24gJ2FsbG93IHIgZnNuYW1lPWEnIG9zZCAnYWxsb3cgcncgdGFn
IGNlcGhmcyBkYXRhPWEnDQo+ID4gPiA+ID4gbW91bnQgLXQgY2VwaCBmc19hQC5hPS8gL21udC9t
eWNlcGhmcy8gLW8gY29uZj0uL2NlcGguY29uZg0KPiA+ID4gPiA+IGRkIGlmPS9kZXYvdXJhbmRv
bSBvZj0vbW50L215Y2VwaGZzL2ZvbyBicz02NEsgY291bnQ9MQ0KPiA+ID4gPiA+IG1rZGlyIC9t
bnQvbXljZXBoZnMvLnNuYXAvc25hcDENCj4gPiA+ID4gPiBtZDVzdW0gL21udC9teWNlcGhmcy8u
c25hcC9zbmFwMS9mb28NCj4gPiA+ID4gPiBmYWxsb2NhdGUgLXAgLW8gMCAtbCA0MDk2IC9tbnQv
bXljZXBoZnMvZm9vDQo+ID4gPiA+ID4gZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3AvY2FjaGVz
DQo+ID4gPiA+IA0KPiA+ID4gPiBJIGhhdmUgb24gbXkgc2lkZTogJ2VjaG8gMyA+IC9wcm9jL3N5
cy92bS9kcm9wX2NhY2hlcycuDQo+ID4gPiANCj4gPiA+IFRoYW5rcyBmb3IgcG9pbnRpbmcgdGhp
cyBvdXQsIEknbGwgdXBkYXRlIGluIFYyLg0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4g
bWQ1c3VtIC9tbnQvbXljZXBoZnMvLnNuYXAvc25hcDEvZm9vICMgZ2V0IGRpZmZlcmVudCBtZDVz
dW0hIQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEZpeGVzOiBhZDdhNjBkZTg4MmFjICgiY2VwaDog
cHVuY2ggaG9sZSBzdXBwb3J0IikNCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBldGhhbnd1IDxl
dGhhbnd1QHN5bm9sb2d5LmNvbT4NCj4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiDCoGZzL2NlcGgv
ZmlsZS5jIHwgMTcgKysrKysrKysrKysrKysrKy0NCj4gPiA+ID4gPiDCoDEgZmlsZSBjaGFuZ2Vk
LCAxNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
ZGlmZiAtLWdpdCBhL2ZzL2NlcGgvZmlsZS5jIGIvZnMvY2VwaC9maWxlLmMNCj4gPiA+ID4gPiBp
bmRleCBjMDJmMTAwZjg1NTIuLjU4Y2MyY2JhZThiYyAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9m
cy9jZXBoL2ZpbGUuYw0KPiA+ID4gPiA+ICsrKyBiL2ZzL2NlcGgvZmlsZS5jDQo+ID4gPiA+ID4g
QEAgLTI1NzIsNiArMjU3Miw3IEBAIHN0YXRpYyBpbnQgY2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0
KHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ID4gPiA+ID4gwqDCoHN0cnVjdCBjZXBoX2lub2RlX2lu
Zm8gKmNpID0gY2VwaF9pbm9kZShpbm9kZSk7DQo+ID4gPiA+ID4gwqDCoHN0cnVjdCBjZXBoX2Zz
X2NsaWVudCAqZnNjID0gY2VwaF9pbm9kZV90b19mc19jbGllbnQoaW5vZGUpOw0KPiA+ID4gPiA+
IMKgwqBzdHJ1Y3QgY2VwaF9vc2RfcmVxdWVzdCAqcmVxOw0KPiA+ID4gPiA+ICsgc3RydWN0IGNl
cGhfc25hcF9jb250ZXh0ICpzbmFwYzsNCj4gPiA+ID4gPiDCoMKgaW50IHJldCA9IDA7DQo+ID4g
PiA+ID4gwqDCoGxvZmZfdCB6ZXJvID0gMDsNCj4gPiA+ID4gPiDCoMKgaW50IG9wOw0KPiA+ID4g
PiA+IEBAIC0yNTg2LDEyICsyNTg3LDI1IEBAIHN0YXRpYyBpbnQgY2VwaF96ZXJvX3BhcnRpYWxf
b2JqZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ID4gPiA+ID4gwqDCoMKgb3AgPSBDRVBIX09T
RF9PUF9aRVJPOw0KPiA+ID4gPiA+IMKgwqB9DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gKyBzcGlu
X2xvY2soJmNpLT5pX2NlcGhfbG9jayk7DQo+ID4gPiA+ID4gKyBpZiAoX19jZXBoX2hhdmVfcGVu
ZGluZ19jYXBfc25hcChjaSkpIHsNCj4gPiA+ID4gPiArICBzdHJ1Y3QgY2VwaF9jYXBfc25hcCAq
Y2Fwc25hcCA9DQo+ID4gPiA+ID4gKyAgICBsaXN0X2xhc3RfZW50cnkoJmNpLT5pX2NhcF9zbmFw
cywNCj4gPiA+ID4gPiArICAgICAgc3RydWN0IGNlcGhfY2FwX3NuYXAsDQo+ID4gPiA+ID4gKyAg
ICAgIGNpX2l0ZW0pOw0KPiA+ID4gPiA+ICsgIHNuYXBjID0gY2VwaF9nZXRfc25hcF9jb250ZXh0
KGNhcHNuYXAtPmNvbnRleHQpOw0KPiA+ID4gPiA+ICsgfSBlbHNlIHsNCj4gPiA+ID4gPiArICBC
VUdfT04oIWNpLT5pX2hlYWRfc25hcGMpOw0KPiA+ID4gPiANCj4gPiA+ID4gQnkgdGhlIHdheSwg
d2h5IGFyZSBkZWNpZGVkIHRvIHVzZSBCVUdfT04oKSBpbnN0ZWFkIG9mIHJldHVybmluZyBlcnJv
ciBoZXJlPyANCj4gPiA+IA0KPiA+ID4gSSBmb2xsb3cgdGhlIHJlc3Qgb2YgdGhlIHBsYWNlcyB0
aGF0IHVzZSBpX2hlYWRfc25hcGMuDQo+ID4gPiBUaGV5IGNhbGwgQlVHX09OIHdoZW4gY2ktPmlf
aGVhZF9zbmFwYyBpcyBOVUxMOw0KPiA+ID4gYnV0IHJ1bm5pbmcgLi9zY3JpcHRzL2NoZWNrcGF0
Y2gucGwgLS1zdHJpY3QsIGl0IHdhcm5zIHRoYXQgYXZvaWQgdXNpbmcgQlVHX09OLCANCj4gPiA+
IGlmIHRoaXMgaXMgdGhlIGxhdGVzdCBjb2Rpbmcgc3R5bGUsIEkgY2FuIGNoYW5nZSBpdC4NCj4g
PiANCj4gPiBGcmFua2x5IHNwZWFraW5nLCBpdCBpcyBwb3NzaWJsZSB0byBjb25zaWRlciB2YXJp
b3VzIHdheXMgb2YgcHJvY2Vzc2luZyBsaWtld2lzZQ0KPiA+IHNpdHVhdGlvbnMuIERldmVsb3Bl
cnMgY291bGQgcHJlZmVyIHRvIGhhdmUgQlVHX09OKCkgdG8gc3RvcCB0aGUgY29kZSBleGVjdXRp
b24NCj4gPiBpbiB0aGUgcGxhY2Ugb2YgcHJvYmxlbS4gSG93ZXZlciwgZW5kLXVzZXJzIHdvdWxk
IGxpa2UgdG8gc2VlIHRoZSBjb2RlIHJ1bm5pbmcNCj4gPiBidXQgbm90IGNyYXNoaW5nLiBTbywg
ZW5kLXVzZXJzIHdvdWxkIHByZWZlciB0byBzZWUgdGhlIGVycm9yIGNvZGUgcmV0dXJuZWQuIEFu
ZA0KPiA+IHdlIGFyZSB3cml0aW5nIHRoZSBjb2RlIGZvciBlbmQtdXNlcnMuIDopIFNvLCByZXR1
cm5pbmcgZXJyb3IgY29kZSBpcyBtb3JlDQo+ID4gZ2VudGxlIHdheSwgZnJvbSBteSBwb2ludCBv
ZiB2aWV3Lg0KPiANCj4gwqANCj4gT0ssIHRoZW4gSSdsbCByZXR1cm4gZXJyb3IgY29kZSBoZXJl
Lg0KPiBJIGRvbid0IHNlZSBhbnkgc3BlY2lmaWMgZXJybm8gc3VpdGFibGUgZm9yIHRoaXMgY2Fz
ZSzCoGlzIHJldHVybiBFSU8gb2sgaGVyZT8NCj4gwqANCj4gDQoNCkFzIGZhciBhcyBjYW4gc2Vl
LCAtRUlPIGxvb2tzIGxpa2UgcmVhc29uYWJseSB3ZWxsIGVycm9yIGNvZGUgZm9yIHRoaXMgZnVu
Y3Rpb24sDQoNClRoYW5rcywNClNsYXZhLg0K

