Return-Path: <ceph-devel+bounces-3561-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27AF0B4987B
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 20:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7FD87AD149
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 18:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8811831B809;
	Mon,  8 Sep 2025 18:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h/4bGW07"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0350314A76;
	Mon,  8 Sep 2025 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356849; cv=fail; b=b9Co88eEZX19PbNy0pCx2hqURtRP8oQqD08lwqQVSUoYRlHxk8KY0pE1Mkg3cfAeQgtP/2+a4typ8ndki28UGt/Z2LQ2RE5BL6Fy0+nPDSyQ4I/+taMX1KWES8LqkpYLMS3ft+I2c5FVtnZEyeMiW3EK4jtdDBo3sYafTFWg2oU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356849; c=relaxed/simple;
	bh=iWKVopwQnAqWmveBHkjHiOHjXte8ysEocYrvC+eyA24=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=oU1opPmO/5w39Jv/yGDkE0Av6+fzfhmGuD17h/eQ9Cz9TttWd5rubaaqLOaLqngq0mWOQ9xS8nP1zhLZDo3BsEBH9N+MM7kNChCt/tyrcJiCP3WwaPjpS5crk4qP3JfsBosCqainYvB51pfd/4PWjEkEVVmNmswuMSM7jF+f0+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h/4bGW07; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588CsuTX023577;
	Mon, 8 Sep 2025 18:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=iWKVopwQnAqWmveBHkjHiOHjXte8ysEocYrvC+eyA24=; b=h/4bGW07
	+6ydEYM+AjM7AutE84o13/lR0bcxpydcJqPeC0YxdEzt7kWX0zgn79/6J9MQnu1u
	kCSi9KVwpiUajW86IjOWPakklrAZQydL1TLkO4Z3SI5uIWGz8ZXawJFQFEuP1eMO
	P6GMsGH/E2sNxdF86ySx0+xLDkJzrvlTZxazejhtkC7z4FkeuiQyDGniHhNEypWk
	wIUxBoCn6vVHwpmqskcP15067xxIzYkOAgMdqdYctXFdyLV19t3i7QPEB/uJfY0P
	DB3/pb8EzYAxO33hQRnbYhHxjAu9wHkCLfxYQmI1Og/nF/JleeyD7ryx6DWXFdYm
	bHin0KIaC7jDDA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwka1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Sep 2025 18:40:42 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 588IeflH009334;
	Mon, 8 Sep 2025 18:40:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwka1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Sep 2025 18:40:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QU4mUXBfgqwkXo/JASKxm7flWm6anZEaRD5UXDTrFUB6VxnkTwc2/dU/Ks/UmjG39jxaCGTbg688gSsXv3G7m3zlpbr8YLCy3m4oSKqB1u9jmGm03DTMJ6s09VqOo61lyO7p8fKnop76vnX9FBKaCljchPw/sUcuqHWa07WNk2boXVS3Adh6/Yap3MVRXA0EQZuMII5hRfhVK/C+jpq6NoVfNUspcFSq02xOPDITrdsKlQ5scDNN3kFaopUw/CKKe3pTsNCyfO3qcq7r30FxZx7kUFEIUn64xqzD/x7pi9tL9GIOa5iFHsXXqC2sT+CTv728ObYIT6/rjej0OSfqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWKVopwQnAqWmveBHkjHiOHjXte8ysEocYrvC+eyA24=;
 b=xU546VMyoVx/XzEdwnZ1QIuDXG/U82eEHs6hsHOkmb+/uckkH4yWY88z6Teeia0ts7Qky+BV6mqYwfhGvv16JyIvb0jCt5RlUQ6hNbaBhwiq2TH+HSsYr1mTzfMoiuUgdUY3ZEKjvcyKy6ZeuDrunY4K3fsDF946B7YQAgXDGshtAjexb6KyAaHNRWX5avcD9oL4imR5lRVRBsEOhrLJ0wR5EbkJlunDudpU8vr/IJf2OeSD1jNJlm8UO5vzywGTYbDCcmxJZ0VQ/ABs1/7w0U9xcc2d7WscefjjWhBQNHyeAhWzFeU89691y/uNAlsNxeWaALCykPS0H/roqO3Hzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA0PR15MB5908.namprd15.prod.outlook.com (2603:10b6:208:3dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 18:40:38 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 18:40:38 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>
CC: Alex Markuze <amarkuze@redhat.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
Thread-Index:
 AQHcGE64qoYmawrjLUelljJPwcgz5rR4baUAgAApqoCACwH7AIAAZBAAgADiYoCAABc9AIAEuImA
Date: Mon, 8 Sep 2025 18:40:38 +0000
Message-ID: <ecd1c723930ed436a0b85652c95d453254664af3.camel@ibm.com>
References: <20250827181708.314248-1-max.kellermann@ionos.com>
	 <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
	 <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
	 <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com>
	 <CAKPOu+8Eae6nXWPxV+BGLBVNwSu5dFEtbmo3geZi+uprkisMbg@mail.gmail.com>
	 <25a072e4691ec1ec56149c7266825cee4f82dee3.camel@ibm.com>
	 <CAKPOu+9MLQ5rH-eQ6SuiXTzFCEhmaZ9s-nKKQ4vpUCyvc9ho8g@mail.gmail.com>
	 <b3d2da1abe05087f52a8e770bd8eac04c46b3370.camel@ibm.com>
	 <CAKPOu+-HZQa_p3JUXeQY+KZL1yAFK29A6PD2KartKTT6zA785w@mail.gmail.com>
In-Reply-To:
 <CAKPOu+-HZQa_p3JUXeQY+KZL1yAFK29A6PD2KartKTT6zA785w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA0PR15MB5908:EE_
x-ms-office365-filtering-correlation-id: ec262a25-4617-4926-259a-08ddef0734c3
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NTNMcFlDajdxbGZGd09YNkIrWmtVa1dhNVE5Y3pwRU1QbUtKRi83eU5IYmQ4?=
 =?utf-8?B?RUxVaWVTb1prZzh4QVU5c2hMTDFabjFibHdlNXd0WDQ5dWZZdmcyVmF5QjZ0?=
 =?utf-8?B?ZUNoa1BTYmFVc1hlTU0rREV4K3pLS0M1RzFOZm1DajUzbnJiWmI5dVVqTzZH?=
 =?utf-8?B?Y0RzN0RRYXpGUmZESDBJTSsrWFloRlBFRzRmRndmMXd4bjM5KytTbXFWdXQ4?=
 =?utf-8?B?elFXK1ZiejR4Tm0yRjYvWE1KMDNBbXZQWFVLdnpFOUpScmVsMytNR296VlR1?=
 =?utf-8?B?Y1MwZ0hUREFkaUM0RTlMdmZjRC9qQ0pORnZXQmQ5L3JiQnlPTTh6V0s0SW1Q?=
 =?utf-8?B?dXMzdDlWTUxKcEdScDJLalNQWUhrajhHRHlyMU1aZms3ak9pcUdsRytqN0hE?=
 =?utf-8?B?WUgvQzMya281N3dzVzVlRTNqamh4ZzByQnBzVk1tUjdGT3B6bDBjTWtSOE5G?=
 =?utf-8?B?NnVGMjhTRm9wdWVidGl2ZzBkYmQwT1gzaTdqWHJsQmhoSGFWN0dOWE93NlZZ?=
 =?utf-8?B?NmNZVjM4eFY5Yyt1MjFvZ3dscVJTRnJsS1RzS2RYa2RhS0RNaEV3QWhzTExO?=
 =?utf-8?B?R0NqRUJvOGhWVTNYV1RLYklTQU8yb2c1KzliTmJyMmZXR3BtS2Via3hTYUZy?=
 =?utf-8?B?djhOV01DL3FoMlRsVHBWZXJxQmFBY3Uwc0RIRFZnVlcycG1CSXJJcithdmxh?=
 =?utf-8?B?UHA3dlhMTWo3Y1BnUHBlcXZBVDdxVjVxTzhUV0xHdkhCOFo0dlJkUDJmZjN3?=
 =?utf-8?B?YlVmaStjV1k4N25ZVXdEUFdXeGQ5R2twS2l6MW9zc1RsZWpxK0xhN201bE1T?=
 =?utf-8?B?Ly9vVHhmR2pWN3hRYmlRd1lMRFV4Z0N4amxSVEQxNmMvTHM5WVIzNUNRR0h0?=
 =?utf-8?B?OFRGUTJrTkpMUmdtNktnQ0hOckNhcnZUMjBHRG5ES1FkQVhTaDhCeTFBZU50?=
 =?utf-8?B?SWtxMFBoSVhhblV5T2E0ZVRuU0oyeFk2VnNmMGFoRVlwWmt6Yk9qcTRPcnh6?=
 =?utf-8?B?NjZIcFF0R1BUZlJoRmRrT3d5YmQ2WnU1eWM1ZTBBaVlXWUg2Z3BHcU54SVY1?=
 =?utf-8?B?ZWJtY2U1WmVzYXJsR3JqSk9kZGV2bDlZY0Nra2QrbWNGYjhHUUV1Zm9paUJI?=
 =?utf-8?B?MGZaclRsTWxqOUhkN2wwR0I2Y0JSQUttTG5UUWMxV1NZTmdWQ1ZKN0ZFQThz?=
 =?utf-8?B?b1dhOFBvK3YvQm1YN0JqbWd1WUFYQXhUZ1dwVTl2MUM1K3JwTzg4c1dKZC8x?=
 =?utf-8?B?MTYvaW1xbGQwcngwUC9oTzl1bWJrUXBwY0RSUUt3QWxzV1d0WTkvQ1FDRmU0?=
 =?utf-8?B?aXg2NHFobWhQSzFoUFJickU0SG5KbU1SQnk1Wml2TDRrdXRXS0RDTXNwL2dX?=
 =?utf-8?B?M3ZDb3hocjAxczNvMmRSYnI2Qkc5Y0xSd2VwaEVoNFlCT0pUN1hxeHlYbWpu?=
 =?utf-8?B?VHBDTVZGK25qVU1mcFFwZmF6Zmc4QTk0YWQzZWZlRm1YL1ZoNE5UOEl0Y00y?=
 =?utf-8?B?V3QzeTNkcjFEV0dJSDNkQXFOY1Q0WjJGd2xnV3k3QWVPbjUrZnFvR1NmRFpP?=
 =?utf-8?B?NzJNYytVN05qTGd0NCtibnQwWGFrV0grY25DNThnQjgyWUhQZi9XOTkvR3Vr?=
 =?utf-8?B?TXFheVV5WitnMjV6aFR5anVSQXRrdFZnRkpBemVhNWI3eHV4eE9Kay90Y2l0?=
 =?utf-8?B?dVAwYUVvbWZxNEpjRktvTmMvVXgyamJVYVl4bFphSmdUSmZXZzFObFFnRUdC?=
 =?utf-8?B?dXZRUmVSL0lBVnJOOWdMc0EzbmdTODY0Tm0yUFJLeVMxczNCSHFXcUFUTGxZ?=
 =?utf-8?B?Z2VOK0xXQ09rR3p5cnZScC8xZG9XcjRTMjBwOUF3ZHV6Zyt3cDlTdVBseGlO?=
 =?utf-8?B?cXZwTjBSMjduMGFIaWhIaEJGWmNFUjlZYkUzcU1ud3duejJYS3hYVEs4T1J2?=
 =?utf-8?B?Mjl1ODEvTUdmWUxNc1hscWZGSzJmL3dUdHZOcUI0S3J1TDAwaU1nRnBNNUNU?=
 =?utf-8?B?QjNxSlozQ0RnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0dHQ3lQZU96UkJqVzJOYmI1SDUzN1FpRHFnL1ZFTWVJTWtiQ1FlY2ZCVk9E?=
 =?utf-8?B?NXhQVEJZUUYrUVdYdmFOMFdybXZ3aVBVSngzTzJxeURSWHRYNjVOdXNuUUZh?=
 =?utf-8?B?ajVuUTlxNTB3VWorZSs4YWcwb1VVTEhiREMvYWtncTY5K1BkLzNpdmszbXdr?=
 =?utf-8?B?ZzNDOCtHQWlEdEtOYnlibjRjTzN2RTZPYStMcmpBRGltSmZjc0cwMzBjQU1S?=
 =?utf-8?B?TFIzOTlHWVFGWGtjN0s3Wnp4TGcvcXhrNEFCRUFJL3V1VGE0Vi8zcXVlTVI2?=
 =?utf-8?B?SHJpZkZrTW00QS8yQUNpbi8zenloTXhIMFFIdWdZSlJRbnVrdnFhQ1paRExt?=
 =?utf-8?B?Q1IwUERHR2w0cmpNQUpROENZakxTMW9TUmlRbW9RZWphUnk3MGVvZ3NwSlRz?=
 =?utf-8?B?N01kTC82Tzh4REVEVjJvRXlFZzJQai8zdWpaN3VMRFVlZ1JQZDVUWExEZHMv?=
 =?utf-8?B?QmhFdzlnTzE1SVRENElZdlh0dy9pUlI4bHV1emlvUVNsbmN2Y0FaZDc3b0NF?=
 =?utf-8?B?V1NZbGRpaFE5QkhPNk1nWmpyVDdYRFdtMnVmUlhFVHNmVjhlV0d5d0JCd3lz?=
 =?utf-8?B?WWUwU0VFNzVpMjFYalJDTDdOSVhsTkEwQThrK0tRSDRxQWQzNnlJUXhPN0di?=
 =?utf-8?B?bGxSbXJwemNXeHFXd3M4Rzd4L0NHb0N0S0VSSS92OFNLa1Nkc0Z0RDRDbGY0?=
 =?utf-8?B?RnZiYThPL0syeittNFZSYW1aNHJ3aCt1REExY2Vqc3Iwai9LRk1LSzlpVFRZ?=
 =?utf-8?B?U2d5YjByZWZ0Vmh6Z1R2Uzl0aGVVZXJMbEdKTUhxMnJjTS9jRDRyV21ZbmxM?=
 =?utf-8?B?TFBlRmlta0dLR29SbGZxQlB3RUZHM1hTcElwV1NpZmFpZnRzK2JoeEV6aG9x?=
 =?utf-8?B?NStiNS9ZdG1nTFdrVDJxeEJianBMWjB6V2dCak1jRjE2NWhvUWVCY3FkZm5O?=
 =?utf-8?B?ejR2TWxVTGxqSXpTc3daSHlOQXRqeTdBVzFIZVRidEhrT1AwOUJ0VHFIY0xV?=
 =?utf-8?B?Zk83aXk4cVpUejl1VXNwWDlxeE9rZTZzUlFJMVVEZ2pYZHJqbHZiaU8zY2k2?=
 =?utf-8?B?R0NRM0JQeFVaV2NZTE9yTzdnQlJhNW1yaHBwM0R4WWxjc3NnbnBvQnRTSW1x?=
 =?utf-8?B?NERQZXdnUWhtTFpqdkpETERWM1I1WmVYMnJOYmczMlVtdnl2Z1BOYlhQZmZa?=
 =?utf-8?B?QU1zeDJmUTdKa1dQclRtUjc1SVRlKzZsQllQQndWZG9EVXlUeGxFaTJ1dzFq?=
 =?utf-8?B?K09xMGxXSlI3QVFyVWMxR1BsUDBuRnhlaGhrNmhYTXJUUVZUVklOTVdITVZT?=
 =?utf-8?B?RGMvVEhrRHlPQ05PTXhXZnFSQ2I1anJQNzBwdEJIaGIzNG5jYjNUUGJpRldo?=
 =?utf-8?B?dS9XMmdyNmIwVEFMR0dkNmxraS9pY1loMjlYODFsR21ScGNzMzhRdC92NEdp?=
 =?utf-8?B?RTdNNUtmem1PMVFZcVlNVURaQk1TeXh2S0VvUTh1NEhTU3hPZ3NjUWRTektm?=
 =?utf-8?B?SEVjYlU4YllRQVFockZvWUltSkJEbXRUVEx5U3U0bTFKaEY3djdsS1VmOTlN?=
 =?utf-8?B?SzFudVNzcGV3ekFXLzBjdVZsdllINUhwZU9zSHIvdlFIVUVMbEt5TDNEdlRM?=
 =?utf-8?B?T2RBNVRUb3dDakZRV3IxNEtSMWlpUUtIVXVVK2lWN0NBdDc3VlAvYmJGc0JS?=
 =?utf-8?B?VTYwbWZnb1dHMzN1eXhGdTJxNXJaUnd1enhRNUZuTUJLcHlQbEthb3Z4ZWQy?=
 =?utf-8?B?R3ljK1dXbm41NjZocVFURUs5UTJsS21FYXFLeGJ4L1BpMzNtYlRsbk1NNndl?=
 =?utf-8?B?V1FLKzVtQXhEOUkxRGdQSnVvbTNjSURVaDR3NEd3NVJYbkkwSHh5em44T1dl?=
 =?utf-8?B?ektoWWhaZ0h1bXZrQWlaazJCWDB4MVY2Y3YwbkFiTllTUEt5dFZoUEo0ZTg4?=
 =?utf-8?B?OTl6ZFRFUFFyRUMzMnFIVlFjTlEzL0hiRmtFQnFPVG83NXF5UjFadVpaMCs4?=
 =?utf-8?B?VHNTWm1tTXFySnhFSDhrSVhXWksyUkJBcDhjRVZKUXBJRmg2a0h0eHlnQ3ZR?=
 =?utf-8?B?MG1XeXMxWXlha1MrUnd4MTNYdlRjS2RmTVRZMnVDaFlkeTBEYUFsdU1IQng4?=
 =?utf-8?B?UExUd1FTL2gxOUNNeVRqZEwwSE12UkJVa2tVK25JWWYvZ0MyZDBXc1FsOEZL?=
 =?utf-8?Q?KNVVHm5XFkm7Kn98NyV48R0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <827919F9E5447A49BE952FC0A1108147@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ec262a25-4617-4926-259a-08ddef0734c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2025 18:40:38.5169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSBdUDavBEckTB8lfTGe/J8cYvHu0klxa//CWwmmxB6lFN1/KMrT03X+nWHX1fziyHF59UgMSW2QhmTvNscgZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR15MB5908
X-Proofpoint-GUID: QQgxDz12x4aNrRjbHDNW1mEO5NaaGx48
X-Proofpoint-ORIG-GUID: cCPXiaOuvpaBgpLfKCUz3lHgYm1A1XCv
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68bf232a cx=c_pps
 a=lYSdIa1zXDUQQN2vrTcVBQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=6CHt0vpORRLolODGeigA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX33os7OwBnL6w
 306sfer39K+3qGSCbtIqbnSRrRoW1VtX26+BJFrN7t7CqNlCAokUE/2zBluI4FvUB8GzPe/984h
 xWH9i+V5/JacL4N5KU17mjt4LpSij55M/uMDnqGI5zBPg2oRmFdgoYO4RU8CpTjzXdzJazbrX01
 +SHlkPuJAuUMYUbJgVQhb6wadPakshxnDoiMbY1iMeqsKeI1kehmAbpmMY/8IqfB7pIylB3H5Tp
 1KUrfmc0nrvyycqjYvVfGrJnWECWh3d3HCICzls84wXPMvg8KytKiUcQnHkxfPRew2cHpptQe+i
 GyuqZwYiM6U49nUn14AvFyid11CVlZavmg1JdVb2wjed5iaAcfEtpPMy+JygH8J3wGjQAjbX5HL
 a02k+eRY
Subject: RE: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

T24gRnJpLCAyMDI1LTA5LTA1IGF0IDIwOjM1ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gT24gRnJpLCBTZXAgNSwgMjAyNSBhdCA3OjEx4oCvUE0gVmlhY2hlc2xhdiBEdWJleWtvIDxT
bGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIEZyaSwgMjAyNS0wOS0w
NSBhdCAwNTo0MSArMDIwMCwgTWF4IEtlbGxlcm1hbm4gd3JvdGU6DQo+ID4gPiBUaGFua3MsIEkn
bSBnbGFkIHlvdSBjb3VsZCB2ZXJpZnkgdGhlIGJ1ZyBhbmQgbXkgZml4LiBJbiBjYXNlIHRoaXMN
Cj4gPiA+IHdhc24ndCBjbGVhcjogeW91IHNhdyBqdXN0IGEgd2FybmluZywgYnV0IHRoaXMgaXMg
dXN1YWxseSBhIGtlcm5lbA0KPiA+ID4gY3Jhc2ggZHVlIHRvIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZS4gSWYgeW91IG9ubHkgZ290IGEgd2FybmluZyBidXQNCj4gPiA+IG5vIGNyYXNoLCBpdCBt
ZWFucyB5b3VyIHRlc3QgVk0gZG9lcyBub3QgdXNlIHRyYW5zcGFyZW50IGh1Z2UgcGFnZXMNCj4g
PiA+IChubyBodWdlX3plcm9fZm9saW8gYWxsb2NhdGVkIHlldCkuIEluIGEgcmVhbCB3b3JrbG9h
ZCwgdGhlIGtlcm5lbA0KPiA+ID4gd291bGQgaGF2ZSBjcmFzaGVkLg0KPiA+IA0KPiA+IEkgd291
bGQgbGlrZSB0byByZXByb2R1Y2UgdGhlIGNyYXNoLiBCdXQgeW91J3ZlIHNoYXJlIG9ubHkgdGhl
c2Ugc3RlcHMuDQo+ID4gQW5kIGl0IGxvb2tzIGxpa2UgdGhhdCBpdCdzIG5vdCB0aGUgY29tcGxl
dGUgcmVjaXBlLiBTbywgc29tZXRoaW5nIHdhcyBtaXNzaW5nLg0KPiA+IElmIHlvdSBjb3VsZCBz
aGFyZSBtb3JlIHByZWNpc2UgZXhwbGFuYXRpb24gb2Ygc3RlcHMsIGl0IHdpbGwgYmUgZ3JlYXQu
DQo+IA0KPiBUaGUgZW1haWwgeW91IGp1c3QgY2l0ZWQgZXhwbGFpbnMgdGhlIGNpcmN1bXN0YW5j
ZXMgdGhhdCBhcmUgbmVjZXNzYXJ5DQo+IGZvciB0aGUgY3Jhc2ggdG8gb2NjdXIuDQo+IA0KPiBM
ZXQgbWUgcmVwZWF0IGl0IGZvciB5b3U6IHlvdSBoYXZlIHRvIGVuc3VyZSB0aGF0IGh1Z2VfemVy
b19mb2xpbyBnZXRzDQo+IGFsbG9jYXRlZCAob3IgZWxzZSB0aGUgY29kZSB0aGF0IGRlcmVmZXJl
bmNlcyB0aGUgTlVMTCBwb2ludGVyIGFuZA0KPiBjcmFzaGVzIGdldHMgc2tpcHBlZCkuDQo+IA0K
PiBHb3QgaXQgbm93Pw0KDQpOb3QgeWV0LiBJIHdvdWxkIGxpa2UgdG8gc2VlIHRoZSBjbGVhciBl
eHBsYW5hdGlvbiBvZiBzdGVwcy4NCk90aGVyd2lzZSwgdGhlIHByb2JhYmlsaXR5IHRvIHJlcHJv
ZHVjZSB0aGUgY3Jhc2ggaXMgZXF1YWwgdG8gemVyby4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

