Return-Path: <ceph-devel+bounces-3481-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AC7B38A03
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Aug 2025 21:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E1E0462BBE
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Aug 2025 19:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3902D4B44;
	Wed, 27 Aug 2025 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DgMQmadL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05662D238C
	for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756321639; cv=fail; b=IDmS13kgxabhPLZCv94pAbUd19HgrgXBtflEOdMIFi3RG2Wwd64WYQQR0QJFa6FwZzXz53VJxHhTLDF6TPRavri4UdZHILL5WrO61rrWdux/FiKCjWnyjTp+4IF2N+/tkmIm1Oz85cCSDmShh++8X7+BlXhtg98y4Ujb3giZWco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756321639; c=relaxed/simple;
	bh=ez6t38wr6ZFGH206yaqPp3kz4wX4s2aYX6LNt5ZBhoY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=cMprtKkNdR2+PQU4I8ZAKLrarKBVCMub2WzzsIK59548wEm9fKjKvMKr2HmhbxCGZVCHMrbwX99xrYR6oJF0rxuwoWbqp2CB99EcTNoCiAtLAkyEPsYbhQFUGY4FErE6QcUETon+Rt0OymAsygGa0ps3ysOHsjyM7q3ybxAvpkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DgMQmadL; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RAAbcd012769
	for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 19:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=9k59yZHoN/ejXGJHpEAydYc1MUiICAaAx7NkjnGSxqg=; b=DgMQmadL
	p+eJL2STGK0UZeGMqNLaYAuH/A7buv5MQJ22DS+AH6931xvZYMMcpZNI8deiSamn
	qTC23sGnPB7dpn+YsTq4HlP/oj7Aa4p8Ze8GaqNAwUfgqBkbI7NXvw7v0G2Sgvow
	yl0loW2rcOYYI49ZQqlVVJhEnaSu9Ou1GzaNMcj/dBKzbHKRB7r/GpOeKt8ROw3l
	z2Q1G2A54PsYHtuSijt73xMf7CEcKI5PbpJ4sn7yA4CZpoRggg16rzU3NSIiFiCH
	+l5x/+iDUFLdcRQtyTgyfU3vgSxSa+p8ok0idTViGFsd88KhJkRAzvE6lumsod1j
	V5U4m53ngNdrrg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hq5n4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 19:07:16 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57RJ0fTB011532
	for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 19:07:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hq5n4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 19:07:16 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57RJ2DYC014506;
	Wed, 27 Aug 2025 19:07:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hq5n4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 19:07:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhnrANwfQLozq118UNTX/EZBQKD3bTkVKrqDfrYZXa8EIFxV5aNNpujjFjIarOA+ZE10+rbMJOUarinDDMzEOt/eCJjekwcU47XRQzhOLu4B5xm2bwSkxIq1Lp8Qfmxeo5l079JMPj3nGwh4FhNc2Nw4OfzfZrwhn2LL/ezHs0Jko7uKXC6SpB/ihkzaxWZEGjGx44p2GOxcZnlnqB5OP4iGeUVu+oU+SeVeE+rKX2Vq7JDwFTiaiJAgqepxlbjFWD/RUVN4+G8YbP+maKjPS+M/KmQTxYWKgZ/O/nzKlpwFAUe7oybRYIlVQhUGkuYwVYrYioloVroWtMMPtJT7uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruc9BCH9th08uqUvHc86l3gH+sV2Rz0+6/BXipNUz+Q=;
 b=O0+2gVoWuhw5DOFLhA+QprxA+062k6ZQJrD1Ap60+SrT1vVDoWJFEDRZ84BT1dtZKV8CCGDXg/sVSNf9ggrm/F3+fmg0WwFBSbbHrVSXkmmYgsgbHpgeQVkLuQbeXwlFkvlA8jw8BdtHfyuHA3CUKsW4H3U+Fi/97vvvbsOTn7P1E3HlVM1EBGts1XkvvZ28VNyZG5CcDoyKk6iczzg2fKrSdONMIqV3G/TMUWVWUxN4THHfBNCrxwpNe7mMWNrqBq6B9C1vDJv8Tn+a+Lp3yImq6dJPpiAXF8U7QoZqOdIu606DyWFlP6il2ba2qupAZgLA+zMj1WuutgmptOZxgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4495.namprd15.prod.outlook.com (2603:10b6:510:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 27 Aug
 2025 19:07:12 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9031.023; Wed, 27 Aug 2025
 19:07:12 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
Thread-Index: AQHcF37TjyxHalgGV0mBo181XsScDbR23JgA
Date: Wed, 27 Aug 2025 19:07:12 +0000
Message-ID: <f4a614b0955d64b029a8b428c1c86a41fb697300.camel@ibm.com>
References: <20250827181708.314248-1-max.kellermann@ionos.com>
In-Reply-To: <20250827181708.314248-1-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4495:EE_
x-ms-office365-filtering-correlation-id: 27e1d8db-1565-4a96-bcb9-08dde59cee0a
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SW1tSkpRcUtkcWZacXI3dlF1L0hrRWxsRmx6eExEVzZtRHZab1dPc1hrRVVM?=
 =?utf-8?B?SlZXWnNxM0w3aXdOdEJnUHo3Z3cvcWFyRG5tcFRNZjczUnA4WVJIZkpwWDVR?=
 =?utf-8?B?ckVsaG8vZDl3SXl2ai96M2xCQ1d1RkIzOVBSWThhT0EyOHRGZEJOanEvMTNF?=
 =?utf-8?B?Z1FFQ0FLL1czZWxOM0YxQURVdUppZFNmWVFScmY0WWkxekVHaXRHUGk1NnU2?=
 =?utf-8?B?Kzg2NXRJNWtyclBTSlArL0Q3SVZ1NkFKODZtNW51K2lEUWdXNWIwVWNvTk4z?=
 =?utf-8?B?VWhmTzNZWG00Tm9CUzBNbVNFNVZEODdsTUlRclh2TGNlN0RyNjMveldBd1hJ?=
 =?utf-8?B?UmxmTEpNelY5YW81SG03WWd3dm92TnBhaWU2RVZseDFNYVdNK0FRZWZKbFgr?=
 =?utf-8?B?VFZTM3lTRW9jU1ZMdnhqUHVCN3JIWkNCdWM4empGcUY1QXRxVHNXOVM4V210?=
 =?utf-8?B?UlJqWVFDUlFBZTNCUlZnaVhTNXRsWktpM1NUOXVIVDNMSlBBTTd5TEtmbTh6?=
 =?utf-8?B?ZXlMdGdVQVRzK0xYYm4wOFNaelExLzUyQU9YNHUvNHpvZ3FZc3llOU1ZcmVD?=
 =?utf-8?B?UVY1K0s4YkMxUlNnMnp3cCthVU1LNlpWbXdEaEpHa2dvNitqbHFDcjIzNGp4?=
 =?utf-8?B?WjBpbDZPTDE3N0FaMm9QcWZqZGpWQTdyTno3dE83WFY2SWNGclcvRE5qMlhr?=
 =?utf-8?B?UVovSVhUeHBHQmxISlZlSWhFcGRNQi9JVUFPWFNGRFF4N2owa0tHWVFtZ2tl?=
 =?utf-8?B?ZVNlYW5oUVR5MVZ4TnRHY3ZSdURGUlJpTTY2VEF4cGlGRElkM2dkMWtLazc2?=
 =?utf-8?B?cGFndFYrb09heW9pVXpWaktPUlBMNU1oTVdINXU5SXZQcnEyUmNCUVpxRGZN?=
 =?utf-8?B?RXdFOGdDaDZGL2NReE40aDc5K1FFZDgzSTdPMHY5M0FjY1BhY0gwR3B5dklG?=
 =?utf-8?B?NmlDTFdIWXlXaGZJMklWYWpJdmg2ZFFUS0syNEt3WHQ0SElTSVhYR0tGeVBq?=
 =?utf-8?B?aHk5YkxheHFaSE96UjJLTUo5TXhDOHJZTlRqbnh5WmRHOExheUVsVzFmYU4y?=
 =?utf-8?B?ei9hb0VWN1NHZ1V3Szc1RHlmRUpoWFVFUU5VcGtqSGs2RVJGWUQ4REdhOTBo?=
 =?utf-8?B?L0hvUEg2cGZsNTM5OGs4SW0xRTR6Yyt3eWFTSTFEbmdtckdmV2YxcDRqT1Nr?=
 =?utf-8?B?VUJwRXJ5VlpZK0tXZ3pLWlQzNWdVeGZZRkdqaDBHT0l4OWU5OTlVYmVqMzVD?=
 =?utf-8?B?M05zMGtReEpjU3o5QXhhSndOdXVVZXJIb2JvSlZSSkw1NXBiRE9md051Q29o?=
 =?utf-8?B?Y0VDeWZWMUU4aDdaOEZDcitHT250cmZzVm85YWUzV2h4dDBPQWNaQWN3S2w4?=
 =?utf-8?B?ZjFTUFlaZVRrNGx6Z2Z2Z203TnowTkhNOEg3ZnZOZjhKV2toaXdBSk14YzJq?=
 =?utf-8?B?bkdyM3hKTFJCU2NpaFFRT1VTRG9HY2Q4TTBzTFBPcG5pYmxDNGxyV3d5OFAx?=
 =?utf-8?B?UGxIZWR3NytnTDNzSVZ3aGtsc29PNzM0OU91MWkrK0Q2ZTE3c1ZFMGNRYTVw?=
 =?utf-8?B?bUNBMTY1ZGJWazBBQkNkQ3NjQktLOG5CaU5BeFRmM1B2dDVDMlFJNmNUcWo5?=
 =?utf-8?B?ZEYxUTkyRm1aWmZMZU5ib0x1aEhwSmVwTzQxeVNudXBiQlF0WUl3WEhidm5W?=
 =?utf-8?B?K2RzYUhDaGVvZVMwbDF3amZORVdKK0kvbHZmeUl5bEpTTk9qNkRIQ2Yxend0?=
 =?utf-8?B?VzJzVkxZZHdjamlBM2lkNE1uN043c0VnSFRXQU05REVZck1WblZlQWNPdEV4?=
 =?utf-8?B?Z3A5K21hSTU2RXpiNnIrN2N1SXc0dy9CRlp6Sk5KZ0s1dGNiclFOdkluQ1BU?=
 =?utf-8?B?L25IU2lZMEgzV0hnZGhxdXpHL0U5Y1g4NXZGTFY4WnVNTU5xVDZ6b2dlZ0Q5?=
 =?utf-8?B?dHhXTU40N0lRUGdGcHdsRjJQZjNueDZacFpMNUdPSnUyZEdsZERibnFOWkZS?=
 =?utf-8?Q?CSC1TrjSKBfvcn/mS2IVFJVZPNtwG8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?am5YSGJQTCtEUjVUQXNJcXBLMm14WVIzNzFMamE0TVZ5d1V4b3VybFZybThh?=
 =?utf-8?B?U09hWldtOTNMaTBZdWdlclg2dFhTeWVGaUpNMThtUml4b0hlZmlBZnRrSjNV?=
 =?utf-8?B?Z2QyNGZwYTVOdXZPWE5vbm9IMjlTbDlRY3F5bitRcEo5Ti9Ebit6VEtsWllk?=
 =?utf-8?B?WXgxQ0xUTXlSMXhkQS9wSEJlRHhtaXJRbHlQdFc5a1l0N0s3SXdLRC9XQ0hw?=
 =?utf-8?B?NSswNWtWM0M2SWRpaSs5ZVprMmxOc29VT1VuSzJaRTQ4Zjc5bHJoNEVWN2Vj?=
 =?utf-8?B?SXpjMGpWN3pVSmx2ZmNwUCt3MFR2TGpTZFdMNEgrKzBjbmFOckZ3M0szTkc3?=
 =?utf-8?B?Qk9idVpCdHZLM1I5UEFvMytRVW5SMzZ5UU95Y0RXWUVIWXVVUWxoYW5ORXll?=
 =?utf-8?B?NGRIZjQ1MjBIdENxMG1LeklJUThLTDB4STU3TzllYUZWSUV2dktOaU5UV243?=
 =?utf-8?B?bklhb3lyd1FWZys4ZTRXK1VHRE1zbU10QXY2VkQ0VWVFZThiNkVvZ1RwZVZ6?=
 =?utf-8?B?dkFCeWJkVlo2N2hXUU92OW8vdFQ1QWdtSFoxQ1JlNGxtMjNCQ05xT1Noc3hr?=
 =?utf-8?B?NlRNbHlZYUdES2lxNXloeWpzbE1SVkhxMGNaMUtZZUxFK0FuSzFhenlFdWRa?=
 =?utf-8?B?dTliUWtLOXAzeEVjU3VKemFhM3ByWUs1V2VzVEVJcFJHTHphRFJHbGJwM3J1?=
 =?utf-8?B?bklhMjhGQUtxOG9scUZIS2UwQytMU0VWWU81MFNZRXd4dXY0S1BrUm1GZStj?=
 =?utf-8?B?V0lnZ0hxWHR2ekMrM040TVhhUllOR1gxczBOMDRlTDhrUW1CRGxXUXVvSmdT?=
 =?utf-8?B?a1FNWW9zZWJSQWRpOFR1OHZvLzJOMTJ3cnA2WFNQUmh4L3o4WVp5dDFDSCtR?=
 =?utf-8?B?UmM2VGhFZjFnc2QzaWFHQmtUYXptVzQzSWczTHg1MXg2a0dkMkozZUdobGo2?=
 =?utf-8?B?d2U4elhpMHZ2bngvdm02NlFoK1V5M3ZpNTBWdUVYQWlKanpXSlFMaXlmUUJq?=
 =?utf-8?B?a0ZTMGpQeDNkeGlkUEh0djhWUnJSMDVnT1h5Vis3b3VFWkVzSXpQL2pJTUtZ?=
 =?utf-8?B?TzlKVnB6aE9JYmRMOWNFMjBOSUNPbEU2OEJhSmdGZmswQnl2UzFYMjdRb0Ra?=
 =?utf-8?B?Y1V2c20xMlgzRXpHTDY3TkF1Y2RDcnRtL0k0OXA5VXJDRm5YcDZSOGdzZlRM?=
 =?utf-8?B?KytEYU9iTHRCanFKK3JJSFNCc2lmc1BOYzJ4aHBtUGxKd3NNcWNsUFJvcG85?=
 =?utf-8?B?N00xV09nUnozZ01GZ3Y5V3JuMmZPdkdKb3JRaVA4U3lMS0lFTU5NaHdqQ0hI?=
 =?utf-8?B?MlQvYWFzeHJrK1FhYVNQZkpGd2VMdWV4S1NXVS90aDk3bkdVd2dhcHZaVUNv?=
 =?utf-8?B?ZVNxdzNrem1vdTdJZC85cHB1QWtzc0NxOUsyQ3BXRi9JYTVTV3FKRDFIWFk4?=
 =?utf-8?B?a2tLSnpHTGR6ZE5VdXhURWF3WVE0ZG9JRlpqblJjQy9tMDViYnZRVzhzaGNW?=
 =?utf-8?B?SXpUcXgxTUVjVjArSE1EdGRqUlVZZmpWOHhDbEQzM01mVlFyTmUvZFg4bUtz?=
 =?utf-8?B?dFFNRGxiT2R2TWRsVDJFNU12cmhoRk83TWw2SUdTTnNNZVE1MXJRZHlPU1o3?=
 =?utf-8?B?U1JBTm9DRWtuU255aDZVcHVKZjFGaXFLaUluSTB0MUxkRFhMazBHZllsWE96?=
 =?utf-8?B?Ukp4UXdzUFVBdGZrOHFycmMvZkcyd0RJUXBWOUQ3anR3dHI0SmtsU0VLSmhh?=
 =?utf-8?B?ZndIUW9qRXZoRzBWZC93L0pkZEt4V0ZBMjF2U09SdCs0cXJ6NktBNFRhSEVV?=
 =?utf-8?B?WlZaNlhid0hBdVptZGJOeTNoOXNPeFJvNzRBcXFyNm1od2ErWW9pT2pGWFRP?=
 =?utf-8?B?NW10azVHMk5NQ0FyNUNuNU1TdkZZUEJZM09RaDY5dlhIMFpmUy9CU2EvTVVB?=
 =?utf-8?B?czZxVGpDclIvZkdTaFQrWExzbkhTcWRFZStJc3U1VkZnSFdUd0J0bVI1Mnhz?=
 =?utf-8?B?TXBrcURjR3dxTUlERnZmVjFWeG5JZ09tZUxqbEZPNlB2b2dKamV6MC9oaXdC?=
 =?utf-8?B?clFHZjNoaStXSXNCZ054UG44bzk1eGc0ZTBHL3NkbnFvN1JTY0dLdXBnYkJn?=
 =?utf-8?B?NmEvUEdrbHhOa2dKQXRwY2pPNXpTQ3VGM3pTcDU2VndNN3ZwK0RzdlZmNVli?=
 =?utf-8?Q?9X5H5SD98ClheeBQk6w93Hk=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e1d8db-1565-4a96-bcb9-08dde59cee0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 19:07:12.7705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cWuT/5Ga5jtZnOHvgUz5gNQAac+qxpBBCXiKV1mSNDJrAOzSWLGeLjWTD7FTuS17P9bkWaOuZyTv4VMHArcM9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4495
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfXx+GDgeWLZFo8
 nGUWI6dgMhrHc3xP5kvtjFPThWzLt9ypejUnM4xJlnvbiQh4wf8Z4PVtUTzB2SILUs2QCcfTtwK
 v/LPchr+WEDwEUd0x0HstGciVD5X7H+OsemDGI091O3IlafzSa0M9uHxchlgq7uSyRRaw5QkVT3
 45GqKaPsK1QXPV8IuAfLETicYzGyHekTcsPL+SJn1PjxKwkwo2Yeav9lKV/hpaNhAwgJHhUZj8Q
 olkY5871IWQFtaFijhQrEQhp3w70iQDZQ+lX0IadiFdudEDUEKw1yveRR46HYlW8LZ8J445yf/+
 KThF6euglOa8lfM5i85rOIbFtBSjhDXGg9Wpvf04G8JvA/TL7t+Jtd8MoSJfGsKRDAysC6YlsCr
 K8P/AGAX
X-Proofpoint-ORIG-GUID: fKuw9G3V9shEdsLgVKpmR6ZFXoruz2EE
X-Proofpoint-GUID: Xv0yyFyEmBoUTUq0BDOBVMeUknk64zFT
X-Authority-Analysis: v=2.4 cv=Ndbm13D4 c=1 sm=1 tr=0 ts=68af5764 cx=c_pps
 a=DjE2RDNjhBNSN6KFZjFOjA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=UgJECxHJAAAA:8 a=6mJSjco3ShBnIWj8FJkA:9
 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
Content-Type: text/plain; charset="utf-8"
Content-ID: <A009E1023EE1EA48A2585E25F9001036@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1011 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=2
 engine=8.19.0-2507300000 definitions=main-2508230021

On Wed, 2025-08-27 at 20:17 +0200, Max Kellermann wrote:
> The function ceph_process_folio_batch() sets folio_batch entries to
> NULL, which is an illegal state.  Before folio_batch_release() crashes
> due to this API violation, the function
> ceph_shift_unused_folios_left() is supposed to remove those NULLs from
> the array.
>=20
> However, since commit ce80b76dd327 ("ceph: introduce
> ceph_process_folio_batch() method"), this shifting doesn't happen
> anymore because the "for" loop got moved to
> ceph_process_folio_batch(), and now the `i` variable that remains in
> ceph_writepages_start() doesn't get incremented anymore, making the
> shifting effectively unreachable much of the time.
>=20
> Later, commit 1551ec61dc55 ("ceph: introduce ceph_submit_write()
> method") added more preconditions for doing the shift, replacing the
> `i` check (with something that is still just as broken):
>=20
> - if ceph_process_folio_batch() fails, shifting never happens
>=20
> - if ceph_move_dirty_page_in_page_array() was never called (because
>   ceph_process_folio_batch() has returned early for some of various
>   reasons), shifting never happens
>=20
> - if `processed_in_fbatch` is zero (because ceph_process_folio_batch()
>   has returned early for some of the reasons mentioned above or
>   because ceph_move_dirty_page_in_page_array() has failed), shifting
>   never happens
>=20
> Since those two commits, any problem in ceph_process_folio_batch()
> could crash the kernel, e.g. this way:
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000034
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD 0 P4D 0
>  Oops: Oops: 0002 [#1] SMP NOPTI
>  CPU: 172 UID: 0 PID: 2342707 Comm: kworker/u778:8 Not tainted 6.15.10-cm=
4all1-es #714 NONE
>  Hardware name: Dell Inc. PowerEdge R7615/0G9DHV, BIOS 1.6.10 12/08/2023
>  Workqueue: writeback wb_workfn (flush-ceph-1)
>  RIP: 0010:folios_put_refs+0x85/0x140
>  Code: 83 c5 01 39 e8 7e 76 48 63 c5 49 8b 5c c4 08 b8 01 00 00 00 4d 85 =
ed 74 05 41 8b 44 ad 00 48 8b 15 b0 >
>  RSP: 0018:ffffb880af8db778 EFLAGS: 00010207
>  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000003
>  RDX: ffffe377cc3b0000 RSI: 0000000000000000 RDI: ffffb880af8db8c0
>  RBP: 0000000000000000 R08: 000000000000007d R09: 000000000102b86f
>  R10: 0000000000000001 R11: 00000000000000ac R12: ffffb880af8db8c0
>  R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bd262c97000
>  FS:  0000000000000000(0000) GS:ffff9c8efc303000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000034 CR3: 0000000160958004 CR4: 0000000000770ef0
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   ceph_writepages_start+0xeb9/0x1410
>=20
> The crash can be reproduced easily by changing the
> ceph_check_page_before_write() return value to `-E2BIG`.
>=20
> (Interestingly, the crash happens only if `huge_zero_folio` has
> already been allocated; without `huge_zero_folio`,
> is_huge_zero_folio(NULL) returns true and folios_put_refs() skips NULL
> entries instead of dereferencing them.  That makes reproducing the bug
> somewhat unreliable.  See
> https://lore.kernel.org/20250826231626.218675-1-max.kellermann@ionos.com =
=20
> for a discussion of this detail.)
>=20
> My suggestion is to move the ceph_shift_unused_folios_left() to right
> after ceph_process_folio_batch() to ensure it always gets called to
> fix up the illegal folio_batch state.
>=20
> Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
> Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/=
 =20
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  fs/ceph/addr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8b202d789e93..8bc66b45dade 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1687,6 +1687,7 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
> =20
>  process_folio_batch:
>  		rc =3D ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> +		ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
>  		if (rc)
>  			goto release_folios;
> =20
> @@ -1695,8 +1696,6 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>  			goto release_folios;
> =20
>  		if (ceph_wbc.processed_in_fbatch) {
> -			ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
> -
>  			if (folio_batch_count(&ceph_wbc.fbatch) =3D=3D 0 &&
>  			    ceph_wbc.locked_pages < ceph_wbc.max_pages) {
>  				doutc(cl, "reached end fbatch, trying for more\n");

Let us try to reproduce the issue and to test the patch.

Thanks,
Slava.

