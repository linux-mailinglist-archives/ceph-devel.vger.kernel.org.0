Return-Path: <ceph-devel+bounces-3366-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA62B1EDE2
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 19:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B7484E2412
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 17:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8732D1CBA02;
	Fri,  8 Aug 2025 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C49HUAX9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45E31DE4EC;
	Fri,  8 Aug 2025 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754674857; cv=fail; b=CqLQhu5ktmKfLZES+Cwm8Z7i3OVs1wC+O08MVVse2Ft96Yu14jZ1BwF5HxVmAvk0wPXrXLT3N4bHC7rlPaHZ1mMtwN5Fm8AlOqL3JXlCr8Atpx+k2+sxSMgkQw/nvnO18P+FHSXvRAKyvRWDHCOsrWpLSVzsuPzfmgl9TzBWxc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754674857; c=relaxed/simple;
	bh=WHS1xNvHbAEEsbdbSmoY+xDotH0/DXygcImPclPTRQ0=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=shDN3fII2EcKxm+U7tBJcwZHLjJcggC+Qe/SNWjjvdPMK01M1vdZNYGOJIAxLh6hIsARYD2yiLAXjksKg+UvNU59Fq9RTMh3lLYRZb9JxkRoFCir64mGeRPeyQvGyn2S9mTJ7gFJlA+K2fdWZRL3e121ryCesqLtOkJXNppftMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C49HUAX9; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578EgOkZ017997;
	Fri, 8 Aug 2025 17:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=WHS1xNvHbAEEsbdbSmoY+xDotH0/DXygcImPclPTRQ0=; b=C49HUAX9
	nYqHq1ztYPIZhD28e6V9BwSsfnQBlNvFyLJ+AusFoLtSvwkF4coFZgPEOQFzxm3m
	ISq+1OYRZNCkQhkg8cTyriTuB00g4DtXYCLlUFOCM5sZf4i71xuB9/i45On02J1I
	ebuRgtnHvN8tu+0kKrsMnKiGMfMUMYf4nSa9qHhDVt94iw1ntLSurwLzFYXgB4Cx
	muwXXRUBz/bd6JytUzAP/C4Wj6JEX2eGiG1AXUtwrfEwOK8930dv8To694rza9CN
	0Fu2Eqa9c45wFH343uL5gLyRv4qkGHKAA2tWxbgEam28+708GvNVgLC00iO8g57Z
	pnpXEbBWa3Nh4A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq63hf83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 17:40:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 578HekUZ012599;
	Fri, 8 Aug 2025 17:40:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq63hf80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 17:40:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5SPXrUnSUSl244Vdkm5usIEODu3mN0ooQKbtb8URxdXlWthYmekYZYRg89PlC9AsbS7TLG/g0JoR1ffFDsTpvXUxZZyAgAt6MFidE9Z0nh/G28IJElZ+y0K9qmkVXmGGSa9so97DplxhtRd96xO1Ljrxr04tpP7MS6XFBTQZgIErd/Bcp122ykgE/dcaRG4wNkb2DXz/bxJwjsILdjPJjrP91bsaimL/5Lij/Y4JJZ9TTzh++Lkuuj9sJnul9PaERbg8aMBy8qORoIIwBm1K0DkOXCzAcWJY0nc3goonR+csI35zde88UHTfmJNofl3CkCS102xyH3VqZBFCBrHjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHS1xNvHbAEEsbdbSmoY+xDotH0/DXygcImPclPTRQ0=;
 b=w+BzK0FyzZBbrZXxjDSHWltPCmYeVddfkzhYpxZxLexJjpLAQxc2rOIA2ZQuhinBjxwztr0MODFz9Z4fTl0FsHLaYrxajYevj8hIefiwfkyyXx7cqhXmKCXwQuhHWmBVRuwEZ6DVNoQT9PQ1G1hJMlsOLW5z/CkWh4piIqoY4cFUxwXM4kzxnDrbxZ4wtSxwBA5U+dZ9RSS6tXsp8KaBmnT51yklkW1FIlP/XWtMdUJiyHreqIxNeWCGqELNse6wKAXtzdMsX+d+qe+y8N+veST5L9FSJUbQNTc+1ydHhBIPdAnWgkuCGH9JX3ehwvgT9MFjqGQA//F7U/+cp1svZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH3PR15MB6395.namprd15.prod.outlook.com (2603:10b6:610:1ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 17:40:43 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.8989.018; Fri, 8 Aug 2025
 17:40:43 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH 1/3] net/ceph/messenger:
 ceph_con_get_out_msg() returns the message pointer
Thread-Index: AQHcBrdjO64fJtwPukySzFAUTxn/hLRZCbAA
Date: Fri, 8 Aug 2025 17:40:42 +0000
Message-ID: <4cceb60a32d9c0c3412332843030de65ec588374.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
	 <20250806094855.268799-2-max.kellermann@ionos.com>
In-Reply-To: <20250806094855.268799-2-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH3PR15MB6395:EE_
x-ms-office365-filtering-correlation-id: ea7a86a7-e047-4984-1bd7-08ddd6a2b2e8
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K3BKVG4yUU9GLzhqOHBtN00vdHUzMnJucUN3MFUxdFM3VlRYajgyUVllTGox?=
 =?utf-8?B?Z3RpL2lBSmRYZkNjYkhVUmFvYkhvNnlFK2k3NklLQnV0VTgrSG90ZWZMRDRp?=
 =?utf-8?B?cHQxU3d2cWhtMHA1ZGFsMTlUTTVyVHZnc2RremkyQW10Q2RHS0tFcEYyUTlW?=
 =?utf-8?B?c1dabXFyU01HNlVHSzc2b3U5dUREaDU2UEZuZ1YxUjJQcnIxMTU5UlNoaG5K?=
 =?utf-8?B?ZHByRjEwZFZoZ3MwZi8xdHY2QlpGVExwT0tpZldHNS9iNUdNRjhJdE4wM2o1?=
 =?utf-8?B?clhtLzNsdW9RdkxiL2I4V1Jkd1oxRUVKMnV3M0VBQllDTmxFbkYvYk1kZDY2?=
 =?utf-8?B?VHpLZHkzWDRsV2N3bDM0U1F1UHZjQUhwZFFiWEwxalV3Ky9tVjhvcVVqbDNL?=
 =?utf-8?B?Y1p0U2xEZUg5UXJpMFpsQXVwVXp1N3VyUVYwcFhiR29tRktXTDZwWnhPWVBE?=
 =?utf-8?B?b0Uyd3pTckdHZ3dmeFVoUGpOR1FNbDNjcHhZaE1qcXVuT0FjUXpWUjVMYmRa?=
 =?utf-8?B?aUpLWEJrelo2WWVDOFdDUm9yY0FQdmlRNzZUY3FHZS9YNHVsWmZVUDNZUmNX?=
 =?utf-8?B?YTVYenBDbGYxRVRpdE9mdCtoT05RTHlFV1VhWW5yQnBkMk01TTc1Y3RaZThs?=
 =?utf-8?B?dGVtZ1FRakhFWkxnZGQveVBJZVdLcjJibVl5RkNMZCtPbkU2aGlnOG9HMDF0?=
 =?utf-8?B?ejRFVW5jMm55RE44SVFOVUQ4dFdXSmZmNnpydnd5QXBIdmY1TGh2SE9ueW9p?=
 =?utf-8?B?VUMycGxNT2JCNTFTc1hNZWNFVU4rNGlwUkhDRTIwQ3E5OWZ3NUprd0cvMkhS?=
 =?utf-8?B?aHcydGQ5TlFIOUluOUVxR0pTZTZJOXpSVW1SdjFsc0hTdC96NHBlcDBaWU9L?=
 =?utf-8?B?N25jZEV6SDV3bUFuT0VMSjFJTWtzMVViYkV2Zml3VzQ3S0tVZ29xSzRyT0Nn?=
 =?utf-8?B?amxxSU5lYVlDTmU1dFVzSmw0TDBGNWZRWk9tSStYMjVkOTlXZ2Zta2xreDZ5?=
 =?utf-8?B?SkJuTisyN2dMMUlQcUJIRDEzbmhlMzdhQWYvaFI1bnFJTEQxb2pUaThrSTM3?=
 =?utf-8?B?dVNTYThGTFVqODNmL2NOdUl3dWYxWVc4YzExRVJHR29OQU9XUEZvY3VwdXIr?=
 =?utf-8?B?UEd1Q21UTzEramlHbEd5RFZOZitucTZjVlU5aEd6NkwxVnFoYlpINU9sR1Ay?=
 =?utf-8?B?OFdQdytxRVdhVmJvOGF0MHV0OXZsRlpaMnF6NFRRK21RcVpQd1JBT21PdUQ0?=
 =?utf-8?B?RUppTXQzb01yL0E1TllrdWh6MTgzQW5BWS9jZ2RuQkhiZTNxMzBZaHRFcm9T?=
 =?utf-8?B?Z1NERnVHVVQ1LzVyRXlXeVVudnNuY3dvd0tPbTF2eE96N1lLTjdmQzFvODZT?=
 =?utf-8?B?VTFtODB0SlRaRGtFRW12WWlBNnpwRVJqZmZUM2QvWEJBK3ZmWHUzZjhVOVZ4?=
 =?utf-8?B?T0FIYjBVMlBRRFBxUzVMZTBJL0VGL3pZRWs5UmpXOFVxNStLb0t6RGQzRjZJ?=
 =?utf-8?B?cGhucnFWcDNacU52YkRHd2JpemRVRzFDbHJPS25CeWIvUVh3RGR6Mk5iVGFs?=
 =?utf-8?B?cHRCTnlPaXlsWnFpcHR1YmRldEZxMjBsdDEyKzM0bHN6d0NHRmZTN3FudThu?=
 =?utf-8?B?QWR6bU9KaEJOUHc4OFQ5U0I5KzAzTTYyU3g2bWVjWlNPRXlqNG9OeE5CR25E?=
 =?utf-8?B?bkVUWEgwNUkyTjdDU2VmcDlsdlpKMkJERkVjdngzaG8vQUllVVpGckEyeXda?=
 =?utf-8?B?dVhPMjZiU2dDVWUzNkRTM3FpaWtjaFdDK1kzME43L2I4MVZ0cVYyYnZTcWdu?=
 =?utf-8?B?dU1Bd2RBaC90MTBMd01oOU1RVmxVQUQrZjJEcHRiOHhSOHBJa04zem9RL3Nq?=
 =?utf-8?B?bjRVNURVQVI4dzZSM3JMczl3dk96ZmhtT01SRmxGUVJwajN1STZLVDE3VGR3?=
 =?utf-8?B?aUFSWkdRQ3d6R0xuWWoydDY3Qit5Y2pJTXgrSm5ib0NHeGJUeU5nTWtFbWpN?=
 =?utf-8?B?WkZUaWZ4cXlRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZHZzOU9mdnJmVlRIMEFhZ1o2N25KSzdKZE02THd0L1FsWjhSejMzMnpURXNh?=
 =?utf-8?B?SG1ZNUZCVHhwVUtkaC9tQVlLZHJlUDJFV0FHb2NBUFJhNkN6alh3RENHeHBp?=
 =?utf-8?B?NWNMUDhMRjVxRy9yWHNYNTE2aG5GdklqNU9qS3p5KzhvREFtam5KcUlndE5O?=
 =?utf-8?B?YS81ckNYcDhHcnhlQXlkaWYrS2xVc1RQSXA1Lzl6NWR5R2h2QlBWbWRFS1N5?=
 =?utf-8?B?WTNUaGR5dUlyd2tIcmRrNVd1emp5elR2dERMdHFtaUdlYnlVQnFETFVFNmcr?=
 =?utf-8?B?aDM3NVFMQ1VSNFJjbWQrSWlZN1dSSFdXYnZCdmxCdHVaK24veGlFbGF5NU0x?=
 =?utf-8?B?NiswUHI1bHlpQkZSQmo5bFMxTVdBeWlOVjdwR29zUDdwcEM2YVdHSFdGbi9l?=
 =?utf-8?B?MGtxL2VGL1VUSFEzOWxoYXd3RUFkb0V3R1pSSVJPSXpBS3B6ekY0OXJiWXV3?=
 =?utf-8?B?ZmNhUHlxNFVZV2lWUGVaSWRDbmJHOGdVTGNDN1J5L1RqYXF6RUlZS0kxbmto?=
 =?utf-8?B?M0VzbUNVR21NVzFSakd3SXF3aHAzSTZQR0tuYms1TktaUndxYW9jTTNSWmRu?=
 =?utf-8?B?eUN2b211UDdLT09qZ0RsaU5ERG9kUlR2Y0NHVmRXNDZZcy9rYU05YUx0cnU2?=
 =?utf-8?B?aWpSc242SU1KR1dvVHpsa2d6THl1N2hRM0lXRWdsWXJscFRqc3ZCZE9TTEl1?=
 =?utf-8?B?M0VuUTQycVVDSk41ZG45eTZOVGVlUWNSdzl3QkplVGZRV3VNUDhQSndRLzh6?=
 =?utf-8?B?ekJiemgzeTIxTWg0bXpHc200MEZCb3h6MWk5ZFF0cHJqaTlaWHRWMGVJNFFv?=
 =?utf-8?B?RTk4LzVxK25zeGE4QjFTb0FvYzh3VTJyZ2RXZjZWd2hsOHdrVVZrWFhYL0sw?=
 =?utf-8?B?WjhtWFRVVUVJM1QwS2R2b05NRGZPWmN5U1IrOVRUT3EzSlRsT05KWmdFRURp?=
 =?utf-8?B?MzRJamxxNER1K2FGbXIyOStXeExzZjNkYVduY25VRTMvVU9vc0kyamlpWDJW?=
 =?utf-8?B?TkZnU3VYZzRkbEtoUi9kYkNoOXo2dkVwRXZGQncvZXNOUTRkT2ZKd254K3dE?=
 =?utf-8?B?UzRBQ0FXM1VDVmpXMFlYSDFWVXNxZTZraDlubnZzb1pEQWFWWlZOWTBDQ1Rh?=
 =?utf-8?B?RnZPdGIyVmE2YlZWdUxsdFdXN051NjR5eDJHNERsL3FZSjJIUGlNNWoyYnJo?=
 =?utf-8?B?VVcyWWVQTlM1QytzNC9oaXB3OWRJNkdQb0VoWFVCODVkMU43MFlsQ1dsU0Qv?=
 =?utf-8?B?N2ZmemtjNk1vdllpa0lFbDY1WUJzV0t0SnR3dUdOTTA3dE9vK0t4U1ZxZmxv?=
 =?utf-8?B?QU5ZYnFIVnozdXVoeFdQNjAyUHJ0RUJzQmFkN25VeHN0YWJFaW1ORVNPVkhx?=
 =?utf-8?B?aTNqSE5CUWV1QnZ1RzA4U3pIbkdMV2YxYVJIMzJuZk44ZHpEd1AvVHVsQ1pU?=
 =?utf-8?B?NEdNYk04eUQ4YXRqZENtTEJrVml1Yi93RHlBWTRUYUh1NTFCWHZMS0tLL0Jz?=
 =?utf-8?B?eGpsSFg5dW5tb2lpbFc2OWlPZWtSS1pPNlJIT21BazZiV2hPd1NHNEJnVlRv?=
 =?utf-8?B?OHF0UnZPMkQwT0lWamQwWEVwVFVCNEUzYTFxZ3hiRDZVRThtRjdpN0orekZk?=
 =?utf-8?B?ZUk2Mnh2cTh1am9KMVFLV0tEVW1sVW40Z2QxY2xxMmpOSzMvZ0svaVlXZzd1?=
 =?utf-8?B?RVh4ZmNncFk1TDdpUExieGo1SHh5d1ZZVGFFL1ppeXAwVHRPR2ZYNDc0alI2?=
 =?utf-8?B?UmZ2cjhxRWlkTXh1M2JJTmpRY0xGcDAyUzdPOVdueG9rYm54T0NaQlhEZ0Zi?=
 =?utf-8?B?enF4RjV0VFdIekQ0cStmbmVBSjJMS0srTGxESWJ1MHlwcVdLSXgvdjgrSndz?=
 =?utf-8?B?UmNIdkpVTVZzUGc2MER3bDZhc01jaSt0UHl0ZHJnQjFRQ3luMkd2emFpZVFt?=
 =?utf-8?B?d1dLK081bEZVVUFRaC80VDVUVmQ0YUVlcW9JaTR6QlZZVXVhd1pTUTRQUDIv?=
 =?utf-8?B?RnpSOUdBcG1SUDFnYk9VVzE0bEdCY29hZjY5NVJqME1zMlZJaE5wTVFVMDVo?=
 =?utf-8?B?cjFUbE8va2c3aWhwNmFDcHRHaDQwdFdSVFVOOEhFUnpQWkxzbHlsdzNiVyt4?=
 =?utf-8?B?K0JBWHlsQ0d1N2hFVlRCZFYvUTNJUWxQZjhnZXdUN1NVTDBlblBWbzgvSDhr?=
 =?utf-8?Q?dEIIcOboTKCYPTBSBFp0Ou0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <007BF9B3D34BC84EB7E461A5B68D9D14@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7a86a7-e047-4984-1bd7-08ddd6a2b2e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 17:40:43.0584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZplKJgKWRUxmwdlJOQoiPEwYfyqseFwETCK/4m/gpmUoTHdVP0uNYKJRvS2YJ8ZyMLPSyWqLgcWjRQUL1nMUYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6395
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDE0MSBTYWx0ZWRfXwWXxy6XXhbJN
 IasKufZ5X7Tb5/ldFD/3fHjIPdRUDLgv0FN6vn8Vud6ueGg0Bn3vuGU2MACcCvU4JNltJXvHaJ+
 fazNOlyfwRGkvhNQprFGEWdex6dFWve0w0CmDw4pVPHgofDr3satPLl5/SS0znCfeFbJc214g67
 pC55Oa2KZ9VfLyYV0TEmFOPuMetQwFHkT/9iIMZLeXRqVqx6veADYMBUM45S16+VXUAg/yJVSpz
 VFd5gctWIgML1bYMu/Z6SnEd2Ei4bldKUJqswTUavTgMXli/JYpCv9uZB4ub+ks1b2l+FY/CqNG
 Oeqa0L+jsI1cGBunvHNVtbJ6Mg1KnPXa1QjyOIyD8GQL5ndz3PEuteCS1MR/J6lqomm44wN78xT
 dWLjNOnk7HWjmhO0+Qj2urfUxOXwg7BUS3mBCdd+5SqdBqhQB47FiqFCxxRSVHfcer06leKq
X-Proofpoint-GUID: Z59ev33MEOmCNcIc7A0hSOWRiewTQ1CI
X-Authority-Analysis: v=2.4 cv=PoCTbxM3 c=1 sm=1 tr=0 ts=6896369f cx=c_pps
 a=R5I7B2QmnaDnSMjMWWX19g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8 a=gr9rKvr54fbwqHBD6yEA:9
 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-ORIG-GUID: 0SXSBp3hP2hNFld416DAPHvOO9uY8HHU
Subject: Re:  [PATCH 1/3] net/ceph/messenger: ceph_con_get_out_msg() returns
 the message pointer
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508080141

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjQ4ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gVGhlIGNhbGxlciBpbiBtZXNzZW5nZXJfdjEuYyBsb2FkcyBpdCBhbnl3YXksIHNvIGxldCdz
IGtlZXAgdGhlDQo+IHBvaW50ZXIgaW4gdGhlIHJlZ2lzdGVyIGluc3RlYWQgb2YgcmVsb2FkaW5n
IGl0IGZyb20gbWVtb3J5LiAgVGhpcw0KPiBlbGltaW5hdGVzIGEgdGlueSBiaXQgb2YgdW5uZWNl
c3Nhcnkgb3ZlcmhlYWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXggS2VsbGVybWFubiA8bWF4
LmtlbGxlcm1hbm5AaW9ub3MuY29tPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogVmlh
Y2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQoNClRoYW5rcywNClNsYXZh
Lg0KDQo+IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9jZXBoL21lc3Nlbmdlci5oIHwgMiArLQ0KPiAg
bmV0L2NlcGgvbWVzc2VuZ2VyLmMgICAgICAgICAgIHwgNCArKy0tDQo+ICBuZXQvY2VwaC9tZXNz
ZW5nZXJfdjEuYyAgICAgICAgfCAzICstLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9j
ZXBoL21lc3Nlbmdlci5oIGIvaW5jbHVkZS9saW51eC9jZXBoL21lc3Nlbmdlci5oDQo+IGluZGV4
IDE3MTdjYzU3Y2RhYy4uNTdmYTcwYzZlZGZiIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4
L2NlcGgvbWVzc2VuZ2VyLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9jZXBoL21lc3Nlbmdlci5o
DQo+IEBAIC01NDgsNyArNTQ4LDcgQEAgdm9pZCBjZXBoX2FkZHJfc2V0X3BvcnQoc3RydWN0IGNl
cGhfZW50aXR5X2FkZHIgKmFkZHIsIGludCBwKTsNCj4gIHZvaWQgY2VwaF9jb25fcHJvY2Vzc19t
ZXNzYWdlKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbik7DQo+ICBpbnQgY2VwaF9jb25faW5f
bXNnX2FsbG9jKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbiwNCj4gIAkJCSAgc3RydWN0IGNl
cGhfbXNnX2hlYWRlciAqaGRyLCBpbnQgKnNraXApOw0KPiAtdm9pZCBjZXBoX2Nvbl9nZXRfb3V0
X21zZyhzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24pOw0KPiArc3RydWN0IGNlcGhfbXNnICpj
ZXBoX2Nvbl9nZXRfb3V0X21zZyhzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24pOw0KPiAgDQo+
ICAvKiBtZXNzZW5nZXJfdjEuYyAqLw0KPiAgaW50IGNlcGhfY29uX3YxX3RyeV9yZWFkKHN0cnVj
dCBjZXBoX2Nvbm5lY3Rpb24gKmNvbik7DQo+IGRpZmYgLS1naXQgYS9uZXQvY2VwaC9tZXNzZW5n
ZXIuYyBiL25ldC9jZXBoL21lc3Nlbmdlci5jDQo+IGluZGV4IGQxYjU3MDVkYzBjNi4uN2FiMjE3
NmI5NzdlIDEwMDY0NA0KPiAtLS0gYS9uZXQvY2VwaC9tZXNzZW5nZXIuYw0KPiArKysgYi9uZXQv
Y2VwaC9tZXNzZW5nZXIuYw0KPiBAQCAtMjEwOSw3ICsyMTA5LDcgQEAgaW50IGNlcGhfY29uX2lu
X21zZ19hbGxvYyhzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24sDQo+ICAJcmV0dXJuIHJldDsN
Cj4gIH0NCj4gIA0KPiAtdm9pZCBjZXBoX2Nvbl9nZXRfb3V0X21zZyhzdHJ1Y3QgY2VwaF9jb25u
ZWN0aW9uICpjb24pDQo+ICtzdHJ1Y3QgY2VwaF9tc2cgKmNlcGhfY29uX2dldF9vdXRfbXNnKHN0
cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbikNCj4gIHsNCj4gIAlzdHJ1Y3QgY2VwaF9tc2cgKm1z
ZzsNCj4gIA0KPiBAQCAtMjE0MCw3ICsyMTQwLDcgQEAgdm9pZCBjZXBoX2Nvbl9nZXRfb3V0X21z
ZyhzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24pDQo+ICAJICogbWVzc2FnZSBvciBpbiBjYXNl
IG9mIGEgZmF1bHQuDQo+ICAJICovDQo+ICAJV0FSTl9PTihjb24tPm91dF9tc2cpOw0KPiAtCWNv
bi0+b3V0X21zZyA9IGNlcGhfbXNnX2dldChtc2cpOw0KPiArCXJldHVybiBjb24tPm91dF9tc2cg
PSBjZXBoX21zZ19nZXQobXNnKTsNCj4gIH0NCj4gIA0KPiAgLyoNCj4gZGlmZiAtLWdpdCBhL25l
dC9jZXBoL21lc3Nlbmdlcl92MS5jIGIvbmV0L2NlcGgvbWVzc2VuZ2VyX3YxLmMNCj4gaW5kZXgg
MGNiNjFjNzZiOWI4Li5lZWJlNGUxOWQ3NWEgMTAwNjQ0DQo+IC0tLSBhL25ldC9jZXBoL21lc3Nl
bmdlcl92MS5jDQo+ICsrKyBiL25ldC9jZXBoL21lc3Nlbmdlcl92MS5jDQo+IEBAIC0yMTAsOCAr
MjEwLDcgQEAgc3RhdGljIHZvaWQgcHJlcGFyZV93cml0ZV9tZXNzYWdlKHN0cnVjdCBjZXBoX2Nv
bm5lY3Rpb24gKmNvbikNCj4gIAkJCSZjb24tPnYxLm91dF90ZW1wX2Fjayk7DQo+ICAJfQ0KPiAg
DQo+IC0JY2VwaF9jb25fZ2V0X291dF9tc2coY29uKTsNCj4gLQltID0gY29uLT5vdXRfbXNnOw0K
PiArCW0gPSBjZXBoX2Nvbl9nZXRfb3V0X21zZyhjb24pOw0KPiAgDQo+ICAJZG91dCgicHJlcGFy
ZV93cml0ZV9tZXNzYWdlICVwIHNlcSAlbGxkIHR5cGUgJWQgbGVuICVkKyVkKyV6ZFxuIiwNCj4g
IAkgICAgIG0sIGNvbi0+b3V0X3NlcSwgbGUxNl90b19jcHUobS0+aGRyLnR5cGUpLA0KDQotLSAN
ClZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0K

