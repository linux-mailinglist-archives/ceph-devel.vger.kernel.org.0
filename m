Return-Path: <ceph-devel+bounces-4251-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67197CF59F6
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 22:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87CC430C901E
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 21:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E802DCC04;
	Mon,  5 Jan 2026 21:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DOLXxm0h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9A72DCBFD;
	Mon,  5 Jan 2026 21:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647373; cv=fail; b=UUGdMQYtFv5Y6tjpHqa5piNGiSivaACzoBY75jUczYrcEZdeCNdBLPYJ6u8lIYL+CEvfSdK7W6ZswenQL8W/oEUwmaX9OsQCB+wclXWAhxB9368SUZIuCxVnPIeAiBw92sFAtCpJyaTyrlGgjA2q3gMQv2KNgjJDYCTJniwjwdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647373; c=relaxed/simple;
	bh=I7r+LU7e6VHQd1YFOERt6o5KfmrHMzCuQKVQRx1Pxc0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=JUO3arz5GsiNz6JZ1wzD9YovpZD3KM93JLYRPsfBsqYCmFwcH55J9Xx3TgnQfKOiGuUeQqdS7QkfA3xmKDWJsRFeMOu2RXSMQG/PU8rBGd6YhOjuoAGkOsU8GV8qDAnJavNUlexwJRNLS+Ojpn+mKsXy5FP24GudNvP+0Hmf/sM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DOLXxm0h; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605DXZLN017348;
	Mon, 5 Jan 2026 21:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=I7r+LU7e6VHQd1YFOERt6o5KfmrHMzCuQKVQRx1Pxc0=; b=DOLXxm0h
	T6Chcqs/Hacx7XaUklF0ojuDE77dwQH/yEWHTRXLMikxRZol7kruvXliIXpPuaKV
	xrpOpEQL7t24tjuoFTDGjqck1oT2omqBj3vM5+5zEC+l2KBDokJ2mk9Vrg6Cy/J3
	ynO4HcW7RJ1c8OuCQ23VAUazfMOTj+qoDi45hrU7b76DNbEvt0P25gBVGYnROSEz
	ywR7YFRgd1q5cb4IGOmm+pSVN4VmAiSe6fNd+dqw9FS5ekNbQwMfK+dW8xlI/0z0
	Pj7j4X31+uIOGEpSvfc9PMbLYxDH8ceJQbQa+X0sQ+JRSN2DG431FH8Vqwqdv1NZ
	JHvNZZZlCXbPFw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betrtgh7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 21:09:20 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605L9GbP007482;
	Mon, 5 Jan 2026 21:09:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betrtgh79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 21:09:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QcPkF1pHQYr2vUBxfqa5HK0DPVrO4qwuyaFkvY1pIBaOqba7NbzaC/VzvUM9Woce07k2MFsIHsksFnOlfs4Icrex6X6pf+QyFUoGs1fGCT/u3k5XpXR5tFktoIa+lVex00tr5jNZXaPmCZC9z/Vhk8yEqn6HvL0N39uD/LnPi/DnpJ4RxhyH50Te1ONWuRTEDaCns9LXssrposCm62ia7vjO/SBUJ6WJsHWE2XMrUyKhihAnExAN3QsInr+tf+SLoCGbr8gnp+028qXiwT3jRCO2eIyk3aqjq/uGJQwpbqhofZi8ZW94aBTsC6w/Z1JgfmqC+FUDPs8JmMpPiChlrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7r+LU7e6VHQd1YFOERt6o5KfmrHMzCuQKVQRx1Pxc0=;
 b=UlIBdRvpNVS5Vs+rg0gcc+MR8EZQrycIH+0I+uo0ncwQfemqmaDZtn5/4fYiYB4t0de+OdF1yuKYLB7DaQpYFXTGqoigPt9H+WFmGTOaaIDZWcc5KZUFNlH3jnwoxP47u9gmfoCNmG54sluAHbgvgKVhpvsfRskJmjNyglvCawP+vlyu5L6Q96Iom9sdCxPQ1R2hkT5yacmraKajJXa/YdxuNch1D2zwgRfRRzbasPgg/xsuBJ5FCTZQd6bkTfS2vl/UO1ksZnaGVLfK1Af90AweoYqAvdbYImz8i5uutw8SU6Xvm72UG0nJJ6CZaWAl3GXXSMhaNHPSYz8DuuwZsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH3PPF2A279F156.namprd15.prod.outlook.com (2603:10b6:518:1::490) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 21:09:17 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 21:09:17 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 3/5] ceph: Free page array when
 ceph_submit_write fails
Thread-Index: AQHcegDvFhdtGOcvyUSWi1lFhUYcG7VEGxiA
Date: Mon, 5 Jan 2026 21:09:17 +0000
Message-ID: <90190adb0e384d4d9d451d444c46f177bb95366d.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-4-CFSworks@gmail.com>
In-Reply-To: <20251231024316.4643-4-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH3PPF2A279F156:EE_
x-ms-office365-filtering-correlation-id: d6f517f2-cedd-423d-5307-08de4c9eb03d
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?di9RbnU5bnN4YmRJeGRkMjUzQU9ZT29mMU1sUzd3d3NBMnh2VUZyTllXdnlX?=
 =?utf-8?B?L1FIWjFIRWtNQVM4eUtrN3loM25pNlo4UmhSbldaVGU3cFQ1K1RKb3haN1Nh?=
 =?utf-8?B?YmVvTW5XdEZlbnhkQnN0T0R2RlAzZzNEWFl1NUVLRFRGeFFGUFFyaTZIUTBq?=
 =?utf-8?B?cmRwTHBzOW9LbFRvTk84b2RNbTBXUkprcm1xdWVwamR6OStVSHljMmRTaXRk?=
 =?utf-8?B?YzNGZktEaHM5dWdRc2hEWkFVNjVNZ3VHaVdzMG5qdjh6RVhwYXNjVjg5NXE3?=
 =?utf-8?B?ZW9hUWxvMG1rNnNJbUxIa29sczdEc1VSYkhmOWpQeHQ5eWlBUHg3TG9XL0d0?=
 =?utf-8?B?aVpYZjFLZjE0RUpVbjMzZDJBSmRzSEh1NG5nQUN3d1VmaVk3emVTajdWeFA0?=
 =?utf-8?B?MzJyQThvUEs1MzluVFRKekRyZW1BOXRGejE4V3ZHZWlhVS92QmduMzk4aGFn?=
 =?utf-8?B?NkxOZ0ZQRFJ3WUdTMVg5UXc3L05hR1Zmd1FyRjA2REZYbi92SXRQNTRSMlZt?=
 =?utf-8?B?TVNNbU4zOFlIK2NNTDlLK05IZCttRC9MbHVpUTNxby9jb0pHTnJyVmx2UnEz?=
 =?utf-8?B?YUhnS0dxQllXNmVGU000a01FM2VUK2pqWlgvQU5sMjdKM2p6STZsb3NremxM?=
 =?utf-8?B?RGhhOFRKSHdldUFmREYzbjlyNm5kZUZHVTBHSlk3cU5wVXNqWkp4M081V3Fk?=
 =?utf-8?B?ZDlCZGV5eXhCSTdWU3ZjUExUcVZGRHJTTUhiQTRpc1FhRCs5OTAvNjducDZx?=
 =?utf-8?B?cWxRaW1aaFU3Q3hxK25kemZnM1lJWUo1TXBzbDUwdUVDS2VRVHg0czJ2VHQw?=
 =?utf-8?B?TlFVTUZ3RG10N1BpV1ZyREVRL3hNalE3WnVjdE9vNHZpS2tXaDBleHg3dHlX?=
 =?utf-8?B?SHM5eDdCRFRmQ1dxeUpYeXZjbTJLVDRhY3U3Vm5GVVpuQ0gyVDlNRk9ZNlZo?=
 =?utf-8?B?T2FuNENCV3ROTW54VjVTMlRMalFlMHpzQlBMRDBSSy83VHFQQndpbTZycmZJ?=
 =?utf-8?B?SHpoZDJ5ZnFtQ1dZOTNwUkRVcjNRM0RIRWNMS1QwZGFLL0dGYmNOTmxOWndV?=
 =?utf-8?B?cHg2R040ZGt0VlRtNXJ5elB2OHBZVVlNOVdITGR5SGFuUC9UL3JQQmZyREtM?=
 =?utf-8?B?S2MvRk5tMnN2c3J1dzZrMjFlaXdUTWR4VFRBTGlrNDBqUmI2VUdJZm81OFhQ?=
 =?utf-8?B?QnBxUi9PQ1BJd0NDNTM5bUVyUEhhd2J2NVMrZGdkUnc1QVFMZHVieUpmL3VL?=
 =?utf-8?B?amIxeVkwZjBMN2hsRVdkRzYwYW82VUdjV1k0UEtnMHdZaFVQVTBmNVNJbGxk?=
 =?utf-8?B?aFlxV1A1MVFTcEM5VEhXL0dKYmRPOWl3cS81R3hxTUNvSXFPKzZvVWxiVTQx?=
 =?utf-8?B?dXNIWnoyS3UyNTF0cmZ6Rk1uVFN5U2RhQ3hUWUlrdnhzYmcrYUVIMk5XQlJB?=
 =?utf-8?B?ckhGTG9jUkhHdnB4ZUEreERFYkEwcXhkY3dHUjFtUnkyZk9Sb1JQUHdKV0Nj?=
 =?utf-8?B?S1RsQXZEbFBLcS9qT0xwWUROZUlaZTV4MDI1M0JoblA2dStLMmRudVBOYytu?=
 =?utf-8?B?TG9zU3p6YWhaRHkxVHlGNDh6VjlEaG5RYllCUmJGd2oxKy9oRXBmV2E1WThI?=
 =?utf-8?B?UzNQc21TUS9WSHVHYlJ6Qm9SWTRwMjRYdWRaNG1ML01HQ2NLcUlwRExCc2gr?=
 =?utf-8?B?Z01zSTEzTjIzcm1HVlZiTElaTEx4VjFYclNlMlVjbXExNDBpangrbmYxR01m?=
 =?utf-8?B?bkh6a2d2VitEeW1hbm82cGFzLzVHMHBNUytESjBiVkFsa0FFSXdXMjI0K3BE?=
 =?utf-8?B?L1NkSm9IZnJPQ0JXbVJadGEraHNnY0NvNnVBTjlpYzZLNFI2MEc0VXc2MzYv?=
 =?utf-8?B?d3liVUwwek9GMzM5MVN0c24vSS8ranZBU2tEL1B6VllLSlpzd3lxWTZIYmdw?=
 =?utf-8?B?cW1Hakc2RGdKdlVVbGREVjEydmhRZGl6bHZ2UjJSOFFHK2RPVzNDQVRpNE9H?=
 =?utf-8?B?NXArdnNBZFFLR0RXZHE2bVl1Unp6WDZ2bkN0bnlHTWlkNVloK0x6TVdySFg1?=
 =?utf-8?Q?sZb4+V?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RFBCN0RhNzNwcTFhNTZ0WG1rUGpTNGFDRnRzMDJUZGhWYXhLZWh0bEpQMnRw?=
 =?utf-8?B?TmFoZE5xckVYZWlyVFpzd2k4U1Qyd0V5TkM0bHZXWnNQOW1WeWNzdU1iTlFj?=
 =?utf-8?B?TlRKSTR0SDhPTFBVcU5XbDZ5S00wcDl5M0dRRFhWN2lac2pjVHlVZ3FQbXF1?=
 =?utf-8?B?S0ordTg3cy9zZ2dnanYxbW9wZ1JkWlJjS1RlZDl1enVicTZ4b1ZEN1pnYzF4?=
 =?utf-8?B?U21qSll0K2poSE1TOFN1VG5Rcm41N1pzYjI5MjlROHI4MVF5SGtmWFVrZVJY?=
 =?utf-8?B?M0lBV2JzM2JkNHdxVnA2bGdzVkpVOTZzeDNIemRuMzBYOEh0eGJQV2N0YlB4?=
 =?utf-8?B?aWJNZkFWWUtDOFl0eUxqK1dFM3VNSHZGVlRWVWQ4Y04zNkM2djFZa3dGSHNV?=
 =?utf-8?B?ek1hL2RZRVh6TnFDS0l4c2lPUFVWYlhDYXUyQkJNVjBNY3ZGeExpdDJOMjV0?=
 =?utf-8?B?cXhWU3ZuSG8xR0tQR2N5bU9oVEpsTDhxcmNwQk9QZVNDNlZ5amp4Y0hXakUv?=
 =?utf-8?B?SHl5ZnJmdXNSNzRGQXBzdEd6Y0VhOFJ6UzVBc2ZONEc4dHd0UG5sK0hrNkZl?=
 =?utf-8?B?RHhaUDEzS1dNQlNxbHFRUVEyVm12VU1IVDFzb3Fnd3BYaEVwTFhXTGt3dFZt?=
 =?utf-8?B?R3N0dnh5YkR4RDBNKzdlYUdaTmN3YnEwVU9sVW5zZmNHc0Z1VmwzS2I0dUpz?=
 =?utf-8?B?Z2hTWTBoaDBSc1MyZVFyT09KcXVWd3FhVlZXdTBIRmJJZHYwdUo4SUxodWNI?=
 =?utf-8?B?ZHRvL2lyZTlSbEdobHNtYTJEUHFjQ09YSFRnc2NBTnB5RUdaaml4MlJiOUJq?=
 =?utf-8?B?ZUZXMEJVaGVpZkNweTNIRTFPN3RNZkhaS3doQ215MWNTeSs3Y1pPa2FqWTlO?=
 =?utf-8?B?Y05CZ2tpVEtSamM0K1ArWHNMeTNDOGZsV25CQWsxWXlHbURnREJ3VUdXejFk?=
 =?utf-8?B?QzRkQTE1a2NSNHloTjhNQUJOOTduRDlPTGlYTWcvSEtGMXQ4NGhqSHdRYkJQ?=
 =?utf-8?B?NkNFbUV3TUpWZjV5S3lKTHZvd0hwU3hxelVoc20wSzZsSlloZktzbVJKUWhx?=
 =?utf-8?B?ZktXZ2JLYkRscGg5V3lsLzlCUGc4U2FWT1ZxUFFpV2JXL2xDUWptblFNN3Ur?=
 =?utf-8?B?RjZQTlF2bWVTZGZYWXBmaDdTTUhhcXFEYUJhNmZEallZOGJYUGpqcjNuaW1Z?=
 =?utf-8?B?UmRBUGhzRnprazZCOFBNcTBsMGJqRmt2K0xlNldUVFdUeFpIYUFRR3EzdnQ0?=
 =?utf-8?B?ZkM5NDJaTWFYcmIyUlR3UnRGWFdROUdGVGkvNC8wNHNqRlN6VnU5YWZTeFc5?=
 =?utf-8?B?R0pldVZ4WXFXWDBwUGl2VGVtbXZXeHZ1dU9ybG1zdEM2K0JCK1JQMUFlZTRx?=
 =?utf-8?B?NEFIKzIxd1Nlb25uVzFqYmpnRFBzb01LemNUSVBleVdPSGVObnFMZWMwZGhk?=
 =?utf-8?B?MWFEUCtnRjJPTHpzMHAxbkRMZCtNakd0K2wrNDFBZE9VRW1EYlR0b2NGQ0dl?=
 =?utf-8?B?d3c5bjFZaVNNa3V6dlNpN0htZkZpcHE2aTNyVEFxck42WEwxR1FNQ0tTWUtF?=
 =?utf-8?B?eFhzMUY0SjVXUlRIeFRvc2t5Z2htWmZpcFlxZXZ1TnZBbXp3K2RBNll1Zzdm?=
 =?utf-8?B?azFXNHNKeHlyK3l5cUFxdE94dEdzNURMdDV0b2s3N2R0L2NEbzJaL2V5VjNW?=
 =?utf-8?B?MU5hbTNQTDFIb1FxZTRXdTR6MjVFMXEyTWs2OHZSVklUWGRITUlpQUlZb2NI?=
 =?utf-8?B?WlFuTVBKeFFRZ1dlNk5FajVXUzBjQktoMG0wQWtMSTlGdDdpdllHVXVOWE5H?=
 =?utf-8?B?NW9WMlNxa1lGazFtb2VDSkdma2RnSW1PNlBYZGNqRWltWU54S1ZOREw2czhN?=
 =?utf-8?B?ODdaL3QrRDI4eW9oRlQ0VE1LL1orQWtpWCtlQ0FJS1BoaC9EQzFrZ0lyMFFM?=
 =?utf-8?B?ejQxakkvZDF3SkFMWHVUenpwcGYyU2FPZnNBL1dzdkh3Zk9ZMUUvYmoyWHZm?=
 =?utf-8?B?MGdCOXVUMis3b1Y4MUw1MytSOHVkOW1HQjRZV2pSWCt2eDZXRHRoSDhoZXBi?=
 =?utf-8?B?ai8rQitySXpLOCt2VVM5TXNtY1JYS1hmYzhqVlE0ZjN2WVRuWkZnMGNkM25Z?=
 =?utf-8?B?bmYreGxCNHN2ZzR1OHZydGR4a1RRZ3kxLzgrM2FoUWp5ZmtYejFrMTEvbUJZ?=
 =?utf-8?B?djJNandNYkN3K0dnQnM4OE1WU0JPY0tBaGRwV0wyMGo5c3pGbWFEaDNFLzJG?=
 =?utf-8?B?VTJ6SE9QUEgvQjFBTE94RU1oQ1VJckNYa3cwM3RjTkU2R2drTVFtUXBIR291?=
 =?utf-8?B?c2h0cGFwK1dERVpSdDVFR1ZwZXI1d0liQVQrNGhlUlBML3NUdG0xZ0hjTEYr?=
 =?utf-8?Q?oCa0Lx5RWTpxQU5SPIoDnfv5iASnYExaWXy9P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <196EF341A3FCAE4997B60EE7D4DDBA2F@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f517f2-cedd-423d-5307-08de4c9eb03d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 21:09:17.8117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FEk2xOkULpXvZLe7xbmbZZM8D4VjtpfhJGdCJiNRxTM5gea+KQuwJO6n/ZL/if1zt8lpF3jnv6RF6kExZ7b1AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2A279F156
X-Authority-Analysis: v=2.4 cv=aaJsXBot c=1 sm=1 tr=0 ts=695c2880 cx=c_pps
 a=n9MmWVbgKLYxIbvHr99TLw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=tQlTsIa2nFrKJPzxGjQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: h-hnKXemyQUcJDUIIRFI7KL-T3oaZ7fC
X-Proofpoint-ORIG-GUID: lPT0dbxJgQQrxwIx6tW6ADmaOPoX-gFf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE4MSBTYWx0ZWRfX5Me+1SUpxdgh
 4b6shaw5SiRdaqIfZqcrQKazbQuUn7DVnqOsMfsBb1Z4GbzS5U1pltcZeGHniHswTFoOVT2JC3l
 hjQT5e58iXGq0i6hkOH+Y0lJmKakbIX8nGQVYnrn/uUCoU9hJ7P9SDEw531asaL4akJUaGn1faY
 Z1w+nFrlLlO5HA7QLCvkCKrlgjO+wxX3UuhF7Hq9MarIzU/qoJI9OF3okHgepawc+POdKHRQ4Tg
 mO7UXVc9x374MqiQATXsPf7DsX3RVui7X7F9viUO0OSahIqdXm3l1i3pIBt4FTDeLt8mImjtqKE
 zHSaCbgM0D5AgA6itcFGssGglhYtGjzujZKlEgcatH5SBK5f69e5xubex61coldh6PiPEtUwDDI
 4Zf/Hqc9iwTCw+v0kCFNRLoDKNZnxs75fVVSgBM1Ep47Q9fDyoki0SWkUA2URSl02JP2PqSKa0U
 BcXfwacLhaNUdAgttsg==
Subject: Re:  [PATCH 3/5] ceph: Free page array when ceph_submit_write fails
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601050181

T24gVHVlLCAyMDI1LTEyLTMwIGF0IDE4OjQzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
SWYgYGxvY2tlZF9wYWdlc2AgaXMgemVybywgdGhlIHBhZ2UgYXJyYXkgbXVzdCBub3QgYmUgYWxs
b2NhdGVkOg0KPiBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goKSB1c2VzIGBsb2NrZWRfcGFnZXNg
IHRvIGRlY2lkZSB3aGVuIHRvDQo+IGFsbG9jYXRlIGBwYWdlc2AswqANCj4gDQoNCkkgZG9uJ3Qg
cXVpdGUgZm9sbG93IGhvdyB0aGlzIHN0YXRlbWVudCBpcyByZWxldmFudCB0byB0aGUgaXNzdWUu
IElmDQpgbG9ja2VkX3BhZ2VzYCBpcyB6ZXJvLCB0aGVuIGNlcGhfc3VibWl0X3dyaXRlKCkgd2ls
bCBub3QgdG8gYmUgY2FsbGVkLiBEbyBJDQptaXNzIHNvbWV0aGluZyBoZXJlPw0KDQo+IGFuZCBy
ZWR1bmRhbnQgYWxsb2NhdGlvbnMgdHJpZ2dlcg0KPiBjZXBoX2FsbG9jYXRlX3BhZ2VfYXJyYXko
KSdzIEJVR19PTigpLCByZXN1bHRpbmcgaW4gYSB3b3JrZXIgb29wcyAoYW5kDQo+IHdyaXRlYmFj
ayBzdGFsbCkgb3IgZXZlbiBhIGtlcm5lbCBwYW5pYy4gQ29uc2VxdWVudGx5LCB0aGUgbWFpbiBs
b29wIGluDQo+IGNlcGhfd3JpdGVwYWdlc19zdGFydCgpIGFzc3VtZXMgdGhhdCB0aGUgbGlmZXRp
bWUgb2YgYHBhZ2VzYCBpcyBjb25maW5lZA0KPiB0byBhIHNpbmdsZSBpdGVyYXRpb24uDQoNCkl0
IHdpbGwgYmUgZ3JlYXQgdG8gc2VlIHRoZSByZXByb2R1Y2VyIHNjcmlwdCBvciBhcHBsaWNhdGlv
biBhbmQgY2FsbCB0cmFjZSBvZg0KdGhlIGlzc3VlLiBDb3VsZCB5b3UgcGxlYXNlIHNoYXJlIHRo
ZSByZXByb2R1Y3Rpb24gcGF0aCBhbmQgdGhlIGNhbGwgdHJhY2Ugb2YNCnRoZSBpc3N1ZT8NCg0K
PiANCj4gVGhlIGNlcGhfc3VibWl0X3dyaXRlKCkgZnVuY3Rpb24gY2xhaW1zIG93bmVyc2hpcCBv
ZiB0aGUgcGFnZSBhcnJheSBvbg0KPiBzdWNjZXNzLsKgDQo+IA0KDQpBcyBmYXIgYXMgSSBjYW4g
c2VlLCB3cml0ZXBhZ2VzX2ZpbmlzaCgpIHNob3VsZCBmcmVlIHRoZSBwYWdlIGFycmF5IG9uIHN1
Y2Nlc3MuDQoNCj4gQnV0IGZhaWx1cmVzIG9ubHkgcmVkaXJ0eS91bmxvY2sgdGhlIHBhZ2VzIGFu
ZCBmYWlsIHRvIGZyZWUgdGhlDQo+IGFycmF5LCBtYWtpbmcgdGhlIGZhaWx1cmUgY2FzZSBpbiBj
ZXBoX3N1Ym1pdF93cml0ZSgpIGZhdGFsLg0KPiANCj4gRnJlZSB0aGUgcGFnZSBhcnJheSBpbiBj
ZXBoX3N1Ym1pdF93cml0ZSgpJ3MgZXJyb3ItaGFuZGxpbmcgJ2lmJyBibG9jaw0KPiBzbyB0aGF0
IHRoZSBjYWxsZXIncyBpbnZhcmlhbnQgKHRoYXQgdGhlIGFycmF5IGRvZXMgbm90IG91dGxpdmUg
dGhlDQo+IGl0ZXJhdGlvbikgaXMgbWFpbnRhaW5lZCB1bmNvbmRpdGlvbmFsbHksIGFsbG93aW5n
IGZhaWx1cmVzIGluDQo+IGNlcGhfc3VibWl0X3dyaXRlKCkgdG8gYmUgcmVjb3ZlcmFibGUgYXMg
b3JpZ2luYWxseSBpbnRlbmRlZC4NCj4gDQo+IEZpeGVzOiAxNTUxZWM2MWRjNTUgKCJjZXBoOiBp
bnRyb2R1Y2UgY2VwaF9zdWJtaXRfd3JpdGUoKSBtZXRob2QiKQ0KPiBDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBTYW0gRWR3YXJkcyA8Q0ZTd29ya3NAZ21haWwu
Y29tPg0KPiAtLS0NCj4gIGZzL2NlcGgvYWRkci5jIHwgNyArKysrKysrDQo+ICAxIGZpbGUgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9hZGRyLmMg
Yi9mcy9jZXBoL2FkZHIuYw0KPiBpbmRleCAyYjcyMjkxNmZiOWIuLjkxY2M0Mzk1MDE2MiAxMDA2
NDQNCj4gLS0tIGEvZnMvY2VwaC9hZGRyLmMNCj4gKysrIGIvZnMvY2VwaC9hZGRyLmMNCj4gQEAg
LTE0NjYsNiArMTQ2NiwxMyBAQCBpbnQgY2VwaF9zdWJtaXRfd3JpdGUoc3RydWN0IGFkZHJlc3Nf
c3BhY2UgKm1hcHBpbmcsDQo+ICAJCQl1bmxvY2tfcGFnZShwYWdlKTsNCj4gIAkJfQ0KPiAgDQo+
ICsJCWlmIChjZXBoX3diYy0+ZnJvbV9wb29sKSB7DQo+ICsJCQltZW1wb29sX2ZyZWUoY2VwaF93
YmMtPnBhZ2VzLCBjZXBoX3diX3BhZ2V2ZWNfcG9vbCk7DQo+ICsJCQljZXBoX3diYy0+ZnJvbV9w
b29sID0gZmFsc2U7DQo+ICsJCX0gZWxzZQ0KPiArCQkJa2ZyZWUoY2VwaF93YmMtPnBhZ2VzKTsN
Cj4gKwkJY2VwaF93YmMtPnBhZ2VzID0gTlVMTDsNCg0KUHJvYmFibHksIGl0IG1ha2VzIHNlbnNl
IHRvIGludHJvZHVjZSBhIG1ldGhvZCBjZXBoX2ZyZWVfcGFnZV9hcnJheSBsaWtld2lzZSB0bw0K
X19jZXBoX2FsbG9jYXRlX3BhZ2VfYXJyYXkoKSBhbmQgdG8gdXNlIGZvciBmcmVlaW5nIHBhZ2Ug
YXJyYXkgaW4gYWxsIHBsYWNlcy4NCg0KQ291bGQgY2VwaF93YmMtPmxvY2tlZF9wYWdlcyBiZSBn
cmVhdGVyIHRoYW4gemVybyBidXQgY2VwaF93YmMtPnBhZ2VzID09IE5VTEw/DQoNClRoYW5rcywN
ClNsYXZhLg0KDQo+ICsNCj4gIAkJY2VwaF9vc2RjX3B1dF9yZXF1ZXN0KHJlcSk7DQo+ICAJCXJl
dHVybiAtRUlPOw0KPiAgCX0NCg==

