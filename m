Return-Path: <ceph-devel+bounces-3981-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 443A7C49271
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6749A4EE30A
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 19:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B879C33F367;
	Mon, 10 Nov 2025 19:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qgtc/d+k"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D408D3385A1;
	Mon, 10 Nov 2025 19:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804650; cv=fail; b=BvDRh7tycJk8ZfAm/tWw3DOx3q4KOEgzvoCYdGobDZ1dee3ht0tOW3In1yhsbtJL068zXQol0nwsL1jNlWAlPK2Lkj5U95q/2AtEdrnrqOaFRJFMyv+tFbfHtapdsZTJMNjipmS3r6wu/f8y2n5rv+LXoQXMX6ttum/2vYdbOXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804650; c=relaxed/simple;
	bh=hm+VQlmfkLSY3C1vPmg36/nhLpGXT2OjYRtYH7i/5n0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=V/uOmbS6nvj+Z3LLRlAqA2Ptuy9wQEWcxqGh3LzD3TnXCqSazdA8EIpqtwBMqjb6MEfe7U0LRjnx0te8W6OG6EbJBo73pWH95D8vYQk9m1Bj4Z8nQUKa6jbtihA5L2EKqc5SWpxL3JA8vPNRDkLO/NKm/PJdjXxgplj3BbcXTJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qgtc/d+k; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAG3MpC003210;
	Mon, 10 Nov 2025 19:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=hm+VQlmfkLSY3C1vPmg36/nhLpGXT2OjYRtYH7i/5n0=; b=qgtc/d+k
	Wx+l8zjzJit0v2U/bDX1bGF7iJa1yOeM5uZloNZhPoyCu6uTXs4j5r0DxyzEbUga
	I/akn8ohn67KsyIb7lWXVXqnsb/LoeKEQaF0+kD1/Mxhe8UhiyN/Woi9moHzi/U9
	EhjFs1WjInXyBYG2FAKJqM17bP1JOkZ8r/dm8abL2lkKtzhhZLz8hitxSdBL75Xv
	C+yFnx7rNLKON3AFCRYz1AznlxgaGzbHPS7H6cQx5Yc0e1qzpgdy6NTtn4KSs8q1
	WbyhnQmAPaWFelglXzzZWWNl+kl3NN0SbEXhf/bKNOaPgzEXVqnBbiacjpNIhFd5
	ljRnm1TJWrbg1w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81xg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 19:57:21 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AAJpO2s002171;
	Mon, 10 Nov 2025 19:57:21 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010033.outbound.protection.outlook.com [52.101.193.33])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81xg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 19:57:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/ihXOHjjHNAPRbPQ5YLwxnKRcLeB4KHXI4ZFGmBQpEQsCnwdG01TnuV/51IYdV2K2IXS9YJu3un7aU0CvqymXF+BldYt/c8O8dlwcluJXyNOixBCj7ii7Mec7a0W2I05W1iqQplDxkjJSQLIc/6g4xjVUgtt6Kn5BHTl3bzDtv67/QeVmTYlF2VZscdJPPpr0tQDDn6l9JDno2TaRimH+yf+C5iLztbW1OtsdLZhh0zxg20am6lVdmjt6JNM8IRVUg17WiaGNzwGHFpwDtG/Lxy+G304TRswdzeMRtT6bd+iEzK7iLE9vyeFp2Ekx8eCUrXRAlsC4Ec2Aoya6MIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hm+VQlmfkLSY3C1vPmg36/nhLpGXT2OjYRtYH7i/5n0=;
 b=VwmOCOoiMIxn/jEQPWap8B6whOI/2G/wA11HBD17lTX4ATLfNAz0U862gMLYaY8DgUrSoWIF4nh7jPDNZS6NJEL1pm9MOuOukU5IKMEfkSkJnC0jo2ZQoE18n2ZfT1fpkMQL5wfn53QP3pyrIYs515WWk5QA11RdCmkMnlllFUDZEaZyNtY0JL27bH3VKFgRDjEmsyX0oREb1o637zq6RiwZCxHeN9G7ZaknmmCO/B5ZUw76TXwp3HV4qTolgeDT76BFZNPD4jV2jIcpI6yu2WrBGnoC4sNJ0n8MFCOZKuHlFHQbVBAYCeEVeMcdvAl8M27JWd+m5QxSSmgZVpCyhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA0PR15MB3887.namprd15.prod.outlook.com (2603:10b6:806:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 19:57:18 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 19:57:18 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Gregory Farnum <gfarnum@redhat.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>,
        "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com"
	<nick.desaulniers+lkml@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] ceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcUnsZwcN+bEDhFkO0820vr4BqvrTsU3iA
Date: Mon, 10 Nov 2025 19:57:18 +0000
Message-ID: <01593a9ca971421a39c483819855d41c251da905.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
		 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
	 <CAJ4mKGYPoxPS62yFigmqFPPTHOSwgtj+WKwEtdpNGsu3BJya3w@mail.gmail.com>
In-Reply-To:
 <CAJ4mKGYPoxPS62yFigmqFPPTHOSwgtj+WKwEtdpNGsu3BJya3w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA0PR15MB3887:EE_
x-ms-office365-filtering-correlation-id: fcdb34a7-6590-4b05-df0c-08de20935ab6
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z28wYXVmRnE1RFVRenRzNnRPc1VmNTUrdGdSdFZ2b01NZUdiUkE5Sk1vc3R6?=
 =?utf-8?B?aVJpbS94NUpOVVNBREwvdXZKSEwyZlNnUjdpUUcvN3hDRlg5VTN6SE9sWFp2?=
 =?utf-8?B?bHBlWm1XL0NYNTg3YmwwMHAybnFhV0RFMzN3eGxzSTRhdzRxZm9CNkhpUGRa?=
 =?utf-8?B?dEJsOU5IZ1pwSUY2b1BiUWcxclduNjBHekk4dktLZ2FyMTR3Y1QyQndDRU0v?=
 =?utf-8?B?UEJNVytTVEhTdnYzQk9kR0hMUEZ5SWMvcHdmZHFndEd5bTZTUGJQUXhqRGxS?=
 =?utf-8?B?TnZoUE9UbjhyRU9LVFVzOUxDdmdNei95STB1a1k1YVU3MTEyTzJGUEh1QXZP?=
 =?utf-8?B?N0ZvelNoazA1V2tpcWtFSmhEai9OcE92ZHk4RHdXdDQ1cFNDUElkSmJoQVdN?=
 =?utf-8?B?UWJKdEdXeGF1Rm1nZWJCaEpLR21SL3RhZllBaDY1TzFWeU9kbHdhdkFPQkp2?=
 =?utf-8?B?bFM2NU11VUFEYUlQZldGa2FBQ1l0d3BnSklRVGVZa3NhWXZOTVBNMlpQcW1M?=
 =?utf-8?B?L2VncDE0UFhjam0vR1dFZ0tKQnBYbXJ1ZklVaVFmaGJYR09UN01SU0pTK2tY?=
 =?utf-8?B?UkRnTUJRWkNhZThJcjN3aS94eFhrYkZOd3ZiMGI2MlAvdDZQQW9UbkQzNkFa?=
 =?utf-8?B?TmEwMW9oR1Zsa01RSVJQbVpEVHBDTWNDK0NybkVpb1VVeGlaTG9CNjNrMEN0?=
 =?utf-8?B?citmSzZKN1lQMWl6cXRLTXMvUEhlaVFXSjhiSTJjMkl3S0w5Vm9zbzNEMmlo?=
 =?utf-8?B?SE83Vk1tM0t0dWtqeWI2OXlWY29nZ1pNaEpUZUZZdGlRYjFJdHpOdHphOHds?=
 =?utf-8?B?cjJMM1hpMzF5RDZRZTB0OTRLTkVqRFNhR3A4eTIyaTZyUUZtTDVWQWxRVVhp?=
 =?utf-8?B?eGpncHBTMzVRbW42RWhXTjlwc2lzSkVYOWhTSE1kNWpBRjB6ckVQS3lYN2I2?=
 =?utf-8?B?LzA3TTQ5MXRlMzNPRkdBYWpuOE8xVmxGNC9aTjJwS2NWRDhsZGpqUUcvS3ZC?=
 =?utf-8?B?U0p3WEJLMnBBR2ozV0VtOWtlRjV6WkJYUEF1dCtjNUdQYW02cWZubE9JaElE?=
 =?utf-8?B?Tmt0R3lPdGtzOE5uMW50amNaWmF2Z1l0SjR3dmhaNDFmd1dpbUtsdlZyMXdZ?=
 =?utf-8?B?WU13UDhEWTZ2V0d4dllxa29zMkp0TVlMQjVQYXlDWVpLbGJ6Z295OE5XMmp6?=
 =?utf-8?B?S2x6aWRzQ29oQzF5ZWVqQXIrTlFocGlGb3UwMnFsRTBsNC9xam5iMERaOFll?=
 =?utf-8?B?aHRJcXNXcW9XNDNWVGY1RjQxOU0yclZQS1p3UmVnZkdLREs2K1UwejlXZE16?=
 =?utf-8?B?ejVKOEJVUzNzMWVnYjYrTHI0a3FXajU5dEJkenBSOWtUVittNjlSckhOK1BR?=
 =?utf-8?B?VFdtU0R0cmMrc0ZRM3ZHakhwcE9aWWFoR29YcWxQbTZYQkhKOTBwUVcrZnVV?=
 =?utf-8?B?bXpQQllQKzQveWF2elhqWi9VZERtalBKeGlVTjB4OXFlYTFQb1lvZWxMTmpU?=
 =?utf-8?B?czRWTVVybGx0clBjNkZmdDk0T0NTZFFQTzFWNTh5ZVZpSmFUTDQyNkVubWVE?=
 =?utf-8?B?bERTNE5zKzNEMUQxQ1d6MXcwR2xoSWp2YVZ5SzNuQ3JHSHdHcHpXTXFQeFFY?=
 =?utf-8?B?ZHptSWE4cWducCtLUnY3WWJOOWJ3dnJkWTRGcWpOUHZzTi9BL3l4dUVlZGxy?=
 =?utf-8?B?dXdqMVVoUnZjQkloNTdaSWJlRHBwM2tiQnRDK1hZR1R6R2FKdU1TaTdBUkVR?=
 =?utf-8?B?UHZ0TGJjTVdCYlF6ejBUTXNXL3pIUXZxSDIzSjZyUG04SjU4OHVSaUphRGhX?=
 =?utf-8?B?dlNUUDlodU80T3FxUlFJcUxqZE16UEcwRUNxZWRuTUZUa3Z4RnNNTWdTdnMy?=
 =?utf-8?B?OVZOYkhySzJoL2Y0RnR0eDd5Z2xsSS9VM3gxaGY0Unk2cER6Tm5OdTFSNlhF?=
 =?utf-8?B?N3Jldk1kak51dFE5VlJ5QnIrY2pxeFhwTG8wUlZDNEN2OFByL1R5d2VoL0ZB?=
 =?utf-8?B?M1NDanRQM2J6UUdEaUE1T0RMYmNuQXFJeXpHVnN1dlA5WUZCU3ZMUTBzaHZ1?=
 =?utf-8?Q?8Zsy3g?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VnRTNGdZdzFPcDVybnBlbndyaUdNa2c0WmZhL2ZSUS9oZktZYTRoZEQ1cExa?=
 =?utf-8?B?blpDckF0eldMQmlFY2JpaGc0dzlNS3ZTQmtzVlcvQzRJWlVuR0M4SHo0UG05?=
 =?utf-8?B?OXRPaytMajNuZDBnd25zbzE1S1JQdnZ4eW1TZ3ZsYmE3ZzFMZkdxc1pVYk52?=
 =?utf-8?B?azhqa0ZQR3BWTEYyR1VEZEhiOVB1NzlWMkpRNXYxZnJVK01JTFVOcURydEd2?=
 =?utf-8?B?S3BJUDNrZHRVcTRiV2dmbXF6R0Zqc05CVVhJblhtaWJnbysrRzdvcHhvQU9r?=
 =?utf-8?B?R2JBY09qYk1yQ1JRNGZxZkJtRUZJWTdJMkRhNzAyR3ZrczVjM3FweEZaT2ZX?=
 =?utf-8?B?SXVaMys5Q3FrRG5jbENaVTFOM1Y3YlVSWGRJcTRXQy8wblBjYzQxOVlhcDZJ?=
 =?utf-8?B?NWdCVEQzZmVHcys4VXI0ajhuaGd2MUMzeXVDdGZRZkphazdZN2FZTEpvWlNI?=
 =?utf-8?B?ODRsS0FCbW5ZdnBCL3ZUVTdrZHoxMkYxNTBhOVVmM1NSUG1PZjlMSFlhS00v?=
 =?utf-8?B?ODIzSDZWTTkvcDNmQ2dMWmt2cU1zSHVZTkp6Z21zS25Oc3k2TllXSE1pME5X?=
 =?utf-8?B?NG9GSDlBdncwbTBjNDZmcEZqYVJSWkthQzZPZlJyZjVYdUd3MUdOL0YwZlVV?=
 =?utf-8?B?K2lOSERFMFRNcU8rSXpFQk56TTI2b2I5MXJScWtqZTN3T3pFZHVDTVBGQk1T?=
 =?utf-8?B?eHVUSEt4aTRBU3N2MmVhT2xJb1RhOWlCbVVyMXBmOW9IdXkzd0lIYitPeWNG?=
 =?utf-8?B?TjVvZmcvK2JrWWhSUVlTbS9IQ3R6dEtFZmlFUU9WbTh4RHdGcXlCQWdIb0tx?=
 =?utf-8?B?TkVHd1VjVHE2d3NhdndtRGdmQlpNSFFiNko1Vkwvb0kzRkQ1Mm9NeGtnOGNl?=
 =?utf-8?B?ai8rRHUyMWMxR05GMHdMelJYMGVkeTNwVzFSalFwaGljSUJGMzlBd3BFblZ3?=
 =?utf-8?B?TU1WQzhCUUdXV05yeEZYUEVBU21NZ2s1SmxwYTlFUy9MT0l0emFFeVZpeTZz?=
 =?utf-8?B?bHEzSFdKamp0ZmZ4UEtkR2FRWEUrY2xYT09rdFJuUStyVUdZSXRoemx0U1Nn?=
 =?utf-8?B?SDE5c3phaEh0aWt2SjVLVVFQNmN6OXB2cFZiRFRONkF5emV6S1FJS0xPM3hr?=
 =?utf-8?B?cjR3bW8vci80K0JTQTN4bkoxR2lNa1VxWjdYR3NGUHZDR1FkWjZrbEtVbGMv?=
 =?utf-8?B?alFtSEFZTFZuRy94eGVlNE9KQ3ZZbGpiT3lGQjkrMk0rQUlvaFhtRjVnejU1?=
 =?utf-8?B?RVNFV1JVaThINGxRR29pdHJqcEJiSEt1cSsyZ3ZQQ3JOMkMzazFPaDlnUnpx?=
 =?utf-8?B?bUI5ZGVuUTdWVzVFb0I2R2xUU2pDTEY5dkxRWFVHcVNOQ0hHNWRnRTdaZUVL?=
 =?utf-8?B?eEJ2WXpHYkpHYmJMcW0rZXNLRTBWaHpMcmcxV2VqR3o0TXd2aDVoOFVRckFH?=
 =?utf-8?B?WC9QNjRhZ081WFNZTUt4K3BjcWpJZVdjWXIydjNQOEl4RWRjSVljVVJkc1Rk?=
 =?utf-8?B?OXFRb3hMRXdsbVlhVW5TanJBNkVHTHVaMU8xR2NNNU8vMEo2RzczYUlGTzAr?=
 =?utf-8?B?dWV5aEhlNDlzaWVqdGlIWW1jeU9Sa2UyMGtTaENoc1Z0c2I1NndPRFlNbytn?=
 =?utf-8?B?eUFTM1dUN24xS3VzdVJNTkY5ZzRTN0R2dVpKYU4vZndNcmJLUlhPaDZQd200?=
 =?utf-8?B?OUptOXpsS2QxbW9WU3d0VmduVnloVlAvYXBWSHo0OEx3VFJDa1hmbWtWUnlo?=
 =?utf-8?B?UmxRanl5MEt2S2p4NVhDbDFDS1M2cEpqYnJmY2xqMDdRSmUxd2hneDBXT2Qz?=
 =?utf-8?B?Tk1zeWJtSmF2TjZKbXBpbkxTTWdYUmpUMnlzTzNQUmFoSTJ4MHpwZTRoSmxv?=
 =?utf-8?B?Rm9GbjdCQUhFZmZUeSs4QnB0SXFGOHdUa214VFB1Rlg4Ulo4YzU4WWgvTWJT?=
 =?utf-8?B?TDQrQkZKdmxudkJUL08yUStES0ZVTDNLbGNMNUVNT3V6R3NyV2kwaWFxK3lQ?=
 =?utf-8?B?eWFhVTRsc3RVM2lSeXhldFVrZE5jSTN1UXdQN2tzRzlvYWd5MlE2RkhtWHJG?=
 =?utf-8?B?b2FlWlVTdWtIcFdxOVV2RStDT2R6UVVVaFNpOEt1enRaYmRTRkRTNlJwOUNF?=
 =?utf-8?B?bjgzYVUzNUpCbnJ1YVJjc1F1dlJSdUxLclNZL3gvMGZOckhRQTJIQlhWMVlW?=
 =?utf-8?Q?x6xHn40Ztf7IpCciSsBSoZg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB49F62BBDB3CD46B7D8036D4C1BB9A5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdb34a7-6590-4b05-df0c-08de20935ab6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 19:57:18.6950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LSewfeONwhrgLwn99kAi21ewR5eBbs4DJxqw2TD726Ri7CKsVJiP6bdk7oWouBLTQRQA+l7tZbszEyZi30BnCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3887
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfXy9wMQVPnXiJ/
 OAyZmJJJT5DIi7KM4P1rf3as37R992LeNd4eCSXN4z/Fix8/sUMC39lj4TdcCbeJz9h5IFzzkJX
 GPuc0r0S57n5GFsZZtdxk1KAobSvEVIFu/6ZKv3ILEqTbWWLniYeIfmmQO4OLOizkNNeLTMJoBp
 8hQRvlznvuGtQlEigWeOY/MkCv1XVhDXsl8E5gLIrKyHBIAdv6QG4FOT0GID8KZCPtTfijoeUKc
 2/NPLmc5jNO20FP1uOIZHv9Ydcd82m2bjaF34H14yup7HId4OCzb+EndFV3OzzTRkZ7ZxIjFrM7
 SMSrX1DHEPLLiT8aU+zryRDzz5EpgqVXLNg+T5caMCyV8KtfWd/jK8uCuh7QW16p+sVsfKHxAcD
 jXuUTo5v4zfMe4LsdTlK71GXAzHgDw==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=691243a1 cx=c_pps
 a=s4741YMcG+xsu4HPw1GdWw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=QyXUC8HyAAAA:8
 a=lcHQ55qyRYMRVMbbq20A:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: b66lP8-88NhXry7R6mdPBgCQsjhidlFe
X-Proofpoint-GUID: KFO9KmotPyGwMF7aafJXxTiofQW8qqbj
Subject: RE: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

T24gTW9uLCAyMDI1LTExLTEwIGF0IDExOjQ4IC0wODAwLCBHcmVnb3J5IEZhcm51bSB3cm90ZToN
Cj4gT24gTW9uLCBOb3YgMTAsIDIwMjUgYXQgMTE6NDLigK9BTSBWaWFjaGVzbGF2IER1YmV5a28N
Cj4gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAyMDI1
LTExLTEwIGF0IDE1OjQ0ICswMTAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+ID4gPiBJbiBh
IGZldyBjYXNlcyB0aGUgY29kZSBjb21wYXJlcyAzMi1iaXQgdmFsdWUgdG8gYSBTSVpFX01BWCBk
ZXJpdmVkDQo+ID4gPiBjb25zdGFudCB3aGljaCBpcyBtdWNoIGhpZ2hlciB0aGFuIHRoYXQgdmFs
dWUgb24gNjQtYml0IHBsYXRmb3JtcywNCj4gPiA+IENsYW5nLCBpbiBwYXJ0aWN1bGFyLCBpcyBu
b3QgaGFwcHkgYWJvdXQgdGhpcw0KPiA+ID4gDQo+ID4gPiBmcy9jZXBoL3NuYXAuYzozNzc6MTA6
IGVycm9yOiByZXN1bHQgb2YgY29tcGFyaXNvbiBvZiBjb25zdGFudCAyMzA1ODQzMDA5MjEzNjkz
OTQ4IHdpdGggZXhwcmVzc2lvbiBvZiB0eXBlICd1MzInIChha2EgJ3Vuc2lnbmVkIGludCcpIGlz
IGFsd2F5cyBmYWxzZSBbLVdlcnJvciwtV3RhdXRvbG9naWNhbC1jb25zdGFudC1vdXQtb2YtcmFu
Z2UtY29tcGFyZV0NCj4gPiA+ICAgMzc3IHwgICAgICAgICBpZiAobnVtID4gKFNJWkVfTUFYIC0g
c2l6ZW9mKCpzbmFwYykpIC8gc2l6ZW9mKHU2NCkpDQo+ID4gPiAgICAgICB8ICAgICAgICAgICAg
IH5+fiBeIH5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+ID4gPiAN
Cj4gPiA+IEZpeCB0aGlzIGJ5IGNhc3RpbmcgdG8gc2l6ZV90LiBOb3RlLCB0aGF0IHBvc3NpYmxl
IHJlcGxhY2VtZW50IG9mIFNJWkVfTUFYDQo+ID4gPiBieSBVMzJfTUFYIG1heSBsZWFkIHRvIHRo
ZSBiZWhhdmlvdXIgY2hhbmdlcyBvbiB0aGUgY29ybmVyIGNhc2VzLg0KPiA+ID4gDQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGZzL2NlcGgvc25hcC5jIHwgMiArLQ0KPiA+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+
ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9zbmFwLmMgYi9mcy9jZXBoL3NuYXAuYw0KPiA+ID4g
aW5kZXggYzY1ZjJiMjAyYjJiLi41MjE1MDdlYTgyNjAgMTAwNjQ0DQo+ID4gPiAtLS0gYS9mcy9j
ZXBoL3NuYXAuYw0KPiA+ID4gKysrIGIvZnMvY2VwaC9zbmFwLmMNCj4gPiA+IEBAIC0zNzQsNyAr
Mzc0LDcgQEAgc3RhdGljIGludCBidWlsZF9zbmFwX2NvbnRleHQoc3RydWN0IGNlcGhfbWRzX2Ns
aWVudCAqbWRzYywNCj4gPiA+IA0KPiA+ID4gICAgICAgLyogYWxsb2MgbmV3IHNuYXAgY29udGV4
dCAqLw0KPiA+ID4gICAgICAgZXJyID0gLUVOT01FTTsNCj4gPiA+IC0gICAgIGlmIChudW0gPiAo
U0laRV9NQVggLSBzaXplb2YoKnNuYXBjKSkgLyBzaXplb2YodTY0KSkNCj4gPiA+ICsgICAgIGlm
ICgoc2l6ZV90KW51bSA+IChTSVpFX01BWCAtIHNpemVvZigqc25hcGMpKSAvIHNpemVvZih1NjQp
KQ0KPiA+IA0KPiA+IFRoZSBzYW1lIHF1ZXN0aW9uIGlzIGhlcmUuIERvZXMgaXQgbWFrZXMgc2Vu
c2UgdG8gZGVjbGFyZSBudW0gYXMgc2l6ZV90PyBDb3VsZA0KPiA+IGl0IGJlIG1vcmUgY2xlYW4g
c29sdXRpb24/IE9yIGNvdWxkIGl0IGludHJvZHVjZSBhbm90aGVyIHdhcm5pbmdzL2Vycm9ycz8N
Cj4gDQo+IEdpdmVuIHRoYXQgdGhlIG51bWJlciBvZiBzbmFwcyBpcyBjb25zdHJhaW5lZCBvdmVy
IHRoZSB3aXJlIGFzIGENCj4gMzItYml0IGludGVnZXIsIHlvdSBwcm9iYWJseSB3YW50IHRvIGtl
ZXAgdGhhdCBtYXBwaW5nLi4uKFRob3VnaCBJDQo+IGd1ZXNzIGl0J3MgdGhlIHN1bSBvZiB0d28g
MzItYml0IGludGVnZXJzIHdoaWNoIHRlY2huaWNhbGx5IGNvdWxkDQo+IG92ZXJmbG93LCBhbmQg
SSdtIG5vdCBzdXJlIHdoYXQgaGFwcGVucyBpZiB5b3UgYWN0dWFsbHkgaGl0IHRob3NlDQo+IGJv
dW5kYXJpZXMgb24gdGhlIHNlcnZlciDigJQgYnV0IG5vYm9keSBnZW5lcmF0ZXMgc25hcHNob3Rz
IG9uIHRoZSBzYW1lDQo+IGZpbGUgaW4gdGhhdCBxdWFudGl0eSkuDQo+IA0KPiBBbGwgdGhhdCBz
YWlkLCBpdCdkIGJlIGtpbmQgb2YgbmljZSBpZiB3ZSBjb3VsZCBqdXN0IGFubm90YXRlIGZvcg0K
PiBjbGFuZyB0aGF0IHdlIGFyZSBwZXJmZWN0bHkgaGFwcHkgZm9yIHRoZSBldmFsdWF0aW9uIHRv
IGFsd2F5cyBiZSB0cnVlDQo+IG9uIGEgNjQtYml0IGFyY2hpdGVjdHVyZSAoYXMgc25hcGlkcyBh
cmUgNjQgYml0cywgd2Ugd2lsbCBhbHdheXMgYmUNCj4gYWJsZSB0byBjb3VudCB0aGVtKS4NCg0K
U28sIGFyZSB5b3Ugc3VnZ2VzdGluZyB0byBkZWNsYXJlIG51bSBhcyB1NjQgaGVyZT8gQW0gSSBj
b3JyZWN0Pw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiA+IA0KPiA+ID4gICAgICAgICAgICAgICBn
b3RvIGZhaWw7DQo+ID4gPiAgICAgICBzbmFwYyA9IGNlcGhfY3JlYXRlX3NuYXBfY29udGV4dChu
dW0sIEdGUF9OT0ZTKTsNCj4gPiA+ICAgICAgIGlmICghc25hcGMpDQo=

