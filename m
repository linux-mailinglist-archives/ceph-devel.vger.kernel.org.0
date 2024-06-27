Return-Path: <ceph-devel+bounces-1505-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEBE91A346
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2024 11:59:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81D331F22F12
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2024 09:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A38A13C3F2;
	Thu, 27 Jun 2024 09:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HF8LrhvW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C1813A245;
	Thu, 27 Jun 2024 09:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719482350; cv=fail; b=CT11c+vPOpMcxDJjWwuTrZ5kRzybtN4OJr+kU2fHk02BXPbIVd6v+rBPjxjDqjr0/4o/jdffpMf3jpRly6k6apCJ2IEv8p0KhWsTg3pLryvtsUJXW+q1fkgTsAc/QZOqjjvn46sxLkvZ+k564In5S99h+qh/WFSQOXePI3dFwZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719482350; c=relaxed/simple;
	bh=b+F1fwXy/4cYAmFvaHjfVNUGmjIOL3Y+eM93OcFc2ro=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CMAyRTsSZz6CmpREQWLGLR7OMAQnGla1xGQI70G/m195wv0JqL1CREVH17bIK/BdgasUybJ2oLZWEnJT8BcNMQOWAcJxyPhIWbFhYAjhA5BvVxkPC7rZJozWwgjfX35mmPbBrpQLyvjLSiBQWIK/w6gC8r45p467FODME0UupAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HF8LrhvW; arc=fail smtp.client-ip=40.107.96.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv9TOI7oAhI/fJAOcT9SRl5L+jTRcfiI5vBmodT3NxY7BwA4GaT5Q7UwkQAKTSx5DdbBs5S0K1bK5V6Rs9OZ6ADvsnqwZek+jQixJBaMQ8AnuICcnIPHIIx0IFf6K0aTbfgetsmxEDewr8tpoyQpcCow/Hl9s8PefoWXyFlU7msvrvmNST9nHHdyuR9vrSDJfCYShkAArisgBM/BVORPSgEGfe3Wvgkmil9scjtYObvniBfe6c2T2P/Sg66qoMSGW6I5GaA2LzNNrqPl5/BvZCmReGm7VI3i3L4sOxnZgSpl5kiaifktBVyCKGMfZ5olAmDoc8TNac2ShZ8HBKOXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlWtaCgawQK+6MshhW0hQum/UMxvfkHug5My9VxhFxA=;
 b=FMfruTCb13BhM8mQwNPbcEjCXEKxi71X6VAzI8KfLbndkoJdW7zbAy0PdIuD1TeJxIgiae6DgX9Xzf+x4FlaKZlAtgvPP2bK/SPeXZX0g3iSSZQDHk5cNY31RUPKORvEXc7LBCEXEjZMQQ4D6iZuHhXEol1qGZ4JON+F/o3XRwzaaaBaMC80/zhSmm5YUYpaPDm9VquivtJ6v886SXv6Ar9Ji31bFUfkoPZph7pNrHW9qNlo+Cz3JARpAzH2GzVdneHhfZHdmK2bWHu59FdmTOEuppsbq8Aq8uN3XcPxm4ogz77WfOHEi6mSiFLM0E4fbNURuJSdL32NbZqPL2lR/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlWtaCgawQK+6MshhW0hQum/UMxvfkHug5My9VxhFxA=;
 b=HF8LrhvWQBCFDdlX7PkmhsJRXRzqXzx85HM63mciPRFRwFHHy2/5cwEoe9az1q4JFluHSnOnKP0Q08eoHwl91y5hFn/oGGil4Q8FYAj8WOZHYjjl0ZXi1XgTtpFLi5v+0Ayzbh6JQ6ygcJ3nES1o+02QAhaJTQJxjj7pnh9a5L0X6I5Km4xwWT4pS8aAWmgK5FF6UMj0SopEabtYS6FyzwKcwe9GtNuY7epw6+VyyzHDdWAi7Z+12Ixwv1PzbyoXBthftI/x7bdqb4zkfAdIo+Gaj3B1KMHMF9ppQzLDGD6pIBRl59+qGei86dkYLhzXsrDKFqpT+DHA+aeAGpwF0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BL1PR12MB5946.namprd12.prod.outlook.com (2603:10b6:208:399::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.32; Thu, 27 Jun 2024 09:59:06 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%6]) with mapi id 15.20.7719.022; Thu, 27 Jun 2024
 09:59:05 +0000
Message-ID: <23aa9894-f913-409d-a385-8813711e2898@nvidia.com>
Date: Thu, 27 Jun 2024 10:58:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] mmc: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Justin Sanders
 <justin@coraid.com>, Denis Efremov <efremov@linux.com>,
 Josef Bacik <josef@toxicpanda.com>, Geoff Levand <geoff@infradead.org>,
 Ilya Dryomov <idryomov@gmail.com>, "Md. Haris Iqbal"
 <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 Ming Lei <ming.lei@redhat.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
 Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Vignesh Raghavendra <vigneshr@ti.com>,
 Vineeth Vijayan <vneethv@linux.ibm.com>, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240215070300.2200308-1-hch@lst.de>
 <20240215070300.2200308-18-hch@lst.de>
 <89164197-7218-4f24-bf24-0e67a1882c78@nvidia.com>
 <20240627094950.GA30655@lst.de>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20240627094950.GA30655@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0688.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::17) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|BL1PR12MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: 94269348-8a13-4b70-96fd-08dc968fc7ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFpVcEN0V3ZDVkhMbTJ2dEJRbEhhNHd6b1drdHdiYjZWQWhFYU5Cb2ZjVG16?=
 =?utf-8?B?aktqaU5HNXdDbTB4dVE1Z1VUNkdrYnZYSHJBU2p5Uk42RHUrd0JSM3ZTdGZI?=
 =?utf-8?B?NmtUdHlETVJla1ZBRUlQZlZqbUxuT1JKN1dtSHhKdGRFVm5lZjlFaGk1c3Yz?=
 =?utf-8?B?azlIYnhKbCtMcmo3b3d0cUJ6eG5RUlI0dFIvUkJjNk9iSVkwbGZYYkY1N0ox?=
 =?utf-8?B?ZVJLdWl1TnpDd3Z5Z25RVEpPMmxlcGQ1dU1yTkxCeUZkRzAwSFAvQkROTTJZ?=
 =?utf-8?B?V2ZvUFFwWGlvRXRRWXJJajZscHdmZ3lxS2N1RGVhaXdOSkFSRkEvemZJbXQ2?=
 =?utf-8?B?MlpBR1dJTnR5V1VMQnQ1SGlzSFpMU1dCZnJRRGhZVUhTNnZUbXZpd3hCQ0Fq?=
 =?utf-8?B?eTlLRjJBNmpFR1FqaFZCUUZpSGRzYTZnTU1zcVZkbXE5Um5UbHc1NmNGWTVj?=
 =?utf-8?B?ZEhLVytuTkc4aHpnZml5SnFuR0NiajZ2TjdCTkxHYzJoc2dFRm01R1pKd0RI?=
 =?utf-8?B?bFNYRDdFYnhDeU9qQWR1NVhKejR1WCs2VUJpUXhob1R2Z0ZZQkkrQTRMYzEx?=
 =?utf-8?B?czhSUmVQYUdSZGJnQ1I4WlZ6amg0aStYS3AwbUptRnFQTGFNeFZEbEFXbmpr?=
 =?utf-8?B?czNoMzFmVWJhTndmWUc0akEySnNOd01pbk5jalp4MkovVndSOFV5ZDhLS1ZQ?=
 =?utf-8?B?YXFraTRQRFc3dGFSWGVLanNVdHVOdXFSZ3dLVURRVWVPVUFBZWVpMDczMDNa?=
 =?utf-8?B?N2hid1dQUzNKdzlLaDV6RFN1dXhiMFVSVld4SlhTMDFZMEl3NE96S0kyVG9t?=
 =?utf-8?B?RXZNWDEwbklqR3ZiNVhURFBCVkluRFpDcmE4eGRNNVZyamo0N3BCZnVxS052?=
 =?utf-8?B?b2NPd2NkRjVSUUI3eTEyZ2pwRXhhbmY5UjBJS090V2lLTk5RNUxpTTQ2S1hR?=
 =?utf-8?B?YU40TDZHUUxrd2IrL21uN3lGYWJjZFN4dWF2TXZsOWZQRDhZa0JyQ0VhajJN?=
 =?utf-8?B?NVNjeVRUQURyTGtITHVRTmMvck9LeDBJUHNQNkhxNTFBVFhWR1Fab0FUVmdV?=
 =?utf-8?B?UnlwSkoyOFBUa3lNbWdzb01HeVF5MHhybzFMNURDR0ovQ2tXUmRjTnRuRlhV?=
 =?utf-8?B?M3VyTWRYYWRSSjIyS25taGJ1a3cyeWt6bVdVelROcTJpdXdvVWNmUjNCWXFm?=
 =?utf-8?B?c0x5S3U3SjdSRlBYOHg4Y2VaTm53ZmFOZ2hRcXBNWHh3c3gzMFFqbm9jL3pI?=
 =?utf-8?B?MmprTFhCSWlWRW1aTlZDMVZKN0haWS83NW8ydlhkbGZIcVRMRjNFYW5HR3I5?=
 =?utf-8?B?UG15R3ErcjVZNlZXY1BLU21aTDNxRWltYVBVVzJvSDk0aHl6RGZaOFJNL2JM?=
 =?utf-8?B?aUZab1NUME1mWURyelh2TjRGTHBocGNuRXNlL2dYVXFibU8ySzYxZjd3ekZL?=
 =?utf-8?B?RTR0NEozbDdUOGk5T3BqdXpKb1VwR2RYUFUreGxxZWdFZ2srcnNtVUhRd3dp?=
 =?utf-8?B?QkhhaWdYMTNRNUlYMXliK3dkQ1o3cnZkalJxK29PUWFTbWxQZFBUZ1VKU0U4?=
 =?utf-8?B?SDdhQWJaMjlqbXNoS0p5Q3VlRVppQW5kclYvejMzdk1VM0xqRCtMM1Foc2xx?=
 =?utf-8?B?bUMvemNXZmR2aXp4NDZyM1BNc2NQNWdsa3VxcGg0UUdSS0pyZWgyRHMvUHdO?=
 =?utf-8?B?bjdGVkJkUWRoTmVSV3QxVVJLVDkvVlRMZldIb0t2dFVQSDMzMnQzOVpFWnNy?=
 =?utf-8?B?WWxrc0dXVlpnTGdoWGk4NjVuZHlqcG5pWFFnd1VYME1NWVhlVU40ekptS29C?=
 =?utf-8?B?cnNrUGQ2Sk5rK00vb3YxUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEk3dmhNYmEweE5ZUGhCeW5rYitOV29FY0lVMktVRTUzQU9pRDNGTFR5UUk0?=
 =?utf-8?B?YUNGZXNRdjZsYVZReEE5SWd5UnpZWGpMUjUrVmRJZnRGMkREalZtejlJenAr?=
 =?utf-8?B?UWFNekdXeXZQVEdGeTRGaWNwYnF5U0NsTlpnVTNDKzUzdmQ0b2FNMmhCaHlt?=
 =?utf-8?B?WmJ6dXBIdUcrZThiQXMwUXE5YW1TWjlLWXlWczQxUmlKQmhLRml1QkliT3Nr?=
 =?utf-8?B?eFVFMm5CbmJIZ2JwaUV3ZUxEY3FNWkQ0ODY2OHlZODM1SWFtTVhVMGJyZUJJ?=
 =?utf-8?B?SXNEZVREb1VXTjNUdUovelJxSUUzRmZsMXNocnRnbmdxaTFZOG5HVmw2SGFP?=
 =?utf-8?B?MDROY3JjMHowcjU3SDlZQlpvMHlMZ1lTbWx1b1FtUzljNGx5bnIwY0ZUbWFC?=
 =?utf-8?B?MmVUNEljY1NVbzloY1E1Wk5yaFZab1ZBSGJ4YndoYkR1dVNTL1dTN1kxYm40?=
 =?utf-8?B?YmxoVnJNdHZPSFJMa1RpTGsyaVpVdjE4Rit6K0dnODlJUHRSSDVYNnhzcEtz?=
 =?utf-8?B?ZXVBQjJMQUg4dStUcUtvOHc2RW94VGRYanBqb24vVFFWZnZqbEJMbDhFOWFs?=
 =?utf-8?B?UHM0QmRvR1RvL3dwWkR5Z3BibEFDVzJMandqUno5KzFuVW1hTEU4RkpxSXBv?=
 =?utf-8?B?aWloWFlZS3d0QStJMHFyQ3lERVhuMFB6WHdCTEdkZ0duL0ZDcEplSDJhVmJo?=
 =?utf-8?B?cTRsU3dmenJFdG1wcTJFcG9LeFY0SjNYa3NVNnFBcHovVkEwZ1BkbkoySXFk?=
 =?utf-8?B?Y2w5dnZsSjNDZUFrN0QzaC9iOVJaVEhNdjZZT2lMNjVobGN3VG9XbE5HeEFY?=
 =?utf-8?B?cExrbGRUaTFzcU42cnVXOTE5Q05hYW4wenM5dTBvRTU5blJlMURGODRUY3RQ?=
 =?utf-8?B?MjJPTXNUbnlVWmJsb1duR1lCckdrS0tCbGo2OVEvM0ZZRUlGWU12Ui9XR1ZH?=
 =?utf-8?B?VlR6bzlIQVh2TEVvTk9XZk42dU5udVNjb1FZaEozampGcXdaTk5ENjk2S1lm?=
 =?utf-8?B?NWF4emJQRHZ4YTJTVmt4aTBGeHI3RUpjeGgyVk4rSXUzTHRoVjY1bkxjbzNz?=
 =?utf-8?B?bHozWjAvUkpEVjc1K3hrdTAxSThjMUhnVmZhR1ZIZXFkQTVqQ0dlalY1STZq?=
 =?utf-8?B?MW0rc1ZldXlYQytBeHdsMk85VmtwY1NJZlh5Q0xJUWRmbndBdEkweHNSb3Jx?=
 =?utf-8?B?RUVpazg5N0IvcWpnY3FxRGlVSlM3VFVYYmpMeUVTRkNJRk1teTZYdUhTSUYy?=
 =?utf-8?B?eTlMbmNkVTBlbjZrb1E2ZW1Kd3JRaWZCTlk3TlJuNnUxeHdrbWYveWdtMFZj?=
 =?utf-8?B?ZTdrV2xrT2drbFcvVnVzRWM2SVY4SGN4aTM5WlljdytLSnZyWUlNVHRJMlY1?=
 =?utf-8?B?a2pRU21FTDJHM05yT0Y2RjZYbm9GVWg1K1RIQVpia09namttVGZtbFBtUkd2?=
 =?utf-8?B?OCtRMGJ4T1VXSi9DNUE1cWM5ak1oanhOQUxQYW0xVlJuckVReGpROTcvd3RU?=
 =?utf-8?B?Q0JnSUVXbUMyeXdRK09nbDloVVM0UExzdHhxNk9tRWEwM1A5bElsN0tWb1lv?=
 =?utf-8?B?a0poV3kwMWtWeWllenRSemJXN2M4UUp4c1hMOEhndEJVRUxweUR6MHlBKzRN?=
 =?utf-8?B?TUFlQ214OGhDbzlJUms5TEltVStmTmpRcEYzUFZsOHB2dkdJSlJ1aG83N3h6?=
 =?utf-8?B?OFRZUWlkeG9IUjhxdVBDajVUME9pcThVRURYcVA1eHBPNVJFL0FpYW8xaHgr?=
 =?utf-8?B?QzNRbXF4aGhsT1VsemgwMUc2WUJKUzFtekpLN0l0d3ZBRXBNRmdjeGRPdEhB?=
 =?utf-8?B?OVE3MDlsQ0F6ZlA0RXR0eU5jczkyVS9HREpySTEvL2dTV1MvOGJ6VnQzVjNt?=
 =?utf-8?B?TlZaaVNjUDVMZi9yVFRvVEV0akZkRWhvU2ZWWUJ3VU1rMFIxdmFuUFV5Q2lP?=
 =?utf-8?B?dkVrOS8yOHFVaTVDT1FtcEJOWDkxd1BKTDZvZkZ3K2ZvYUZpOXE5b1dpNDBs?=
 =?utf-8?B?b0FhWUpsNHBsTjVYUVJCK2todkV1SU1qUWZrUUpZWms1R3pvcjliQ0UxOXdQ?=
 =?utf-8?B?bHJ0QkQ3QU1wOVdNVi9BQTdVeURIU0Jud09xdzZxWWx5R2RSUFE2VTM1bTA1?=
 =?utf-8?Q?yAfFSNp8f6RhjjVJuXyEvUCDM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94269348-8a13-4b70-96fd-08dc968fc7ca
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 09:59:05.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpbSr9FaMDliw5SKcgIlGcSbimQk8pnSWcQDrYtYSaxdYcQABJ/4j6jr0lYb5LR9XQRRdJ+eyG4H3fegXf12JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5946


On 27/06/2024 10:49, Christoph Hellwig wrote:
> On Thu, Jun 27, 2024 at 10:43:24AM +0100, Jon Hunter wrote:
>> We have just noticed that since Linux v6.9 was released, that if we
>> build the kernel with 64kB MMU pages, then we see the following WARNING
>> and probe failure ...
> 
> The old code upgraded the limits to the PAGE_SIZE for this case after
> issunig a warning.  Your driver probably incorrectly advertised the
> lower max_segment_size.  Try setting it to 64k.  I would have sent you
> a patch for that, but I can't see what mmc host driver you are using.


We are using the sdhci-tegra.c driver. I don't see it set in there, but 
I see references to max_seg_size in the main sdhci.c driver.

Thanks,
Jon

-- 
nvpublic

