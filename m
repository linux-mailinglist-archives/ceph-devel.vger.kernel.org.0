Return-Path: <ceph-devel+bounces-3018-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9B9A97576
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Apr 2025 21:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3153BA79D
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Apr 2025 19:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7E423BD06;
	Tue, 22 Apr 2025 19:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dD/se4kb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B86230BEF
	for <ceph-devel@vger.kernel.org>; Tue, 22 Apr 2025 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745350344; cv=fail; b=PwRYdI3Z5errpZ+m5rKEcx9vrnAPKPcdDlPTTigHjoUcYoeKGjbAbsck+Kwlgx7+mAa1qCguXAMYtiAzK+31GjI3XaDSioUHB0RtcT7fyzYdQfoahpC+UXPTicBudU4oI1BzpYTbYfB7laBgHSK6NOb6/gtYdQlRroaAOmQ5IK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745350344; c=relaxed/simple;
	bh=ZwVmZcsfCpVA2wpOgJSi2dWzTDs1l7A2Rb5xjXKOuZ0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=rP8OfDJm90eezUzLiG2hkpPzXi5kzPN9Ukzjdx2tsRlu1cyP2S6Z5KAQsKkMDaQKH7YtQxreWG4fkqlNCm7Zz9qvJHr6A4FYQT0+I6xQx8JaO9kWh5142WooK3IpiP0NCyddF2OhMC2esZqb60iH6Yd68g2w0SG62eKfUS2dmrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dD/se4kb; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53MAbWtD020829;
	Tue, 22 Apr 2025 18:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ZwVmZcsfCpVA2wpOgJSi2dWzTDs1l7A2Rb5xjXKOuZ0=; b=dD/se4kb
	ZFeizmUVS/XXSS92zsQ9ivMKQrnvG4uutdt1JKrWc0dvfvRu9Iu6+a4IiNScH/bN
	Cubta89r0A9Peagsb3OS5WmAJYN6gyQ5pluESMcs7hus3ImNKyD7NcU0JT6B1QKx
	FjuCPvtawESvniIkfFi+2LcXon4a1zld8WXyqvqFDih4OE4dy8/6N/5fitC5BvlJ
	t7Iwxs+BVNRj1/FeafmmS/1mlV2JytrdFGv55mYPn7ofG/3gNdFWuMp3Z6HLKIGC
	GzuYLIXINMZ2fZCGieAfb2k4LW7iuM2E96eTRjZcuthRe/rWNvOloVqO0q3DGBmc
	ZLytWrJYmSdcRg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4669h1jb0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 18:26:01 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53MIQ1vg008024;
	Tue, 22 Apr 2025 18:26:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4669h1jb0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 18:26:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uDYQi3ibYz4jq/tqUy4ntfy223d2idywDgET7PECJV3ASd9qdtBvtBTt+jECm5Qf7OwrdqOuD1bNMurG0sFZSj8qmQmCKEWfBzRmWy7EcNI++TRkLmVaUxWd56eD5vrxwRxLktIRWlo3WtGnBCFWoj7ZzJ3vK1QRKN8tRRz01H26+qwmzDVrkzo89Nwr21uy/MlAqrjY11WZejyPhEs3lIHQT/QKPpsBEo11npUV8jGTdVvOKqa12cPIAuG9RbcPEgTaxRIy6YnAYPZ6r6A+e7SXY+9jFxyQyy2Au9bxJG5BFrYUIoX15kxcu9ZfBpmj1xwbRAahbsVM6SAtcmGvxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwVmZcsfCpVA2wpOgJSi2dWzTDs1l7A2Rb5xjXKOuZ0=;
 b=R9C1TgowW0pk6g7CZKqzFVbk0R/Yj1yrH4jBkHSjDTo0uPtBumvSdX57MOGCe4Wqti9u4B9wE6Ut+wxO/hvQerhbeYdJMzNCHOT8fz+0jJy+W9b6xqzI1Aycy+hp0r5+3G3hOUg6hc1ycqU5gAVEIFlAq9jthBpN9YGj7CFo5lvvoM3dI8TJmVNw4FayjJ/WQbUvFNyh0V8vSZhFLR+cIIL4leci0EjNQh1j3KL2rc8KKlu+s7aDpqfWa6B7Bn67qQVRXhUw39NK99kcoGsqd523CfEKRE4gbJrzp9oWI6bowAXfaRQTJyWwZOJIJJEaNfogEOwsH4TrzRceDnWLHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB5287.namprd15.prod.outlook.com (2603:10b6:510:14f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 18:25:59 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 18:25:59 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>,
        "d.kandybka@gmail.com"
	<d.kandybka@gmail.com>
CC: "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: fix possible integer overflow in
 ceph_zero_objects()
Thread-Index: AQHbs2nCTOayZkB+SUOfvlR0hiCJ2LOwASeA
Date: Tue, 22 Apr 2025 18:25:58 +0000
Message-ID: <601d58859a0e69f188e62c2b5339b75aca2e5a3b.camel@ibm.com>
References: <20250422093206.1228087-1-d.kandybka@gmail.com>
In-Reply-To: <20250422093206.1228087-1-d.kandybka@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB5287:EE_
x-ms-office365-filtering-correlation-id: 3b177aac-466d-4bee-a722-08dd81cb2119
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RnQwWVYyaktyV1RQcjZZV1lCYmdCd1kxbkpKSkhjYjZJZlRPSSs3SkxGY1Js?=
 =?utf-8?B?NFlRQ254VnpoNm1MZ3JxM2hsK1dZSG90RGxLY29UQkpEVDVRMnRGSXVNY2lF?=
 =?utf-8?B?SnpqZEErQWlOb0lTcWlzaGZqOSt6N29xbWtvQ2h1cTJabUs1YWlCYjF2cDVB?=
 =?utf-8?B?bEtFU0RIVXdUV1RESHcvbUxhK0RGNWZmNmZUWHR3K1JibW1nNEZsK3IyMmY2?=
 =?utf-8?B?VDNrNWdQeWtMRUFMZVpnQk8wa1RzaGd0YzA2Y0VSQTVBVWtsK2YxUnFWQXp6?=
 =?utf-8?B?ZXhIcDRrMmFXSmt2cmN0VVE4L3ZEekxROU1Kc2JOS3l4VnJxTG5RdkF0L2li?=
 =?utf-8?B?VGU3V2wrT0RkcDlCU0Izc296YTkzMWxqaW9tM1JrUVlVZTVQd2pON3IwMUNu?=
 =?utf-8?B?QzlhcVlUS0ZHNmoyNVpSSDJUc2NVVmFReFM2USthRzVpSVpIZk5zRWxKaGZz?=
 =?utf-8?B?TEVPdHEyZGFUd3dqYXZaQnRqdTF6R0VWQWJXY0ZOcFh6S2M0elVDWW1ib0hH?=
 =?utf-8?B?RzBXR3ZDTHdIY1FHV1R3SzRGRlFnZ2pzVlQrOWZYUWVGaTVjdXE4anVnUlFC?=
 =?utf-8?B?Q21YVzh4NlpLbTVaSStPWnVxakxwbWsyNjZvLzRVakJiVTZXMzl2eGNhRHVn?=
 =?utf-8?B?WC9KNTA0V0MyV0RmS0hCQmg2eG9RUkh3WGlvSHg3TDhOT0tDb2ZrbmJsQkdt?=
 =?utf-8?B?V2FCclA4dm9PR0FQRHRiRElMbURJbkVmem5PWUcxVjhzOWFNa0Y3NE9JWUh4?=
 =?utf-8?B?QXJZL3I4c1JkdG9EODQrTitaTjgrVXpYOGZ1UzdKQzBvaXRBL1ZHRWhHRm5S?=
 =?utf-8?B?NndLZ1c0N1RtT3ZMUWVPd2Y1ZFRlaTUwQ05NMC8rdUJiZlFRZkhuci9Ua1Vq?=
 =?utf-8?B?L3lGNGFabDRZM0JoMlRBTWViajlBaXI2dGNwTVR0VFNCUE1JMzFxVkFzZ2hC?=
 =?utf-8?B?S01iVUE2OGZ4dVlQSzBBMVpHZm1PRGxjMkMrZTR0d0ZteDZuK1BJM3BWNUw4?=
 =?utf-8?B?aGNHeTViQ0ttRjIvWW83eEhON0RMa2RRQWcya3o4cXUxaUpzVFRSNmNrMFpK?=
 =?utf-8?B?OTdTbERSOHUzUnk1R1laVThoVFRWem9UNnhHKzFPR0d2NzlvK1NKSUhQVTNQ?=
 =?utf-8?B?MVAzaHF1cU80TGRMalZYNTZaMFExek51QXYrWnpHNldnYkpjQllOcmVRWXVy?=
 =?utf-8?B?Ly9FNk5admpYVEMycEhHYUs2WUdDYVJ1c1AvdnBManZXd3BMM2wvY1cycmp3?=
 =?utf-8?B?OWEwazd0eklCYnA0NWJrMUNsYlhnODdqNHBCSkM2OFozcjhJR29CUm9DK3Bn?=
 =?utf-8?B?Sk9KTzEwbE52NzRkaWtWaGZkdEFDRTg4MGZpNzdkVHdvZHRHN2s4Q1JpVlpP?=
 =?utf-8?B?UktzV0JvdmNJUDBxUE5Mb1l6RzBBcGJHcURpcW5qSnlZcEdUMVZiRFlweE1u?=
 =?utf-8?B?a2E0YjcrSHhBdnhBYlZJU3dwOWxvQlF3dW0yaEVTcVBQdUg4U1laZXdNU3pQ?=
 =?utf-8?B?b0hScXdWNCs1d2NEQUdHSjJ3MlF2MmsycCtyRDhYUndQZnlvbXlRWkpyL1JB?=
 =?utf-8?B?VVNpL3BYT0JqTks2UFRHZkJnK00zZUFaUzhmbHBrYnY2RFRGTXhCc1hPOTlL?=
 =?utf-8?B?TklSa2VpeURXNGxzcDhyTFVTSDRZQmwyeUJKaUNPdlh2alczOTVRazZZTGRW?=
 =?utf-8?B?Wkx3TGwxZnBRM05MSUwySlhSSmxJQ0U5ZEg0a0JHeEl0WEtBQjZPUW5POERI?=
 =?utf-8?B?bjduUHVhaVd5bzBHdFlOV1c3TTAyWURYWm5hR3lOMy9sY3p5SmIxOWR0Rkpj?=
 =?utf-8?B?aXNqM1ZiOGd6WUtRbVA4Q0p1SkVjUUM3K1ZseUFvUk1paVcrZ215SGQvNndX?=
 =?utf-8?B?VkpOcyszcW9oUjBZL0JaeTJvbkVEb0J3Tjg5MC85S0xuUmpQajhoeWIvVXMy?=
 =?utf-8?B?ekpUTVYvYUNYNjBYaWV2R3VsQ1c0NlhESlpHV01tRWNxQ2NxelorT3lMS1RT?=
 =?utf-8?B?VDFjZkNBSllBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bERQNi9uSXBGWWdyRFg1eHYydFo0azd4bnlrSGtKUTdybjVJR1UwcWs0RkJo?=
 =?utf-8?B?SUtPTld1SmNHS1gyLy85RnRKd21oYmExaEVsZm4za1R1YSsyVjRnb3lIUUZo?=
 =?utf-8?B?UTF0TS9TYVphQ2M3YlU0UitPQ2xUcXhaVkxHYm9hakhiU3lxV2VkNnY0dDFq?=
 =?utf-8?B?UlJHcjJIZ2FSTlZHMzhGOXl3VlBVSmhXQ0tSNGdVaEx3eUg0UWhVaU5uTGRh?=
 =?utf-8?B?S2VRQ0pNSlZMZDh1MDY2UEcxY3dGUnFDdHlBcTBQckNwekZIT3JvSHFhc3ZU?=
 =?utf-8?B?dXZzM29hZFJRTExvY0tTR0pWaE9WWnFYYVUzaG54WHAvdk82cGVuUVZnN05R?=
 =?utf-8?B?SlpPWnRVbGlmNzg5TzFjT0F5bVlmYktZOEsyWlQwK2dhbmFGbVVwRFRJT2xY?=
 =?utf-8?B?VVZCWldZc3dUZnVjMFZuSHdJaTV4YzlaK0lFYnVRaHJYQWVlc2JoRGpqd1Zi?=
 =?utf-8?B?VTdaUHJzTXZha1FweW9FM2ZUOFBvT1dFNEdaZ2w4bzhlVWYvdjY2bTBVM2Rn?=
 =?utf-8?B?RnBEWEw2YVFONDMrL0pMVDBqbldObU4ySWo5Q1ZJT043dFkvZDJDN2hVNU01?=
 =?utf-8?B?MWxjdFVDdDEzZGtTcG5XclVQOXpqVENPNTdYVVdITWo4NlkwMzNoaVFRa1NZ?=
 =?utf-8?B?MTZUZE1FdlVIWTgxR2VVNzU0YnQyRDFqYkVyaGNqcEIrUkFSeTFrUS9yVDJM?=
 =?utf-8?B?RU9JYmt0anNUaFpuejRGdG5zZDdFdGZ3SDZoYWc0cU1vSGQyNzBHbXArRnNX?=
 =?utf-8?B?TmxsbDFqQ1IzMXJ1WUZvVk50OUFJT1h1SkVOWWNtdHBtbVI5eDVoUXdlL0Ex?=
 =?utf-8?B?aDRWSThKK3ZXR3BPNGlPckZsQkc0N3FXcGFJZllpUS9LTGtIUURsayt4SmU4?=
 =?utf-8?B?MGpUdmJLOVlvZUVWeFQrSW1LU2FLMHF0c1ZrUnQycjBHb3Q3dXR0N0tIMHAy?=
 =?utf-8?B?RDhISm5xVmhsK0M5ZmREazNnUkNVK0grekNnU1A1NDU2Y2h0d3dsZFRteTZY?=
 =?utf-8?B?dHU5d2hLNDR2VHlUekk5ektUSDJCL213R2RYbllJUEVVSW00K29yQUVadUNh?=
 =?utf-8?B?Tm9iVktoZ1ZuMVZ5ZEN5Rm5OLzk1K0R6ZGRHakxMRXVPajIrNDZ5WWFiQ3NO?=
 =?utf-8?B?WjA2WWxndDV1QWovWktsOUU4YW1veWxsQityMnR6SjJaUnFYcHZMRkVVYzlD?=
 =?utf-8?B?Smw0TlNtT3JCcDZRVXpZaVBPV2htR28zVDYwUm51Tks5TUJiQkVOdzBTaU1H?=
 =?utf-8?B?SmdOamJ4RXFGRTVETHFoTUFWSndMblU5ejhUNXYyUVgxQlZVaU5OY0YvTVd0?=
 =?utf-8?B?eEJuTVgzMDYvbjhPV2o1TWE1UlBZc0pUL0xpbzF4SXl0N0c3NW9WeFFIa3ZD?=
 =?utf-8?B?ZkJmUWlyRHZKUXBVR3VhYzcwWlYxRS9oMWpXMGZoclB5ZXQ1dkFZWWU3WHlU?=
 =?utf-8?B?N0h5aGpEd3ZnY2pkcTJaQmp3aVlLUEE2STJsdXZmVDIzTnJ5cDZTNkZObnRE?=
 =?utf-8?B?ZGhxR3RWcEdoZnBhNGFzR3l3WFV0b2JSL1ZFeUw1VUd6Nm5uK09qRDg5TDhw?=
 =?utf-8?B?U1kyUW9OUEtJUWdWRnFIUHhuU2FuUUhxY0E0L1VadHZCeVlUREJJRjNpbEZj?=
 =?utf-8?B?SS9jelN6VGVlanZxU1RNNFhha2lpMjRRTVd0S2xvcGU5K1ZkR1JJcEZtYWIw?=
 =?utf-8?B?Mlkwb2pxSEVuQmxVdmNEa2hJajArdVlQYWJzcWwwdmpRSTlJbCsxSnlzbjh5?=
 =?utf-8?B?VkFQaWtkTmFrVjdwQkRBaEpabXNPRHJhNHYvSG9JVkY2bDQrVG56T0JPU3JF?=
 =?utf-8?B?MG5QYUkvQ1ZrYWIva2QwSG04ZU83QnRjYnIvSmRGQVlWSy9ZZVN5QThwRjFx?=
 =?utf-8?B?SjA2QnNrUnQ4bjBSOXdFMDVoWm1DSzk0S2V4QVc3RWhJdDFuUTZoQ2JDdUQ4?=
 =?utf-8?B?R3Y2ejY0MitzRkxxK2MrdHp6Mi8vSndFc2ZreUs2bEhlRHRPVlJpcmk3ZWxU?=
 =?utf-8?B?WjJLaUhhTEwwTjFiQkw2a2MxeU51d2RUVVRCK3BBbTJjUndtdFQ1d01nYzhr?=
 =?utf-8?B?Si9zLzVuYndxeE1PNTlGVHpSanpRaExMUXFaRXhRZEdPTDBzbTBPSUZCL1o4?=
 =?utf-8?B?ZlBxVFNuMGhmb1FsUmNpN3RLWk5iVUJrOEc3U29SQm1nWU92cDJxdFd5WGt0?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <757DAD199B9350459EA11D4AD0693BF4@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b177aac-466d-4bee-a722-08dd81cb2119
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 18:25:58.9779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oNTJ5VLixdNpdZsyRE8Pp8rn5ySFgb/9ULd08/8mRLFVAX/ENdP+OVTliJnRA27pkba4CEFa3vuZrViJftZ0+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5287
X-Authority-Analysis: v=2.4 cv=XvP6OUF9 c=1 sm=1 tr=0 ts=6807df39 cx=c_pps a=oQ/SuO94mqEoePT5f2hFBg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=HH5vDtPzAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=FLGt9KEoI4YcIy2scO4A:9 a=QEXdDO2ut3YA:10 a=QM_-zKB-Ew0MsOlNKMB5:22
X-Proofpoint-GUID: i8NVPYQPD9Q3eETHAaJKLqzQiCkPoIHB
X-Proofpoint-ORIG-GUID: u69dhnoPO41_PK28oEh7jqNihcfT1v1G
Subject: Re:  [PATCH] ceph: fix possible integer overflow in ceph_zero_objects()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_08,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504220132

T24gVHVlLCAyMDI1LTA0LTIyIGF0IDEyOjMyICswMzAwLCBEbWl0cnkgS2FuZHlia2Egd3JvdGU6
DQo+IEluICdjZXBoX3plcm9fb2JqZWN0cycsIHByb21vdGUgJ29iamVjdF9zaXplJyB0byAndTY0
JyB0byBhdm9pZCBwb3NzaWJsZQ0KPiBpbnRlZ2VyIG92ZXJmbG93Lg0KPiBDb21waWxlIHRlc3Rl
ZCBvbmx5Lg0KPiANCj4gRm91bmQgYnkgTGludXggVmVyaWZpY2F0aW9uIENlbnRlciAobGludXh0
ZXN0aW5nLm9yZykgd2l0aCBTVkFDRS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERtaXRyeSBLYW5k
eWJrYSA8ZC5rYW5keWJrYUBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9maWxlLmMgfCAy
ICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2ZpbGUuYyBiL2ZzL2NlcGgvZmlsZS5jDQo+IGluZGV4
IDg1MWQ3MDIwMGM2Yi4uYTcyNTRjYWI0NGNjIDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2ZpbGUu
Yw0KPiArKysgYi9mcy9jZXBoL2ZpbGUuYw0KPiBAQCAtMjYxNiw3ICsyNjE2LDcgQEAgc3RhdGlj
IGludCBjZXBoX3plcm9fb2JqZWN0cyhzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2ZmX3Qgb2Zmc2V0
LCBsb2ZmX3QgbGVuZ3RoKQ0KPiAgCXMzMiBzdHJpcGVfdW5pdCA9IGNpLT5pX2xheW91dC5zdHJp
cGVfdW5pdDsNCj4gIAlzMzIgc3RyaXBlX2NvdW50ID0gY2ktPmlfbGF5b3V0LnN0cmlwZV9jb3Vu
dDsNCj4gIAlzMzIgb2JqZWN0X3NpemUgPSBjaS0+aV9sYXlvdXQub2JqZWN0X3NpemU7DQoNCkZy
YW5rbHkgc3BlYWtpbmcsIEkgZG9uJ3QgcXVpdGUgZm9sbG93IHdoeSB3ZSBhcmUgdXNpbmcgc2ln
bmVkIHR5cGUgaGVyZSAoczMyKS4NCkFzIG9iamVjdCBzaXplIGFzIHN0cmlwZSBjb3VudCBzaG91
bGQgYmUgcG9zaXRpdmUgdmFsdWUgYWx3YXlzLg0KDQo+IC0JdTY0IG9iamVjdF9zZXRfc2l6ZSA9
IG9iamVjdF9zaXplICogc3RyaXBlX2NvdW50Ow0KPiArCXU2NCBvYmplY3Rfc2V0X3NpemUgPSAo
dTY0KSBvYmplY3Rfc2l6ZSAqIHN0cmlwZV9jb3VudDsNCj4gIAl1NjQgbmVhcmx5LCB0Ow0KPiAg
DQo+ICAJLyogcm91bmQgb2Zmc2V0IHVwIHRvIG5leHQgcGVyaW9kIGJvdW5kYXJ5ICovDQoNCkxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5
a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCg==

