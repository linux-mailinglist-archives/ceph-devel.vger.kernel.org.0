Return-Path: <ceph-devel+bounces-1254-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC498D8181
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 13:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D331F2444A
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 11:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1344B8529E;
	Mon,  3 Jun 2024 11:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="UZAHehRs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2121.outbound.protection.outlook.com [40.107.6.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB0984FDE;
	Mon,  3 Jun 2024 11:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415242; cv=fail; b=Yr1H0CVkpie/c4E8/eu0a4AMxE6NezuaPvTOMQwDyHeQvBZ4ZqFUgeepsVEaX8BPQf50Knba4tYFoA2i/fH7/LQzkfwC9JvzSZUo7RTrkkZcPXxFtFLKa4MjXYK0cNq4fMZPcZegPYsUWvpKhDeOYr4uqDc7hS4Z0KosbIvomtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415242; c=relaxed/simple;
	bh=emWdh88yIZPuI9XD231vukObF1MJaRhmIpzkFn+8gBk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lCMF/OP9EZ1bmiL4Dg+Wi1bWgA9GvECpXj9dPH7BDzYjbFvw4NFaGTaZB1tpxAPPNdA4FmDKRnp9e763KAQsybzOrzWzCi2jfzblIQ7MFsNUTQrmnsR/zl3/C9g9AbxxaiYnzPhr7wb9quhn6jJVeKUUq/H1TyW1tIVSfLh0gEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=UZAHehRs; arc=fail smtp.client-ip=40.107.6.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3WMuE9d3PKdxawz2T1T6k442enZ4SAZHSwTegqLGG5/p9rLJU6snRH8EhblHoAA/ZPvS8upUzSNPWm1at1JiZau3AXlgS6kGTkmPtN/9O1HDgtCzCF1EZ9n8JskACTLszZEVFzBsyewu1WaGRkGQQsJ1AgumbynKghnpCBZcADL/Z0yYJQuSC3Up2xq/xmdC5VOhNq1yHJkb1nkChVrJRAYGn1/r+cakTKe2xxU0UNd52QPSuJ904uuhDQSwkAgPsM/BZt+tYpDCCLaXBZYrzzyBVFKHLmderw0sCmLNLVOs+tfSvHCiMqAKstve2TmHQbxUlhytz67pd7/4pxE5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emWdh88yIZPuI9XD231vukObF1MJaRhmIpzkFn+8gBk=;
 b=Z5EE6UoNo1xBa5fHBchHIrOZHRePsPck4LnX7LGDaDu14rJ+w35s8b9ksYNSLuZMVjksQjLeUXZxIBuNBlAhfePmNR828pA/s4KfVcgljT3o3+D3lJWih9XhOljsIWx93pRpvwIYut3vqVdmix9RL5GCEnDYA/aaNrRN5LCYW65LYPqZtc45MnGugUTo7/dQiXGcHfWcyYaLNPtc/M1i8hyW7d8qeL/RhnROSZr+vkyMuDe1TXN6Q+u2FC6lVIDqWucghPREuQ9mNkJt7nr+dcYsOPBSuc1aBS3Oiab2wETQOiJG8Wj7OlSdC6rcK+xwV42U9gDMyquArqXgSO0DdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emWdh88yIZPuI9XD231vukObF1MJaRhmIpzkFn+8gBk=;
 b=UZAHehRsflZp57SyHV/bOSJYWmZsX5N1L4m6NISbn1FB4PhETeazyN/t20jEzL+nXHNcr8ixGIrEVqbLLo49/l3tCFTEUVHTfm40o641kqZu/4bv57DzBhe6B6pbldZE+Axazbj/+6mYS8TYL1vn4NPizWQEWaLui7DCD8sYZQyNw8q3z4xM84Y2TWiI21V26OifojIw77B1yFBeBNerLAgg+XDA6sSHpWwbzyeazO/F+Jsdc+7T2weo6bKbk2ThGC760plgdqyOO/GUnS/+kGDXEQwT69DXK8TuI98FoeqTIuNv6hxk98uCiTg0Qt/dOFHx+NSn79BjBdIHhlbGxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by GV1PR04MB10243.eurprd04.prod.outlook.com (2603:10a6:150:17d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 11:47:15 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 11:47:14 +0000
Message-ID: <85e8e613-ea8f-4f6d-b9f7-cd05913b5de6@volumez.com>
Date: Mon, 3 Jun 2024 14:47:04 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] net: introduce helper sendpages_ok()
To: Hannes Reinecke <hare@suse.de>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530132629.4180932-1-ofir.gal@volumez.com>
 <20240530132629.4180932-2-ofir.gal@volumez.com>
 <8fc3fc34-2861-429e-9716-b25b90049693@suse.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <8fc3fc34-2861-429e-9716-b25b90049693@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::17) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|GV1PR04MB10243:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afaea04-f8f4-4267-a597-08dc83c2e957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nk9MdzNPNUdENis3U2lNSkZDRnVSN3dSVDJodlBlWDRyQ0xwT3AvUW5aUlpV?=
 =?utf-8?B?aGxwZVVyaUNsbG9obUgveHZlV2xOVzFRK3QvTE15dHRpYXdRY3A2RXN1cEZz?=
 =?utf-8?B?MS9tcFdEQlI0RnJ5WnNZQm85WmxSemFFK1kvTU1HMlRUWUp1dmVtbWRkSDFk?=
 =?utf-8?B?R05xUmpZMm1HeGl5VFhMQXdkaFFTUXU1QlZMaWNBTFZhOEJBSTQxTzdkTlVm?=
 =?utf-8?B?eXh0cnVnNndxNnNtOHFkUkVnbktTdVBSVTVNQThmaHFxSmVIcTVRVlQ4RGpT?=
 =?utf-8?B?OEx1anZnZUszM2F6M2l2QU10ZVQ5RGZsVzVZUElxM1lzV3VDRXRxWXB3cHdm?=
 =?utf-8?B?R1R2ZUZVZVVybC91bktBanFMdERCbmdEZm5HcTFrZVR4Q1Y3WUFWWFFvaUVP?=
 =?utf-8?B?bm5vdzBwdk9qZnpQLzlCREo2K1pIMjBlWlIrdkpsbGovN0FvUmxIdTRjYkl4?=
 =?utf-8?B?LzlIOXY3VUl4ZEEzdFFkWWZkaTVETzltNDE1VzFzVkJYNENBOGJHeWViQU5X?=
 =?utf-8?B?dzNWdVdVc25YcElMZU0xeFZEUFIzaHFmOHJwdjhvUFhIV0ZFaVRYd1hnTUZS?=
 =?utf-8?B?YlhkdmhzVnBNRWt2b08zSVp0eHpxelVWQVNPSTU1Q0hTbW9iN2l0eGpmV2RL?=
 =?utf-8?B?bnRoNmJuN3pqSGJxaHpycXdIQTROdmozWmpKb3NRcVBZQ2Q0VkR1cVNKVTVL?=
 =?utf-8?B?WnpXaXIvUlBDNUd4VVZ6bWgzVzhEbms1YXd2U0s1MVdZbm1OdW9yc2U0RkU5?=
 =?utf-8?B?VllndXVRcERJYm8rVnFTUDI5blc4ZzdnWExGK09sTXpDWDkzNG1vK1d0YjAx?=
 =?utf-8?B?YThkbmxFdmR3K2srYjM3UXJFZmpCdHpwWTZDR0dpZVFrQVlINVdhbk9nRENV?=
 =?utf-8?B?U1l5VmxhT0p6Y0tzbUZRMEE4U2lGSWpReDU3ZGliY2xpeFlLY1NhTWNINFQr?=
 =?utf-8?B?RWsrT09nNG9mREprb0lDSVNUL2ZHVXl4TVVmakxmWG9aMS81U0JYenVUNFBW?=
 =?utf-8?B?YzVsZlVsUzNJWXZCdlVHUFFmUnR6Zk54TzhtSlpMdjhMNTcwd052dlcxTVJn?=
 =?utf-8?B?Zm5iaTljUm50MGliOG8wWXNQc1YwcTBqTVNGajRaS05WTWpPbUxKNVJWYlVz?=
 =?utf-8?B?UE90MEJPZ09pcURrdkNNMC9NSmgwQ2JjUlM2QnZBUlJGNkFyM090RGZKRGNJ?=
 =?utf-8?B?Wk1wN3puOVlESXdONW5xd29vT2hzZmdmcmxiVkZRVHhsR2I5N3RvRGZSeklH?=
 =?utf-8?B?MDlPRVo2cDhqUGJFejRtRUZ3MEp0K0NNaGl3THRXSVVnSmowOEVrWFQydkF1?=
 =?utf-8?B?Slh6N2lwYXhjSXBPSThYbWNjaUxEL2MzeGFVUTN4S3ZueXZ0USszSUdpalkz?=
 =?utf-8?B?Q1Y4anJVYVgwU21yc1JTd1VSN1BGaVBZZDk4dHhtVThCY1lUUFI2ZlZhRkt0?=
 =?utf-8?B?MUFRS1p3MUNhNGtEaFM5L05kVUk2L1UwV2ovTDZubk1qYU5HckpHdm81VGND?=
 =?utf-8?B?SnhxRHBMTkJ6ZXI5NzJ3KzRTVW96S0xnVG8vdHdjQno0VzQ5cEg4S2Fsc2ZH?=
 =?utf-8?B?bk9Eb053UGY3dFBPQlA3M2t6TUpPeU5sR3J1Ui9tNUVlS2luL0pza3BZRFl1?=
 =?utf-8?B?TDlhbU5FYlhsSzFOcndVRUM4M09EU1dsRjBqVi9OTHhBM0lVUEZPbjR0WmVG?=
 =?utf-8?B?ZEVuNFk2V21vOHBHNjNIVUV6N1VNdGpNU1FJNkRkNW5DSmNnVjBJdWhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amlkRU95eWFmQng2V3RiZnlHbWFYUkdNNnBjbUh6UiszbllsRFNEVFFhaENo?=
 =?utf-8?B?KzNFVHZVR1pGRCt2S0lnOGZtR3RkdkhUelZaR0VqZTh2eUJJcjljUlpGaWdK?=
 =?utf-8?B?SUhsUGFxOVBkR1hVUlBpYSsySG9Mc3dXeFpaWG9QNEZmcEcvbGFNMm5oc2o1?=
 =?utf-8?B?TVpyTEFINTZKTm1PcFpSQ1V5dGVIY3d2UDdnUjBVUitvSUFrWEJ6NElNOG45?=
 =?utf-8?B?VmwvZDZjSUNGejhXYk1ZbXR3KzlCanJBMGJrei9MNmNtV0tTdWJma0JlcHJa?=
 =?utf-8?B?VG9sWm1TWjEyTmMxbThweEJUYkRjSHZCclhPdGN5OEVyMS9aQVduOE1ucGlO?=
 =?utf-8?B?UlRRQWpnOE5ZSGdVZmdrTTBXdTB6U0pXZmxCbWtLVU1BU3o5a0pqYzAxZndz?=
 =?utf-8?B?aHNlQXNEa0MrTXE5MlJ4c1Q0VUJHcjBsaFh1QmtoWFE4d01aVnI2QzYwalFk?=
 =?utf-8?B?QkNXbFY2K0ZUaElkUWJQcFkwckpCZWRuV3FobC8zM3NxNXRzVDhLT3ZHRlVM?=
 =?utf-8?B?VEVNR0I1Nm9CcnpqWVd1Q0FIcXIvTytnV3U1emYxUXRuNTFqZzhkamVVUXdk?=
 =?utf-8?B?bWNXNjkrazBSS3VZS2N5WlFBM1lKQ3dreVc1TnEzRWQ4TTgvYW9kVVJ5TkFX?=
 =?utf-8?B?d3h1WXFBOFJ1cjc5R1pPd0UrV3p4aTdyaFdqREFoemRZSHhvZ3N1UTY4UnU2?=
 =?utf-8?B?N0d6Ry9ieUo0REx5VG1KQ1Z0RnZVc21JTk92djE1UXB6K3lwaTdIVFNYUEg2?=
 =?utf-8?B?Uk54a2VlcnJkY0NIWFVBWW44RFhlajdKUm5YamVoK3phSWtHNmtzUXNmNDFN?=
 =?utf-8?B?dkE4ZGx0NkhiZGU3a2dvN1VYN0g3NHBldzgxNXZRNjg1YXdHcGxZL1NwNFlZ?=
 =?utf-8?B?VTZXMnhxMzVkbFk3WHVuWjhIK2J1U01RK043ZGdBV0VXT1RYdmJkbDVnZENz?=
 =?utf-8?B?Ui9qZHR0RW83V3dYdHBqZmVyLy9HUGppQW5BL3FDRjRDK3B1NExFTnI2cFNY?=
 =?utf-8?B?YmV4QkhQZ3ZMN0d0T3JEU0I5Si9EWFBwK1dQekF6TElKSWVmTzRQRXB6WnVL?=
 =?utf-8?B?c01pODkrMkVGOVZ0SDFmN25oa2NFOUZ3VTJQdkFxRmhHbjBTV0NOZ3VDaFUx?=
 =?utf-8?B?dU9BQ3MwdnRYNitSbW5QQmIrTjJBOWgyVmIyL1FrNzA0VlNIK3g3UG5BMlBi?=
 =?utf-8?B?SWE1eC9DRWd1dmdnUHVrZ3BtNEZkSWNVekJBN1RWZHo0N3ZGOERjdDdPRzYw?=
 =?utf-8?B?ODVGQXlwS281ODVvOFNUL1RYM1pydy9pS1RLTlhNN0dtUmZ4VTRwM1NtaUwv?=
 =?utf-8?B?clV3YlEvd2NncVZveUhLWU9vY0ZJd2c0ZTRJQmJwMDU3QVRDNVFPMUhDSWJZ?=
 =?utf-8?B?YUtPRjBLdUwxRWErN3R3Sk53Y0RIM3B2ZklTc21hNHFlOFdWY3cyaVY5alk3?=
 =?utf-8?B?VG42QzhEd0pBMWtIZm9ZcURlOVR5SWs3OEZNb1BPczh6dCtDam9qQkQwa1I4?=
 =?utf-8?B?T1NpVXUxZUtzazA4K1RFanFveUx2MERIT0MzTy9JOTcwUklBMzRwdjcvU2JO?=
 =?utf-8?B?V0JBOWVMUTR6ZUJpUmIwbTlsSFRPR3hGNlA2UUtzMnAzb0xUdWlldmRtUDN1?=
 =?utf-8?B?SHZKNVNWYk1sK0R1TzErRllaeTI4bGxMdVI3aGZndVNtbnBNUjRsdWdTMURj?=
 =?utf-8?B?WERNNkt3bFZqKzVUTDlhakFjTVJxekNOZjZQRHRrN1ZNR2JZUVhzVnU4aDhn?=
 =?utf-8?B?cWROeVdiMVo0RTZaTndrQmlVWlIvK3Z3NWIxM1ZJZkZrR3VYL2FMYXFCbGJq?=
 =?utf-8?B?TElvWFhrdStEWEtxUWxmeW8vcDlJcnNxN002VDQxTWpCbmI5dURNaHZBd1Fj?=
 =?utf-8?B?Ynh3eWRocms2Q0pVeXNZUzVhYTdudXBGRnJJSUpBaDBNK1dXUmpsY2ZEdUdO?=
 =?utf-8?B?Nk5FbUhyT0prT0FVUlUvUVo3dzJ1cTBONFFKbldFdUpEWmF4MkFwTkxlNUZ5?=
 =?utf-8?B?TWlkUkZ1bXVQb1JnckRvTXA1b09wV0hZbEdMZkhyK0o5ZFUxcGRTcXZ4dVNt?=
 =?utf-8?B?RnU2NW43b0dWTk90SDdodWd3QW9BOGgxVk1MVTYwUzdQb3ZybjBOOU9qNDVo?=
 =?utf-8?Q?sgB3V8LrslqR+su4RLZJWvMQV?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afaea04-f8f4-4267-a597-08dc83c2e957
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 11:47:14.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2klV7o4pM/SCI5dhtYrYMgZrP+cFire2jGfJahW519bsBdRKFhMY6Pm6/dasRlE+RFFPHCw4YhyoftYhZXUjng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10243



On 03/06/2024 10:18, Hannes Reinecke wrote:
> On 5/30/24 15:26, Ofir Gal wrote:
>> Network drivers are using sendpage_ok() to check the first page of an
>> iterator in order to disable MSG_SPLICE_PAGES. The iterator can
>> represent list of contiguous pages.
>>
>> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
>> it requires all pages in the iterator to be sendable. Therefore it needs
>> to check that each page is sendable.
>>
>> The patch introduces a helper sendpages_ok(), it returns true if all the
>> contiguous pages are sendable.
>>
>> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
>> this helper to check whether the page list is OK. If the helper does not
>> return true, the driver should remove MSG_SPLICE_PAGES flag.
>>
>> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
>> ---
>>   include/linux/net.h | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/include/linux/net.h b/include/linux/net.h
>> index 688320b79fcc..b33bdc3e2031 100644
>> --- a/include/linux/net.h
>> +++ b/include/linux/net.h
>> @@ -322,6 +322,26 @@ static inline bool sendpage_ok(struct page *page)
>>       return !PageSlab(page) && page_count(page) >= 1;
>>   }
>>   +/*
>> + * Check sendpage_ok on contiguous pages.
>> + */
>> +static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
>> +{
>> +    unsigned int pagecount;
>> +    size_t page_offset;
>> +    int k;
>> +
>> +    page = page + offset / PAGE_SIZE;
>> +    page_offset = offset % PAGE_SIZE;
>> +    pagecount = DIV_ROUND_UP(len + page_offset, PAGE_SIZE);
>> +
> Don't we miss the first page for offset > PAGE_SIZE?
> I'd rather check for all pages from 'page' up to (offset + len), just
> to be on the safe side.
We do, I copied the logic from iov_iter_extract_bvec_pages() to be
aligned with how skb_splice_from_iter() splits the pages.

I don't think we need to check a page we won't send, but I don't mind to
be on the safeside.

>> +    for (k = 0; k < pagecount; k++)
>> +        if (!sendpage_ok(page + k))
>> +            return false;
>> +
>> +    return true;
>> +}
>> +
>>   int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
>>              size_t num, size_t len);
>>   int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
>
> Cheers,
>
> Hannes


