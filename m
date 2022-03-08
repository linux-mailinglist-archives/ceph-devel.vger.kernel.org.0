Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28E14D1930
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiCHNcZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 08:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNcY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 08:32:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660C843AD2;
        Tue,  8 Mar 2022 05:31:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228Ci7PK002358;
        Tue, 8 Mar 2022 13:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=WkyHusOdSSp0TaxBVpmQUXJJlndu2FlFYGw2Ci8kDv4=;
 b=Hjx0qVP2cLFZdGtZd/qTlARlhdVDFgFaHJSxtArH608lMIXSk6ZeUh20E3WoAjKuUHIn
 k/G147ASQxBxBh4V8UmZLEPGoJSYmM+zL9vYgL7PFjj4QyWJkT8f32nA4bpfOZUWUOk0
 OmAh3mK3eGAAgrsWEnlSByBY4Yw8zHvnnJSoqp+JAxjkWBMSt0RVDA5V2HMhNx2+eDUQ
 ILR36GszoRo7jNBOy4BOSpGp3af3V8rMv66fj2AlXtH/ryxVColcb7EKjSHJS9LAkubl
 DlVcFi+RwzNBduow8jTifNv6xicXdZtpgHCY9ZmXqOPgMykEJEECtKiXwF9C3f7llsDi 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2f1ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 13:31:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 228DHC5G083126;
        Tue, 8 Mar 2022 13:31:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3020.oracle.com with ESMTP id 3ekyp2610n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 13:31:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZZ6Ld7N+lkXF8Fx6Vux4dRjalQa/VgfVU9RNGHa08UBF3XZuiByR+wasQrNaPkdNVA+Z5DR6Q4/5pqGAeFV8zfUBP2ha70AELJTiA/1ECnhNwLFYaUWq9CcI6knF64/gH/Db5ZyQBTba6iVyqCdSpzjQZMgB2qT0m4pSCbfzjIsR3AYd+RfjJ0iMCXyykLR5jUZd68W5XyFUA3ynJ8aaxcrEDzaRNGp9OoUZfZrqI0gu3tT8R0iXVQUGJAR2L4FE5A/H2hS1wx/RxRKrWLMR8vEqbbXlG0xRM02BzoIT9hE0nT6aBRPkVxsY0QxoSG85iF0AfHJBzXzMv9nskTHWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koMk+VTXOQetsSx6iNmu7NV5AE7h8CwyaqACRI181No=;
 b=MQbIwRMMM8DXIyExKBT16yA5o/ObM4kjSXh7F4KQHXt6gl9UztmNDRTQEOoShIVD5QtDIcNJsl+YW6Fh4RyL2oOQj4auA7XdRjsRPg2wDAfw1eMll5y2BTfPQfiR7ii7flEGNIIOFL1vxnRLEN53X48wS44PTeXMIORQCSBhCSXtJ3tyR6MK8DxNHV0aezx0hRGfCr3JryCKXZ6NPPjC8UF0oEv6tyAng8NEqDXR9rRCsZYI+8+CUtAFWv+U1DUvvsqhZJZod2gWTDgNV4qDytVBUClpHXQjwmQ5PpVpIwMngKgXfCqZeDnxoYrutt1ZHqioGu+kyN0bEJ9invaKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koMk+VTXOQetsSx6iNmu7NV5AE7h8CwyaqACRI181No=;
 b=qEP5Ta3bnIRQYBV1RNVveoYA8GdrddPkN6gjBVABKiI8COVl5bDfy3tW+SjaZ6hOQgd9QY5NTb7SGyHFgeSzSaFnrB0tG7mtCqkcJMpcZVbAKUPnLQD6S9gC0pRgogTy/XOqppb59uSP2Z+VlT/Ob8OaxXNpTuD5OqG22sqQPfs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4515.namprd10.prod.outlook.com
 (2603:10b6:303:9b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 13:31:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 13:31:10 +0000
Date:   Tue, 8 Mar 2022 16:30:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     David Howells <dhowells@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ceph: uninitialized variable in debug output
Message-ID: <20220308133051.GK3315@kadam>
References: <20220307142121.GB19660@kili>
 <1019938.1646732163@warthog.procyon.org.uk>
 <dae26bb75c456e50b196f41966807d05e92b19ff.camel@kernel.org>
 <1b892ba94ba4fe23b80fdfe29c92fdcde35e0b5a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b892ba94ba4fe23b80fdfe29c92fdcde35e0b5a.camel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0032.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eea2e8a-b5fa-44fc-e31d-08da0107e883
X-MS-TrafficTypeDiagnostic: CO1PR10MB4515:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4515941F91C16D5D2A94CACE8E099@CO1PR10MB4515.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTgveH8fOCmeqTsevNty3PXrT+PxN6LrJ/sstz1Zs8c27YnvA1cR4r+2irJ9Q5Thw+8uPh1JCSG5K5gpyNgVwv8gqDoF1JPAe8jRboWNLY49WGIUqQr+njJI25fIo8FewhQyTAklxUpIpoaU1+GMUxKws/+vBNxduAPN+XuPtXfhoSZiLQJNdHRp7cGRHERxBy5ejuzq38Gi7xLVsFWvzJRNgfKRp4vHliK4UvhEH24WMDjPj8R59jPpv4lTDsMyhG1YGJcvpEV08oXqT9Nf9wtW1Ic/sNFwGvysBtepdyhgzDjVke3BZYmJkvedjttydk8HBGyU/suZPvR+CKRv3dIwftNJx5USXEUKEq0L36K92O+zWePR5spMzc/WNIaNoNeSnmPdsSzAVDlxnmCTgtntE1u1DREs1JcP38hDtXnW+OU+hzLHcmYGhaA604XTM6kd4PkfEd17TJikL5BywChNnwPTB7FaIQFiRn1h08lu1jr09h6ekmz+NQQE/eDVmW9aVTRZ6LyLhVSIIow3SihMJhIdrlGcd69iQ4nAdY54XuDgPjNEroTComc48rKdkCBuNAmfSlj+kyzmbc9KxhncglMlbkotN1M9MU3nP2GCmq6wlGaS5ORWYxK/HohmKFmlYELFgfcXP8aNHBgQQ+DkiTTJH8R6no1BINPzdCob+ui7uxV5BHaFpuKUOoQIaQQ0fne2GNt9MJGDnp998Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(44832011)(8676002)(66946007)(66476007)(66556008)(33656002)(5660300002)(2906002)(6916009)(8936002)(54906003)(38100700002)(38350700002)(316002)(4744005)(186003)(508600001)(6486002)(86362001)(33716001)(6512007)(6666004)(9686003)(6506007)(52116002)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?A4Rq4NTsuBmyHtCk1TPCFCk7qpVNR57sg42JMrNLgLd6Bo7KfdaIgOthRr?=
 =?iso-8859-1?Q?6Ibj4fskTiJdVVWF24gLG7ScG/lwZUU5NiYhmQGn5GjoxSj0k/uUd/nITU?=
 =?iso-8859-1?Q?ZOes2f3THYukAfqqWmvHehOO7gdwxeLoV77BeLMYLysdw5AdMKXhnSXWuN?=
 =?iso-8859-1?Q?inF9ZNC6FOJuw2ImscUDsLvPSa149Y156HnyAdbrLQuigC4M9Zt2cZWWhs?=
 =?iso-8859-1?Q?ThZ4zciVTdFqJpad7R4/MKHv+sfNQ9olAddbCOXwWS6aqZvo5TgJPOrQuC?=
 =?iso-8859-1?Q?QI1JPoqPo/GQo2qyTEHcDGQvmREIFLwwbTIMTau3lOXP6FTtARBj2pqZ1n?=
 =?iso-8859-1?Q?+d9WEd2l/sCPqYx8aAtT0sF9d5KQxS8kbmA4vmPLmfLahyHRiDyoViVGMu?=
 =?iso-8859-1?Q?1fzx3rmycdCGRcOtLByI31HZFJkqPiIvurRUHEJn6QfdMKzxu4dyJl5ow9?=
 =?iso-8859-1?Q?LRhtDwdIigPEp9RkGUyCoNBd3Yk4oST9TayO/F5x0+PmekalLHsNFO0ys+?=
 =?iso-8859-1?Q?7EYzSkMwGbw6pVKD8UG+qeS5/Axbb3H+d2UjGIOGpuyDHWGYOnwYov8LVh?=
 =?iso-8859-1?Q?MDhmlAVIMncxIDo7PUkHkXW4uWPliZf/OM1ziyaMAC2M9JvlHpZAkZMeBD?=
 =?iso-8859-1?Q?E/lPBGUKZl0/168uig7FSHB140kGjA+NVGsjlT96RgPmSmOjDJ7Kc8o4we?=
 =?iso-8859-1?Q?FhKBC1ck48cwGYR1qA8D4Wp6mbV275hzkwGgFTtoKIqX2UUJlpT7+cRS30?=
 =?iso-8859-1?Q?/QJEX9E0eFPb4OXO5jYtfvTyWEAzmzR1HRLR0gtVnadWxcppHXC+lU8vu9?=
 =?iso-8859-1?Q?IG0UcYczNGQmupU3mgh85G0Lg4wD7lsNgrVQWVvCoe/Gq+RTcRvoJ5roug?=
 =?iso-8859-1?Q?tMImdEnKMaLtWtVBYvC2fY99xBa8nc11FHZq2beGmPG1HxpynlcfKHdR++?=
 =?iso-8859-1?Q?ygMnhYpm7fNe3bzNpBwTZe0NfE7IN79BAAZCmRe5q6glzvCZDSMW9RtouG?=
 =?iso-8859-1?Q?X/3Kuvk1OdWYeLzLGlJMxPwI7Z6LE6DTQ/rXGzg3FsQJeKmlxCqtLnR+QT?=
 =?iso-8859-1?Q?gw+iRmRW+zC+LOFGpG0f7y5npia5kewCZTvi1PNPbdeBp7UIyL9980y9YM?=
 =?iso-8859-1?Q?+TxA+FuNXE9Jgupcu6wMZfPQCGM7Go1a09Trehs4UgJx2xAwIF9JWHF0Kb?=
 =?iso-8859-1?Q?VzUs4nsBPapCFSep2I34hSyXhIeKwZAhsrvqcCmB/5DqUGvWgv1xB+/nw/?=
 =?iso-8859-1?Q?ZHs1IsGneo8PIe81kc0d/DIck4DhUH8lwvOouduDlktvN1elR9yuYu2TXt?=
 =?iso-8859-1?Q?60iont+U/PFmmj1FHYWy3AdZxWyv6Etl2OuQJMsipnPW77/L0Sqm24JvKX?=
 =?iso-8859-1?Q?FbKiYeopfqRAsKjIAMAfJNdxS8x6xRl9H/di+J+OWRaEHcZ63/7yG+kdTH?=
 =?iso-8859-1?Q?XzXq09VnHzPNAEsM17VXH8sHP+aX88w7Sxap4wlYFXBvo68BhhBhhfJcd2?=
 =?iso-8859-1?Q?aX8iERcE8OKrGoOjCnfjE7SLdi3s50duzM2ouj8eHsU0jE6TQ2L5Ft7/jD?=
 =?iso-8859-1?Q?z8LSMJ+1aMZk8VfOGUbhDJc63HKshHnP/7nCjdgZiHpqWfwl7Sc97S0IcI?=
 =?iso-8859-1?Q?pxmxw/3VFcqpQ2B6w1af2ZtycctZ5+/1++LPKRcWsD6QP6yT9V+pzdixnm?=
 =?iso-8859-1?Q?8Fm2UQ4n/SVgGB4NmpA2K5GNkE80tKrIGGyfP6DneTF5dOyG9eqgOsyvWU?=
 =?iso-8859-1?Q?afbQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eea2e8a-b5fa-44fc-e31d-08da0107e883
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 13:31:10.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XahN5vJ39WME545I4apcWW/tpBr5c8SP+ZgOit/9nNCITE4Mow667hwjglYRTNCBBaL1O/SXnY+O0xDO1YYVGKXbo2ZXitojbypFuaXx9zE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080071
X-Proofpoint-ORIG-GUID: gG9iB7km8Snc0zIwqbjaERAZMePVPonG
X-Proofpoint-GUID: gG9iB7km8Snc0zIwqbjaERAZMePVPonG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 08, 2022 at 08:28:21AM -0500, Jeff Layton wrote:
> On Tue, 2022-03-08 at 08:24 -0500, Jeff Layton wrote:
> > On Tue, 2022-03-08 at 09:36 +0000, David Howells wrote:
> > > Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > > 
> > > > +	u64 inline_version = -1;
> > > 
> > > ULLONG_MAX?
> > > 
> > > David
> > > 
> > 
> > ...or maybe CEPH_INLINE_NONE, which is:
> > 
> >     #define CEPH_INLINE_NONE        ((__u64)-1)      
> >                                                    
> 
> I went ahead and merged the patch into our testing branch, with the
> change to use CEPH_INLINE_NONE instead.

I liked CEPH_INLINE_NONE so I was resending it right now...  But thanks!

regards,
dan carpenter
