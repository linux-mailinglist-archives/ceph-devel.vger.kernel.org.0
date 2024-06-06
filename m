Return-Path: <ceph-devel+bounces-1269-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFDB8FE798
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 15:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DFBEB26829
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 13:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275DC19642C;
	Thu,  6 Jun 2024 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="A5EWutyj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2114.outbound.protection.outlook.com [40.107.22.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0BA195F10;
	Thu,  6 Jun 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717679917; cv=fail; b=ce6CMy5/M4o0GQFxr9bTRwFraW06vXn0JGGJIUZGP/WRNDYJrlTHQzAcamKYFqvDcyG8CT226saDdfrxLUfc9l7J7T+LRvvEyU1/uRJXzMUZOtF17DLHnNkXzWY+mfyi28DlJrKBXeqWg849Fgi4R3A4ztHzmSC1T59g+iwVx58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717679917; c=relaxed/simple;
	bh=2mC5ccPXyxnKJ7rgijXbQysj727nuvw1o6WiNV24ikc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nnuw6zUX4x/Gw2IpRJDvxmGyN9EF8kDi/XUD14oNcyQV4SmokLZZnngEFfzXIuCvfY/yoicTYWQg3hyBN1k1AN7deH0Bc17WPr3vmAamaqjTgIQrVyoEkg+jARvzh93jbE+mstxTQnHDtPVqCBuUzKzV2jzqi+pBAW9g1QD4jMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=A5EWutyj; arc=fail smtp.client-ip=40.107.22.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGNIWux1JX/lwehEwinzwX5mMcNUV2w9M8YRf2lPxz+AU7ofPuhOSFlMllYEbf6f9WGRvxI8IUNd4z1SfujtOlx8oCsQZUjQETwdMtSh5q9Lg2ygwzPzLpPGkMvfYCXxkE8QRW/4ZiJosl/clb7xpoqTsljlFao2mouDtjWvIa0DzPtlDmOLT4LRnylMlpaJngJjk7WZ9z7ksYOXBvMN38kfFJmCZaua+ZHVKanxIj0dI6bVdjBPv9r0BEoQ3XwzjI1/tXicOAifLjydjC+H2jt8MjIlIrt1eh6iNjjOXPaSLT5t45yfFpIyJ8KL8Vu+LzZvXws5jsvdcg1nKsKCqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHImrJ20hWX2Yn1locZFrexgjpSaL+ByGSrCm6m6aZQ=;
 b=nSAsoXN2wWHUfOI5tuROcCYBdXOzYxwrm7kwyZrnXJSBaGBnoyQJX2F70qmostIvDlf+sFy3Ys1cLe35lq3mo1NvcKOYW4SnwCQTyqZqXDf3gImpuAQlHmVUWnxz4dMFrGGnCKoUoSLCw5wob4emma7PTj+mmfFPalHvwfpXMxTyLFL/KJyBFS+qU4PvTiNCK1V9Mh5ACQhDWqL74T7+MwK6/xbH6MTR9F2Ajl9uStOY0Ld+GaBIxnlVG8BSUnf3kNu8Vo6hV2J0GUce/IsU5Loqt93CklN0lP9BqK1RjEjWKulRs5YksG9IAAQT86yBUwLzeLQQYJ79ZBp7XZVpYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHImrJ20hWX2Yn1locZFrexgjpSaL+ByGSrCm6m6aZQ=;
 b=A5EWutyjbYZVDk2omzw3L+VazgCZSeucHa6eNTUM0hidK82emEmO4ph9jOmtf+uJ9hYR2rVkLmXezEG7wBJThVZeTgUnvc7jLu+7Zr6Lah5rFwC52C1VKl2uDlMDe/dRLgtmKVqnDCsT5QfUHrj20cXJuq8ZYWYNKBT4rKeYTifywzCFSHq83f7iKEzbI7HUXlcLFy6iOauhrX+TG/vxa0jItwVrtW34XlL5V45HQ+x3szzCpRyX9kFVXZaGuh7umAUnAs7Eok6nKOBthEmqpiGN5GMQ6EKr9UfHCKAh3mqDRK1NX44LtwGYaIETujh1QcPqE4bD0enQy9/q4cP3ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by PAXPR04MB8365.eurprd04.prod.outlook.com (2603:10a6:102:1cf::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 13:18:32 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 13:18:32 +0000
Message-ID: <ace6e7a9-3a77-43eb-ad86-83eabc42cdb4@volumez.com>
Date: Thu, 6 Jun 2024 16:18:29 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com,
 edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240530142417.146696-2-ofir.gal@volumez.com>
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
 <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
 <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
 <20240604042738.GA28853@lst.de>
 <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me>
 <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me>
 <b13305d7-35c8-432e-bea1-616410a9da15@volumez.com>
 <20240606130832.GA5925@lst.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <20240606130832.GA5925@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0002.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::8)
 To AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|PAXPR04MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: f6108768-f310-4f1e-c2bb-08dc862b29f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUtUYmxkRUU3dis1UlY3bXczRzR0ZWdKS3gvMUw5VmU5R3lGalZWWU92TDk4?=
 =?utf-8?B?WGRzNks2Q2RhTlEzRkIwdWF2OFF2L0lleVBXbUkxT2dpQjVRSlV6WDZDTUow?=
 =?utf-8?B?bm9VV1RTb2tpaGxobFBieHk3MmlKejBIMlNJTnZpNVlUbEl2dzdrVmJISDEr?=
 =?utf-8?B?aXpKTVJEVVAxRERaUXh0Ui9MT1pvUU5nTWtmUjNnZWN0a2plelNEcTFkOWhX?=
 =?utf-8?B?ZitPaWQxRW96aWc2dXAxZ2lnL0RWVldMSERnNjgydkdKV0QwNFV4SUZhbktl?=
 =?utf-8?B?M1hBb3ZNK1h5QzZHeVY4dGdlYmRtbEkrMFRidHBieVRDaDhyZGdvVUk4Y2ov?=
 =?utf-8?B?RXdRTzEzaTh5MStCZUlVVndrem5WNUF5ZXZnOXRVcGxHM1lSZlJza0ZjOWR5?=
 =?utf-8?B?blgvRnNWZ3UvalZIT2p4SHpacmU1Q1M5aTRqQi9lT0Q4OG9kMzJZblBGWEE1?=
 =?utf-8?B?Nms3bE9pdGcwTG5ld0kwQnllWUVNbHhiOGhERFUzOG9XSThXQThHWVBYdlZ6?=
 =?utf-8?B?UVRBbEZrSWVtODErVXZLemtXWC9QVkpTcWZVY1lNUnhockhvRGJXS3MyaHMx?=
 =?utf-8?B?a2tNOFJUM3NZYW9ubUNMREJWOVpGTTVQeDUweE4yY3ZZSWtpeTc3a1Vzejhh?=
 =?utf-8?B?OXNVdXB3MzEzdDVKeHRiblBVeVFsY3c0emhhMkp6L0RJSDVuMm95Wjd2a1U2?=
 =?utf-8?B?RE1DNWFPWGVkd3NBclp3Rng3RWx1QzJTQUkreTUrM0JCQVdBaTEwd0tnSWRG?=
 =?utf-8?B?U3dhN0Ftd2FwRldlUkRHMXRTN3NNSTlUeGtSVDBuVjhwd0I3RVUvMEYrWlZL?=
 =?utf-8?B?VVFZZmc4RnNEVWdYSFVCTDRVN1lVM2l3bzR0blA3SGJ1VHhmU2ttTkhKQlpH?=
 =?utf-8?B?bjVkWUJVYUIwbEs5S2FvZlQ4Tm12ejVpR21pdFB5ZHJQdFU5Q2lvTk4zbWQr?=
 =?utf-8?B?UmcvZUYxVERYN2lQOUw5LzZBNTlZSnR4NkpQZlo2bjk3dE11VzZ3Vnh0b3Y3?=
 =?utf-8?B?QTk1eEUwUzZBL1YxemVCT2ZjbG1KRU5BbmVYWDRHaEYyTkREbmhzVWRZTnJX?=
 =?utf-8?B?cEVLeE9ZT1laSXNnTm1KL01iVW1pWC8yRG43azFPQ1dUbGFqTHpRZk15TWtH?=
 =?utf-8?B?eGZPdi9GcDBMK0I4MnI3c0hkZWMvWEI0cElkS0VYc0xHZnBoQ3VOQTFMVnhp?=
 =?utf-8?B?N1hkMW5VbmdwNmV4RmwvNHdwRHpub2srZlIzekozT2pTMWFRcnBzYXdVUGhj?=
 =?utf-8?B?R1N1SllPTDFOdVVWUHFwSG9oRFJ5Y3hucDArMWhDNUZldEduWGpqS2FWTXdC?=
 =?utf-8?B?a1NzVFJoSFpPMFg5bThuL2xYY0RDTGZMa0VZRWVXdTB2SCtrbHpzRnpxSWNV?=
 =?utf-8?B?dWc5NXhDOU1QK1dJWWljK0hZUHdXRXB5bmhiaUNKQk1yWVhLMnRIYlp2VHF5?=
 =?utf-8?B?Q0MxWTFFK0JLRGtkZU45L21xR29iTHFOMC9mRDFIRmJsejJnbUR6T29xMm9s?=
 =?utf-8?B?SzdOSzVxWGQxVXE4NHVyNENqcWpTY29hM2E0cDM1NE5KeE9xM3NDQkh2WEl4?=
 =?utf-8?B?UDcwcmh3OFRUWWhLejlvVGVuZ1ZwUEJYQWg1eDk4WXE2UUdid3VWbUlGclo3?=
 =?utf-8?B?L00yb0lXOGNDVk5KYUJZNzVJdk1nQ3VNNUVzK1EwYXZGQXhEL21aZzdqL25F?=
 =?utf-8?B?YVhzaFZWRDh3alFpV3c1YWJVSHZzSjlmZTR1Z2gzUGZrVHRLWEhRSGRLc0Zn?=
 =?utf-8?Q?b+2GTZmjaW3SqXgYiXzuMP7/awjZ4d7LhG/NvkP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlY4WGF2WnlWV3YyRmR3Q2N2SGFBYUlvWlJaRkxWZVI3Qk0xY2tPRFQ4NUdp?=
 =?utf-8?B?MEM3TlN5Q0JsWGZhRVFGNzNtdk40UGdMMHYxWGMyeU9QVVdRa2dHK29jdWVl?=
 =?utf-8?B?aVY5SCs3aTk3b3d6UGlWVFJwSWtvSDliTythNStkZHZOUlc5enJKbTkyMWhV?=
 =?utf-8?B?Z0pKRHUyQ1RoV1MxQlVZL2pyN2MrVndPN2N4dnJNMkNqVTJBMGZyeDJ0b3U3?=
 =?utf-8?B?RXhqMmMramJZdjl1djNXWjlYdjB0OG5hdzVXd0xuRTdGem5jWXp4WEI2djM4?=
 =?utf-8?B?RWJ2NE1LU3FjUUlQc09IVlEydUJkbXpjb0cxWG5pWWFZN2EwbTdqWWkycjNi?=
 =?utf-8?B?RUtFU3ZoL0prMDZqU1JDL3llZmY3R2tlMWxqUE1BU1M4ZGIzMjFwcTlteElo?=
 =?utf-8?B?dERuWlg0aTNWWVR4RHg2dTQrUUIvckV2ditJelQ0dE1ySWU4Mno5ZHBTK0Ja?=
 =?utf-8?B?VlZ0dWdyME0rYjhJVVVMNDIzdStCMm84ZkgyTFBJd3BjN3prY3E4NzhWV243?=
 =?utf-8?B?ODdHV2M2VTMreEYvdU9kUGdSR3l5TDdwb0w0ZkJyL01LTEt4ZTE0TlZVcmhu?=
 =?utf-8?B?aHJMUEt6eERBZGxBUDEzY3p1WnpobU5TdnVZM21jUEloNW9HeW9YSGVCOEtW?=
 =?utf-8?B?OWRMOE8zbENkRU16dUVMcEVqNm92VjVVaUxYQ2ZXdkFmL0owR2NtdWEwNUJt?=
 =?utf-8?B?a0M4Mlo4L2twY21iSFY0YklSejliWHVIMUNmUW5TbVZTeXc0VjBUNnVoOW1I?=
 =?utf-8?B?WnFBVGlmM2h5a2FWZ0Z0Nmhlcy9UOXJiTEphMkpFQWxTM3dPTEROMU9hd2Fm?=
 =?utf-8?B?YzdiUHJMckxob1Y2czR1aW9VV0hsb2RDQnBualVvUHo5b1kwV2J4a3Jsam1y?=
 =?utf-8?B?ZXo2Y3NRMUtkTGx3dmhwcUE0Snl4RjBLWEpvYXNVc0RLK2MvUU94Q3B2aXBt?=
 =?utf-8?B?WmUxZFJFUHNFcFBGSWJ3SFh5OW5YYkcvQTZHTFo1Y3JBWE4wY1NDQzZTc2M3?=
 =?utf-8?B?OUdta0ZUMzIwTmdTWG1MZ1VTbk1BMXBlY0xXNGNpWDMxLy8zdHlmeUVOMkxu?=
 =?utf-8?B?N2dhRTdQS3RFR01QU1VtUXpPTWc5UlhaTFVPanZIOWN3WFVkOTBqbVRtSkdk?=
 =?utf-8?B?bTFWQ3gxL1dxN1NaSW9kVGQ1aTNheXMrL3dYTEFvYzhuSER0SHVUc202dW5M?=
 =?utf-8?B?ckFjaVowSFRzT1hmNER3eHdKZDZnVis4bFczeTRPK2QreEMwamJYNmhwSTMw?=
 =?utf-8?B?cnRNanBnS2x6NTRqc21rVWxyZjZsZU9jeDlWT2hrVkFiV25kWDl2d2Nia3Bz?=
 =?utf-8?B?dW9LWmwyL1hMWkdKc0hRWDdxcEEyVEtYeklVOUFUNTJvM2grOUI4dldDc1dY?=
 =?utf-8?B?eDFGcEQrcktnY05zTXh0OGNiaFQ0Qko2TTc3bmQ5Zmw2OVZhSUp2WUlSOEtx?=
 =?utf-8?B?b05Gdi9HcVBXSmppSndnR0xkRGpBd2E0ZWFmR0pjK1VaVm54VnJSODJFZ01F?=
 =?utf-8?B?TE53QkhwZkwzMUcrNnE1NDV4ZVBHQlI1end5NXlod1ZvU2JJTkJXY3ZKY2J1?=
 =?utf-8?B?SUNtYUxYeXd2WFdna2Q3UnVrVThMMktMUXI2RFBZOVlkMU9KTlV6MVdiMUxu?=
 =?utf-8?B?WjRJRkgxTnFEUkdPTEhDUC8rUE04bmYxZGVPT2k3a3ZkNlpxK3FsQU5rQ1pC?=
 =?utf-8?B?L0hCNEd1UzdCbDA0TkwyYll1eUJ6aXB3cStheDhBbTRuakhubUhHaGhNS2Mv?=
 =?utf-8?B?dm1pMVVkNmlLQVNPN01MZnZqY3pSMUlTNXV5MVZjK1lyTExoSnlTNWMzOWtj?=
 =?utf-8?B?bUdRZk9NSlZOdlNCTU8zT2d0dW94cStEOTY3SU1ZOGY2clFKWldBOHFkdDll?=
 =?utf-8?B?OHRBWWc0TmhnbFBZMTI3UkFPQ0RPejZ1RU5TNHhjK2k4ZUlJQk9VaWkyRU95?=
 =?utf-8?B?UWJFd0RSYlh1dGtVQVRtY1E2NkRlRXlPczMvd1FObW1MQnlPVXpUV2R6Y0wv?=
 =?utf-8?B?ZnV3VitmN1hjTmFVZXNCODZVMWUvVnBYeUVHamlDMnk3SzBCRWtScmpYSDFT?=
 =?utf-8?B?MnFKbEdWckEvS3RURVZ0bUoxTUpUelFyZnZjdDhQY1FEYkw0bWZBTHZlTjlF?=
 =?utf-8?Q?frj4ysUO4yJ+Y9YIToPHaSAt/?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6108768-f310-4f1e-c2bb-08dc862b29f4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 13:18:32.6935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSq4GqC7nuY/fSZq52+sgWcGyBlSR63dmzOvT8VLZpGKDnY65tLNRUQAPP30taYCBSWccE+AAzEA6mREx/MtRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8365


On 06/06/2024 16:08, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 03:57:25PM +0300, Ofir Gal wrote:
>> The slab pages aren't allocated by the md-bitmap, they are pages that
>> happens to be after the allocated pages. I'm applying a patch to the md
>> subsystem asap.
> Similar cases could happen by other means as well.  E.g. if you write
> to the last blocks in an XFS allocation group while also writing something
> to superblock copy at the beginnig of the next one and the two writes get
> merged.  Probably not easy to reproduce but entirely possible.  Just as
> as lot of other scenarious could happen due to merges.
I agree. Do we want to proceed with my patch or would we prefer a more
efficient solution?


