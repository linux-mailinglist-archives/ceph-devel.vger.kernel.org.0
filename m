Return-Path: <ceph-devel+bounces-1541-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 228C8934A52
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 10:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CD3E286D68
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 08:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E3613B293;
	Thu, 18 Jul 2024 08:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="ohcher/F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11022116.outbound.protection.outlook.com [52.101.66.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B48213A272;
	Thu, 18 Jul 2024 08:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721292340; cv=fail; b=oFUuE/GiSDvtL/J0dee0I8+vMDtcyJ4PIRkxECO4ecOWl+fnf3+L8noIn017eGWo7wgs7qiZyLE7rbN2zUilF/dS/gF6D9df3qee8S8qKDg3X447VNs6D1VwkOf+A106tqGxzNwZcD2IibvHSFPPZysiSckxhUo29KbOoxcY7F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721292340; c=relaxed/simple;
	bh=hrXyDaUZD5O+KIuY6QI0GBnrWAENZW6x0xDSGwfPjoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UFRSHCm71qlRYAKfV8T5hd0AzdkMjEbN48QCY/mo1srVva2qi0e6rM4/vP5/PgQQXgShV5VoW4mDKwc8bI5gq2w8/9IQIIkS9Un1zoKn+G33vwh8bucp+gGpWj5whrPWOpWejGXMOkpZAPQvIasK92g6KuSyks7I11+/OANK9Jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=ohcher/F; arc=fail smtp.client-ip=52.101.66.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v4H7fT67DxCXxrOPufiCsKD9IK80r5P6wzyQCBDekDbh22xQGbLQx8kUmkySOsj8fHRX1Ur2qxIhVdvB4z4Jj0eGAAXddvd/0SBtc9MPvUd6mFFAcneV6RATrmKCnXbFQmH9fc9jsfBE/lh9vAcTmmMFX1mX/w6jCov7rV4aXU/+IbK49NFFHYYaRbfJySMkUkD93G8aP1GMgH63H0p8aFFe+Jrwz1rpYXEwn1+1qlux8UJ54RUqdEsWLevy8Vq2YrgOSIJPBWyPCxJzvUVCQ8eD0caxWX/rx232kr+qNFpxy+4Jr5fIwbVeHB/GED63ecyZ5G6UvhB7p5gE3J1NQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=427ibjUET2vgiYD30TKQMjrgcTz1GT6EqH2o5uxTbbg=;
 b=aknUEp3Kc+4TagcW1u07b7OqllANt+jRXScD+Suu3ezJyZD+NBvhS5gtVHeOsx7YZmXgm4Mki2a0pA7FqLF7pMNboBY3jYjOfXORyGu1aDOUdwwZXGLQwJFa9YgS/JLdfonIvtJfAki1XS/CqKhi5hCy9VAdYwoTzAm2baG/TwB6i3n0lun9SUve5D/F8RHffyns+XqJ5NjbJFKFYIgOeV7hSC99WR0ws/OJsCjUiEGlXyiN/rKDzWagfzC3H0nIk3ScS40LBFsHJqiZgA0thCE/CHNZKCn4RDLS1EkCmm+G8FPIEMxc2jUuzz44QBRt0CcssZo8I2UamxfPND4WlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=427ibjUET2vgiYD30TKQMjrgcTz1GT6EqH2o5uxTbbg=;
 b=ohcher/FbxBpNSNC89whsVEqQ41UYUZPV4RxoLlfjZFHoN7XhyK/zm9xx2jllIaDMQHj/WulOq0MPl3gvy5GbCTydXaMQLHA3mvh8n8z9h8BAFa1w50g3HlHX0kjCdp6b1SFRxtlUmCXT27py9xtz/S7/eE0GhnIdb+oq28f3jq1E33uPkvRVvqczyi9NURVJbGx6O3JFuj+B7sBrUsvzUuJnqGgtKbwj4oZGdPWIzustgzMoZiLYOCKU/aTN2uDhV1PiTGaMIHW4Dy67tGpbrgDuKXRBqPpP1gitUMi3c9V78URBJcB48yAnA3VgQoEc6ZXUvJdQUXRTXZc5JZh0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by PAXPR04MB9005.eurprd04.prod.outlook.com (2603:10a6:102:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 08:45:31 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 08:45:31 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v5 3/3] drbd: use sendpages_ok() instead of sendpage_ok()
Date: Thu, 18 Jul 2024 11:45:14 +0300
Message-ID: <20240718084515.3833733-4-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240718084515.3833733-1-ofir.gal@volumez.com>
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|PAXPR04MB9005:EE_
X-MS-Office365-Filtering-Correlation-Id: 505f93ef-ebe3-4eaf-8108-08dca705fae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVBuVVU3L3lYSHk2UGVEdGtGbHJqQ2hBV1U5Q0dDajRleUI0WWhCcVNnT1RE?=
 =?utf-8?B?U3ZjMy9IZ3BzMnRSMW50WXB6TWtadjFnQnB2L2NlaWcvNVc5RTRRdmNySXFG?=
 =?utf-8?B?STVpSkkzTHpXcUZQRXlUY1ZHS2t0TzVNdWRQS3B1TCs3clRNOXdWTWxuUkor?=
 =?utf-8?B?S2NxWDRxUi9tM212M09jOVErcG9aREY1aENXQSt2UTRiOTRoM096VldjY1Zu?=
 =?utf-8?B?RGlnWm9pK0hJRkR3TnlRQXBVenpnNlc2aVN0RUdwbDlNZ1dxT1RpdDBVUWVZ?=
 =?utf-8?B?dW4xTTgvTjl2TUhOanEyR0Jtd1ZNYXpNYUVsckFJcXBJSVA1R2x1L0FRUCtC?=
 =?utf-8?B?R0E1aHViaDFnMVVxTXpRL2RwQk41M1pQdzE3Q1BLZ2hRUWd0TElTYzlpVmRz?=
 =?utf-8?B?YVJiaWlsMXJqWm9YRzhIWXlmWndTZ1JDNy9wa2dTaG9EOUJUNEVQZXpGd2k2?=
 =?utf-8?B?VEpKWWMxZDgvZTFTcmRzRGVHdGVtZTZ5UTZ6TVJraEF1WEovR0xaYmtGRmUz?=
 =?utf-8?B?RjE2NlVXaFhseWpDd21HUEJIUTBTQk0xWmFOTnpjRi92UDFqK2ZrVzl1Rkhw?=
 =?utf-8?B?ZUcvczlKNU10SThpTXA2eXZaeWk1eTBGbHdwQ3BSd2pNcGEyZi9UWHRlV2hZ?=
 =?utf-8?B?NERaN3VEN25TbFVacXJlVGNZN0VicWExVVZzN3NoaXd2MmkvdUtIK3NYREU1?=
 =?utf-8?B?MHJsbHMvTVFLbWJaQlNQMnR6a0xQZS9ITElrY3VjQUxjTXJxRTRidzF1ZWti?=
 =?utf-8?B?WC8raFZwaVBRbGIwZmpzQUIzSXNqckQrZ3VFT3BZRm1XTStBWDFEKy9rU1pD?=
 =?utf-8?B?L3pzaWV2UGRMN3lUMVBMRkVUM09WUHo5VmFXT1RsUnpPcHkrMnlRN1pMQ1Bh?=
 =?utf-8?B?REkrVG9NMlI5T0dvRHVRdVhHcHRhbnNNRzcwZ0h6cmJmaFIrYjl3dXloTy9O?=
 =?utf-8?B?RUJ5d3F5YmUrMko1M2MyQzhxWTd2RzJYbktVTzMxWHdXVUxtWWxBK1I1eTNv?=
 =?utf-8?B?eU5CQTFyVzQzUE8zMzVUZk8zMkFsbnlTUjRabU9iREk0blQzZ0tHTnRUUHh6?=
 =?utf-8?B?Z1VHYnlybThTMmo3ZjA1MzYzZDN2ais3K055VTN4SHZsRW9iSVFPNG1WMGNH?=
 =?utf-8?B?ME8rck5xN0hqcXRTNHFpWitqYUlEK3U0c3h1dURsYys0N2RLWURVZGVFNmIz?=
 =?utf-8?B?NDFQUEpVYVVtTTlyTzFHWE1uQ3JvY1Aydmp0cHg4SWV3SDhqMStJVGRBT3VI?=
 =?utf-8?B?Wk42NFNzaXRTTE9HcWlmSmRwUEhMSDlqRU04eDd6eW02bzdBbkNDYVYzQXFx?=
 =?utf-8?B?VUlnQXlJajIzUXdYdWd4b0hqZUQ4aWRJMHJoT3lEMmtUSTdtbHVhYzVGV3k4?=
 =?utf-8?B?dGhoZFBMRjhGc2ZyczA0MytVZVA0U3FydUhyZkJtZUc1ZzNuaWZpK1BMSndk?=
 =?utf-8?B?M0VXZ1NyMGJ2MXladUZvTi9rWFFzUFFNVWpEeVNQM2NicEszSkdKaXMxMDI3?=
 =?utf-8?B?QURYZzJrSGRaOFdnTU05djlEbUNqUjhsUWt4ODBnWFhES3dJa21mOU1CN2hY?=
 =?utf-8?B?dGJENHh2L3BZR0lCNGRhK295Mkc1akcvMW94NFkrc2hIblM1N0ZVWjQ4aFFh?=
 =?utf-8?B?SlFqaWNsOWo4Ti9jYXpUZFhoL1VhNlQ2bGswVG1RbHFLWFpOOS9SZXJjbDdX?=
 =?utf-8?B?b2lYd21aSUdaMVJha0swWGFweUZkWHNWZmZpLzB6WFNlRVNkclZaTU5HdXZu?=
 =?utf-8?B?RGNpVEpXVGI3YzB2SG1YOWpxMUV1V05JWkcrR2x3TGFqVnhodmJsR09GZ285?=
 =?utf-8?B?WTFWbHB5ZlpvNW45cGVRa0Fib2tvUHVHYkRsWTFGRkdzc1Y2MWN2Yk5uTjhD?=
 =?utf-8?B?bzZGTjRSZE1oUHhkc3N0VHVTd2EyS2hva2kwQ012K053blE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEZxdmRkWllyb1k1di9USUd5cXlpQmF3bURJanhTVkUxMnRJdVJ1U3I5RzJR?=
 =?utf-8?B?ckJBeFRqYXc3ZE9PSVg5Vm5lcTlRZXgzMnhiTE53K2RHQTAyNWE3ZHRoQnNp?=
 =?utf-8?B?OU1RcUx3cTY5TWc1YUY2WFV3UUU4eUVBYlNkTWJ2VHZkaVZLWnovZFlYNzJm?=
 =?utf-8?B?L2JRc2FnLzR3OEhaYzNMN3NYYXB6bmE3K0Ftd0ZQT0ZzaUdLMERiWjg1ZTE3?=
 =?utf-8?B?dk84cFp2Vkh6d2dXK3g4T3I3NzlDekwydzdPbzI3MWFwR09MR0R1RjZJS3Ix?=
 =?utf-8?B?bFB5L3oybHFSSStQMG9kN3hRdkVBRS8vWGx4czliMkV4ZWhtQXgrbXZlZWhH?=
 =?utf-8?B?TGdTaEZwME1ta3QzaWl5UVkrZEZkRVJBQVR0QjhvMFRRdldkL0ZPdVlERXRG?=
 =?utf-8?B?M0p4cDFGNWRna25GZ3h1ZTh4bEFrSDJManFDSUxCYWVjOVkxYU5mMXVLOC9j?=
 =?utf-8?B?SXpCOWoyb2tPVVpSaDRtNnNCOXFNdlI4a0YvVDIwMVBld2Yxb0gyMG1oM1RR?=
 =?utf-8?B?MzRybHJQVFNZa1ZCYTJGNVp3OEhkZmgvbDNQT1VZSVNVN3M1djBzK0N4TlVo?=
 =?utf-8?B?RTIvZkg0OWJnUHR5YTZXZ1FRZ0RXWTVDT3A3N3pOVlFKRWgxeTJ1ZDMyRk5Q?=
 =?utf-8?B?ZGlaMTVIV0I0YU9ZaFdnTU9XZVE1OHFyNVJhMlc1ZW4yQnBuU2lub1JOblRJ?=
 =?utf-8?B?cyticXJnamNuMWl2dWI2WXY2dkR6TkN0dDhSSDFETkJ3T0NqZGczbEladkNr?=
 =?utf-8?B?TFpFdWhNRk5IV3RuN1BhTFJBS3ZYcG9BY3M3VGxrUEJvczlMZ2l4RHlOb2pC?=
 =?utf-8?B?b2Y2aWhMeGJQUExUZFFSeXNTdFRGNThZQ0VleGpTcGxRS3FuWmtMemdwRUVz?=
 =?utf-8?B?WTRBM2xXTjlhQ2dJSXdFZHRWbDErK2NpNlZUaTU5Z25KMXRGa0J6Ykh6dkRM?=
 =?utf-8?B?WVoxWXZyNDBxYWNYT0ZJMW1TaGxjSlA4cSthbGdmNnd4SUdhRXVuYXhBNnNq?=
 =?utf-8?B?bWpPR2JhbThMT0tDR0FhR2VQKzRSUUxrUFF2LzdXbkp5dXpjT1ZURTBiMEpq?=
 =?utf-8?B?bkF2MXB0N0JJcWNRMEQzOTJLT0hxUk52cWJJUFQraWptS1dlTUlhcVVuMWk1?=
 =?utf-8?B?Q2JKbWtyY3F4Skx1Y2lBbkJRSmEwVDBvSG5UenhKeEk4ZVRkZkd3OXQzWlpw?=
 =?utf-8?B?VERuaDA3L01hdy8xSHROa1hSNys1Z1ljZFIyV0pLQndNdys4dFNMVEQvek1a?=
 =?utf-8?B?b0JnS3l0WDNqL1lXb3ozRXM3ekJ4RnN3clYyOHowaW9FaXUxZkI4b1RINTFa?=
 =?utf-8?B?MUJYMFYwZHFnOHgxRzRVYkhFWE1lZjVXRXJsNEIxUHd0UWY2dWZzRDl5S2pG?=
 =?utf-8?B?TkZlL2pEdFhCbHJJOXVna3VRenJGK3Zab0dnb1A0eHNZWGg4dng0eFBIZTk1?=
 =?utf-8?B?c3MwTGF3ZTdJaStHaEwwdkUxUHlNTWxiTlJiL0doRGRoVmovV3hEV1gyT2lB?=
 =?utf-8?B?UFVWMkpBL05MSXlFaTl4WGQ5d1V4MlZNNGd6cklRUDVxU1FWdmVmUXRsWHBw?=
 =?utf-8?B?QTFhelJqK3ZxUXdTakYwRmYraUVaRkI0VUVpRUhmTE4vdkYzdml1RUQ5YUFJ?=
 =?utf-8?B?Q3Badjg1NDYybUlEMG5Ea1R2ZW9QelQwQUF6WWprNno0M3RZWk44MEN0TXM2?=
 =?utf-8?B?SGpVL1lnWDN2Vm9yM3BBTGhLVEVWVmFvcTZURjlsM2p4aHM4T1orOWhtc2ZG?=
 =?utf-8?B?UHJkSTFiRTNjNmQycUM1bFFOc0ZjVG14Rk1VaU5HK2U4TG13TGR0UXJ3N3Vj?=
 =?utf-8?B?UEdSTHFWUitlbklTOGJ0VGxtSDlVbkxaWW5HWC9VMEVRUGlQQ0tFQnA0UFY2?=
 =?utf-8?B?Y2R6cUFwazBSNDFDcWt4TisrbjQxZ2t5bXoyOGY0Mm9MdzZNeDNCMDRhcVQ5?=
 =?utf-8?B?U3BscWZLMll1L0R5cjZHeHZNeEhhR21SOEk1U3VzcnVzQVI3a2owYTNxKzhj?=
 =?utf-8?B?TS90OS9KWko2UlBPMENoZEhvZytpYXpzMGdqSkpHWWx5bnNsRjBRYml4cmk5?=
 =?utf-8?B?RGRWaG0waU5hWUU4eWZWRWkyRGNsNmxKV2hRcUMvZVlUWmgzTkNGTU9rYW9z?=
 =?utf-8?Q?okg/1bJHE2G8YwiX8UJAeAUhA?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505f93ef-ebe3-4eaf-8108-08dca705fae6
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 08:45:31.1108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVl628MNfwdYuq4yOFcUkzw+oy8L65uMwqlJpXSovK7oeJEgW35OuLPFwbEh/ew2AZzwA2/uP5Tf+RgRK4priQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9005

Currently _drbd_send_page() use sendpage_ok() in order to enable
MSG_SPLICE_PAGES, it check the first page of the iterator, the iterator
may represent contiguous pages.

MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
pages it sends with sendpage_ok().

When _drbd_send_page() sends an iterator that the first page is
sendable, but one of the other pages isn't skb_splice_from_iter() warns
and aborts the data transfer.

Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
solves the issue.

Acked-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 113b441d4d36..a5dbbf6cce23 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1550,7 +1550,7 @@ static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *pa
 	 * put_page(); and would cause either a VM_BUG directly, or
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
-	if (!drbd_disable_sendpage && sendpage_ok(page))
+	if (!drbd_disable_sendpage && sendpages_ok(page, len, offset))
 		msg.msg_flags |= MSG_NOSIGNAL | MSG_SPLICE_PAGES;
 
 	drbd_update_congested(peer_device->connection);
-- 
2.45.1


