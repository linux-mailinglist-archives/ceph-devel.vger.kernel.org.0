Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D04637C1
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 15:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbhK3Ozr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 09:55:47 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36302 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhK3OyV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 09:54:21 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUE2kZn009060;
        Tue, 30 Nov 2021 14:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=sBg2639inLa3jeBXmURv/mpuJ08KII/HVAUVjq4/IHY=;
 b=kq9NikamBRpWItwbtDWIDe+OtD9f/ycxl1fUA4sgwKwc374uZXdeljDvB/0GTNvM0T2+
 DnmlEosz5hc3jaHb5l7rCHwUr1Blt1rR9K1amEWkYkJWBoYBBU9sTY2F983CwQam5rk/
 J7+3tPZAR4dFKe3bCVCaCnq/lqXlKpoc5licAzYh685PxnMoeQxOWVAEbaZMwL28E1qQ
 Pu3Fb6ttOQWp6dAE2xgz4TWE+DPzPE8RMkb2ou6wIPaguXW7MKUabZXYnkXGT+DXC0QY
 45haPOd9SNfA0nLeRV1HKd/V+fmdy/ja+292Kz4/yM58NYkRFc2TcPNa7DhInjQP6wIR Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9sj66-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 14:50:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUEQJ1i062607;
        Tue, 30 Nov 2021 14:35:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3cke4pnvq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 14:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjirzLo6zgozywHsdua/gaZ9bgdgBp41+HN6UsrILmeKaYoWl73fpK+QE08u0htOHdKAs9Kc7IIzO2fWlhQAq4Ca1ly6QMr+sCr+GIs+xvFzVR02RGqijBC0Gs1On5mTHsX08gq7GBaARqsJGn0YAj39mNoOKQBC8rSFW5vhm8hQM1NS3FlOckqHsQuQylhr0FVwGFsvJr7uTM3go5Aqorhx1Cp9+4Mgabx/hq0uJTAvRRDzEiLICdebvs3beGXqF9CnYZh4Bj4ooYhgjhwf0pNRa7YtFlMIbCfjFbC/+RW9u8c3/dMId3xHcSHcJ9tYQCFkQ12jCPhGxdR6L6sruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBg2639inLa3jeBXmURv/mpuJ08KII/HVAUVjq4/IHY=;
 b=S5v6gVKl1LfuZHMf/rPlC0n0GCHfUz/ZVIRAvRFFApOetIK+4Naq+lfeC5HRbwYZta/8dhF9kPug/9DVNM1jWfoUQP7vcXm59R9Ema+ntdft1HnTBi66iUzSvE0327XOJTSNY9Cw0p+STeuScT2sHmwo7Zuex7tE0WhQaItc/IAnl2yBV3gIptsMwaH96AGB0RnaVZ6yi4CL6M9kiAZgAFPZsZnzG+qbmAWXNJAduUKfn+cjrLBXE1SQx/ur8TVgctG651sFS7jPVtKCDkXiy3w8xPLuKyv/pL1LTEyd/Fdl4Ikvah0LImwb7pYOOiK/o7VU2T1SVCn2NoBV2keVWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBg2639inLa3jeBXmURv/mpuJ08KII/HVAUVjq4/IHY=;
 b=IgpAD15NDJjz6nxUVGQd+i9vhpt2JBKRLzl/Y/VDeL+oyN+A5+aTNG0AXbvt5e7RFGQEJW2k7gpcwN2ieiS3kQzRb4EuaWDU34DPKTZ226bPuNzk+UgPIQaRPplE7GEKoKVLy5KHONWNNhQqyVZr9RRabdCb1EAhH37mRv0fE0c=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5863.namprd10.prod.outlook.com
 (2603:10b6:303:18e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 30 Nov
 2021 14:35:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 14:35:36 +0000
Date:   Tue, 30 Nov 2021 17:35:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        vshankar@redhat.com, ukernel@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: initialize pathlen variable in reconnect_caps_cb
Message-ID: <20211130143514.GY18178@kadam>
References: <20211130112034.2711318-1-xiubli@redhat.com>
 <41b05af2020a3cb345a16f5dfca15f6f5f41bfe4.camel@kernel.org>
 <d14840f4-3ad8-55ce-480c-4d8cf3234893@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d14840f4-3ad8-55ce-480c-4d8cf3234893@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 14:35:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67c89e7a-aebf-416f-f42f-08d9b40eac4d
X-MS-TrafficTypeDiagnostic: MW4PR10MB5863:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5863EB7997FB114363B71B648E679@MW4PR10MB5863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNr/Q2gUV9e+CJAA9it6qwyelv8CCG2j7f6vZ8msuc9JTouKFgk5IjX53IkBh8nkvuImYz/dxY2kmT6XEbW+ceRT4puvTXanCVguP4JEW3l+3IzDvaJb7krXG/hQgc0USNGUMwYllGzixDMbpTUYtMjjsoXUZsY8deXKpfgAZd4wT2jg3nQkCtNDpVYMKF6UQySXXUaIvGItTPSjrNzJvRtFqJu8GoVMuixNQOoipFY37/kXuHRmqG0vjoMWtFyyYeRk8ez+T+iwVhrkyk+qRM6Da5VQ0KjG/jj7sfPbMMdAEmUJxlq/F7lxcpxfxVfyDk7/ciKPBWXSdTuSIy/nx9eQXUAFx6KKOKK84RHmpaFIXPXOTL+x/ylBEf8bSLw/RqcWgiYBbPNPoW5VMksDvb4WlzW9bFc4+y1hbcyev8AdnKeOdvfyArpOCLb4UEFiR35xH+qE4LhhODxNa14sgCWfK3IGVCwjtd7FkK9NYl4vHWFK/02bh7r7lTcNIZZiuwZ+4TLhFSOwC7xsctkhgiAACSV/opfHTYiNUmP2iBkuGweF4V0bJbak20s6eE8Yyjjwq42MDMJvR7Qlr9DDLqTxzXZ8em1g+p0dYKgvoYZN0N99XzCw4oFNEasqRvgBzOhr4HXwNQzgi5xVbrsYiv8qaJb+672oaT1wUnzMD17xtVgcqbj0DHKVLs+bIkreB9ndlfCiEEYlziGCCOfxNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6496006)(9576002)(66476007)(186003)(6916009)(33656002)(2906002)(86362001)(55016003)(4001150100001)(26005)(6666004)(4744005)(508600001)(5660300002)(9686003)(38100700002)(316002)(38350700002)(8936002)(83380400001)(956004)(1076003)(8676002)(44832011)(66946007)(53546011)(52116002)(66556008)(4326008)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cPREexeIGkbpIwa9d6AGW4We+J80TLtKxaMiQ+0CU8s9qltwRwpWd/N3bB1G?=
 =?us-ascii?Q?tEPpqxPzimHKonivghlw8doOu4HQ0P8g8Re18M1m5+qRfesh8sPBsh1FkYaI?=
 =?us-ascii?Q?aUiHOhnhHRIpl8IxTnSN57plWI+oLzJajWzCMpOBAYADZO0vH2Jo01x5Nx76?=
 =?us-ascii?Q?d5+H4MdUtze9SspFfxi1x+jFb+qoZp9I56I7GOVuDXja28NuOXEsmt0Kfn2E?=
 =?us-ascii?Q?hW8ZxbMupcwk49O5T2b83zTXJoL4iPVTgQBGbJx9Q43QmAF/aZOhVrNIrgfx?=
 =?us-ascii?Q?HygY8qRroOzHM/6JMwTeZbViO6SOR0ngJfiymg2of9mIQAykpE+VZebQt8Xq?=
 =?us-ascii?Q?dyQhWcvSOZDvVatpFwjnfYnD+ZFfk/KlAA1sGeWvWQHnSJmuLIIiklpgIKGK?=
 =?us-ascii?Q?5Asl53La6wFf5llfOnOgvJKiVOB9ZHb09U+QCXVi7DuAMuoCPqexuou0DLJz?=
 =?us-ascii?Q?xgIfqNs0N6z2W/fJzn/TKBya7RPDy3owrlkkRQQ9bwloDle5OxbWPSoN2RC4?=
 =?us-ascii?Q?88SIxiFMZbASxVNGyvDXdLsNUh6dEtOdps769BLvsyhkeP/fCfDQZ1b56ntc?=
 =?us-ascii?Q?itBcgvr3AVuCG9O5u4WL6Sl0SlzdTYhdiiUsQIQkKjhOo8GcLz7ZphCAk2LQ?=
 =?us-ascii?Q?9iz5Xr/+n+e6FsevgG6uAVwMQ3kGX0+XRpCWtdzHhDiQx8znN/ZDs2yawKnl?=
 =?us-ascii?Q?/8FQsFXVPUXteh7K6LyboKlzPZ3JXtPzBPJ5123TbYNHxmmLfO9QRkfaA1SY?=
 =?us-ascii?Q?xa1AJN0FTWEA+twHD6bVWEr9yG9jS8nwn/B2N8KUjAZdY4+2wDHOPPpU+dUs?=
 =?us-ascii?Q?QaubyekjZL/niFys+wyzU4CwnPNlnz144nHKtRRdlX1OhvD/XpZ0roRMV9g6?=
 =?us-ascii?Q?ycyX3gTaT96v1F64PY765TaVXGmK9zkLJkIke5hw/iwWet1AoCvvYkYc1htH?=
 =?us-ascii?Q?9YMxGYU2q9GxwjwSWj8ikIQNZXQWu1FLmiMCbtxRlU9qIfG6UwXFaJ8RFVV8?=
 =?us-ascii?Q?N7CSKHFBRQKp06ShMfrrUah7Qup9cs5jAzOIypoxzhasz86EfKsZX5Sai2Ex?=
 =?us-ascii?Q?Ytxdwh69sBWwlPmO8zk2VQNV71Qh2qkDDrPRkwiJoPWUfyGXCqObLM1QjHFX?=
 =?us-ascii?Q?0Gesf7ZS1OxS9smTsmIMwNXZr3eOgxUVIF4u0/2STJpp8LZYaf6ZVDEtmK0e?=
 =?us-ascii?Q?spTtMk+p8+4WkrUh9G3RdcPd5qbxqWunlrdSwezbSyhac7d20RYDKP3s3boT?=
 =?us-ascii?Q?4ztvkuZV1DMk1srx5XFO4mRFpkwxTGsddXB6DxRcsPy8leQ3/Izlu3G16YAE?=
 =?us-ascii?Q?3BvaxFwc8NO0gYAuilyZuD2ra/+QXlgUpkkTXkHgCkt292GsqZH/6e3B/ewE?=
 =?us-ascii?Q?K5xtVf/mphY17b12Vo9Ohh+3jL4gP00HswuNL76AVAX9yTwYQRGu8d1q3vuD?=
 =?us-ascii?Q?xASy0Z98m7mmXE2Np1muTEwBt3jhvAanf5yekI0dwY8reSqK0hQd010fEVjA?=
 =?us-ascii?Q?QkIv/ZUWYSyS4j466Xx2L934jWT04uGDmckbC+Vglsr82rbLOWyVuEMdJ4Xe?=
 =?us-ascii?Q?NlG1PTFRNuJQsjiWSevkmbeaIH1F4p1Zr/IbP5ViuGDS+x4U9ivF9oC87zJe?=
 =?us-ascii?Q?1wTQjVukRonplEE3fAPgNuKt/Ta8Q7aQvIk5c/oYJ8/3lPYKYgdm1BNaGVZs?=
 =?us-ascii?Q?Y6N0IonkUnhHBlyRX1NC34JS8NQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c89e7a-aebf-416f-f42f-08d9b40eac4d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 14:35:36.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbV2NAMNSJ84u3cEcB0n/sJlVNn41oRc2jQEwusZ114banTaaNE+iTzxK9TgqgpcxsHL9xbBKw+8fdSjQY3cbFblvl30FCyI5oJ97iHs0RM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=804
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300080
X-Proofpoint-GUID: RtVOFIZbOGlkcW0uO1BdacVqqmE6JIEu
X-Proofpoint-ORIG-GUID: RtVOFIZbOGlkcW0uO1BdacVqqmE6JIEu
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 30, 2021 at 09:12:42PM +0800, Xiubo Li wrote:
> 
> On 11/30/21 8:07 PM, Jeff Layton wrote:
> > On Tue, 2021-11-30 at 19:20 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Silence the potential compiler warning.
> > > 
> > > Fixes: a33f6432b3a6 (ceph: encode inodes' parent/d_name in cap reconnect message)
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > Is this something we need to fix? AFAICT, there is no bug here.
> > 
> > In the case where ceph_mdsc_build_path returns an error, "path" will be
> > an ERR_PTR and then ceph_mdsc_free_path will be a no-op. If we do need
> > to take this, we should probably also credit Dan for finding it.
> > 
> As I remembered, when I was paying the gluster-block project, the similar
> cases will always give a warning like this with code sanity checking.
> 

I think I was just having a discussion about this.  Do you remember
what the warnings look like?

regards,
dan carpenter

