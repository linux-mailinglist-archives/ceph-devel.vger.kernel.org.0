Return-Path: <ceph-devel+bounces-3443-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78681B252A6
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Aug 2025 19:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39AD03BAD89
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Aug 2025 17:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E52329A9F3;
	Wed, 13 Aug 2025 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hOPPrGls"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA63299A8C;
	Wed, 13 Aug 2025 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107789; cv=fail; b=upkjjRd68sR3dReEG71fwvPMqZZRinws2uHPsX93en61zxwsdtXIzcpROGDbj+X9NuDMRM2hr5NfdNnE8OlblDxq3ccg1N/xLLN6NZpzhPpPEVpb66p8HF+opdOI3xTAdjZTQIcoK/2axjuG7odHI2LF8PRKMim8wjb0sFltZd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107789; c=relaxed/simple;
	bh=jVWGKsYOE/jzTdPIKaQKukH+jpgSVtoRqGlw/xB+Beg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=IHLxwccT8sfUTgpUtRYSdr06Y/GEqb4g2kiFXrTxkj+09/q3A6WYn/nqcO+nfWMBMzibug/HL0KYSG5WaYlR+F2c2X71+jEmXSaCgoFsumnGwl6etYYYj7Nc2+SABd6DYL/D5+EoaMfioK8wNP5Tl3Vx35I1eZZ04A1+gezoT2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hOPPrGls; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DCIfsn029936;
	Wed, 13 Aug 2025 17:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=jVWGKsYOE/jzTdPIKaQKukH+jpgSVtoRqGlw/xB+Beg=; b=hOPPrGls
	l20Cr/QWfwfAJGdKIEC1ujLfqXr86T2YwUYd69GkSCd5pyelNZGxt/3BO6RAJsYU
	Bzm+we6DRVCbu/YthybUfyztI1uKMvPpcVQSOkJyy88PJQhLQLEw0oZKMEbRarTH
	J6I7+ex08ZXWmD+VgwJU0hsvDE+Tl9PBT6a6EjE2pS3EGyN1Ff6jobhz3crR3pYN
	lLzKLEYlI71rOmZE5Ew8uwtUP0przya8XKW3+xG9qsCqv1iNzKjal1ljmi46UgvF
	+dQ5v1uZ9VS4DQTcUAWZwcag4qKTEtc/dW3Y3uLTc42nIevPJzpkgy/cZbrWHoER
	06aD9uhkA/eZAw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwude1a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:56:24 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57DHKaWc032530;
	Wed, 13 Aug 2025 17:56:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwude1a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:56:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSBFiRu12V8KuK92CCWf404eTZgmY+8iZWdvvU8K0pxjB14F6d/S8VT2VQU6eMdoTG5GjBWegQDnQR1RfeZ/ledSBJcXbrrIBRA9UxPHQKNUl9Rq/Wt0fWnpAXBxlflu8HFseZQ6U+xo7TdsJuOd+MEBcJ9gdaQvL30wf+8LPi+RExQyW9kNkREhECgL1nWQC6+KxyWOv+0Mti0VMcyHImeu7LGFGvixlv8Ip46Q5aqtPM5f7CFbIXeBdDX1FqSgFRDJ1JdSjV1pUsGeUhfHjqknMJOZmFbuNNJIvpOY8vaKhnQ7HFnQxG0AP58bV0R4NK1cG6zByYTfKQ7BQzY/FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVWGKsYOE/jzTdPIKaQKukH+jpgSVtoRqGlw/xB+Beg=;
 b=SrkZoDXfigb/UZrB6DOEaauucSVFTBHqgNBYJTR2ehKz3JD5UM+pe8rTTRz+AlS1lBsWCLZnRdMpoLgvZKv52uGSXv68bYtMjeeVK1wMRwtwHG5tWARtJ7J+ub+xrDxgeMz5uPbceNlNGIDkugmGcUM/NWF6KmysK6ffL/y7cjbBPT6Cf56IUeStxp67kRgVfkxr2jm08f4PI6B11wr7Og/MZH25g9GMWUQGFfXPXGy3/ZNLK9Dx2gqq10FYh+XiBXkMphwFjM9KIwbzHIC/Q8FXdCsN9A3jt3EGdgNGoWMUS95/FDHMqlVvfLRFXP/sirCeHKrytKZ8igGiQJ1KDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4768.namprd15.prod.outlook.com (2603:10b6:510:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Wed, 13 Aug
 2025 17:56:21 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Wed, 13 Aug 2025
 17:56:21 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v4 2/2] ceph: fix client race condition where
 r_parent becomes stale before sending message
Thread-Index: AQHcC2+U5VaUFEtdLkavBz7/ikcdRbRg4EYA
Date: Wed, 13 Aug 2025 17:56:21 +0000
Message-ID: <0cd97d2d8e592655106278aed4fa8e05c9f372fe.camel@ibm.com>
References: <20250812095739.3194337-1-amarkuze@redhat.com>
	 <20250812095739.3194337-3-amarkuze@redhat.com>
In-Reply-To: <20250812095739.3194337-3-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4768:EE_
x-ms-office365-filtering-correlation-id: a68914fd-9b88-42be-f760-08ddda92b61e
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aHFVMzFIelJkWng1a2NyWHdiZG0zcmZ5L3ZCaGNvUDRWcXdLVEc1M2NzSDJV?=
 =?utf-8?B?R1V0TnczNkhWTTVTTk9sMFFMU1h0NndNME9wOUZua3JKdGhzSGVaMVE2cks5?=
 =?utf-8?B?YjZDOWJ6eG1zRWUrTXIvYWdnNktjemFPaEFxcHRGdnpHbm1JdjBtWkZFUUFK?=
 =?utf-8?B?UytWdUNIUW5vSjJKMXFCblhnclVDV0VLS3hrMi8xcElva1hEbTdHUTMrbVJF?=
 =?utf-8?B?RlpPQlUrRFM2Z2hVTUcybmtmbFZpM2NLQS9WWjdCSW82NHA3TFZ2U2o1RXpU?=
 =?utf-8?B?SUFQMUJpYUxPVzk2Z1l0T0xBek9iRjYwK3d3aUV1bFdkRmpnRTBscEFVUkFJ?=
 =?utf-8?B?YW9naVVzdzk2L0hjTVJSOGh4a0tCV1ZERUExalZuS2lRVEZuL2pjNktMTlNo?=
 =?utf-8?B?ZnUvZU0rbnVaeWFLZWJmeFNBYnlpK3FtdXF6a2lZQWpEb3ZVSVcvZnBaVS9v?=
 =?utf-8?B?NzdmZGRSZGJxNncweHZWd04zMlIvdTJyUytNWjVJQ3MzSHM1RTlpRlF6bmJO?=
 =?utf-8?B?aEN0R213UnhjbWhiZDZlU2NYZXZDSWwybHpjdW5FRUs3M1lKZjB4K3BaR0Uv?=
 =?utf-8?B?eklsWUxWUHByTThzRm1UVFBOUzkwcVlKeFRpem9obDBtZEVLMUwrR25lVFFB?=
 =?utf-8?B?ejJLSHhNaGtlV1Q2NG9aZU1aaDNDdjk0S0RFYWlLaDNpL0NQcEtYd296K0tB?=
 =?utf-8?B?MkFRdy9mUTZkMDdLRGhNeXpUWHhIOHpDN0pZNDBYQkZGVEdyVVpiYUFHNHRC?=
 =?utf-8?B?WUtMWHFTc0FRRXZsQWEvKy92VFF1eWdBUzZzUGxvWWNwNGtYZ2kvVkpvN1du?=
 =?utf-8?B?bE5uRFlZa01VMUtYVEpZZVliRzdTOEdPNlIxNDRzeXJrSm03YmdKbHJSSXZo?=
 =?utf-8?B?Y002UFBiaCtKVHIwYTdBM3ZJY1pLZ0VtYXhlOGNrZmtyYlZZeXZQVllCTkpp?=
 =?utf-8?B?OWk1WHZlNFF6cFlLUGNTaGFtUHJNZlU4UnpTNWpOOWxFWCs4V08reVNtZkM3?=
 =?utf-8?B?R3JWWUtRUlFyWjJUWXFlUEZLbjZQWDcxcnNNYTRZT2Iva2xiajk5TDV3c1JS?=
 =?utf-8?B?U0lNTm8veStuWCtwUFZ2QlRSc1ZIb2tPM0E3eFBkVm5BQVBmQXdjNGEwR0t5?=
 =?utf-8?B?ZGp5bXU1TmxRVkEwOXlmZjlrUUJ4bDMxNzh0Wk41dVpncnJlZW5RUVgyVEFD?=
 =?utf-8?B?YU5IYU11ejV6elJuTmNuK3V5b1FndWt6emxMbDRQT2VJRXBUaWp4WlpJQmhj?=
 =?utf-8?B?eVcwRGZBWG95clZVTEVpekZlc25HV0hnOFMvU2xpT1UvYUFUMGwwenhmT0Z0?=
 =?utf-8?B?ZzhvL3gwU0l5TUg0TDR4MUZRMnFUZG5BM3l4eDF1NU9leTIwUlBKbnB3TGp0?=
 =?utf-8?B?RWNGeWc5OGFNUTJFSjdZM3lNZlQwSmNSaDlsbEVZZjNtY2hJZ0lPZGZvNUJs?=
 =?utf-8?B?NGh5OU5IRVFZUU43WGpqVy93WU9XSktMUUxuRy9wTlJuZVdKNXJPUUNpc2w5?=
 =?utf-8?B?YVB1Y0ZmNHZ6ODFLTkRTM1N3MzZWWmtYTjlkVlk5QXNrM3pEb3RzaloyUDMy?=
 =?utf-8?B?YWVPK1V4Nnl0aHl6Qm45OTdpM2I5ZjJXTUFQZmc3Rnd3RnhRODcxSWxBZmNt?=
 =?utf-8?B?ODRTUVRIZXV0ekFOWEhIRDJkUGlOMmlmbHgvK3JSVmQzZitTVEtOQVZnbDVR?=
 =?utf-8?B?NjdEZndYa2hGQU9FTmdnV2NWK3g1RWlwK1dmZ2xUZ3RsVUwrN0piMmdLS3pj?=
 =?utf-8?B?UmJCTUkxRTZ1Qll3eTR4aGlleG5OWEFiM3FwYnkvbTYxZmNPWFM2ZGRQZ0M0?=
 =?utf-8?B?V2pUUTcyY2M0L2JjeXlWL2JGNlRINjBKcGhhWFU5YXNyQks2VXRVSDBnK0tR?=
 =?utf-8?B?ZlpXRzgwaDZyam5Ha3pLZit4ZzZ0cnJ5cDZJQjlndTF0ZGsveEk5bFBTL0Fx?=
 =?utf-8?B?c0dxME4vNGg1c3RIZG1vK01SZDFQTjZpVDFEZSt0OEZvZEFETWlHNTBLL2pz?=
 =?utf-8?B?RHpLUTZ6ZnNBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Sk1jUkZ1MDhwSlIyS1NmczNCZ05yVFBZRnJaeDJheGx1TFJON3FHOWhJMFBW?=
 =?utf-8?B?UDlBc1VEeVBVa1lHMDd6L2IySmNEdjZPTEloQytRRUF5ZWN5NG80RnVpelFK?=
 =?utf-8?B?cnpoQmFSeWthRVRVRmgwRTlYSjlBd0VhTlY3ZVdLci9xRWV5d2hvZFBqMHVV?=
 =?utf-8?B?V1ppR05lM2ZCZ0hEWThrcDZ2UHBqZG1ESHQ0YnE0NWJxUXNOSEo4UjVwZHFz?=
 =?utf-8?B?WC9PdENKNEtNQ3QvazNUdDlZWTFxZ2tURFM3UWJuNk9sR1ZLODRrbVNiMCtz?=
 =?utf-8?B?VXNHOWVneG55NTgyc1VPakJZbGZ3WVdlTkk1Tzd6ck0zUDhybnlrdFRzZXJ6?=
 =?utf-8?B?RlpZdkF1MG1TNExCQy9zVWxtWFJ1VHYwMFpBbDF0WjRBL0lWVHBrNEU4djlZ?=
 =?utf-8?B?OHA1VzA2U0hJTTNtRjZiOVlpdFcwRVNlVm9ENFVFRTM4eHAwZ3dHV0k3Qm04?=
 =?utf-8?B?ZWdYNzdkTmdqNXRiVmVhT2xRaHFVRFRnTW0ybFJ0ZkZ2R25TcytDTmVxNFEx?=
 =?utf-8?B?N3A3bVUySzIrbzBJRStCeDJ0eTZ3bjBNb2ZBTzNpVzFNQitmUGtTbXpWRk1Y?=
 =?utf-8?B?cXZ1WnJVaStpeGNtZXRDTHVzMlI2M1kvU2FwZzV5SGk3YmEyY2JkVjlwQnBY?=
 =?utf-8?B?NzV4K2JCTzB0VklkQmphazJqUkYvay83d2JNVUdTY2VEM0ZEWXJyQnhhbDN5?=
 =?utf-8?B?RHB5ZHc4YU85WE1BOWxMYVZWaFl1SFZLY3pGdVBhNXR5ZThzQ05ZSGdsdi9k?=
 =?utf-8?B?ZUptOWh2d1Y0ZXMramdPRjhIRHlnQmVCVHpiNWkxTWxDOFhxT3pKZXJDWTJw?=
 =?utf-8?B?bTZrTjhyYm0rbi91OUQxS0RocWRVak5lWm9sNnRzZzQwZ2pPcjFOUlIrazA5?=
 =?utf-8?B?MEg0N01lVzRTclhFbzBKcWlQMW1JTlRDbTJNRHJpWDhWUThidzJPT1dHR092?=
 =?utf-8?B?K1pEL2F6UGpTSGZuNHNhclZmSnVia2NVMk9mR1c1RUtEblMrNkNtdnQ2bnhW?=
 =?utf-8?B?L3dWemhjaTllWjBjYWh3TExFL3gxSU5teGgxMzk0ZHRhbFZaZEZMak5HTXRB?=
 =?utf-8?B?bVc4UkdPNkF4R3FMWk42alpjWStqK29rZGh2YzJlczlTTzIrOWtIVUFsUWxi?=
 =?utf-8?B?T0VQNytReURScXlKdjVPTktRbWpvSVJnaHQ5dGh1T3hCdWpNbjhIZ1pDZ0xt?=
 =?utf-8?B?bTRsVkFZL1h5ZFZDTG4wZEJXTS8rOTI2d2VxNkkxdmwxY1I3RkNuazhSN1FR?=
 =?utf-8?B?YnJTS3Jrb0ZLUFN1ZkZFVmN6bkljUitBcFNLTjV2bnhZZ3ViRk93VGdma3cx?=
 =?utf-8?B?Y1hGWExHbDAzRlMwODRJeFl4bjBPTE00WXdXNHVvZllURlhnNzVYV0Juekdq?=
 =?utf-8?B?VEdGTGw3VUdLMXFrOGtCYUJNRUltb2pOOG9oSEZBclRSVXorYzdVZVgzdzFi?=
 =?utf-8?B?Vnl3bDlsMTRLcEk4c1NsdC9hRTB0VytvdS9tZzVWQzlKYlN0dkxVSkxudzgy?=
 =?utf-8?B?NFJZTjMvTGczNWxxMFpqUExyTTVCcnFjamxFejVDYjZrcjNDb05iSlhucmxQ?=
 =?utf-8?B?aGhwU3F5ZGxNQTFtL0hSZjczT21DQmdvaExrVDZGbXlDbXI4d2w2NExpc2Fu?=
 =?utf-8?B?MHM4dEV2eTZ2QzhCb3Q1blh0UWdEZEFkY0VzVjliZE4vemErSUpsSUZvdVd2?=
 =?utf-8?B?TXRIUUhieEt1cjZYVDVmV2FrbTJORW9TbDRyOUNDaklhRDVDM3BBV2RHeGdl?=
 =?utf-8?B?dTRSTTZSdlpRMnFlR00yaGlOcU5NeVBwaVhEQ0tmbkFFQ1ZDYzkvMDlZeWN0?=
 =?utf-8?B?aEtDbUZxNG8rYUFPY252ZFJ6cVJ2RHovdGVISE1lRCtJT0VmdUpsZE81dGVM?=
 =?utf-8?B?MjdubWFvN2hpNDhEUTVOeTJ3UVhpTFE4ZXl2YjdFcjVOUy9razJnOFB2UWxq?=
 =?utf-8?B?ek1GMXFXOCtwWGEyMTAxQnVoLzhDd1pEV1BHaHNSTS9oM1hlbEFQSSszdDNH?=
 =?utf-8?B?cjhzUHg0VzU1VWlOWFlxZGlLVHJ4akhXbUVkN1BKMnBrQ2dTVUd2MVFhb3dN?=
 =?utf-8?B?bDBucVF6ZXZ5aHZRUUVIeEhEMm44d0pTdGc3SDlPYmRxRzJWY0NVTGd4ayt4?=
 =?utf-8?B?VWI0bC8xZ0E5ZUVQRVd2emdyZEo1U1NQSGlLb3pLWkR2K1ZLR1BYaDB0VTFJ?=
 =?utf-8?Q?04ecMQboPnNJryh3aO/xdgo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <983772968E8EF5419B3C930C63DF275F@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a68914fd-9b88-42be-f760-08ddda92b61e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 17:56:21.1887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +1J8OFM8gFvE0N01qfHpVWjlAL+qEezjh3VFM4WK6IqfmjFGeBoP59gydRW8wTsmKDDLwypoDO+WDccLhUtXVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4768
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXxlGCUWT3aeXX
 5MSQSmY+HViTlqQBbhl2/GvMv8JJkoleiVcCqPR+EUsoueXTibr/d/nNOBhh/kk2WAkZPbbzn0Q
 9udnyZd48hyJ8EvyuNt5yXULCbRmlV0G3afmC2jAd0PcF4Qzx3yNJro555O/Oe4It/kRTbKvXYW
 QmHr/CFxu8qcMFpvsQvW8fRnt/grin7MneK/eV5+a/vHaY6U0eT7vz5dItxcVLJRNKy1G4egthj
 EMn+A+UjvuWyyt12Kpx6boYceH2taq1E4lmsbHdy3N1fzjZ9L3SNAYK5/LpL0B9mmQiNg9ur7bZ
 ksRAhPOAbBczYr+jSBP/3p+erd9oWzxUp8cgCqcR2cD89xwnzkkch7L6dOItnT1d4NGS+rlsdD8
 6cTU1sbi
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689cd1c8 cx=c_pps
 a=RvCmOxSchWnKnqXp0A+Feg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=95tDJqoRyqkW9PFrcBAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: OJVCFwkA--ebO-x6106oxQcbN7IVpt4o
X-Proofpoint-ORIG-GUID: l3QpPCT4OpBmpK2FQL_v0OzAAqfrgAK4
Subject: Re:  [PATCH v4 2/2] ceph: fix client race condition where r_parent
 becomes stale before sending message
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDA5OjU3ICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkncyBpX3J3c2VtIGlzIG5vdCBsb2NrZWQsIHJlcS0+
cl9wYXJlbnQgbWF5IGJlY29tZQ0KPiBzdGFsZSBkdWUgdG8gY29uY3VycmVudCBvcGVyYXRpb25z
IChlLmcuIHJlbmFtZSkgYmV0d2VlbiBkZW50cnkgbG9va3VwIGFuZA0KPiBtZXNzYWdlIGNyZWF0
aW9uLiBWYWxpZGF0ZSB0aGF0IHJfcGFyZW50IG1hdGNoZXMgdGhlIGVuY29kZWQgcGFyZW50IGlu
b2RlDQo+IGFuZCB1cGRhdGUgdG8gdGhlIGNvcnJlY3QgaW5vZGUgaWYgYSBtaXNtYXRjaCBpcyBk
ZXRlY3RlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggTWFya3V6ZSA8YW1hcmt1emVAcmVk
aGF0LmNvbT4NCj4gLS0tDQo+ICBmcy9jZXBoL2lub2RlLmMgfCA1MiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNTAg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQoNCkxvb2tzIGdvb2QuDQoNClJldmll
d2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhh
bmtzLA0KU2xhdmEuDQoNCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvaW5vZGUuYyBiL2ZzL2NlcGgv
aW5vZGUuYw0KPiBpbmRleCAzNjk4MTk1MGEzNjguLjQyMTEwZDEzM2YxNSAxMDA2NDQNCj4gLS0t
IGEvZnMvY2VwaC9pbm9kZS5jDQo+ICsrKyBiL2ZzL2NlcGgvaW5vZGUuYw0KPiBAQCAtNTYsNiAr
NTYsNTEgQEAgc3RhdGljIGludCBjZXBoX3NldF9pbm9fY2Ioc3RydWN0IGlub2RlICppbm9kZSwg
dm9pZCAqZGF0YSkNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiArLyoNCj4gKyAqIENoZWNr
IGlmIHRoZSBwYXJlbnQgaW5vZGUgbWF0Y2hlcyB0aGUgdmlubyBmcm9tIGRpcmVjdG9yeSByZXBs
eSBpbmZvDQo+ICsgKi8NCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBjZXBoX3Zpbm9fbWF0Y2hlc19w
YXJlbnQoc3RydWN0IGlub2RlICpwYXJlbnQsIHN0cnVjdCBjZXBoX3Zpbm8gdmlubykNCj4gK3sN
Cj4gKwlyZXR1cm4gY2VwaF9pbm8ocGFyZW50KSA9PSB2aW5vLmlubyAmJiBjZXBoX3NuYXAocGFy
ZW50KSA9PSB2aW5vLnNuYXA7DQo+ICt9DQo+ICsNCj4gKy8qDQo+ICsgKiBWYWxpZGF0ZSB0aGF0
IHRoZSBkaXJlY3RvcnkgaW5vZGUgcmVmZXJlbmNlZCBieSBAcmVxLT5yX3BhcmVudCBtYXRjaGVz
IHRoZQ0KPiArICogaW5vZGUgbnVtYmVyIGFuZCBzbmFwc2hvdCBpZCBjb250YWluZWQgaW4gdGhl
IHJlcGx5J3MgZGlyZWN0b3J5IHJlY29yZC4gIElmDQo+ICsgKiB0aGV5IGRvIG5vdCBtYXRjaCDi
gJMgd2hpY2ggY2FuIHRoZW9yZXRpY2FsbHkgaGFwcGVuIGlmIHRoZSBwYXJlbnQgZGVudHJ5IHdh
cw0KPiArICogbW92ZWQgYmV0d2VlbiB0aGUgdGltZSB0aGUgcmVxdWVzdCB3YXMgaXNzdWVkIGFu
ZCB0aGUgcmVwbHkgYXJyaXZlZCDigJMgZmFsbA0KPiArICogYmFjayB0byBsb29raW5nIHVwIHRo
ZSBjb3JyZWN0IGlub2RlIGluIHRoZSBpbm9kZSBjYWNoZS4NCj4gKyAqDQo+ICsgKiBBIHJlZmVy
ZW5jZSBpcyAqYWx3YXlzKiByZXR1cm5lZC4gIENhbGxlcnMgdGhhdCByZWNlaXZlIGEgZGlmZmVy
ZW50IGlub2RlDQo+ICsgKiB0aGFuIHRoZSBvcmlnaW5hbCBAcGFyZW50IGFyZSByZXNwb25zaWJs
ZSBmb3IgZHJvcHBpbmcgdGhlIGV4dHJhIHJlZmVyZW5jZQ0KPiArICogb25jZSB0aGUgcmVwbHkg
aGFzIGJlZW4gcHJvY2Vzc2VkLg0KPiArICovDQo+ICtzdGF0aWMgc3RydWN0IGlub2RlICpjZXBo
X2dldF9yZXBseV9kaXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBpbm9kZSAqcGFyZW50LA0KPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGNlcGhfbWRzX3JlcGx5X2lu
Zm9fcGFyc2VkICpyaW5mbykNCj4gK3sNCj4gKyAgICBzdHJ1Y3QgY2VwaF92aW5vIHZpbm87DQo+
ICsNCj4gKyAgICBpZiAodW5saWtlbHkoIXJpbmZvLT5kaXJpLmluKSkNCj4gKyAgICAgICAgcmV0
dXJuIHBhcmVudDsgLyogbm90aGluZyB0byBjb21wYXJlIGFnYWluc3QgKi8NCj4gKw0KPiArICAg
IC8qIElmIHdlIGRpZG4ndCBoYXZlIGEgY2FjaGVkIHBhcmVudCBpbm9kZSB0byBiZWdpbiB3aXRo
LCBqdXN0IGJhaWwgb3V0LiAqLw0KPiArICAgIGlmICghcGFyZW50KQ0KPiArICAgICAgICByZXR1
cm4gTlVMTDsNCj4gKw0KPiArICAgIHZpbm8uaW5vICA9IGxlNjRfdG9fY3B1KHJpbmZvLT5kaXJp
LmluLT5pbm8pOw0KPiArICAgIHZpbm8uc25hcCA9IGxlNjRfdG9fY3B1KHJpbmZvLT5kaXJpLmlu
LT5zbmFwaWQpOw0KPiArDQo+ICsgICAgaWYgKGxpa2VseShjZXBoX3Zpbm9fbWF0Y2hlc19wYXJl
bnQocGFyZW50LCB2aW5vKSkpDQo+ICsgICAgICAgIHJldHVybiBwYXJlbnQ7IC8qIG1hdGNoZXMg
4oCTIHVzZSB0aGUgb3JpZ2luYWwgcmVmZXJlbmNlICovDQo+ICsNCj4gKyAgICAvKiBNaXNtYXRj
aCDigJMgdGhpcyBzaG91bGQgYmUgcmFyZS4gIEVtaXQgYSBXQVJOIGFuZCBvYnRhaW4gdGhlIGNv
cnJlY3QgaW5vZGUuICovDQo+ICsgICAgV0FSTl9PTkNFKDEsICJjZXBoOiByZXBseSBkaXIgbWlz
bWF0Y2ggKHBhcmVudCB2YWxpZCAlbGx4LiVsbHggcmVwbHkgJWxseC4lbGx4KVxuIiwNCj4gKyAg
ICAgICAgICAgICAgY2VwaF9pbm8ocGFyZW50KSwgY2VwaF9zbmFwKHBhcmVudCksIHZpbm8uaW5v
LCB2aW5vLnNuYXApOw0KPiArDQo+ICsgICAgcmV0dXJuIGNlcGhfZ2V0X2lub2RlKHNiLCB2aW5v
LCBOVUxMKTsNCj4gK30NCj4gKw0KPiAgLyoqDQo+ICAgKiBjZXBoX25ld19pbm9kZSAtIGFsbG9j
YXRlIGEgbmV3IGlub2RlIGluIGFkdmFuY2Ugb2YgYW4gZXhwZWN0ZWQgY3JlYXRlDQo+ICAgKiBA
ZGlyOiBwYXJlbnQgZGlyZWN0b3J5IGZvciBuZXcgaW5vZGUNCj4gQEAgLTE1NDgsOCArMTU5Mywx
MSBAQCBpbnQgY2VwaF9maWxsX3RyYWNlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBj
ZXBoX21kc19yZXF1ZXN0ICpyZXEpDQo+ICAJfQ0KPiAgDQo+ICAJaWYgKHJpbmZvLT5oZWFkLT5p
c19kZW50cnkpIHsNCj4gLQkJc3RydWN0IGlub2RlICpkaXIgPSByZXEtPnJfcGFyZW50Ow0KPiAt
DQo+ICsJCS8qDQo+ICsJCSAqIHJfcGFyZW50IG1heSBiZSBzdGFsZSwgaW4gY2FzZXMgd2hlbiBS
X1BBUkVOVF9MT0NLRUQgaXMgbm90IHNldCwNCj4gKwkJICogc28gd2UgbmVlZCB0byBnZXQgdGhl
IGNvcnJlY3QgaW5vZGUNCj4gKwkJICovDQo+ICsJCXN0cnVjdCBpbm9kZSAqZGlyID0gY2VwaF9n
ZXRfcmVwbHlfZGlyKHNiLCByZXEtPnJfcGFyZW50LCByaW5mbyk7DQo+ICAJCWlmIChkaXIpIHsN
Cj4gIAkJCWVyciA9IGNlcGhfZmlsbF9pbm9kZShkaXIsIE5VTEwsICZyaW5mby0+ZGlyaSwNCj4g
IAkJCQkJICAgICAgcmluZm8tPmRpcmZyYWcsIHNlc3Npb24sIC0xLA0K

