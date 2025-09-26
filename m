Return-Path: <ceph-devel+bounces-3747-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F24BA55C3
	for <lists+ceph-devel@lfdr.de>; Sat, 27 Sep 2025 00:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2998C4C4A4E
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 22:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C0E2877F0;
	Fri, 26 Sep 2025 22:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sjknzmWV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0811D6AA
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758926595; cv=fail; b=COP6BYmmCNLJZRnhv0v/H1eXNW6aVxblhgPGe0LPob/FhL9wL2xzWqAJvmgPcw5aBHbQbluhCVXKj+gEOf5LNpo8UwonxjExghF3Q0sYQ/dPL5y76mZ8kOG8h8LLrVzJoki9Kej70dEYcKv2pA8lqDlTVkpOzLE8EnDlesHZ4f8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758926595; c=relaxed/simple;
	bh=vqwY7BLS0O0uV8mLLxu6XQcqvuu+d9E19JtS0SkYCRg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=YHj9Fd+kGsRF+NleY9CrgqwItrJ9aB4mqVePsiIQ4RX30usbee6Z3v7198sAnfWQ6a1+upQh2pcOx3cZSvMJWp3XvVpgTns1vViKX3u4TfETx85AbGReIbejDUF5qoqAb+vrDSEHuUH6InEFD0uhnBkazes4vcRQ0X51q/LGl/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sjknzmWV; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58QGO1ZK005127;
	Fri, 26 Sep 2025 22:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=vqwY7BLS0O0uV8mLLxu6XQcqvuu+d9E19JtS0SkYCRg=; b=sjknzmWV
	RczwVTIly5cTlP6u0D/6aatyzFXu+U2Su6Nh8pQSBkBi04JmzDmztI9sGlzlWY+p
	3mh26GV1vl7k0pl/JgLLFxhVWbb3YwIfW/byllWl2DJbHfY1ouHV061lTjWA73Yw
	xUb2+mTceFCvBjy03jBAve5d2/ys0fte1hvTwXfq1SkyRGxF5n76QFjjoqIqOhob
	fsNU3sVGB6EaGTsdbf2dNzxqlY2IOVC/FyjyP8+F39/7CktGD5I3a/KaDaB7mt7I
	mAXt2UwIcUYynGS4z+/858XMAzYuXB5cD3rFGVnVy8kMmrRxCdq6MScfceyIVls/
	hMmRqDbOyhQxHg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb6qm4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 22:43:05 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58QMh5TW006842;
	Fri, 26 Sep 2025 22:43:05 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb6qm4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 22:43:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QN6FCXpVySZWrUcgoLnseQU1xz8I3PqTww+eAfN4zlsKXD6rPyc6yHddczgceBPeaBn8DTgl68ESykp5bgnIVB5JJYq5oNVqg8w0itivrbfwO6DsAyjMENd+Rpwlj9AIArMmBr8fstJ3RECIu5+apSz9D6xzkrCC81y093HABf62zlPS1zrEfYECQ2TClcKzk3eEgceeyb4Z+xdIjUCUhkxEfUlfx5EIGpCclkC+zOTNqw/c+Cr260jDQCc0VFYRbe3W3eCXZx9YyKB5Xb7PjY3hJYDfTGG+kAsfeEFWkUEFdhXKKXQCcs9bryN1SfaoszEX9A3IPLI1ybQsG6EBrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqwY7BLS0O0uV8mLLxu6XQcqvuu+d9E19JtS0SkYCRg=;
 b=N9e1Di8i8CxpGHnLz9DLo0HkuvzH9OTjsncZ7sn+BiUBRDX/6RhqhpKQErJ+iByUARuG3N5AwcxxrUa2OYDoiDB8lhNsmt183m1lpmbRs8tYooiXY1VWsBU2IvzeXz/iwXHUOaWjgpx9uU26Of5r3pSwjO0mbBAaqy+Xwrg6ohayTcdit7NT0jKeRLkp5JBrxC9yPuswUTo8HVba/LeB19zZ9hS0A5W2QzuNVMVSqWf0/4Y9i3UmNMscyDulqUM6wtcnksN0kn/gHvgetdueol6g03shhiRXLtlrGYn7YoAGw5Fb8opnsqjCi40QuSMpaYSPmjU0TZCDeLhlz4cMpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM4PR15MB6033.namprd15.prod.outlook.com (2603:10b6:8:185::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.13; Fri, 26 Sep
 2025 22:43:03 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Fri, 26 Sep 2025
 22:43:03 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi
	<Pavan.Rallabhandi@ibm.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph/006: test snapshot data integrity after
 punch hole operations
Thread-Index: AQHcLtltwsnvtj5hjky4zZOfQ+f4GLSmECEA
Date: Fri, 26 Sep 2025 22:43:02 +0000
Message-ID: <82776065039435c2d728066faf72102a6b95d391.camel@ibm.com>
References: <20250926113227.609629-1-ethanwu@synology.com>
In-Reply-To: <20250926113227.609629-1-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM4PR15MB6033:EE_
x-ms-office365-filtering-correlation-id: 92667969-ae40-43eb-bf5e-08ddfd4e0d60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VkFxM2tXSXZINlkxclBFMlNGZTc5eTdCL3dXUzBxeEtRSmh0cHNJYm5jcU5V?=
 =?utf-8?B?Zzk5N2JUdkxnTzh1b2RGNFFLYlZzcUY5OVR4ZmdsNjlncFE4bDZFVk04cVdS?=
 =?utf-8?B?K0Y2NmpKcWozYXY5UC9MNkxsY3dBb3hlSnNTTlNOWjdRTFphQ24wZ05SZzkr?=
 =?utf-8?B?UnhGOHBkRkEvcVZlSitqbjhVRi93RXA3MUxJUTNmR1FMSFVCY2hsM3NlTTJN?=
 =?utf-8?B?Sy9RUXFBdHUvamlaSUxSZFY0alVid3BxbVVaS0pMb2FEdWJQRXh2L01nWnFr?=
 =?utf-8?B?SzJoMHQ0QzJ4WDAxOTBkNWlTb3U3TVhOcXl0OXEyRzBUR3hFeWRoU1EyWHhq?=
 =?utf-8?B?U0t5MUxuSHBrZ1MrNGpJcWd6dFVhaE1DSkR5RW9qaStNS3Z1VlNmQWJwY0I0?=
 =?utf-8?B?aEZhNDNZSThlekhCRnR3a29id2NRNFNlT0FrVk1LaDluNDNxTXEzSitzS0JV?=
 =?utf-8?B?Ym5VbWFNVDVrOGh2Ty8yZnpXbVk2Mnk1dndOYVRVeStMeUc5LzhlcXJDVzM2?=
 =?utf-8?B?ek1EMnlFSng5UFcrMkFrS0tZRW9qaGdFb1BpZ0U5YkdRRmRpdmFFSTNITVEw?=
 =?utf-8?B?U20wbDVmZUZSazA2VjUxZmVidVF1TkM1b3JyWGtoWnprK21uYkQvbkRRT1VB?=
 =?utf-8?B?UWE5ZWN5d20xbWo5L0pVR25nQ0lFSE9PcGtieGdtbzRGVGdvODdXS3FkdW9B?=
 =?utf-8?B?SlpzWmlWVmVhcnk2TFJoVlVzKzNKY1ZRYkNKZEtmcDNtMGlZQlJlRit1MStX?=
 =?utf-8?B?NlpjUzNLMERORHR0M05NYmh3QjRGQWhFK0NhR1FzeW5CVk8wMFZMbURSeENB?=
 =?utf-8?B?OFY3OEVEdS9xcFNkbXNMa3k3bS9FdkVmNDUxOU56NFdJL3FUZkx5KzNxNlNT?=
 =?utf-8?B?bVdLV2h0NmFXL0hHLzVsOW04SDlyMFN1KzdZSFhQbTRvR08xMjFUWFR0SjZF?=
 =?utf-8?B?eXh0US95NTQrc3VwTUhmUVZXcUtEcmxCcFJJSXIweFQzQWlGdTh4YzdiWFZh?=
 =?utf-8?B?QTFnMU03ejFYNW1TWWVCZGVTV3V6RVNrSmZ3T0tBZW1tQWg0ejhUVHdnYTM4?=
 =?utf-8?B?V0NkcHFTRzRmeCtXQVVFcUFrenpDRFZ0Um5nRy9wbUl1TGlNTjB5SkNaQ1JR?=
 =?utf-8?B?WDZnMHh6Y29EeGtNYUhJVXFuTW8yaEd3ZFlRUzJ3QUNVTEZOUE5UblMzMnRI?=
 =?utf-8?B?MkxZNklsWkFpcnhKUWF5TjBMV1pYcFN5YkNLMzZjdWIveGdiVkNYTXVlSmlH?=
 =?utf-8?B?MWVOMnNvcGwxcHBpZWY3ZjEvdmlsbzdTZFVuNHVMcW0wanNiNHFOTGJXVG9Y?=
 =?utf-8?B?V25WMVhUenZqb3lOMVUrYnBjdGZCaTVKcUZRS2FDdERJTHBsaW1GNnAwY3pq?=
 =?utf-8?B?SW54YXA1QXRWL0ErZWZvNGhtRGNVYy9RNlRQS3BhNGdzQktzM0Ntdm1zcEtL?=
 =?utf-8?B?NGxjNjMxK29wc1lOVU9qSGtuVXNkUm9CekY1OUlCd3ZONnZNMHUxU3g4Nk1x?=
 =?utf-8?B?SGhYMUxBOUt6VHNMWWhCUU4yZC84Q0lhZWRudDErTCt3RnZScEFoSFFMVTdN?=
 =?utf-8?B?Zmh2dnVBMTNsb3NyMytLSWlxb2pDb1FLaldCRVhTN1ZYbGJKREtYQ2JneXlo?=
 =?utf-8?B?YkZlY2gvZFpVK3NIaFk4UGcyZGFrVTFTS1FvQWR2ZFozRDV1VSs3SUl2S1JS?=
 =?utf-8?B?cUlCY0cySzRpcXJqTzE3Tnphd2F4ays4WGorZjA3cjZtOTZqUHVPMDdHbncv?=
 =?utf-8?B?TEtneWo1ZUNpYzM4SEp1dU0xSk1aRkR6OGRaVkhWTU5BbGpCVERQejVlNGJT?=
 =?utf-8?B?TlB4WkFqVlRoRDVFWHhqbnhtbkdHenc5MWJxa2RyR3F2Q0xVQTVabklaQVVF?=
 =?utf-8?B?WS9nalpXMFpvaUdhWlNhTHRGNFhldlUzZk4yUDN1V0ZBRFRJWUlJZktmczRM?=
 =?utf-8?B?SHN6SHpCcWU0VmNSQkwydEx0ai9NVXlBb3FFWWNPOGRFeHczVnVjQUQrLzJH?=
 =?utf-8?B?eHJBRnl6bDRkZkZ6Lzkvc1ltWVhmc0R6RHluM2hPTDVkRnBkU3R6em5FV3Yz?=
 =?utf-8?Q?e4whkT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TmF2NW54RVRuaU8xbGdNbXkwV2xlRnhSYS94K3lyMUVNOUc0bWh2Z3dXTmdM?=
 =?utf-8?B?Tnhhc0J1R0t6dzRWSUxxRWFWbFhJY2hQbG1QbVBYaHpOSXhTRmt5VDkrSmM1?=
 =?utf-8?B?WUduUFlnT2tTT29tZnVQTS9HUTNZMUVXcno5cDlDN3JxaFk3bGVYSjhQQUx3?=
 =?utf-8?B?ZnNVVlQ1eHJnbHMzTDJwbFJZMm1GRVdHYktERDJuSE5WVFdjYW9UVlR5QXR1?=
 =?utf-8?B?TnpCVUJpaHVYbk5wcVJYZUdKQ3ZySkdsZVFNRUhmaWFJdzVOazZSSUZSOWxC?=
 =?utf-8?B?eUx0bHZaMDJOeEtjVzNFUVZuek5TUUhCc0tDMzlFKy95SEc1eSs3UW1MS0hY?=
 =?utf-8?B?YmJCcVZ5dEk0YUhxZnZXNklNT1lhQTlmTFpKNEVTUTBKdWJkNlR4MGVaQzc1?=
 =?utf-8?B?RTV1NjNRNStlZWg5bm5lY1lXYUpyRU1odDhGVXRqWnkyeVJXakVMazh5MDhL?=
 =?utf-8?B?S3NDb2dCQWoyZkZ2bzZxdlBpTndQV1AyMHk5UDRlVlhsRlV1Q20zTGNKVHZC?=
 =?utf-8?B?RDViVHRSTTF6MjBmOGNNYVhWdHBxSDRMT3I3Rk83THFJOXZ3Qk42MzVZazBr?=
 =?utf-8?B?cmRJR3NxZ0V4OEdUTDI4VDVyZDJRY2E5anZCZWRZZUt3dWs1WWdYMmZ0VVR5?=
 =?utf-8?B?OFpyOXltelhIajVoQlBJcUJNMEZNbVB4SDYrT0d4OWpUUktQazRZaElUMXBk?=
 =?utf-8?B?VDEzTWN0NyswRGp6TU5mZkdNNG1qMXIwZFpTUFI1a2dtZXJJVnYxd1k1VVNj?=
 =?utf-8?B?ZVV0QS85Uk5jRXZUZ3EvM1FkYVpNRDFrdHVtY0hGTzdvYzk1U3lpVDhjT0sw?=
 =?utf-8?B?OWhlTnV2bzMyNHlWaWJxMHFseVQwREp5NWhnaklHOThRZ2g5T0FPcWtrWmg1?=
 =?utf-8?B?REtDS0xkY2hJcXcvNTF2RityQ3ZEaFkrc0pKZFBsTWlOUGI1MUJDbEI1YzE2?=
 =?utf-8?B?R0FwREJXbm5xMStzV3BGdmdzbExsVlRqanEwUXlnVldQSnFwOGx4MExHejJP?=
 =?utf-8?B?amlTT0UwOTFGdzgwUlVKK2EwZFNPdC93SDVvWE10R3hQS1J3Yjc1ZGdERFQ1?=
 =?utf-8?B?M1JzT0tkai9xeFdUUVFqWU9IblZ2K3J0ekdwRUhyK1pLT01FRkkvOUI1ZWlH?=
 =?utf-8?B?M0tabXhGNmZJYVFvam9ySVJqSlhwaDFvN2pJdEduZVQwRXJsKzVyTHE5Wlho?=
 =?utf-8?B?b01YTEhQNFFEOUNQeGlwY2xBR3gwZUxnV2luY0Z4MVMwSUxJcmJreFA0cm4v?=
 =?utf-8?B?aSsyRnZMcHBuOHgvOXZPZ1pJajBuUVZQUWpBTTYxMVJ0OGJFUGg2a2lKY2FC?=
 =?utf-8?B?Umw1OUpabndNYzV0MnlRS0tER0JibTVnSFo0bEpYU0tJZWVVZGFBaFEvNHNN?=
 =?utf-8?B?MHhzc1FPMHFVZ0hTVUliME5wc21qWnJBTmI4WjdwbTRZeWxORHg3MHlFa1gx?=
 =?utf-8?B?ZThRblc1djFSQXFlUFhid1B4YStwdVE0OTRWamhrNnhDL2Z2NE1qeDF1bzBN?=
 =?utf-8?B?ekY2YzBhaXVOU2RZakNDL3FUa1p0czBLQWVMSHczdG9XcDVPYjlyWWRFZG8x?=
 =?utf-8?B?ZWcxcUNwYVlNNGZGN0NQSVZxb2M0RlhDL21PRzg5Q1p5a2JIWWl2ZHNISjhv?=
 =?utf-8?B?bFlZVUkzWWEwS0xFZHBiWUlsZ21qN3VVL1B2eGNidGpTTFpwdE0wYWxLc3V0?=
 =?utf-8?B?MzNqQkJEL0ZIMTN2a1NIa3FPYzVUNGE2SDFVNUt0RElWTHRXSUo2d3B3OFBs?=
 =?utf-8?B?SlFlL01jKy9EZkRVNTFmd1ljeXlLeWZsa1A2VGhjdjd1amI5MGEzdm4xRlhP?=
 =?utf-8?B?TjdrS09ralVyN1JaVEU4N1ErZ0tUamFubTk1ZXVRbDBRY0FmRWdnejRTSlVJ?=
 =?utf-8?B?cUF4NG9zZ00wMUF5V081UUdXdkNReWY1dGFPTTlRRm5kNXhUK1BobVFsZnY1?=
 =?utf-8?B?V3JFYUtpc1hzN2J0cnJjSm9HWVZTWXJOWWhxSExnTmoyWXpvWEJibXZCY09M?=
 =?utf-8?B?Q1JzWWUxVWR3WHBFQVJzem1IWjlyNUErRGFEdjN2MnBpR043cGNkVDNtNmpY?=
 =?utf-8?B?dXZoVGk1SUlULzZxTUhZUTAxQitjNlk3Z3ZnYlhueEJqWi9OTG5QaytRSEhw?=
 =?utf-8?B?V2tZQ2NXWitMVnhRdDliTG1Ydkg5dGpNMDNHVXZtNDNrU3RFMzhiNENGLzZO?=
 =?utf-8?Q?UHzSHZy1VYRBmIeui0WYmsY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5051441C620BE498C7BA2373616DC73@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 92667969-ae40-43eb-bf5e-08ddfd4e0d60
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 22:43:02.9926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBHgWiafKoMCjI0CcC+RkaM38uf9PjOdzq0dcu3oMMVRP9adHH12fFLRYSmjwO1n5Qk5XOxf7wWdCloH8i2JPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB6033
X-Authority-Analysis: v=2.4 cv=MfBhep/f c=1 sm=1 tr=0 ts=68d716f9 cx=c_pps
 a=5I5pDAtSp800fId2YpAiPg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=LM7KSAFEAAAA:8 a=_LYUkS10yfyiiBvGqacA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cXzpV1XJmI0o0wFPXUbIPUhvLFcA-kaK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX4DLR8fWAqqsv
 bm0SkJpcSXzPeeL07i1Vohp6aKyZWRTEDfmpRGqF6ew2sUHCbBOHFz6Kq/t8szWQtbk8HTYNR4u
 RoJZTOn5mmqrByCw+XEkxntEoZ4iRCDNnDWQAst5/JCLqC9tGdg9HKY+ShzrKCiRf5+N1+Bc9eQ
 3tThxBsd6fX83UUqgqMNYE48lpG9O93l8V0I3eXX3E1nW5hyNpztqSs7ZeaT5t+e6OX1ut9uq/2
 0BRB3tCJKrp84//uumEkqiipMz1C1Q1tnBf6t9F64ISE/5LB/lqzG46iKAPHmRavUDGNhEXL34j
 19HnQMvZUGXQX/zAVWgDi1+gkhciEf5qofaBY1FqqAIcqYA8HDeJ+czupQzlvhMlWW1cdChEHan
 QMpa50fKtPvCs4jfalmrdHS4EALZRw==
X-Proofpoint-ORIG-GUID: O1bvy7y4jr3iIpvv1EixXTW7d3qzwddC
Subject: Re:  [PATCH] ceph/006: test snapshot data integrity after punch hole
 operations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_08,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDE5OjMyICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBBZGQg
dGVzdCB0byB2ZXJpZnkgdGhhdCBDZXBoIHNuYXBzaG90cyBwcmVzZXJ2ZSBvcmlnaW5hbCBmaWxl
IGRhdGENCj4gd2hlbiB0aGUgbGl2ZSBmaWxlIGlzIG1vZGlmaWVkIHdpdGggcHVuY2ggaG9sZSBv
cGVyYXRpb25zLiBUaGUgdGVzdA0KPiBjcmVhdGVzIGEgZmlsZSwgdGFrZXMgYSBzbmFwc2hvdCwg
cHVuY2hlcyBtdWx0aXBsZSBob2xlcyBpbiB0aGUNCj4gb3JpZ2luYWwgZmlsZSwgdGhlbiB2ZXJp
ZmllcyB0aGUgc25hcHNob3QgZGF0YSByZW1haW5zIHVuY2hhbmdlZC4NCj4gDQoNCkFzIGZhciBh
cyBJIGNhbiBzZWUsIGdpdCBjb21wbGFpbnMgZHVyaW5nIGFwcGx5aW5nIHRoZSBwYXRjaDoNCg0K
Z2l0IGFtIC4vXFtFWFRFUk5BTFxdXCBcW1BBVENIXF1cIGNlcGhfMDA2XDpcIHRlc3RcIHNuYXBz
aG90XCBkYXRhXCBpbnRlZ3JpdHlcDQphZnRlclwgcHVuY2hcIGhvbGVcIG9wZXJhdGlvbnMubWJv
eA0KQXBwbHlpbmc6IGNlcGgvMDA2OiB0ZXN0IHNuYXBzaG90IGRhdGEgaW50ZWdyaXR5IGFmdGVy
IHB1bmNoIGhvbGUgb3BlcmF0aW9ucw0KLmdpdC9yZWJhc2UtYXBwbHkvcGF0Y2g6NzM6IG5ldyBi
bGFuayBsaW5lIGF0IEVPRi4NCisNCndhcm5pbmc6IDEgbGluZSBhZGRzIHdoaXRlc3BhY2UgZXJy
b3JzLg0KDQpZb3UgbmVlZCB0byBhZGQ6DQpfX19fX19fX19fX19fX19fX18NClNVQk1JVFRJTkcg
UEFUQ0hFUw0KX19fX19fX19fX19fX19fX19fDQoNClNlbmQgcGF0Y2hlcyB0byB0aGUgZnN0ZXN0
cyBtYWlsaW5nIGxpc3QgYXQgZnN0ZXN0c0B2Z2VyLmtlcm5lbC5vcmcuDQoNCj4gU2lnbmVkLW9m
Zi1ieTogZXRoYW53dSA8ZXRoYW53dUBzeW5vbG9neS5jb20+DQo+IC0tLQ0KPiAgdGVzdHMvY2Vw
aC8wMDYgICAgIHwgNjAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiAgdGVzdHMvY2VwaC8wMDYub3V0IHwgIDIgKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwg
NjIgaW5zZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3RzL2NlcGgvMDA2DQo+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvY2VwaC8wMDYub3V0DQo+IA0KPiBkaWZmIC0tZ2l0
IGEvdGVzdHMvY2VwaC8wMDYgYi90ZXN0cy9jZXBoLzAwNg0KPiBuZXcgZmlsZSBtb2RlIDEwMDc1
NQ0KPiBpbmRleCAwMDAwMDAwMC4uMDJlYmRkZWINCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90
ZXN0cy9jZXBoLzAwNg0KPiBAQCAtMCwwICsxLDYwIEBADQo+ICsjIS9iaW4vYmFzaA0KPiArIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArIyBDb3B5cmlnaHQgKEMpIDIwMjUg
U3lub2xvZ3kgQWxsIFJpZ2h0cyBSZXNlcnZlZC4NCj4gKyMNCj4gKyMgRlMgUUEgVGVzdCBOby4g
Y2VwaC8wMDYNCj4gKyMNCj4gKyMgVGVzdCB0aGF0IHNuYXBzaG90IGRhdGEgcmVtYWlucyBpbnRh
Y3QgYWZ0ZXIgcHVuY2ggaG9sZSBvcGVyYXRpb25zDQo+ICsjIG9uIHRoZSBvcmlnaW5hbCBmaWxl
Lg0KPiArIw0KPiArLiAuL2NvbW1vbi9wcmVhbWJsZQ0KPiArX2JlZ2luX2ZzdGVzdCBhdXRvIHF1
aWNrIHNuYXBzaG90DQo+ICsNCj4gKy4gY29tbW9uL2ZpbHRlcg0KPiArLiBjb21tb24vcHVuY2gN
Cj4gKw0KPiArX3JlcXVpcmVfdGVzdA0KPiArX3JlcXVpcmVfeGZzX2lvX2NvbW1hbmQgInB3cml0
ZSINCj4gK19yZXF1aXJlX3hmc19pb19jb21tYW5kICJmcHVuY2giDQo+ICtfZXhjbHVkZV90ZXN0
X21vdW50X29wdGlvbiAidGVzdF9kdW1teV9lbmNyeXB0aW9uIg0KPiArDQo+ICsjIFRPRE86IFVw
ZGF0ZSB3aXRoIGZpbmFsIGNvbW1pdCBTSEEgd2hlbiBtZXJnZWQNCj4gK19maXhlZF9ieV9rZXJu
ZWxfY29tbWl0IDFiN2I0NzRiM2E3OCBcDQo+ICsJImNlcGg6IGZpeCBzbmFwc2hvdCBjb250ZXh0
IG1pc3NpbmcgaW4gY2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0Ig0KPiArDQo+ICt3b3JrZGlyPSRU
RVNUX0RJUi90ZXN0LSRzZXENCj4gK3NuYXBkaXI9JHdvcmtkaXIvLnNuYXAvc25hcDENCj4gK3Jt
ZGlyICRzbmFwZGlyIDI+L2Rldi9udWxsDQo+ICtybSAtcmYgJHdvcmtkaXINCj4gK21rZGlyICR3
b3JrZGlyDQo+ICsNCj4gKyRYRlNfSU9fUFJPRyAtZiAtYyAicHdyaXRlIC1TIDB4YWIgMCAxMDQ4
NTc2IiAkd29ya2Rpci9mb28gPiAvZGV2L251bGwNCj4gKw0KPiArbWtkaXIgJHNuYXBkaXINCj4g
Kw0KPiArb3JpZ2luYWxfbWQ1PSQobWQ1c3VtICRzbmFwZGlyL2ZvbyB8IGN1dCAtZCcgJyAtZjEp
DQo+ICsNCj4gKyMgUHVuY2ggc2V2ZXJhbCBob2xlcyBvZiB2YXJpb3VzIHNpemVzIGF0IGRpZmZl
cmVudCBvZmZzZXRzDQo+ICskWEZTX0lPX1BST0cgLWMgImZwdW5jaCAwIDQwOTYiICR3b3JrZGly
L2Zvbw0KPiArJFhGU19JT19QUk9HIC1jICJmcHVuY2ggMTYzODQgODE5MiIgJHdvcmtkaXIvZm9v
DQo+ICskWEZTX0lPX1BST0cgLWMgImZwdW5jaCA2NTUzNiAxNjM4NCIgJHdvcmtkaXIvZm9vDQo+
ICskWEZTX0lPX1BST0cgLWMgImZwdW5jaCAyNjIxNDQgMzI3NjgiICR3b3JrZGlyL2Zvbw0KPiAr
JFhGU19JT19QUk9HIC1jICJmcHVuY2ggMTAyNDAwMCA0MDk2IiAkd29ya2Rpci9mb28NCj4gKw0K
PiArIyBNYWtlIHN1cmUgd2UgZG9uJ3QgcmVhZCBmcm9tIGNhY2hlDQo+ICtlY2hvIDMgPiAvcHJv
Yy9zeXMvdm0vZHJvcF9jYWNoZXMNCj4gKw0KPiArc25hcHNob3RfbWQ1PSQobWQ1c3VtICRzbmFw
ZGlyL2ZvbyB8IGN1dCAtZCcgJyAtZjEpDQo+ICsNCj4gK2lmIFsgIiRvcmlnaW5hbF9tZDUiICE9
ICIkc25hcHNob3RfbWQ1IiBdOyB0aGVuDQo+ICsgICAgZWNobyAiRkFJTDogU25hcHNob3QgZGF0
YSBjaGFuZ2VkIGFmdGVyIHB1bmNoIGhvbGUgb3BlcmF0aW9ucyINCj4gKyAgICBlY2hvICJPcmln
aW5hbCBtZDVzdW06ICRvcmlnaW5hbF9tZDUiDQo+ICsgICAgZWNobyAiU25hcHNob3QgbWQ1c3Vt
OiAkc25hcHNob3RfbWQ1Ig0KPiArZmkNCj4gKw0KPiArZWNobyAiU2lsZW5jZSBpcyBnb2xkZW4i
DQo+ICsNCj4gKyMgc3VjY2VzcywgYWxsIGRvbmUNCj4gK3N0YXR1cz0wDQo+ICtleGl0DQo+ICsN
Cj4gZGlmZiAtLWdpdCBhL3Rlc3RzL2NlcGgvMDA2Lm91dCBiL3Rlc3RzL2NlcGgvMDA2Lm91dA0K
PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMC4uNjc1YzFiN2MNCj4gLS0t
IC9kZXYvbnVsbA0KPiArKysgYi90ZXN0cy9jZXBoLzAwNi5vdXQNCj4gQEAgLTAsMCArMSwyIEBA
DQo+ICtRQSBvdXRwdXQgY3JlYXRlZCBieSAwMDYNCj4gK1NpbGVuY2UgaXMgZ29sZGVuDQoNCi4v
Y2hlY2sgY2VwaC8wMDYNCkZTVFlQICAgICAgICAgLS0gY2VwaA0KUExBVEZPUk0gICAgICAtLSBM
aW51eC94ODZfNjQgNi4xNy4wLXJjNisgIzQ3IFNNUCBQUkVFTVBUX0RZTkFNSUMgVGh1IFNlcCAy
NQ0KMTI6NDM6NTkgUERUIDIwMjUNCk1LRlNfT1BUSU9OUyAgLS0gPHN5c3RlbT46L3NjcmF0Y2gN
Ck1PVU5UX09QVElPTlMgLS0gLW8gbmFtZT1hZG1pbiA8c3lzdGVtPjovc2NyYXRjaCAvbW50L2Nl
cGhmcy9zY3JhdGNoDQoNCmNlcGgvMDA2ICAgICAgICA4cw0KUmFuOiBjZXBoLzAwNg0KUGFzc2Vk
IGFsbCAxIHRlc3RzDQoNClRoYW5rcywNClNsYXZhLg0KDQo=

