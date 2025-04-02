Return-Path: <ceph-devel+bounces-3003-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E227BA786FA
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Apr 2025 05:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3103AE5F3
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Apr 2025 03:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5211A2309B1;
	Wed,  2 Apr 2025 03:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mO4kxx+T"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4115A23099C
	for <ceph-devel@vger.kernel.org>; Wed,  2 Apr 2025 03:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743566374; cv=fail; b=dlErIgJPxwvrRhTkCjH4hspblQB4QgEsBRVN+wCg5xPV1rF+Y5W2A+MiUNl5pF3e2YHrM8x+nQ/1XnEGD6jNNn1n2GSD9dJFpuYARM4xc33QLwscT3dSvFB1s2D1eqJysFLQqbnJiW4GzphFVnSyDm6XriWUyZ17Bh7zSkdIPWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743566374; c=relaxed/simple;
	bh=ysCiRy7eyQLc8pjYLgNOZWftqOTW1ikxJ58LHnEsXFM=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=bdGXaZvlCwMqzTkm6q+L/coeP2i99Z9UMo9ac22wYCQbli4qunN2mMqEKa+VcDN/Sl1tdb1qANotfv7x+AAYKW2JwV4tYAAB8W6ZWAkbveYWWjfr1HbENFiuVP7brdz8kM1BPUyRlLmY0p/HLFfnlgIuS1dL1MkMHlmy6+fELqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mO4kxx+T; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743566372; x=1775102372;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ysCiRy7eyQLc8pjYLgNOZWftqOTW1ikxJ58LHnEsXFM=;
  b=mO4kxx+TFiKyhcGB8pTgi6pLV2ZMWNlBOoKFNTfto0GafgMXbt0jlM/6
   a/5ko20VIVKECHD7twrHt+PD8vnd8tNNSxEza2o3Ei/LUQm2oOwDWMYWC
   qxUhUyNRPqhUha56sOSbBz0u5/JAfpmbSvtEcycnxoNggARGX9nDrhUKv
   8FrbhsyBGQy6YB/5qbdWfDUK6nSCkKdBDvKvcc13UH64ZfcDoo7yZwNL1
   CEIjejkwSPThsAUoER4sx6mfRcUSSms0mJtAu6+mTGByZpSdd7pa8vSVS
   CgQqcCVhZwMdzWUcSnCRd9S3SfnZ+JZ+gwHCr2W3oauPcUynNFxw5WRsw
   w==;
X-CSE-ConnectionGUID: VB+NyqUyRsmY202gp+W2vQ==
X-CSE-MsgGUID: W5oDz2efSs6xsDlOX7jszg==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="44620690"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="44620690"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 20:59:32 -0700
X-CSE-ConnectionGUID: usUl9zsqRaC8tMsdAcCbwQ==
X-CSE-MsgGUID: 0Nh8bLUuQQ6YMJEz9ZtKYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="127403309"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 20:59:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 20:59:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 20:59:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 20:59:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtCFl++n2V0X4uFNJ+lm8UYyoBToENct6lA7iSdyXDh+enZeaZok7h76hBh/nPbyQDLVTROXKRaebh744V2O/k6AOQXrYDLF3ypORE8WuqW7Y6cH6xD8/igyMZukbtpsytoNY0UJNw/96/MhkURRCuFNl4GW5ztS+/EUcComJcVRLVEzjnlCCQPn2VIT3CTgBke++x/twAp/8pdsRCwq6ePbE5WAdJoDj9zT0JroCYK2o3Nh7rs1f2XAf9A6VJ8ueFFtNgWUlJhZLbHafk37dow74vParp/kcOq1iJa0Zh+fksdewSLZM3FI62M6/j5hgruNrQq35CsKjUqDP0nV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1d4Ud1ji3geFroHrheGerjolfPurQ5E+HGXLbjuwSlE=;
 b=XNRYTMWDx+GvAH2SHMYSi5cESp2VuwRQqJ1Maeg9G7JjDsnDjFKIhbQjrqzp+owcnfxcCWnqG41raqd6xsi5g+VPUAjGybnGcm0OCTSsX+DBwJIGH5FUMXtMTwt4IXAhaI4Z4j2MaGEpBKHKdnDVYkLE1EUeAKtHf6f6GKNHm5xvOBz6ZiKTyfveluY7sTwrJtocppoTIBuqaxOis4F3nFBDNqSm/FCQdO++wCN/52MFjeN/zI/bKw86j8UXGCMugElXIq6wWVyl3tMhCNZLL0paGDYrspfNUql3oor0veqe65SIutqPlMEX4Kq0tYtj1dqd7+hjWFKC7MQV1ySbcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM6PR11MB4514.namprd11.prod.outlook.com (2603:10b6:5:2a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.54; Wed, 2 Apr
 2025 03:59:27 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 03:59:27 +0000
Date: Wed, 2 Apr 2025 11:59:18 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <ceph-devel@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [ceph-client:tls_logger]  75b56e556e:
 WARNING:at_mm/slab_common.c:#kmem_cache_sanity_check
Message-ID: <202504021147.a27c3dc8-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM6PR11MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c1146a-386b-4323-c850-08dd719ac31b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0HOeOKyvRHUdiXW/Pi0pDCGTOOD5tY6SBoCkFFwxPlZnyBLWWrh6yBj02GHm?=
 =?us-ascii?Q?8+zRmDSZiPmXYVdsrHezHSxbo+tDL5KTHK26G56V/P9dm4tWBA42IzZXVdc1?=
 =?us-ascii?Q?A3Q3IrzfoNO2EfF3RpaWjtp8XDbMWFhvi3DH318rwAMADCv1gWhi7iU3Jk3w?=
 =?us-ascii?Q?wJL0kXu96q2fG4Apdh3oPpD8xdJIYO5cthBbGyemveypNJ8q4WnRAjNz5mbO?=
 =?us-ascii?Q?kVwq1BuHdbGGGBC62DVEhZneCJIxQ7jSk2QJv8RUuRw+XGhyr34arNe83K45?=
 =?us-ascii?Q?SSCZ/7FsuX8OmFO2PSP1x89qzzUdOHlKC0g4n8zcMZTo8KYbAdt7dkVKtfo8?=
 =?us-ascii?Q?CcBVbS4wUCK6ivEfZ28h4IU++jM6yGsmdxiuvHMffskAFsbiI55K2ihOvCbi?=
 =?us-ascii?Q?mQ/CNlysYZAcoKw/vrh4rC0uO52EieZEykRXWgXBJDXVhQ3UIzBd7brHO+Am?=
 =?us-ascii?Q?rkydtheXJdFj9gN09RYkXm8ogrKe+qcvlnwb+EX9iIG9eoDljWrGFH14hdbA?=
 =?us-ascii?Q?tiHHvg1UXn7ncnReKzMs4HW78Hb4bWT01gR6dTusLsgzshH/Yw+fCRTL4qMj?=
 =?us-ascii?Q?N4sQYaZ1vecfh0uhvP3Uzm7mzB2Kf11mGVYHYeweQhm9QAU1hEhwopNEs6Z3?=
 =?us-ascii?Q?nxFTka3xS4bZ7FnU3xwLG+sGDmEjv3aLJMEfoV+cO8saW8qTf1Hgb5LeAuTO?=
 =?us-ascii?Q?zr7+Zaxm0sT6drRVvh1LVIW/Z8HNecHxdMFPl35KRx3Q/gIz6SvC8jc6UIfZ?=
 =?us-ascii?Q?lX8zV/A462WdTQ7uKlOyo+xxHiH4MvUWSexuDu2IKAcg8TY7Gxyz+jERhUEu?=
 =?us-ascii?Q?uPUQmd6J1+bLtP7xHR7qT1FZ6grr67c8ewnlA3vENFXnstjLUgjTbaWn4phF?=
 =?us-ascii?Q?hLo0QpETdTO78eZtBLyksLp+X+uj1rreSTCwNBB9uVDwRxJwMoAXZyD4INYf?=
 =?us-ascii?Q?iBrKnKJbmfZqID1Gq+uyez087YCmJgwo0HwI21P21whsAnIk1zkVkNrzO2CI?=
 =?us-ascii?Q?Jcz85luesdseqxfMtr+S+TfcNuNqY1N2awTyfQ0vgXV6kHYqD0s4xhTqqKAK?=
 =?us-ascii?Q?S3WoKm2LzNo+glWSa9JkrSx6iHY3fYg1tlpXnlmLwGRl9rpkMWjrIJGRaEki?=
 =?us-ascii?Q?fUwvh9iPaE6hjufGwDc0Cs/d7PTYWkLUFtwEzkKPXQ+oW75tlGHctaFSw65Z?=
 =?us-ascii?Q?mHNIIYCHqTjdh98uUqzY/Er3n1X0STzx91S5AHXjJ/8xxQcZLyY8YkB77NgK?=
 =?us-ascii?Q?QvRmvRHMsEf4b/QV7Mi8fmK4RH9kZT+bJpPpt9RX0M+Zj7l4R48Z3whnjiqW?=
 =?us-ascii?Q?ngGr1r6BIFrYgaB7PdLXyPwWf5IHgO1bC6E0UeZfAn5a9Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n0bR4v9Rv1//LGkyd25lxlHT1+7O5idxIj2hoXg5URbzjCcTWd7Ynd8DQYYP?=
 =?us-ascii?Q?ty1fEVWjjlAPB6xbZfrmD/9IxEJ45QFcgunNg9VBjOZDRm6QJ5G2fJ16k2E6?=
 =?us-ascii?Q?gHkPm2tMa8K2+ozyERzkCNWjsZ8tfYNNGgrMt2r1eXaUUkXGB4m3UWOJ2r6j?=
 =?us-ascii?Q?cSjUM7jELVgI1+IpvK8qbvV1E8XzZKvS9vV/RWXVDE77grpezuu2c5B+Fu5z?=
 =?us-ascii?Q?GiMFAEERuLwwVOCYWOly2zlEJhyd83Lcc4SWPOELXXZU3afLmYbzk8j/lykz?=
 =?us-ascii?Q?67Z90Yq6sL3YI0U79Surdoadx+HmdzxlZyFdDmNmVVqi5jYaisyp075KiOcY?=
 =?us-ascii?Q?gCckzjFj+cOxgqVfl56spLKnYHiZnuIgLVFvI+3/gX4Docf8Otu9UZLOT+nJ?=
 =?us-ascii?Q?TFSFoX3syNQTXSBBgpEtYYoQzQifcahs88I3K2H2nqmohhfQr3oLUgz0Z6f6?=
 =?us-ascii?Q?vV4w9GIC/IO32DodvyVhLGd/KyEFV2t/7e+guiemytQD/hUuDxU4lX89fzS2?=
 =?us-ascii?Q?Sl4gUyU0VOngvZEgNKXG+EH/EdJTg4StZZmJRbmDwipLiQ0agu3724EG6NKp?=
 =?us-ascii?Q?5XP27GZytKR7uO2H7Uy+PQfIsZtWKxjGSXbW5M3bBvIwpn15Vo4oUl0nv+2j?=
 =?us-ascii?Q?1ByklGlqU9h7UkKp09GXCtvw9+MOg5QwK33sIXVkxtSi4iPjV2XRDAA/tf2+?=
 =?us-ascii?Q?MmH61rIAlIBvLA+8xxpJkIJRUCjdG+kVW0IrN2uUFengKlhDPDKNJXrhDgx5?=
 =?us-ascii?Q?U2ARr+RjQs8a/qtSwXJPgBk+UjXHCR5091WL/FeEnqUQ+xs4sfnyKT8l8j08?=
 =?us-ascii?Q?nwBIpj+QQbwchSXAGYXoj//iScTcQyLuSS5XU+8kktv6xziQ297PCVEGJ3Pb?=
 =?us-ascii?Q?nT3+ry6hYEZuYragdvmEYnI4JrF1DoVx5YEz9aCtEU0bR4O3N6N1Sc8yRLr1?=
 =?us-ascii?Q?GkafREjT8ExCMoS+MKf/UqImHsXBvlrRR00V9TESIENwaMYHkJ03j5dFf1a4?=
 =?us-ascii?Q?am2jY+OXz+8HwfwYSYLmmT0f1Vfn9C/t1lIFYexgL0EtS7HD11ysH9w96PBk?=
 =?us-ascii?Q?rZmR2i9fJ7GBgvh4W4tuf4G0tuut4KFr83lPz78MK5SZvqp7eQS8cKxFiaFF?=
 =?us-ascii?Q?yRcS/f9FckuPIW8VKdC1yGc8UkTUT4AckfnOITEJDQl3bhEv7sjKSctZPCSS?=
 =?us-ascii?Q?eIaTS2uUGVg1tfRANxVI5okAyDwZFBpi6F9+WWHO41EgifCwey1SPYfA035c?=
 =?us-ascii?Q?t9T+WwrZaHLkdjGTpFvYHZorRuHzdgdPmj5l27lBFNMroQDbbMzaDOxDzckk?=
 =?us-ascii?Q?ArUZjZeQ6Dm9/oipWzRT9Utgx61ltr2McUU08TyYWKAoLWGSVlnokZMrUW3y?=
 =?us-ascii?Q?2vKVkqJPMdD6PBvbdtUZoSXnMN4MoPhqlyMdNdvpf0KAq9jvjIDGlaT8E95m?=
 =?us-ascii?Q?iVMUQg8zAHjt1TEfFJHaapGN5/q8N8EQVLirQ2YjPn7S/ugB4DLud7GsdWcy?=
 =?us-ascii?Q?+B5NVHU+BFW2MpPYliaN92rIe1kCkPJAgkCOq/P9zu4MRrEcUWJ4H6EB+W48?=
 =?us-ascii?Q?17xS1yjBy7Y+oV3GymtuyeeTjFX20smatjtLn0uW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c1146a-386b-4323-c850-08dd719ac31b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 03:59:27.0118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMkcwhWPHgBjRVAm4m0eg03ITPd+LehcLHh+/55KLgRQLWDdPKnE4SlRBZxgLkLb35zmZib6BR6yEmew1BFzWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4514
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_mm/slab_common.c:#kmem_cache_sanity_check" on:

commit: 75b56e556ea415e29a13a8b7e98d302fbbec4c01 ("cephsan new logger")
https://github.com/ceph/ceph-client.git tls_logger

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-03
	nr_groups: 5



config: x86_64-randconfig-072-20250331
compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+------------------------------------------------------+------------+------------+
|                                                      | 7ef17a7413 | 75b56e556e |
+------------------------------------------------------+------------+------------+
| WARNING:at_mm/slab_common.c:#kmem_cache_sanity_check | 0          | 12         |
| RIP:kmem_cache_sanity_check                          | 0          | 12         |
+------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202504021147.a27c3dc8-lkp@intel.com


[   52.283971][    T1] ------------[ cut here ]------------
[   52.284905][    T1] kmem_cache of name 'ceph_san_magazine' already exists
[ 52.286061][ T1] WARNING: CPU: 1 PID: 1 at mm/slab_common.c:107 kmem_cache_sanity_check (mm/slab_common.c:107 (discriminator 1)) 
[   52.287476][    T1] Modules linked in:
[   52.288056][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.13.0-rc7-00021-g75b56e556ea4 #1
[   52.289426][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 52.291004][ T1] RIP: 0010:kmem_cache_sanity_check (mm/slab_common.c:107 (discriminator 1)) 
[ 52.292069][ T1] Code: b6 dd 31 c9 31 d2 89 de 48 c7 c7 c8 a5 1a 89 e8 f0 71 d2 ff 45 84 ed 74 15 90 48 c7 c7 31 cc 1f 87 4c 89 e6 e8 85 d5 9f ff 90 <0f> 0b 90 90 31 c9 31 d2 89 de 48 c7 c7 98 a5 1a 89 e8 c4 71 d2 ff
All code
========
   0:	b6 dd                	mov    $0xdd,%dh
   2:	31 c9                	xor    %ecx,%ecx
   4:	31 d2                	xor    %edx,%edx
   6:	89 de                	mov    %ebx,%esi
   8:	48 c7 c7 c8 a5 1a 89 	mov    $0xffffffff891aa5c8,%rdi
   f:	e8 f0 71 d2 ff       	call   0xffffffffffd27204
  14:	45 84 ed             	test   %r13b,%r13b
  17:	74 15                	je     0x2e
  19:	90                   	nop
  1a:	48 c7 c7 31 cc 1f 87 	mov    $0xffffffff871fcc31,%rdi
  21:	4c 89 e6             	mov    %r12,%rsi
  24:	e8 85 d5 9f ff       	call   0xffffffffff9fd5ae
  29:	90                   	nop
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	31 c9                	xor    %ecx,%ecx
  30:	31 d2                	xor    %edx,%edx
  32:	89 de                	mov    %ebx,%esi
  34:	48 c7 c7 98 a5 1a 89 	mov    $0xffffffff891aa598,%rdi
  3b:	e8 c4 71 d2 ff       	call   0xffffffffffd27204

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	90                   	nop
   3:	90                   	nop
   4:	31 c9                	xor    %ecx,%ecx
   6:	31 d2                	xor    %edx,%edx
   8:	89 de                	mov    %ebx,%esi
   a:	48 c7 c7 98 a5 1a 89 	mov    $0xffffffff891aa598,%rdi
  11:	e8 c4 71 d2 ff       	call   0xffffffffffd271da
[   52.294641][    T1] RSP: 0000:ffffc9000001fc18 EFLAGS: 00010286
[   52.295579][    T1] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[   52.296770][    T1] RDX: 0000000000000000 RSI: ffff888100350040 RDI: fffff52000003f77
[   52.297942][    T1] RBP: ffffc9000001fc30 R08: fffffbfff0eb4f9d R09: 0000000000000000
[   52.299159][    T1] R10: ffffffff81302352 R11: fffffbfff0eb4f9c R12: ffffffff86be5b60
[   52.300383][    T1] R13: 0000000000000001 R14: 0000000000000118 R15: 0000000000000000
[   52.301484][    T1] FS:  0000000000000000(0000) GS:ffff8883ae800000(0000) knlGS:0000000000000000
[   52.302727][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   52.303710][    T1] CR2: 0000000000000000 CR3: 00000000074c2000 CR4: 00000000000406b0
[   52.304895][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   52.306017][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   52.307166][    T1] Call Trace:
[   52.307696][    T1]  <TASK>
[ 52.308112][ T1] ? show_regs (arch/x86/kernel/dumpstack.c:479) 
[ 52.308799][ T1] ? __warn (kernel/panic.c:748) 
[ 52.309515][ T1] ? kmem_cache_sanity_check (mm/slab_common.c:107 (discriminator 1)) 
[ 52.310375][ T1] ? report_bug (lib/bug.c:201 lib/bug.c:219) 
[ 52.311034][ T1] ? kmem_cache_sanity_check (mm/slab_common.c:107 (discriminator 1)) 
[ 52.311962][ T1] ? handle_bug (arch/x86/kernel/traps.c:285) 
[ 52.312664][ T1] ? exc_invalid_op (arch/x86/kernel/traps.c:309 (discriminator 1)) 
[ 52.313373][ T1] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:621) 
[ 52.314126][ T1] ? this_cpu_in_panic (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 kernel/printk/printk.c:362) 
[ 52.314935][ T1] ? kmem_cache_sanity_check (mm/slab_common.c:107 (discriminator 1)) 
[ 52.315663][ T1] ? kmem_cache_sanity_check (mm/slab_common.c:107 (discriminator 1)) 
[ 52.316478][ T1] __kmem_cache_create_args (mm/slab_common.c:304) 
[ 52.317143][ T1] ? write_comp_data (kernel/kcov.c:246) 
[ 52.317722][ T1] ceph_san_batch_init (include/linux/slab.h:349 net/ceph/ceph_san_batch.c:48) 
[ 52.318321][ T1] ? ceph_san_batch_put (net/ceph/ceph_san_batch.c:38) 
[ 52.318957][ T1] ? write_comp_data (kernel/kcov.c:246) 
[ 52.319781][ T1] ? init_caches (fs/ceph/super.c:1636) 
[ 52.320509][ T1] ceph_san_logger_init (net/ceph/ceph_san_logger.c:190 net/ceph/ceph_san_logger.c:175) 
[ 52.321225][ T1] init_ceph (fs/ceph/super.c:1643) 
[ 52.321965][ T1] do_one_initcall (init/main.c:1266) 
[ 52.322674][ T1] ? __sanitizer_cov_trace_pc (kernel/kcov.c:217) 
[ 52.323556][ T1] ? trace_initcall_level (init/main.c:1257) 
[ 52.324442][ T1] ? ftrace_likely_update (arch/x86/include/asm/smap.h:56 kernel/trace/trace_branch.c:225) 
[ 52.325200][ T1] ? __sanitizer_cov_trace_pc (kernel/kcov.c:217) 
[ 52.326114][ T1] do_initcalls (init/main.c:1327 init/main.c:1344) 
[ 52.326879][ T1] kernel_init_freeable (init/main.c:1581) 
[ 52.327703][ T1] ? rest_init (init/main.c:1458) 
[ 52.328397][ T1] kernel_init (init/main.c:1468) 
[ 52.329013][ T1] ? rest_init (init/main.c:1458) 
[ 52.329718][ T1] ret_from_fork (arch/x86/kernel/process.c:147) 
[ 52.330422][ T1] ? rest_init (init/main.c:1458) 
[ 52.331069][ T1] ret_from_fork_asm (arch/x86/entry/entry_64.S:254) 
[   52.331999][    T1]  </TASK>
[   52.332475][    T1] irq event stamp: 475325
[ 52.333009][ T1] hardirqs last enabled at (475333): __up_console_sem (arch/x86/include/asm/irqflags.h:26 (discriminator 3) arch/x86/include/asm/irqflags.h:87 (discriminator 3) arch/x86/include/asm/irqflags.h:147 (discriminator 3) kernel/printk/printk.c:344 (discriminator 3)) 
[ 52.334393][ T1] hardirqs last disabled at (475342): __up_console_sem (kernel/printk/printk.c:342 (discriminator 1)) 
[ 52.335790][ T1] softirqs last enabled at (475186): handle_softirqs (arch/x86/include/asm/preempt.h:26 kernel/softirq.c:408 kernel/softirq.c:589) 
[ 52.337250][ T1] softirqs last disabled at (475165): __do_softirq (kernel/softirq.c:596) 
[   52.338696][    T1] ---[ end trace 0000000000000000 ]---
[   52.340184][    T1] ceph: loaded (mds proto 32)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250402/202504021147.a27c3dc8-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


