Return-Path: <ceph-devel+bounces-2265-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3E39E789B
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 20:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8435C18864FB
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 19:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C33F1D89EC;
	Fri,  6 Dec 2024 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sVDm2DZ2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBCC1953BA;
	Fri,  6 Dec 2024 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733512323; cv=fail; b=hfIA+ppcZzsRIBXBYPLC4824pNBZEVTxq0+HPI9qkX0PemnxP2N9pmUw0UTXkZ8jT0mch91bkX64zPypbek2TdV/1O4ecVB3spvf6TXJ6JWI1DJ/QX0c4SAgvylZa8XQt8cZPT8saRmnr89uLzIvN7hNr+C1uY0Lxjjonxe0hPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733512323; c=relaxed/simple;
	bh=uG7Y9eFJ6fdaKRUl8LjEJQbAfblAWeyhzJtKd+Fx14o=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=QOwVjK/Ltg9iKKNlWl0dj1YkRTX/E8HrMSQwpoQMkQyC9Tlj0a28Nlr9FEeF4G19O/3aHfntdMW6SYcUBmqxv1XNy+TjH6rsbAMdMEMY0oRss+fqkjFpg1PVlThMgZXCqfTa7j80yBmMjIdlQsSR1zH3aSx7E8yVfRs1Gc5y9To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sVDm2DZ2; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B69UMIc027563;
	Fri, 6 Dec 2024 19:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=uG7Y9eFJ6fdaKRUl8LjEJQbAfblAWeyhzJtKd+Fx14o=; b=sVDm2DZ2
	wn7oxgDvL+4n3QfHc9UINs/bakrPaBTBnth/DxpjCOMu0uyHB5QAZjwt6eGElCSY
	NuiQlRK6luJIIWUdDoCS+9tghNu6D5KKrit0++mLKCRs1EeCo6sFFvjf3gTQqbxo
	GOjps1A+G2pvHnDfWWAE8fBDeAWRd9cGxbEOEiLBHjOIuNFosNFFO7g0OayW/ZeH
	zOl/QguY3CQn8GKIMMfd7RMRo0TNOLgLV8mHLM8E/xIsSK/bcSoLe33KaQgEelkk
	l11Rp0kAhQhOTNYgqY0+JgNShYmzF94mZMnmb4uFn4zf/qACT9hU45/jmJb0ZjO7
	DJkTRQQFEDvi4g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43bxptjev2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 19:11:53 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B6JBqxu030025;
	Fri, 6 Dec 2024 19:11:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43bxptjeuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 19:11:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uc5kPNJwq0n6syYCIikkgXb58QEc1Z+Yvdt60T+A4yRrl7Ad1yT8RSDnWqXF2+vODkdjuuKaO+aHL6Fij810hh1J9MAtnBoszt0keHE/rUvndpyLNA1THBwO/vz5t3gSbSAhMBUTH9tDbpuMT8YCGZCu7OGeHS7GAoIfh3tXBoOiB8vr5tfxmqpKB6VoEsXH1oWfaOek48cpb0MiKvopze0B7ry7/DX2PMC7Mc54ZAEJ6e2Z/KmnCd7VuNiaZERgvGq40p7nndlrkhOzfzST3LNXyohAcu85taNU7RALzctR1nbcxwVcQCoWnX0hyZyafMqa2m90a1E8EGpPNvK5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uG7Y9eFJ6fdaKRUl8LjEJQbAfblAWeyhzJtKd+Fx14o=;
 b=GuSeyruQ3O2nwgq3rkl4TDv3a0afqLTamTVW3Yb3VMUXsfJvxA4SRNUy7uSVqYn24MGqdUnog7OgXcSTtF7K25SvdA9LlOCgLB1h+3t1QMYqZ7LaCHmftqJloJARdwAzYon9EZbRZFfAgSLiv7bNyGivjbA8BHa9mCbI8kNHP44/6hko8vK72I83OHGgDD7YItKqDef8/WqM4lpYTnEyPwRrzqKmIsbXhcYm0yUz5YOfsGKn6HPSnz1hed5Vp+BPxc1xy6ret8IS5g62Dtsvw4xwneho84FVOq/Gq+Hkm5ahe+6ySQY4ZHQleb6Zh7fzENb/EOK5nWsD5vR0kz0lfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS1PR15MB6589.namprd15.prod.outlook.com (2603:10b6:8:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 19:11:50 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 19:11:50 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>
CC: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/io: make ceph_start_io_*()
 killable
Thread-Index: AQHbSBDvGioVo1fY1kSWst7E0f1e0LLZlUSA
Date: Fri, 6 Dec 2024 19:11:50 +0000
Message-ID: <cd3c88aae12ad392f815c15bab0d54c8f9092e46.camel@ibm.com>
References: <20241206165014.165614-1-max.kellermann@ionos.com>
		 <d3a588b67c3b1c52a759c59c19685ab8fcd59258.camel@ibm.com>
	 <CAKPOu+-6SfZWQTazTP_0ipnd=S0ONx8vxe070wYgakB-g_igDg@mail.gmail.com>
In-Reply-To:
 <CAKPOu+-6SfZWQTazTP_0ipnd=S0ONx8vxe070wYgakB-g_igDg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS1PR15MB6589:EE_
x-ms-office365-filtering-correlation-id: fb9c5a8e-82f0-4479-b24f-08dd1629d64b
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YlpnSWJTRXVaczg5WDc1bGhGR1U4bDBhZ2RHbW11azdBQWNZZDVOOExBZWRR?=
 =?utf-8?B?NktCSDBONFIrTkZxeS9tQmd3dk9Va0tpTEE4T043Q3ZWR0VLWHVicUdyZnhN?=
 =?utf-8?B?VVFvVlZnN3liMERaZkJ5Q3Nkbm1jREdudlFGanJncmErRUdteHRYaE0wcmd0?=
 =?utf-8?B?Y3ppck9sT1RNZWRQTmNydEtrM0dnNUxUYmgrM05JU1YxeUk5bXdTcWVCclpJ?=
 =?utf-8?B?blM0SVc0c29JWVZObVdoMEJpMTUxZnFVcWo0RlhFaXlhR1pBV01zcURXMEw3?=
 =?utf-8?B?bUQzeHRKTThJbEMxdWdialBvU3BpTXFQd1U2RDFoY1lnNnA5ekpxajRwZEtN?=
 =?utf-8?B?R3Y1R1Z2em44aER6WTFXYXJUdEZmN1NDRWFzVncwaG9iVjdZMGo1aUoyZGxn?=
 =?utf-8?B?Lzlsbkw1M1V5SE9HOS9IMmIza0NjSUtOUzVxbWtRSlZWVGRDOXRTdmpuNjBj?=
 =?utf-8?B?bSthbThGVUNrMWRFRGN2QzhGY2ZOZ1lqTUxGVVNmRTJWaFNkOHRqaGlaTkVF?=
 =?utf-8?B?WmUveHE5QnNjK1FISC9JMU9EQTNJYlNmTTk4TEE1S1ZMcWp3UzNoYmJqUjBh?=
 =?utf-8?B?MTlpVk9YSkZnTzlzbEwyemUzMTlsc1cxQXBBQzlwTy96S2tmY2FHUURjYjZQ?=
 =?utf-8?B?RG1YL0hLajNDVXZqdElwdVJVQm1ReXdEZHFNZk1PTGdtM29FOU00d3NVck9J?=
 =?utf-8?B?UHQ5TUgxMFdtRDhhWWtONlROektwditQYzRVY05kUTFLZGkyM2FuUG9QalV2?=
 =?utf-8?B?QSt5Z2JwMnBZcXNtSGpiK1NtQVZ3eWZ3bms0L0Z4K2V6TGZEOFFzZFhUMGZ5?=
 =?utf-8?B?RVpGR21SSm5qeEh5eXFVSklac0NySmJNeEYydldOdmJmRmg2ck1hTGlRZUda?=
 =?utf-8?B?Q3R6ZkZQQUNFZ1Y1M2xIR0M1QkxDZjUrcElMOUpMRlhQUGZvYnpNLytwczJw?=
 =?utf-8?B?M0JsQm53UDB6MEZkT2dnSiswY1BKS3A5R0pZZFd2VFAzZURhajZaOUtPaHJG?=
 =?utf-8?B?bnoxNHg2SVV3TzdOYVltdnJsU2llbmFJSEo2d0VPdnBYcFl0Q0tUUnYxSEFk?=
 =?utf-8?B?dXRmZDdXLzJ5V3IraVY2M2M2NFpia0RkSDZISTRJQ1BtYnNhVGJYbjhBelpV?=
 =?utf-8?B?bHhhQ1RvSmhQMFBEenRvdXYyT21BQkxYTmlzN0RPcUN6bnVCNDNtdkFDdlUx?=
 =?utf-8?B?ZHNTS3JIZzk0VjZRZ2dHWWcwejRLWDREMDZid2xlYmVGS2pnbXJkMnhIR2VH?=
 =?utf-8?B?eWQ1UmowdVdvVjZlTkZYTko5bWxqWUMyZzgrUXQ4NW5BWlBoejNYNDlZLy81?=
 =?utf-8?B?SnJHSXprbkdKdUZwakt3T0JEYnE3aFFodzBtekM4TUVSMDB3NVMxcmpaM0w5?=
 =?utf-8?B?cTNaWjZqTzhwMkdPYVNTZ0srZUhReTdSbVg2T2ZFYnphQUNNay90OW80VVo2?=
 =?utf-8?B?ai81NXhoMnllUUZwTUNvK3VSSzY1NmdzN3VtMkplYUhPaW9iL2c5YWU2Z2hp?=
 =?utf-8?B?R1VEQVFjU0d4UnlRUy9VRlVVNUFiSCtkdVVpNFBxVHFpWDVPOVN2K0dNRWRp?=
 =?utf-8?B?RHVjODFzbXlLZE5yYTU5aExoUXl2eU80S0lVbmZ2SUNpZjNodjZub3ZQN0hI?=
 =?utf-8?B?TkVaeUJORW4wRW5qVWlDTmN2VGtqdTF6MGZONmkrTk9uRnlXVzFCU1p3RWU1?=
 =?utf-8?B?WTFBM1JkUEFQNEx4WjlaejI0b0MvZzVnSEVyaVpoVkdkN2tqRVZjMzRXMzRs?=
 =?utf-8?B?VzRqN0tWRmExYjR0ZEFoZ2JEZWhWUTFGSktEMmZqZXByWWlpT1BkdFZXQlNX?=
 =?utf-8?B?ZVFNZWhMSnJ4SkN4QWRuU0pROE1wamFjaVBVdnBFRU1oazNnbnhnSWhUWWky?=
 =?utf-8?B?SkxxL211ck1zMWVkRFJNVktScHpHbXF6azRVRmpneUJoeFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WG14b3BUYUdHdVJNMXN5R0ZsVGJrQkpndndxbm1KN1E5VFZBUFpBRVNtdHlr?=
 =?utf-8?B?YUxwbGdrMUlJZ3FWSWNxbWRBdmw2OWgrZGNhUGFHdnNOMHpoRG1QeDIwQVlw?=
 =?utf-8?B?RlJVYWhxalJ3YVVNRGZXSUNFczJrMzZ4cmEyZmNEbmlhRkh3cE1pbFV6ZFdV?=
 =?utf-8?B?cktSWkx1bnZ6alc2ZVNXYXVpZFNCc3RuRzg5OXZTTE9GN1lSRlllNlk4SFJu?=
 =?utf-8?B?bVk4eUdHWmRiNERzQUJpRTJNM21odjJScTlmTTI0d0hDYXR1MXRtREFxQ0lU?=
 =?utf-8?B?cUtSZkpYZXdEZE0yaS83QXprZ2VOcDZqUHI0T2x3VnRqQTV5alNqSElpSDJS?=
 =?utf-8?B?d0JkeVFtczI0aVZRZEp4OEdyTXBoTzN2cmw3THVXb2VUaFVWTi9PN1V3TThZ?=
 =?utf-8?B?SDdZcHdYelMxbFpFTE5ydDdZYk5vcDFSK3VkaE4yc3RzdU5kSWVCWlc5Q1BV?=
 =?utf-8?B?SXNDZTF0MXYxTk9BRHZWLzFnQTlDbC9XVjZWMDdxeWpUdGtoMDE5MmNOUkpJ?=
 =?utf-8?B?TVQ5Zjk0QmVOaVZHMS9WNThnSGZBZXRMRENoQUNLQ1F0RjVGSzNWQncrMEN1?=
 =?utf-8?B?VU54ZlFNdFhQbWFoZEpPaVBmS1FHNzRxSjNBNjJ4OXVZU2grM3VhMEV5UWZE?=
 =?utf-8?B?RmlObkJneHpBSXJtQmt3ZW9tM01teXBLYVBjVng1cnRjbldYdzYvLzArOFZl?=
 =?utf-8?B?SFphQVU3RzJsUzZnSm5oN25OUmhPT042dUVUcmF5L1JjR09iOVo5N09VcjE0?=
 =?utf-8?B?YnN3Y1ROcG1nT2xFWlljdVRGMHRrT1E5RUFYMGo1UWZWalFrSVdmZ1k1RGY0?=
 =?utf-8?B?VGZ5R0g4NUUrRVgwaGhyS3kydk1GWTdKdUwyWmtyY3c5UzdCc3d5UHpBUHp6?=
 =?utf-8?B?VVZyVkJkdUF3bGZVQkxLRDVOQk5KZTY2MjJkZkFkNU4vSVVOZ0s4VlYrU3Bj?=
 =?utf-8?B?SXpmNC80NlZoczRlN2QrSVNYTUg5S0kxSGdnYWJqcmlUNGFpZXhnMlJpbTRD?=
 =?utf-8?B?OGI0YkNNVXV0RW5CS2xmQVJpSGlpbE1oRjZTckNrODN5U2gweFNRcUZwVmZR?=
 =?utf-8?B?NDNIUWRTV2Npek1mNWx4OVJhdXpHWnZJdXNmN1RvMjdJalUxL1BEVjlnR0lM?=
 =?utf-8?B?RHFnK2plRHc3Q3kxVXIvWVJqS1VrRTgrN3hxNHVHdzJsUEZZa2IzNzJZa2xk?=
 =?utf-8?B?anNDTXNKM0RTZU05ajk5M1V3NWZnN1NGV24waERFQ0M5cmw3bHA0RTc4Tkxj?=
 =?utf-8?B?bEdOSUZvNW1FRkNjZVh2ZjFvSVFGclhRemt2QmtnU2hEczNZTVJWa0VxS29j?=
 =?utf-8?B?U04vVUFRbWdIUGtOQUYxMloyOWx1Ritlazh0OFdzTWRaZjhJSjJrRjZFZHlq?=
 =?utf-8?B?bDRoaE16OTlpOXJCOWx6eEoxUkJoTGhqaGltZUk2eWRhZytQMVcwMmUvaUwz?=
 =?utf-8?B?K2d6YlZkSStXR1A5cU95UnFXOWY5OFFHUWg5QmJLRnEzQ1FuaC9UTXRvSXpZ?=
 =?utf-8?B?T1pjci9tbEJZOTltVzJab2lHTGlwQkxmUFJqL3F2YWh2ZmJBNjc3YTVwdlBm?=
 =?utf-8?B?MDNZTGFmS2lVbkZHV1RBbU9nSFphblZGSCt6N2l1MlN4dGtCSDZ0cjJLVVFy?=
 =?utf-8?B?ZjZBVFdJQXR4RGFFZ2dGMUlwSFlnOGY0R1Y0ZTBMMlV1SDFnQ3N6RExNUU9E?=
 =?utf-8?B?bkQ1NVpjRHIySDZyQ2x4S3RqZXVJZkFRZG5MbUFHYlFkYS9iMnhEWHk5OXNE?=
 =?utf-8?B?Z2UxdlFjUWg5NHVGR284b3BFUEErRGNrRUdsTTVUVmRXd1AzYit2UGRuU1VC?=
 =?utf-8?B?VkU4dDRFTGNzY0NXaXFTcEdkcEpCMHk1U3pVb2pCSHBQUDlMN0JVYTg3Mndk?=
 =?utf-8?B?Q2x2NDVQWXR2djdzcURaanhGQnpyV1B3dk9COHlWV2xFREEzRzRkV0xzbGdo?=
 =?utf-8?B?S1RKbzRtZkVtSU9OWHhoemRrOWcwelc1U0RFYTdIb3VoRy9PTFFpK3ZUWVZP?=
 =?utf-8?B?SWJ6aVBvL281ZVVkdTg4QmNxSVZiL2pQRGNoSEdXRFUvYTBKejBhY0VSMUFH?=
 =?utf-8?B?MnhlUk5VRzBqQ3JJMVJlSythbm9md1I4YkpEV0d5YXdWcGJRTVpBMUMyMkFz?=
 =?utf-8?B?Ky8yY0tubU4rQlpGNHFDbFhFRnQvQXE5M09iblNjSXh0YjY5RW5IendQbHBD?=
 =?utf-8?Q?vfOHvhaVhUOqWhPWkjbyTOo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D543D573CCF5F45B32A1F638134BAD5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9c5a8e-82f0-4479-b24f-08dd1629d64b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2024 19:11:50.0991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QIQBo5tZcLP85qFREKMrku1Ra0mUV54erKV1g3mk8/i1cuVXQNiOQQEyKUNI7tYw9mNjL44v8yTeFqvZ2NMMSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR15MB6589
X-Proofpoint-GUID: tlu8ylBug9Px3ycmHUR5WxIhQJ7wcI7k
X-Proofpoint-ORIG-GUID: DFEhdBsNclW-iHtFBO13c9oyiZcHQscC
Subject: RE: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=758
 malwarescore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412060143

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDE5OjU4ICswMTAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gT24gRnJpLCBEZWMgNiwgMjAyNCBhdCA2OjQw4oCvUE0gVmlhY2hlc2xhdiBEdWJleWtvDQo+
IDxTbGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IERvIHdlIHJlYWxseSBuZWVkIHRo
aXMgY29tbWVudCAoZm9yIF9fbXVzdF9jaGVjayk/IEl0IGxvb2tzIGxpa2UNCj4gPiBub3QNCj4g
PiB2ZXJ5IGluZm9ybWF0aXZlLiBXaGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+IFRoYXQncyBhIHF1
ZXN0aW9uIG9mIHRhc3RlLiBGb3IgbXkgdGFzdGUsIHN1Y2ggY29tbWVudHMgYXJlIChub3QNCj4g
bmVlZGVkIGJ1dCkgaGVscGZ1bDsgbWFueSBzaW1pbGFyIGNvbW1lbnRzIGV4aXN0IGluIHRoZSBM
aW51eCBrZXJuZWwuDQoNClllYWgsIEkgY29tcGxldGVseSBzZWUgeW91ciBwb2ludC4gQnV0IEkg
YmVsaWV2ZSB0aGF0ICNpbmNsdWRlDQo8bGludXgvY29tcGlsZXJfYXR0cmlidXRlcy5oPiBpcyBh
bHJlYWR5IGNvbnRhaW5zIGVub3VnaCBpbmZvLiBJZg0KYW55Ym9keSB3b3VsZCBsaWtlIHRvIHVu
ZGVyc3RhbmQgX19tdXN0X2NoZWNrIG9yaWdpbiwgdGhlbiB0aGlzIGd1eQ0Kd2lsbCBlbmQgaW50
byBjb21waWxlcl9hdHRyaWJ1dGVzLmguIE90aGVyd2lzZSwgd2UgbmVlZCB0byBjb21tZW50DQpl
dmVyeSAjaW5jbHVkZSB0aGF0IHNvdW5kcyBsaWtlIG92ZXJraWxsIGZvciBteSB0YXN0ZS4gOikN
Cg0KPiANCj4gPiBJIGFtIG5vdCBjb21wbGV0ZWx5IHN1cmUgdGhhdCBpdCByZWFsbHkgbmVlZHMg
dG8gcmVxdWVzdCBjb21waWxlcg0KPiA+IHRvDQo+ID4gY2hlY2sgdGhhdCByZXR1cm4gdmFsdWUg
aXMgcHJvY2Vzc2VkLiBEbyB3ZSByZWFsbHkgbmVlZCB0byBlbmZvcmNlDQo+ID4gaXQ/DQo+IA0K
PiBZZXMsIHNob3VsZCBkZWZpbml0ZWx5IGJlIGVuZm9yY2VkLiBDYWxsZXJzIHdoaWNoIGRvbid0
IGNoZWNrIHRoZQ0KPiByZXR1cm4gdmFsdWUgYXJlIDEwMCUgYnVnZ3kuDQoNCkkgZGVmaW5pdGVs
eSBjb3VsZCBhZ3JlZSB3aXRoIHlvdSBoZXJlLiBCdXQsIGZyYW5rbHkgc3BlYWtpbmcsIGl0IGNv
dWxkDQpkZXBlbmRzIG9uIGZ1bmN0aW9uJ3MgbG9naWMuIFRoZXJlIGFyZSBtYW55IHBsYWNlcyBp
biBrZXJuZWwgd2hlcmUgc3VjaA0KY2hlY2tpbmcgd2FzIHNraXBwZWQgYW5kIG5vIGhhcm0gZmlu
YWxseS4gSW4gb3VyIGNhc2UsIHdlIGhhdmUgcmV0dXJuDQp2YWx1ZSBmcm9tIGRvd25fd3JpdGVf
a2lsbGFibGUoKSBvbmx5LCBtb3N0bHkuIFNob3VsZCBiZSB0aGUgY2hlY2sgb2YNCnRoaXMgZnVu
Y3Rpb24ncyBvdXRwdXQgbWFuZGF0b3J5PyBJIGFtIG5vdCBmdWxseSBzdXJlLiBCdXQgSSBiZWxp
ZXZlDQp5b3UgYXJlIG1vcmUgcmlnaHQgaGVyZSB0aGFuIG1lLg0KDQpUaGFua3MsDQpTbGF2YS4N
Cg0KDQo=

