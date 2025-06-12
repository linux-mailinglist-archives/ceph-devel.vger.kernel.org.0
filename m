Return-Path: <ceph-devel+bounces-3100-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0986DAD6E9F
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jun 2025 13:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74B517A73BC
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jun 2025 11:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3186238C3B;
	Thu, 12 Jun 2025 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="noHaxlB1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012024.outbound.protection.outlook.com [52.101.126.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD3E17A2EA;
	Thu, 12 Jun 2025 11:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749726466; cv=fail; b=XRLHJM42rrDu3H5Cpa6j8oU1vtMbizg5c1vbcxBnUVp8Yy52IyJgO3vFUCtUmezFwDBOHfCTrc0uBtmTTSRd/uQ5NjW7JllQwRN2uLD4IlFDy1+lgbzDBWImyeoEbKgrl53iELQauNTb23w/C3WV7LyPPQ0ZTeQTrxTOUocX2I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749726466; c=relaxed/simple;
	bh=29S9QFhwkjTf/I1karCA/3PAcVOia5pF3WG5nu63FRo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=k9BZ72EAH8vHM2rZT6JzqleokhttKj2bWn7kDfQ2vybWZQnNobzRGXWjzTYBNsyv8YenfEahzrFZCR7aUjFopskWX1ONZ1Z7grasiDBKXaXDoQDd9Y2kx3KJihKBn6qqhlhk7vjcnW2bJVSbcIWCaaAus7d7JlvkqljGOVgiCWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=noHaxlB1; arc=fail smtp.client-ip=52.101.126.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5VHXoCcMgBOJSjYgB2Kn63mAIAKn8b34aITeb7opBantzzLByO5oB7Mb7hEWtcKMdTsAIWnqMsS4qdGuE5gYhvpILbeNG1p8HHiTScefhalGsng8551I6y3YyrkTTBZZt3qT3WZ05uKTutw32QhGWCHG5lkATNc0hDtkS4KI5zcFANisakXmmpI9rRIovo+ggwZsLlHeloOjXeJv97+UUKtWoqt4Ifb24+6nW7v49EeP7Or+QEcRFaaF2KJkfYhFhUxasU++yXdOkIaIihPEdZL/BhzZlKpI9nhfmd1HXrjW7lbLtS92xz6oYdw9K7lxD6+OLAegPbi2RiQQ/mkbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2GUhVpU1GZguFdroCIQIX59IDLWPZ6ke+wUl5zbuOs=;
 b=JuVBsVAfTNKcoDTVpTmplFVGmsQ+4rOr37ZgKiX/7fx5ox8jHonT9Cumtmq2wRw5y4hPRwkvs+8C3VhZKuskW4W5ehDSxdHcLE7PyGFwK0soN9E5xlAVMqeLMVtMR6O7zm8GVd9y4nA3gPFwdnAZdDMVwxpseGjhCg5fjCJGW26V16XEGFzbEWBUGz/mk6Led2Xy8pnM6nGBVSqPc/3CKVUbTeMONM0vGqMuTN8E532BYDOeaQiwn2xexGRbUvryYCmaEeYnbkcg5AXkZr0zaTHY7nxiRe5N7ARwEjxYSYk50a5+xSwGkVQ32lV7dUGU2zeTRYP+Q8ePPwtuEZpobg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2GUhVpU1GZguFdroCIQIX59IDLWPZ6ke+wUl5zbuOs=;
 b=noHaxlB1YuzQgHCWP9ocauAIuAPe6jUljaQXKwUrfDa6FWooK53sOSnndH92S6Kiyyob52Jk6//H+8FyTCgYB+FjTO70y3UfhtKqxpjR+KYyl2TVUB3sT0pH7fcVuDmOZ0SA4x7H3UGej+gSCl6EMHfcBAb5Pgr408aicSEZtGZPuCxdirzpj7McYx3M4eM0ppRSpa97WJKS0r48mjHsT3DypEgvx0OpFc419oE3WMxDLL1//DxPk5rFQW4cfo2kKh5X/D026xTGBagsYAAjYQCgkPgtlOuwLTxbZU5/ifQeDGIDzK8Dqqphawlj0ZyP5A8PkyA++kuybVLbtUoVsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB4802.apcprd06.prod.outlook.com (2603:1096:4:169::8) by
 TY0PR06MB5354.apcprd06.prod.outlook.com (2603:1096:400:214::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.22; Thu, 12 Jun 2025 11:07:41 +0000
Received: from SG2PR06MB4802.apcprd06.prod.outlook.com
 ([fe80::685f:929d:f06c:a349]) by SG2PR06MB4802.apcprd06.prod.outlook.com
 ([fe80::685f:929d:f06c:a349%3]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 11:07:39 +0000
From: Yuesong Li <liyuesong@vivo.com>
To: Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Jens Axboe <axboe@kernel.dk>,
	ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Yuesong Li <liyuesong@vivo.com>
Subject: [PATCH v1] rbd: convert to use secs_to_jiffies
Date: Thu, 12 Jun 2025 19:07:04 +0800
Message-Id: <20250612110705.91353-1-liyuesong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:4:186::14) To SG2PR06MB4802.apcprd06.prod.outlook.com
 (2603:1096:4:169::8)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB4802:EE_|TY0PR06MB5354:EE_
X-MS-Office365-Filtering-Correlation-Id: a9e45b7a-d158-4d77-bad3-08dda9a1581d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4KoVkHkHe5SyT1bK/ufSIRaz9BXGA8bJV9880EgLkw9fTKG2vSK5K/lY8y+N?=
 =?us-ascii?Q?KbAyEanF3O00DFEyrH9QuefNCSO2Bxpc2NMHnpD351HJrY8kqYVorq+kXpuV?=
 =?us-ascii?Q?GrKuGwJ7poPU2tuTTdJK/706FSZzHfaZ3543O0nV663olCkNVQ40gJOjSlQm?=
 =?us-ascii?Q?vAoiINKgbRugCGG5c//CtjHLyFNHdwZNvAts/IePO7OPKe1JTYQJgm27fvl3?=
 =?us-ascii?Q?0CDbscaT5uzRXrLh55MqBc272Czd0+pe5npEBPdAEBdzNjDVVKRKmcsSePvK?=
 =?us-ascii?Q?DNBoImi9uw/+Li3KxhZ4wMrVuYMqBMVtfxFJ+FId5HFoXtSG4qF6zmaVom7t?=
 =?us-ascii?Q?+C6tiGYkpinlsxowYeVd7LUjWGjZP5s6vYyqbHgNOYCUDJkr/RDkTbYFdmEz?=
 =?us-ascii?Q?DEjz4/tVOCONr0VL1q2IEAT3TIff3M6mRhWP75kz/BG8lJGocA0gaP09Zpkq?=
 =?us-ascii?Q?fDezNm7dosjsBRyTQxjGdk/MRXzaqQCC/rEGm4Pq00+Twu5qWuX/1UaaWxNU?=
 =?us-ascii?Q?TPsfH1BF7N7Jb5skDrRNXap8OhNXc0gtMWfmr8SrubJVLaLni7Wb1lS3l4+o?=
 =?us-ascii?Q?xYhh2IgFn8rudh/Z/7sllVA9abWmoh0Dl/wTCehpmts21242fGxUs+Xl8oVn?=
 =?us-ascii?Q?oRz4CZcnI7vuRM7GqbufZ4vkc+rrMx0FM1A8ALs6V5Fit8zwyWKEZ/h4UEa7?=
 =?us-ascii?Q?fUsz2r9/le5Wa4l3Ukw86zPLf4kRW7FGd2rL7GUCZttsJ/tNS43T2CqCsspc?=
 =?us-ascii?Q?CZiqRkW+w/cyzF1xy3ZVPaP7Yy8I5DqG14kHyQLnpNfojZOpXuoP9NvQ9zoe?=
 =?us-ascii?Q?U7pX0bqdl6CSG+BHUcPeXNgm3ern/GANe90xbVH3EGIfeiCg7Fq27aIMGsio?=
 =?us-ascii?Q?P5yx99Q17z1BFRA9hH9lgSlq/PmatDP/SSuISTqAeNQWNfPsuewYDt3voUZt?=
 =?us-ascii?Q?8p+830yS9Eqh4KLkpFLJIFpmuM9JrqNpt2LjZRCGRDUBoAtvDBFOp9mRoBB+?=
 =?us-ascii?Q?+VN2lromu/W5NndGIrfPsd50Lx8zcebbk6UPrmCOlKFmHrE9njrwYt67y7ql?=
 =?us-ascii?Q?6mHfeoi4F+Cppw8P/s/1uyomixSBDgKIAYr8mwXT4xQCrOE4mBUOf7/MCGvt?=
 =?us-ascii?Q?3qn1hXVIMiJIIDHzIIjcQ7BaLOlay8Om+ZOdv66wsUeRL5X3F894C/7ju7SS?=
 =?us-ascii?Q?3gzJxuosBAlKxIv8bnkrgOdQPz49ECZlIq7hCXDiexw7MfRqmL0JNLYEHYMl?=
 =?us-ascii?Q?T7ARg7g+b36Ftoz4+32/G6bEITvAGteUBP6i8Z7c5KotH+S1TdxJz6CzgH5Y?=
 =?us-ascii?Q?LjeAIlCxE/Ztr1R5ma47it6+BxPSQcCdOBJdFgo+9vZIQy82hoybT7PJdCpb?=
 =?us-ascii?Q?3L2yB8gU5XArROI5hGA7FX9GFzgQVcEsSXCVWcy36RyFCRZOMZ99IozH288j?=
 =?us-ascii?Q?i+r9Y1ufvYqidIe6Ru5AAqkrJv39G/5RnbZDbsKtlkH+v/bWq3BVUg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB4802.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t3FzcunKf8whOHhkeryjqRRtgRY5ZIke+vl5bDgRbPsZOEfoHZcCIagHuwCd?=
 =?us-ascii?Q?hdNVCK734bJ4SM2O4cuQToRW4hO3DX0UECjVL0Qu/0VhMKzCxCTK4EEM2sIu?=
 =?us-ascii?Q?2Qz/CVCcTrMt0HZygxFuCay9tdi9+HamzK1S/xu7VEvqSW1U/bKt/1jhLtIM?=
 =?us-ascii?Q?o7R6yNwJ21vSN2YQOoY3/oTCB8CjTNwuYL9vlt9xNwXZP3z2PNOWqaegZpKn?=
 =?us-ascii?Q?L6VGZZ9unVLh/ZC6UrWhJFwyOblF5kwA8q18IICpsubNPh3lNTc1UcVCbXnI?=
 =?us-ascii?Q?2ZnZekszyKyQHckKiVydYEHhQHDLnj7nbnrl/EVkZNdY+BkTZLaL6ivrMmr/?=
 =?us-ascii?Q?xT3kICAYaFf9jhi9X/UfAFHucftMF6QByAbP2OfnNwOSmuTBPiPQq6o3x0aF?=
 =?us-ascii?Q?tHzZE4zb9OdSwjEa4XgVzljZMYebTYfsPxT9mVtva41ilmBgu6+NnYTAs2FI?=
 =?us-ascii?Q?rsOpDV6lDyYn5QGntJZemfvcjdgM9R0ky1NE5/kdqIF1sHKqubltb9IU176A?=
 =?us-ascii?Q?xqMUo8hkxRtipwmjYJz+CEaKDkJvmkkC3b7PV+XkslkhKXuibuKnE7FP30L3?=
 =?us-ascii?Q?M+Xt9LmwGEBg8FQFwG1zZxkJnfT7EupoGJYLXhYGAhSyIXqU7qx0ffCtrCt+?=
 =?us-ascii?Q?mWd5Gd45BhIn9TTTl/N1JTRAHIeMy7TYc1RkIUZMI+rl/MQpheLVvmGfMJxn?=
 =?us-ascii?Q?/ypI4Uaa3+224Sd1SabgCSMBhpoVk0psExpHQ+5JfjHgA/SmNlEjWAa1JXV4?=
 =?us-ascii?Q?a+2VBaKB1Zusn+fWy2Spax4dqw6xignRDZZArbU0lZ0L04IipK+hQtxYVPgD?=
 =?us-ascii?Q?MwA4Y/NDUfybbgHErK1R1an4TTsDi930Bblr6LtF3w4yj2YS307nJVGau34k?=
 =?us-ascii?Q?+kgr/1LHcZ/5ykDx0Z+Chg5PfJfNeubSdRrRwCO2SQERpCumJnkl1T7TCmae?=
 =?us-ascii?Q?1otLc3rqViZRUM4Cuy1qCCH7rwUsv6VQl8j4sEG4I7fmpcnc/WB1J0yraF4T?=
 =?us-ascii?Q?FU0jH9yWvzgpqh5nYI0BVOQEXaLzqwCcBrpg4nQPgquFVOcSgdfviYfwE0Ic?=
 =?us-ascii?Q?hlGFIq5h6jvUqCnauqI9F0QphqPdb8dJNadyb1/IaDCkAu7wLozo7DCJAhMh?=
 =?us-ascii?Q?YQfU0bMUWdmxR0LDXbpHrZvcAqY9BXAXqREmLJ9G4QS0M1Mo2eD1aYiAvKdx?=
 =?us-ascii?Q?lRvN89czt68GwpbC55wqF6k0w7jenEK+kNf7erX8/vAWGjar5ABXtQN0OicT?=
 =?us-ascii?Q?VKX0pNsp6lGDP4rVoVRak6a6pGziUVW9eNt5Xb143cMmh31vQiJa8SZ8GF4Q?=
 =?us-ascii?Q?CAlao1JvKG9tM2IxbCSMqku5g2cUik05oKkEacxnbcXoJqVQ9I5EPzCLcZn7?=
 =?us-ascii?Q?H6FMSqcTUsZeSml2UxoR5it0DcAhWOo/iDUlYrDr8B+VTtd4GGl/OYtg2wDa?=
 =?us-ascii?Q?/wgZMOsJYyOz2n1KEG3AO6DNyHMQSMttOK2cw6QNXgDKFCafWVlyMUJl//go?=
 =?us-ascii?Q?VOBw4uZAfp86F0jVAl6As0W7eAD/fRY7UAjksavOMcqNRajPJ2HxkdrtR7Oc?=
 =?us-ascii?Q?zz3BCZD6aZ1HWfLjMA+m1KSZ+qqf15uW58M3vjd7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e45b7a-d158-4d77-bad3-08dda9a1581d
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB4802.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 11:07:39.1897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pj985ZlZAFEqSJ8lvSTS6K46XWMtJXZLBdKXiDEnDITyT3fTXeVPIeelkNVJnjDBFsO61NWx5ZiiVBNHKLdacw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5354

Since secs_to_jiffies()(commit:b35108a51cf7) has been introduced, we can
use it to avoid scaling the time to msec.

Signed-off-by: Yuesong Li <liyuesong@vivo.com>
---
 drivers/block/rbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index faafd7ff43d6..92d04a60718f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4162,7 +4162,7 @@ static void rbd_acquire_lock(struct work_struct *work)
 		dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
 		     rbd_dev);
 		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
-		    msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
+		    secs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT));
 	}
 }
 
@@ -6285,7 +6285,7 @@ static int rbd_parse_param(struct fs_parameter *param,
 		/* 0 is "wait forever" (i.e. infinite timeout) */
 		if (result.uint_32 > INT_MAX / 1000)
 			goto out_of_range;
-		opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->lock_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_pool_ns:
 		kfree(pctx->spec->pool_ns);
-- 
2.34.1


