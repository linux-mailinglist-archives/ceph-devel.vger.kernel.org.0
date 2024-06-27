Return-Path: <ceph-devel+bounces-1503-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0909191A2DC
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2024 11:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50C9DB22846
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2024 09:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4A013B299;
	Thu, 27 Jun 2024 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d98McC9y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A765713A3FC;
	Thu, 27 Jun 2024 09:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481419; cv=fail; b=hh5quqsffn2PtYGyRTgTpvH4WFMYyKIm1RigJ+qsS9DIEP+r59RZpFEcicgYjRhBSYcXXGL6YujJepnoJK9Cr8N1ljR/g7ZM8takV4Fw7rXDzBp0CHBcrW+H8JXiHUgACVDEx7wRLac3cGFkgrewENKwQGXYUb5F/dDBbIkXMzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481419; c=relaxed/simple;
	bh=2umv38My2dL+Z+jwfy3g8ZYdUu8ODZXEkLljCH5rJ9Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OBEhoVPQ4eNhiSX5ghoEkCc2wagVAlcK9F/EsdfuCW0dRufUdaFEZS19KjjE6As3akL+gctJkDPnOwxLKNvDXf+hu8xdewOFxX4UHl3nsZVG4cfGGEYR9l5D1T4dQeNML/dQuoHsE8H36TYeyqReDAj1IfNfoqKRS/U0tSfFQDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d98McC9y; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaWZm0BJCCiXnPRecsysUODFD9Gd8XgWvksdKpNHeT6hhY0w80WWR7a1YXbQE6lCRdNW8MWRLHETlF4iPf81u+9tSKjGJPyLNxT6m3jLTWD0xIIWJNXiXdUK30+FiCWqIhczhUChISkJOKLx+08b5T1EH3yxnSyNe35EaPLFkGZdWP7+lY6jhI0pYajz/Z/3C4+lIpIUur3Lr3mnri1BhCLkB5rGUiXQmqTiuUomp7iXJ4QDFR8KYh5axImPivwOpTNRQJiH2dOSt/jhmg48NYtvSSB3OnGoIcS+tofZ1K5CoLMUKQZdlSYoFun/Cj7tQ6CvtEYXDgsbuoIKJ0L2VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KtCdMbmTrzCFGfsgkJHjfDOFMJ07xOnbRbzbNslhCY=;
 b=a/3TEaej49mRcl+XMf8irtuccs85dH0XHSory/2Pyrr3NfST+w8nECWHAmAPNWCs2O+U1IS/5jlyWRQYOQKYr62RKUmEY93W9Ec+06+TrOLmxWyoeCg0rAnOivdJmHprzJ16MnY5YZrB4qiinUUyPX1aN1dE1pmSKXQgA23EvFyEnnhzzNxGrDBF3bkjsRyYUbSmcLf4YaRQBQw+OyDvObqTlhNtu0BkH2DOi8rw0Cl7LasNcsyvLOlS3Ro4xauKVu7N9Vpq4/WGbkjSA0W1Yhyk9iWksK1baQJ/Ov8XQHvDAHeQbrN5e3tZQbnCgLpi7ZIJM01n52+eGp1HRCAfPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KtCdMbmTrzCFGfsgkJHjfDOFMJ07xOnbRbzbNslhCY=;
 b=d98McC9yCkwCb1ZidyvYIMUvdJle0WGGTuX+6BrN2d3RPXVdWjOJUB7PjJYySyOOMu0YPrKXIoXxdhrWufURJGdll8l/j1hidyVAVSEVZ9snyEUb2mjlXDUsZKVKVgyu2Vnq16FSPiifz+B60u3shFzS+qVvnj1NOsrkrUla2rw/PHDN+zEX1FKmrCqezFw+h4EUM/A/yUOjlYSZikQZY2h7UYzo3ArTqJBpnNt6rTih1Pk+6ZJsoBoaIeKqaSrJfc/doDHdVw3PKgZmgc3W7hu308FsyrYscUcSblD8u4GSa74m1kbU3QZykKN3Sosi4LufcOy6FdafzzY+54Z7Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS0PR12MB7925.namprd12.prod.outlook.com (2603:10b6:8:14b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.32; Thu, 27 Jun 2024 09:43:33 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%6]) with mapi id 15.20.7719.022; Thu, 27 Jun 2024
 09:43:32 +0000
Message-ID: <89164197-7218-4f24-bf24-0e67a1882c78@nvidia.com>
Date: Thu, 27 Jun 2024 10:43:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] mmc: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>,
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
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20240215070300.2200308-18-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0497.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::22) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DS0PR12MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: cc02202a-0ef5-416d-261d-08dc968d9b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFY1cjBSTGtHUlIzYm03b2FldUFkNTRuaTZicUR3ZnkvTHUxMlRWWW1xYjYx?=
 =?utf-8?B?RUc5Nk4zYTczWm5ER21pdmI5Tk5zWFpUMGdvVDNad0ZzcFd0dnlhL0NpNDZ6?=
 =?utf-8?B?N2xyQUpnZjhmLytCVnNZWVZyd1FKSEdiSldaY29uSXU2cm9Mb0tXcmFNWTJl?=
 =?utf-8?B?a0hBaVNWa3dnV2VKdE1pNndYYW5GQ2QxMm9ZblphZU5ianRuZFEremNlNmxp?=
 =?utf-8?B?V2RsWkhSVEs2M0NEOGNqRkdjK1VCVVJxbW1KMk9zcWtlUHgvdmMyc0NiWmVY?=
 =?utf-8?B?NmFkWjdFRXhjOEhEYUErSkVrN3lUN1RLNTNHcHdETlltaHlzUzZVNG9ic2pM?=
 =?utf-8?B?Q3QyVjRoUlpVdmhKTFFqZmk1VTNpVkxXbVFYMjFmVkRmU0Zwa0I0aXVENzVO?=
 =?utf-8?B?TmJFckFjUmg2UFp3UXJJNUlkQkw5Q3pkdHF0MTl6c28vdTZvdGJKTjRMYWho?=
 =?utf-8?B?R3hrbnJ2Y3VCRmpNWjRDbTQvc3lSK1ltbU9aZEo2N1JMSE50aTZrYUdjY1hh?=
 =?utf-8?B?U0d2OTJkWlNucWFndElOdTk5TlJjenZWMHoyNHo4QnJZS0dOMVF2aWg1MHRh?=
 =?utf-8?B?Q3hxaVpwalgzZ1QxWG1EaHNTU21RT2FKYUZZSHREbGhvUWVJMEQ0dWliVmV4?=
 =?utf-8?B?WlRKTmk0ME5SeGVINStJWnJIMnkwb2x2dXNiS0hkMmJDRy84WXRTL3dwbldy?=
 =?utf-8?B?T24zaVdnQUM0aDkwNlJSSys2eW55RjlKMjFmV21xNVJwMW1JYkswamhxL2Jx?=
 =?utf-8?B?c2VkTXhuQ2RiTlBoOXIwQzM5TjZRdVl3SVJOaG1hUzhFRWJraHlPdVc5TmNq?=
 =?utf-8?B?aURtR1pjVDBWdXFHZjFXRDd0R0s2dFA4aVlVUUo3NWY1ck9MYUh5czVRcHMr?=
 =?utf-8?B?Qjh5V0g5eDJubTdvd0JJYkc4dUdkOWpmL3l0OGRJajVsYnIzeUlIRVlVLzRo?=
 =?utf-8?B?RFlGbkdVOXg2cjFqR2RFa2hoUjVRWGNXZTF0Ni9Gdm5tdUNzT1ZGTGJzejFa?=
 =?utf-8?B?UnZwSEgzTElsdnpNeUlGMFBaNVp4MXJiWGtCV3hUQXZTVnpvdDJPTitnWGND?=
 =?utf-8?B?NnJwMGV3a3hmK3Z0N2hvTFBlZ0RDbHpZR1dNU3RNZ3dZZTBUUmpjR1JIWXha?=
 =?utf-8?B?YVZpelVUK3JRNXdUV05hRlhiUTlLdG9TUWd1ZWd2RUw1WnJjRzhZNkU1MVRS?=
 =?utf-8?B?bDRYai9HNEpjSWZ5RmZFS3RNSm92b21pY2VIeE9uRHNPcWFmZ3lTZld1T3FW?=
 =?utf-8?B?TWZuUDFrUHVMODZheFFXMFRpR0E3T2Vhb0MwOWpac2pYZEQ0bjNPM0kzVlF3?=
 =?utf-8?B?Q2F6QzZJVzlzUThDR0hSL2U2VjFkMitOL3l5dGRRam9PNENRYThBc0E1dDdC?=
 =?utf-8?B?aGcxLzVnTlVrVWI1Y1B3Sm1TbEdxaXRaTnl3OVd4VXVnZHcyQ0RVUlVDYkdH?=
 =?utf-8?B?d2ozdUpzaDRRV2JYSEFoZktFeTRjQVdBZ0xTMFBGZWthdURaaXpyTkpjRUli?=
 =?utf-8?B?U21OeTM1aCtKMkw2bVUxM1JGS2xMNVZqTU8vdk9VRkZZZnFsOU51LzlIdW15?=
 =?utf-8?B?QkVYMCtJS3ZMRldpMGh6dkphZ2w0WjJha0pkR1pkZ28rS0pGeXdCTnU3OTcr?=
 =?utf-8?B?MjFVcmhZZStDU0laK3h6UExmcWtVb3V2b1hBRUVMWEc4VS9TRFBwSGREQkly?=
 =?utf-8?B?UkJVL3F6SGpveHRXd1lZNldJMkJ6UUtReUZaNkc1YzRlZk5vUm9zV3pqK2JH?=
 =?utf-8?B?ZWx2RVlwT3BJYzlIZXRub0MrWWpucnJVdnNJM2cvNVFoMlVUOE5GK0QvVW5V?=
 =?utf-8?Q?Bku+Oa6SYEX9FIDJa8HotuxtttmqHyEkSoPhg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUpaVWxRbU1xMDd5M1QreVZJbTRiSmt1bHlpSGVacHEvRnlwTDNKSzVYSHlY?=
 =?utf-8?B?N2lIMGlvK0tZQnp4aTg2eTBYcllUd1h3UWUzSytMbFpRTUdTYnFHdGVMVTF0?=
 =?utf-8?B?N0FHYzdabjJRekI4aEJObmpaL3ZLSlQ1dG40ZjVFYkNMYWtpRzd4VGtxdjlU?=
 =?utf-8?B?WWszYUgrY3FXNlg0aWc5WFhnYlZIU0F1WWhjTU5XdnVQL0c2eXNiZVlpeFdQ?=
 =?utf-8?B?MzYzUktqci80MVdlcDNDS2FkUjU1VnNGUWhGdzgrMmFtSWU5TkFRMkZrUTNp?=
 =?utf-8?B?aktNTXdOUmQ0cXA5WWdpc29kZnBod2JySFo3dERvZzJtNGtyZlNvQzBGNUpW?=
 =?utf-8?B?QXpvdlJtOTJoMkVQUlFFOG9JVE1YaEJKMkpXVHE2NWRwREM1SzNDYlBnYklN?=
 =?utf-8?B?TXNLOW1xYVdDV1pjNHFvc0FUOXoyN3ZONmpSdXhFQTVySWI4ZEVNdzhneVNj?=
 =?utf-8?B?cFB1dzN0SVlKS0k4SDRzQTFCbFlITnRMWm5NY0orMzJzWm1EU1BTR0FYOVgv?=
 =?utf-8?B?M255cTNhUUdFS3I5ZHc4ckNEc1NsQUlNSExMd3N4c1FOdGlDamNVNjJ5U08x?=
 =?utf-8?B?aTIyOHQ3Qi94N3RueWtaUUVLNmF2SmdoMGdzMGROQWx6Rm93RXdpam1VWGdB?=
 =?utf-8?B?NXY5S3dCaEtiN01IUGRmOEVPd0wxQ2o4ZURlVk5Id2QwZFRlYi9DVnd5SVNu?=
 =?utf-8?B?dmlja2wrWXliSGtXSjhwUlB6MlpJTFUzRjVqRGNwUGY2czdJWm1rVjhPa3VL?=
 =?utf-8?B?M0NUdE93OFZQblBWdW5RczdJVFhRMEVBSTZDQTBNbnFBNXpMdndnY3VMbTFw?=
 =?utf-8?B?bElLMEpGMEdVcDJtZ2hGeWhvYkx2ZzArSVM4Y0lKckVHb3hrQnlEbEdsOEFB?=
 =?utf-8?B?UnpvQkNxbkZjaE1VcDZwdEJQZy84ZEZxV2VmeGhkMmxYWVlGN1ozcGdpR3Qw?=
 =?utf-8?B?RkRvT3JEeXhETE5ub2piaGlQUGV3S25veC9aakdwc285bDI5dXVjVUo2V2tu?=
 =?utf-8?B?RG14TnYxSTB2NnNuMDh2Y1JGbDZHMjdQa2xaWXhmQ1o4SlE1Q1hXYkRNbTNh?=
 =?utf-8?B?bEF6aTlScG1sZkdCUjNBWFN6OVVsTTVyRTYxd25VRjV6RUJqRlpyU3JrNHVX?=
 =?utf-8?B?L2tVbXdicTE4M1lzTysrbFRjZ0dPcE9XY3pxL0tjc2dDV1ZlaWxkUmJsOVha?=
 =?utf-8?B?U2h3U2hvM1NPSTE3RmF0dXRPMHFIY2crU2JiVWM1VStkMzNhbko5MFZ3V0t3?=
 =?utf-8?B?TXpIVDI0emthdEIzMWYwMHA5MTJwZ3ZvNW9WdmlVYnJtZmZudHpacVVRT3Fy?=
 =?utf-8?B?aFZjOEJHeXp5THZtcTBmbHp5SVBuSG9oaEdRMzM3VXVBQUtCWUc4NHJmaW1j?=
 =?utf-8?B?d1V4VGpZK3V5Z3lNclBTVFpnRGR4OW9oREFhanZaZHNPbEovTmxDZTlGcEdk?=
 =?utf-8?B?TEQvQWFhV2EwQlJFMUU0NUpBVWxWOEpQWVBkSTVTU0RLd1dDSXBFaUxhMjBu?=
 =?utf-8?B?VmJubFE1cnFaQnhmNnBmKzRuSGw4QlYxejFCOU9iN3BxQ0tyRkVpNThYMDZi?=
 =?utf-8?B?d3hYRnUrc1hlTmtMODFDaGE3Y1VFazEzZHExYUwySFRvUHRIU0prem9BNStD?=
 =?utf-8?B?TitreGM1MUhVamNTVGE4M0FYekQ1dlhXRVpHSW5MN2FRdnFteTV6SUt2QW1a?=
 =?utf-8?B?UXZVdEd1Wm42cC9RTU9tbnFucUtaUW9RSXYzSDB6d3RLTVBVcDR5S0ozV2xR?=
 =?utf-8?B?VWtIREF3d0t2V1MzNm02Q1NybDlDd1FDNVoyMUVSMlBHRngyZXp5ckpiYXpU?=
 =?utf-8?B?cEUzSjVKWmFKU21sTmN6Y0swS2l3UHlyU0lNTndHN3BsTDhOMU1UcXJ3SEpZ?=
 =?utf-8?B?SlRPVUViSytqWHlmNTdOYXQ1WFZnMzg3VVdHWUg3OFovdkpDKy9mL2s1RU9M?=
 =?utf-8?B?TnJtMXM3Snc2Mlp6UStWYXVCcDBWa2sxZ0paWEFBMWtTajUwc0lEWXJnVjgr?=
 =?utf-8?B?RHpJMXdiWDJlUVlyT3hzVUp3S2h1VUxNTFhrOG5aY2Rxby9kOFRzZUl0NlNm?=
 =?utf-8?B?UGNjY05qTmVUSmNORndRVjBsQ3E2L2txdnZ2bzJmTmtObmZHMlhEUmRNamZK?=
 =?utf-8?Q?krMZmWoQcgz/FAC/DYLyNv0Iy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc02202a-0ef5-416d-261d-08dc968d9b86
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 09:43:32.6093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4Wr+zUeRHh3J2FZq/EMtxNpPtl23z5dMtMLtAdGVHKAUxyeX4Hff2xa1aYA+Ka8u0Y56quh1vwW4TnQDKdu/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7925

Hi Christoph,

On 15/02/2024 07:03, Christoph Hellwig wrote:
> Pass the queue limit set at initialization time directly to
> blk_mq_alloc_disk instead of updating it right after the allocation.
> 
> This requires refactoring the code a bit so that what was mmc_setup_queue
> before also allocates the gendisk now and actually sets all limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/mmc/core/queue.c | 97 +++++++++++++++++++++-------------------
>   1 file changed, 52 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index 67ad186d132a69..2ae60d208cdf1e 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -174,8 +174,8 @@ static struct scatterlist *mmc_alloc_sg(unsigned short sg_len, gfp_t gfp)
>   	return sg;
>   }
>   
> -static void mmc_queue_setup_discard(struct request_queue *q,
> -				    struct mmc_card *card)
> +static void mmc_queue_setup_discard(struct mmc_card *card,
> +		struct queue_limits *lim)
>   {
>   	unsigned max_discard;
>   
> @@ -183,15 +183,17 @@ static void mmc_queue_setup_discard(struct request_queue *q,
>   	if (!max_discard)
>   		return;
>   
> -	blk_queue_max_discard_sectors(q, max_discard);
> -	q->limits.discard_granularity = card->pref_erase << 9;
> -	/* granularity must not be greater than max. discard */
> -	if (card->pref_erase > max_discard)
> -		q->limits.discard_granularity = SECTOR_SIZE;
> +	lim->max_hw_discard_sectors = max_discard;
>   	if (mmc_can_secure_erase_trim(card))
> -		blk_queue_max_secure_erase_sectors(q, max_discard);
> +		lim->max_secure_erase_sectors = max_discard;
>   	if (mmc_can_trim(card) && card->erased_byte == 0)
> -		blk_queue_max_write_zeroes_sectors(q, max_discard);
> +		lim->max_write_zeroes_sectors = max_discard;
> +
> +	/* granularity must not be greater than max. discard */
> +	if (card->pref_erase > max_discard)
> +		lim->discard_granularity = SECTOR_SIZE;
> +	else
> +		lim->discard_granularity = card->pref_erase << 9;
>   }
>   
>   static unsigned short mmc_get_max_segments(struct mmc_host *host)
> @@ -341,40 +343,53 @@ static const struct blk_mq_ops mmc_mq_ops = {
>   	.timeout	= mmc_mq_timed_out,
>   };
>   
> -static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
> +static struct gendisk *mmc_alloc_disk(struct mmc_queue *mq,
> +		struct mmc_card *card)
>   {
>   	struct mmc_host *host = card->host;
> -	unsigned block_size = 512;
> +	struct queue_limits lim = { };
> +	struct gendisk *disk;
>   
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, mq->queue);
> -	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
>   	if (mmc_can_erase(card))
> -		mmc_queue_setup_discard(mq->queue, card);
> +		mmc_queue_setup_discard(card, &lim);
>   
>   	if (!mmc_dev(host)->dma_mask || !*mmc_dev(host)->dma_mask)
> -		blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_HIGH);
> -	blk_queue_max_hw_sectors(mq->queue,
> -		min(host->max_blk_count, host->max_req_size / 512));
> -	if (host->can_dma_map_merge)
> -		WARN(!blk_queue_can_use_dma_map_merging(mq->queue,
> -							mmc_dev(host)),
> -		     "merging was advertised but not possible");
> -	blk_queue_max_segments(mq->queue, mmc_get_max_segments(host));
> -
> -	if (mmc_card_mmc(card) && card->ext_csd.data_sector_size) {
> -		block_size = card->ext_csd.data_sector_size;
> -		WARN_ON(block_size != 512 && block_size != 4096);
> -	}
> +		lim.bounce = BLK_BOUNCE_HIGH;
> +
> +	lim.max_hw_sectors = min(host->max_blk_count, host->max_req_size / 512);
> +
> +	if (mmc_card_mmc(card) && card->ext_csd.data_sector_size)
> +		lim.logical_block_size = card->ext_csd.data_sector_size;
> +	else
> +		lim.logical_block_size = 512;
> +
> +	WARN_ON_ONCE(lim.logical_block_size != 512 &&
> +		     lim.logical_block_size != 4096);
>   
> -	blk_queue_logical_block_size(mq->queue, block_size);
>   	/*
> -	 * After blk_queue_can_use_dma_map_merging() was called with succeed,
> -	 * since it calls blk_queue_virt_boundary(), the mmc should not call
> -	 * both blk_queue_max_segment_size().
> +	 * Setting a virt_boundary implicity sets a max_segment_size, so try
> +	 * to set the hardware one here.
>   	 */
> -	if (!host->can_dma_map_merge)
> -		blk_queue_max_segment_size(mq->queue,
> -			round_down(host->max_seg_size, block_size));
> +	if (host->can_dma_map_merge) {
> +		lim.virt_boundary_mask = dma_get_merge_boundary(mmc_dev(host));
> +		lim.max_segments = MMC_DMA_MAP_MERGE_SEGMENTS;
> +	} else {
> +		lim.max_segment_size =
> +			round_down(host->max_seg_size, lim.logical_block_size);
> +		lim.max_segments = host->max_segs;
> +	}
> +
> +	disk = blk_mq_alloc_disk(&mq->tag_set, &lim, mq);
> +	if (IS_ERR(disk))
> +		return disk;
> +	mq->queue = disk->queue;
> +
> +	if (mmc_host_is_spi(host) && host->use_spi_crc)
> +		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, mq->queue);
> +	blk_queue_rq_timeout(mq->queue, 60 * HZ);
> +
> +	blk_queue_flag_set(QUEUE_FLAG_NONROT, mq->queue);
> +	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
>   
>   	dma_set_max_seg_size(mmc_dev(host), queue_max_segment_size(mq->queue));
>   
> @@ -386,6 +401,7 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
>   	init_waitqueue_head(&mq->wait);
>   
>   	mmc_crypto_setup_queue(mq->queue, host);
> +	return disk;
>   }
>   
>   static inline bool mmc_merge_capable(struct mmc_host *host)
> @@ -447,18 +463,9 @@ struct gendisk *mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card)
>   		return ERR_PTR(ret);
>   		
>   
> -	disk = blk_mq_alloc_disk(&mq->tag_set, NULL, mq);
> -	if (IS_ERR(disk)) {
> +	disk = mmc_alloc_disk(mq, card);
> +	if (IS_ERR(disk))
>   		blk_mq_free_tag_set(&mq->tag_set);
> -		return disk;
> -	}
> -	mq->queue = disk->queue;
> -
> -	if (mmc_host_is_spi(host) && host->use_spi_crc)
> -		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, mq->queue);
> -	blk_queue_rq_timeout(mq->queue, 60 * HZ);
> -
> -	mmc_setup_queue(mq, card);
>   	return disk;
>   }
>   


We have just noticed that since Linux v6.9 was released, that if we
build the kernel with 64kB MMU pages, then we see the following WARNING
and probe failure ...

[    2.828612] ------------[ cut here ]------------
[    2.829243] WARNING: CPU: 1 PID: 87 at block/blk-settings.c:206 blk_validate_limits+0x1cc/0x234
[    2.830417] Modules linked in:
[    2.830963] CPU: 1 PID: 87 Comm: kworker/1:1 Not tainted 6.10.0-rc5 #1
[    2.831773] Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
[    2.832538] Workqueue: events_freezable mmc_rescan
[    2.833341] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.834263] pc : blk_validate_limits+0x1cc/0x234
[    2.834927] lr : blk_set_default_limits+0x18/0x24
[    2.835654] sp : ffff800084c4f730
[    2.836161] x29: ffff800084c4f730 x28: 0000000000000000 x27: 0000000000000000
[    2.837448] x26: 0000000000000000 x25: ffff000084130008 x24: 00000000ffffffff
[    2.838607] x23: ffff800082d84000 x22: ffff8000828b79c8 x21: ffff800084c4f8b8
[    2.839754] x20: 0000000000000008 x19: ffff000084170000 x18: 0000000000000000
[    2.840831] x17: 00000000900163fe x16: 000000008802ed71 x15: 00000000000003e8
[    2.842228] x14: 0000000000000002 x13: 00000000000372ef x12: 0000000000002bb0
[    2.843536] x11: 0000000000000000 x10: 0000000000004400 x9 : 0000000000000000
[    2.847832] x8 : ffff0000841703a0 x7 : 0000000000000000 x6 : 0000000000000003
[    2.855075] x5 : ffff000081279e00 x4 : 0000000000000000 x3 : 0000000000000200
[    2.862140] x2 : 000000000000ffff x1 : 000000000000fe00 x0 : ffff800084c4f8b8
[    2.869633] Call trace:
[    2.872055]  blk_validate_limits+0x1cc/0x234
[    2.876278]  blk_alloc_queue+0x7c/0x260
[    2.880038]  blk_mq_alloc_queue+0x54/0xbc
[    2.884504]  __blk_mq_alloc_disk+0x20/0x190
[    2.888266]  mmc_alloc_disk+0xbc/0x250
[    2.892062]  mmc_init_queue+0xe8/0x114
[    2.896091]  mmc_blk_alloc_req+0xb4/0x374
[    2.900237]  mmc_blk_probe+0x1d4/0x650
[    2.904194]  mmc_bus_probe+0x20/0x2c
[    2.907434]  really_probe+0xbc/0x2a4
[    2.911391]  __driver_probe_device+0x78/0x12c
[    2.915627]  driver_probe_device+0x40/0x160
[    2.919587]  __device_attach_driver+0xb8/0x134
[    2.923881]  bus_for_each_drv+0x80/0xdc
[    2.927664]  __device_attach+0xa8/0x1b0
[    2.931578]  device_initial_probe+0x14/0x20
[    2.935845]  bus_probe_device+0xa8/0xac
[    2.939606]  device_add+0x590/0x754
[    2.942864]  mmc_add_card+0x238/0x2dc
[    2.946691]  mmc_attach_mmc+0x12c/0x174
[    2.950494]  mmc_rescan+0x27c/0x318
[    2.954172]  process_one_work+0x154/0x298
[    2.957919]  worker_thread+0x304/0x408
[    2.961931]  kthread+0x118/0x11c
[    2.965187]  ret_from_fork+0x10/0x20
[    2.968835] ---[ end trace 0000000000000000 ]---
[    2.974440] mmcblk mmc0:0001: probe with driver mmcblk failed with error -22


Bisect points to this commit. This is very similar to the issue Geert
reported [0] but we are still seeing this on the latest mainline with
v6.10-rc5. When building with 4kB MMU pages we don't see this issue
when testing on the same hardware. Let me know if you have any
thoughts?

Thanks
Jon

[0] https://lore.kernel.org/linux-mmc/CAMuHMdWV4nWQHUpBKM2gHWeH9j9c0Di4bhg+F4-SAPEAmZuNSA@mail.gmail.com/
-- 
nvpublic

